-- 고객 요청사항 시스템 - 완전 새로운 버전 
-- 2025.08.21 - auth.uid() 타입 문제 완전 해결
-- 접근법: 모든 사용자 ID를 TEXT로 통일하여 타입 충돌 완전 방지

-- 기존 관련 객체들 완전 제거
DROP TRIGGER IF EXISTS trigger_create_notification_for_customer_request ON customer_requests CASCADE;
DROP TRIGGER IF EXISTS trigger_validate_customer_request_data ON customer_requests CASCADE;
DROP FUNCTION IF EXISTS create_notification_for_customer_request() CASCADE;
DROP FUNCTION IF EXISTS update_customer_request_status(uuid, text, text, uuid) CASCADE;
DROP FUNCTION IF EXISTS update_customer_request_status(uuid, varchar, text, uuid) CASCADE;
DROP FUNCTION IF EXISTS validate_customer_request_data() CASCADE;
DROP FUNCTION IF EXISTS create_test_customer_request(uuid, text, text, text) CASCADE;
DROP FUNCTION IF EXISTS create_test_customer_request(text, text, text, text) CASCADE;
DROP VIEW IF EXISTS customer_requests_stats CASCADE;
DROP TABLE IF EXISTS customer_request_history CASCADE;
DROP TABLE IF EXISTS customer_request_attachments CASCADE;
DROP TABLE IF EXISTS customer_requests CASCADE;

-- 전제조건 확인
DO $$
BEGIN
    RAISE NOTICE '🔧 고객 요청사항 시스템 생성을 시작합니다...';
    
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'notifications'
    ) THEN
        RAISE EXCEPTION 'notifications 테이블이 필요합니다.';
    END IF;
    
    RAISE NOTICE '✅ 전제조건 확인 완료';
END $$;

-- 1. 고객 요청사항 메인 테이블 (TEXT 기반)
CREATE TABLE customer_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id text UNIQUE NOT NULL DEFAULT 'REQ-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(EXTRACT(EPOCH FROM NOW())::text, 6, '0'),
  
  -- 사용자 ID - TEXT 타입으로 auth.uid() 직접 호환
  user_id text NOT NULL,
  
  -- 요청 분류
  request_type text NOT NULL CHECK (request_type IN ('quote_modification', 'reservation_modification', 'service_inquiry', 'complaint', 'cancellation', 'additional_service', 'other')),
  request_category text NOT NULL,
  
  -- 요청 내용
  title text NOT NULL,
  description text NOT NULL,
  urgency_level text DEFAULT 'normal' CHECK (urgency_level IN ('low', 'normal', 'high', 'urgent')),
  
  -- 관련 데이터 - TEXT로 저장하여 호환성 확보
  related_quote_id text,
  related_reservation_id text,
  related_table text,
  related_id text,
  
  -- 상태 관리
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'rejected', 'cancelled')),
  
  -- 처리자 정보 - TEXT 타입
  assigned_to text,
  processed_by text,
  
  -- 처리 내용
  response_message text,
  internal_notes text,
  
  -- 추가 데이터
  request_data jsonb DEFAULT '{}',
  
  -- 시간 정보
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  due_date timestamp with time zone,
  processed_at timestamp with time zone
);

-- 2. 첨부파일 테이블
CREATE TABLE customer_request_attachments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id uuid NOT NULL REFERENCES customer_requests(id) ON DELETE CASCADE,
  
  file_name text NOT NULL,
  file_path text NOT NULL,
  file_size integer,
  file_type text,
  
  uploaded_by text NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

-- 3. 히스토리 테이블
CREATE TABLE customer_request_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id uuid NOT NULL REFERENCES customer_requests(id) ON DELETE CASCADE,
  
  action_type text NOT NULL,
  previous_status text,
  new_status text,
  
  action_by text NOT NULL,
  action_note text,
  
  created_at timestamp with time zone DEFAULT now()
);

-- 인덱스 생성
CREATE INDEX idx_customer_requests_user_id ON customer_requests(user_id);
CREATE INDEX idx_customer_requests_status ON customer_requests(status);
CREATE INDEX idx_customer_requests_type ON customer_requests(request_type);
CREATE INDEX idx_customer_requests_created_at ON customer_requests(created_at);

-- RLS 정책 활성화
ALTER TABLE customer_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_request_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_request_history ENABLE ROW LEVEL SECURITY;

-- RLS 정책 설정 - TEXT 타입으로 직접 비교
CREATE POLICY customer_requests_owner ON customer_requests
  FOR ALL 
  TO authenticated
  USING (user_id = auth.uid());

-- 매니저/관리자 정책 - users 테이블과 조인할 때만 캐스팅
CREATE POLICY customer_requests_staff ON customer_requests
  FOR ALL 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id::text = auth.uid()  
      AND role IN ('manager', 'admin')
    )
  );

-- 첨부파일 정책
CREATE POLICY customer_request_attachments_access ON customer_request_attachments
  FOR ALL 
  TO authenticated
  USING (
    uploaded_by = auth.uid() OR 
    EXISTS (
      SELECT 1 FROM customer_requests cr 
      WHERE cr.id = request_id AND cr.user_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM users 
      WHERE id::text = auth.uid() 
      AND role IN ('manager', 'admin')
    )
  );

-- 히스토리 정책
CREATE POLICY customer_request_history_access ON customer_request_history
  FOR ALL 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM customer_requests cr 
      WHERE cr.id = request_id 
      AND (
        cr.user_id = auth.uid() OR 
        EXISTS (
          SELECT 1 FROM users 
          WHERE id::text = auth.uid() 
          AND role IN ('manager', 'admin')
        )
      )
    )
  );

-- 알림 생성 함수 - 완전 안전한 타입 처리
CREATE OR REPLACE FUNCTION fn_create_customer_request_notification()
RETURNS TRIGGER AS $$
DECLARE
  current_user_id text;
BEGIN
  -- auth.uid()를 text로 안전하게 처리
  current_user_id := auth.uid();
  
  IF TG_OP = 'INSERT' THEN
    -- 알림 생성
    INSERT INTO notifications (
      type,
      category,
      title,
      message,
      priority,
      status,
      target_table,
      target_id,
      metadata,
      created_at
    ) VALUES (
      'customer',
      CASE NEW.request_type
        WHEN 'quote_modification' THEN '견적수정요청'
        WHEN 'reservation_modification' THEN '예약변경요청'
        WHEN 'service_inquiry' THEN '서비스문의'
        WHEN 'complaint' THEN '불만접수'
        WHEN 'cancellation' THEN '취소요청'
        WHEN 'additional_service' THEN '추가서비스요청'
        ELSE '기타요청'
      END,
      '새로운 고객 요청: ' || COALESCE(NEW.title, '제목없음'),
      '요청 유형: ' || COALESCE(NEW.request_category, '미분류') || E'\n' ||
      '고객 ID: ' || COALESCE(NEW.user_id, '알수없음') || E'\n' ||
      '요청 내용: ' || LEFT(COALESCE(NEW.description, '내용없음'), 100) || 
      CASE WHEN LENGTH(COALESCE(NEW.description, '')) > 100 THEN '...' ELSE '' END,
      CASE COALESCE(NEW.urgency_level, 'normal')
        WHEN 'urgent' THEN 'urgent'
        WHEN 'high' THEN 'high'
        ELSE 'normal'
      END,
      'unread',
      'customer_requests',
      NEW.id::text,
      jsonb_build_object(
        'request_type', COALESCE(NEW.request_type, ''),
        'customer_id', COALESCE(NEW.user_id, ''),
        'related_quote_id', COALESCE(NEW.related_quote_id, ''),
        'related_reservation_id', COALESCE(NEW.related_reservation_id, ''),
        'urgency_level', COALESCE(NEW.urgency_level, 'normal')
      ),
      now()
    );
    
    -- 히스토리 기록
    IF current_user_id IS NOT NULL THEN
      INSERT INTO customer_request_history (
        request_id,
        action_type,
        new_status,
        action_by,
        action_note
      ) VALUES (
        NEW.id,
        'created',
        NEW.status,
        current_user_id,
        '요청사항이 생성되었습니다.'
      );
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 상태 업데이트 함수 - TEXT 매개변수 사용
CREATE OR REPLACE FUNCTION fn_update_customer_request_status(
  p_request_id uuid,
  p_new_status text,
  p_response_message text DEFAULT NULL,
  p_assigned_user_id text DEFAULT NULL
)
RETURNS boolean AS $$
DECLARE
  current_status text;
  current_user_id text;
  auth_user_id text;
BEGIN
  -- auth.uid()를 text로 처리 (캐스팅 없음)
  auth_user_id := auth.uid();
  
  IF auth_user_id IS NULL THEN
    RETURN false;
  END IF;
  
  -- 현재 상태 조회
  SELECT status, user_id INTO current_status, current_user_id
  FROM customer_requests 
  WHERE id = p_request_id;
  
  IF NOT FOUND THEN
    RETURN false;
  END IF;
  
  -- 요청사항 업데이트
  UPDATE customer_requests SET
    status = p_new_status,
    response_message = COALESCE(p_response_message, response_message),
    assigned_to = COALESCE(p_assigned_user_id, assigned_to),
    processed_by = CASE WHEN p_new_status = 'completed' THEN auth_user_id ELSE processed_by END,
    processed_at = CASE WHEN p_new_status = 'completed' THEN now() ELSE processed_at END,
    updated_at = now()
  WHERE id = p_request_id;
  
  -- 히스토리 기록
  INSERT INTO customer_request_history (
    request_id,
    action_type,
    previous_status,
    new_status,
    action_by,
    action_note
  ) VALUES (
    p_request_id,
    'status_changed',
    current_status,
    p_new_status,
    auth_user_id,
    COALESCE(p_response_message, '상태가 변경되었습니다.')
  );
  
  -- 완료/거부시 알림 생성
  IF p_new_status IN ('completed', 'rejected') THEN
    INSERT INTO notifications (
      type,
      category,
      title,
      message,
      priority,
      status,
      target_table,
      target_id,
      metadata,
      created_at
    ) VALUES (
      'customer',
      CASE p_new_status 
        WHEN 'completed' THEN '요청처리완료'
        WHEN 'rejected' THEN '요청거부'
        ELSE '상태변경'
      END,
      '요청사항 처리 결과 안내',
      CASE p_new_status 
        WHEN 'completed' THEN '요청하신 사항이 처리되었습니다.'
        WHEN 'rejected' THEN '요청하신 사항이 거부되었습니다.'
        ELSE '요청 상태가 변경되었습니다.'
      END || COALESCE(E'\n\n처리 내용: ' || p_response_message, ''),
      'normal',
      'unread',
      'customer_requests',
      p_request_id::text,
      jsonb_build_object(
        'request_id', p_request_id::text,
        'final_status', p_new_status,
        'processed_at', now()::text
      ),
      now()
    );
  END IF;
  
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 데이터 검증 함수
CREATE OR REPLACE FUNCTION fn_validate_customer_request()
RETURNS TRIGGER AS $$
BEGIN
  -- 필수 필드 검증
  IF NEW.title IS NULL OR LENGTH(TRIM(NEW.title)) = 0 THEN
    RAISE EXCEPTION '요청 제목은 필수입니다.';
  END IF;
  
  IF NEW.description IS NULL OR LENGTH(TRIM(NEW.description)) = 0 THEN
    RAISE EXCEPTION '요청 내용은 필수입니다.';
  END IF;
  
  -- user_id가 비어있으면 현재 사용자로 설정
  IF NEW.user_id IS NULL OR LENGTH(TRIM(NEW.user_id)) = 0 THEN
    NEW.user_id := auth.uid();
  END IF;
  
  -- 관련 데이터 검증
  IF NEW.request_type = 'quote_modification' AND (NEW.related_quote_id IS NULL OR LENGTH(TRIM(NEW.related_quote_id)) = 0) THEN
    RAISE EXCEPTION '견적 수정 요청시 관련 견적 ID가 필요합니다.';
  END IF;
  
  IF NEW.request_type = 'reservation_modification' AND (NEW.related_reservation_id IS NULL OR LENGTH(TRIM(NEW.related_reservation_id)) = 0) THEN
    RAISE EXCEPTION '예약 변경 요청시 관련 예약 ID가 필요합니다.';
  END IF;
  
  -- updated_at 자동 설정
  NEW.updated_at := now();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
CREATE TRIGGER trg_customer_request_notification
  AFTER INSERT ON customer_requests
  FOR EACH ROW
  EXECUTE FUNCTION fn_create_customer_request_notification();

CREATE TRIGGER trg_customer_request_validation
  BEFORE INSERT OR UPDATE ON customer_requests
  FOR EACH ROW
  EXECUTE FUNCTION fn_validate_customer_request();

-- 통계 뷰
CREATE VIEW v_customer_requests_stats AS
SELECT 
  COUNT(*) as total_requests,
  COUNT(*) FILTER (WHERE status = 'pending') as pending_requests,
  COUNT(*) FILTER (WHERE status = 'in_progress') as in_progress_requests,
  COUNT(*) FILTER (WHERE status = 'completed') as completed_requests,
  COUNT(*) FILTER (WHERE status = 'rejected') as rejected_requests,
  COUNT(*) FILTER (WHERE urgency_level = 'urgent') as urgent_requests,
  COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE) as today_requests,
  COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '7 days') as week_requests
FROM customer_requests;

-- 간편 요청 생성 함수
CREATE OR REPLACE FUNCTION fn_create_simple_request(
  p_title text,
  p_description text,
  p_request_type text DEFAULT 'service_inquiry',
  p_urgency_level text DEFAULT 'normal'
)
RETURNS uuid AS $$
DECLARE
  new_request_id uuid;
  current_user_id text;
BEGIN
  current_user_id := auth.uid();
  
  IF current_user_id IS NULL THEN
    RAISE EXCEPTION '로그인이 필요합니다.';
  END IF;
  
  INSERT INTO customer_requests (
    user_id,
    request_type,
    request_category,
    title,
    description,
    urgency_level
  ) VALUES (
    current_user_id,
    p_request_type,
    CASE p_request_type
      WHEN 'quote_modification' THEN '견적 수정'
      WHEN 'reservation_modification' THEN '예약 변경'
      WHEN 'service_inquiry' THEN '서비스 문의'
      WHEN 'complaint' THEN '불만 접수'
      WHEN 'cancellation' THEN '취소 요청'
      WHEN 'additional_service' THEN '추가 서비스'
      ELSE '기타 요청'
    END,
    p_title,
    p_description,
    p_urgency_level
  ) RETURNING id INTO new_request_id;
  
  RETURN new_request_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 테이블 설명
COMMENT ON TABLE customer_requests IS '고객 요청사항 관리 테이블 - TEXT 타입 기반으로 auth.uid() 완전 호환';
COMMENT ON TABLE customer_request_attachments IS '고객 요청사항 첨부파일 테이블';
COMMENT ON TABLE customer_request_history IS '고객 요청사항 처리 히스토리 테이블';

-- 완료 메시지
DO $$
BEGIN
  RAISE NOTICE '🎉 고객 요청사항 시스템이 성공적으로 생성되었습니다!';
  RAISE NOTICE '✅ 모든 타입 충돌 문제가 해결되었습니다.';
  RAISE NOTICE '📊 메인 테이블: customer_requests (TEXT 기반)';
  RAISE NOTICE '📎 첨부파일: customer_request_attachments';  
  RAISE NOTICE '📈 히스토리: customer_request_history';
  RAISE NOTICE '📋 통계 뷰: v_customer_requests_stats';
  RAISE NOTICE '🔧 간편 생성: fn_create_simple_request()';
  RAISE NOTICE '⚙️ 상태 업데이트: fn_update_customer_request_status()';
  RAISE NOTICE '🛡️ RLS 정책 활성화됨';
END $$;
