-- 고객 요청사항 시스템 완전 재작성
-- 2025.08.21 - db.csv 파일 기준 정확한 타입 매칭
-- 실제 DB 구조: public.users(id uuid), public.quote(id uuid), public.reservation(re_id uuid)

-- 전제조건: notifications 테이블 존재 확인
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'notifications'
    ) THEN
        RAISE EXCEPTION 'notifications 테이블이 필요합니다. 먼저 create-notifications-tables.sql을 실행하세요.';
    END IF;
END $$;

-- 1. 고객 요청사항 메인 테이블
CREATE TABLE IF NOT EXISTS customer_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id text UNIQUE NOT NULL DEFAULT 'REQ-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(EXTRACT(EPOCH FROM NOW())::text, 6, '0'),
  
  -- 요청자 정보 (public.users 테이블 참조)
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- 요청 유형 및 분류
  request_type text NOT NULL CHECK (request_type IN ('quote_modification', 'reservation_modification', 'service_inquiry', 'complaint', 'cancellation', 'additional_service', 'other')),
  request_category text NOT NULL, -- '견적 수정', '예약 변경', '서비스 문의' 등
  
  -- 요청 내용
  title text NOT NULL,
  description text NOT NULL,
  urgency_level text DEFAULT 'normal' CHECK (urgency_level IN ('low', 'normal', 'high', 'urgent')),
  
  -- 관련 데이터 참조 (실제 DB 테이블 구조 기준)
  related_quote_id uuid, -- quote.id 참조
  related_reservation_id uuid, -- reservation.re_id 참조
  related_table text, -- 참조 테이블명
  related_id uuid, -- 참조 데이터 ID
  
  -- 요청 상태
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'rejected', 'cancelled')),
  
  -- 처리 정보 (public.users 테이블 참조)
  assigned_to uuid REFERENCES users(id),
  processed_by uuid REFERENCES users(id),
  
  -- 응답 및 처리 내용
  response_message text,
  internal_notes text, -- 내부 처리 메모
  
  -- 메타데이터
  request_data jsonb DEFAULT '{}',
  
  -- 시간 정보
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  due_date timestamp with time zone,
  processed_at timestamp with time zone
);

-- 2. 고객 요청사항 첨부파일 테이블
CREATE TABLE IF NOT EXISTS customer_request_attachments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id uuid NOT NULL REFERENCES customer_requests(id) ON DELETE CASCADE,
  
  file_name text NOT NULL,
  file_path text NOT NULL,
  file_size integer,
  file_type text,
  
  uploaded_by uuid NOT NULL REFERENCES users(id),
  created_at timestamp with time zone DEFAULT now()
);

-- 3. 요청사항 처리 히스토리 테이블
CREATE TABLE IF NOT EXISTS customer_request_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id uuid NOT NULL REFERENCES customer_requests(id) ON DELETE CASCADE,
  
  action_type text NOT NULL, -- 'created', 'assigned', 'status_changed', 'responded', 'completed'
  previous_status text,
  new_status text,
  
  action_by uuid NOT NULL REFERENCES users(id),
  action_note text,
  
  created_at timestamp with time zone DEFAULT now()
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_customer_requests_user_id ON customer_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_customer_requests_status ON customer_requests(status);
CREATE INDEX IF NOT EXISTS idx_customer_requests_type ON customer_requests(request_type);
CREATE INDEX IF NOT EXISTS idx_customer_requests_created_at ON customer_requests(created_at);
CREATE INDEX IF NOT EXISTS idx_customer_requests_quote_id ON customer_requests(related_quote_id);
CREATE INDEX IF NOT EXISTS idx_customer_requests_reservation_id ON customer_requests(related_reservation_id);

-- 첨부파일 테이블 인덱스
CREATE INDEX IF NOT EXISTS idx_customer_request_attachments_request_id ON customer_request_attachments(request_id);
CREATE INDEX IF NOT EXISTS idx_customer_request_attachments_uploaded_by ON customer_request_attachments(uploaded_by);

-- 히스토리 테이블 인덱스  
CREATE INDEX IF NOT EXISTS idx_customer_request_history_request_id ON customer_request_history(request_id);
CREATE INDEX IF NOT EXISTS idx_customer_request_history_action_by ON customer_request_history(action_by);
CREATE INDEX IF NOT EXISTS idx_customer_request_history_created_at ON customer_request_history(created_at);

-- RLS 정책 설정
ALTER TABLE customer_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_request_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_request_history ENABLE ROW LEVEL SECURITY;

-- 고객은 자신의 요청만 조회/생성 가능
CREATE POLICY customer_requests_owner_select ON customer_requests
  FOR SELECT 
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY customer_requests_owner_insert ON customer_requests
  FOR INSERT 
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY customer_requests_owner_update ON customer_requests
  FOR UPDATE 
  TO authenticated
  USING (user_id = auth.uid());

-- 매니저/관리자는 모든 요청 조회 가능
CREATE POLICY customer_requests_manager_select ON customer_requests
  FOR SELECT 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = auth.uid() 
      AND role IN ('manager', 'admin')
    )
  );

-- 매니저/관리자는 요청 업데이트 가능
CREATE POLICY customer_requests_manager_update ON customer_requests
  FOR UPDATE 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = auth.uid() 
      AND role IN ('manager', 'admin')
    )
  );

-- 첨부파일 정책
CREATE POLICY customer_request_attachments_owner_select ON customer_request_attachments
  FOR SELECT 
  TO authenticated
  USING (
    uploaded_by = auth.uid() OR 
    EXISTS (
      SELECT 1 FROM customer_requests cr 
      WHERE cr.id = request_id AND cr.user_id = auth.uid()
    )
  );

CREATE POLICY customer_request_attachments_owner_insert ON customer_request_attachments
  FOR INSERT 
  TO authenticated
  WITH CHECK (uploaded_by = auth.uid());

CREATE POLICY customer_request_attachments_manager_select ON customer_request_attachments
  FOR SELECT 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = auth.uid() 
      AND role IN ('manager', 'admin')
    )
  );

-- 히스토리 정책
CREATE POLICY customer_request_history_read ON customer_request_history
  FOR SELECT 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM customer_requests cr 
      WHERE cr.id = request_id AND (
        cr.user_id = auth.uid() OR 
        EXISTS (
          SELECT 1 FROM users 
          WHERE id = auth.uid() 
          AND role IN ('manager', 'admin')
        )
      )
    )
  );

CREATE POLICY customer_request_history_insert ON customer_request_history
  FOR INSERT 
  TO authenticated
  WITH CHECK (action_by = auth.uid());

-- 요청사항 알림 자동 생성 함수
CREATE OR REPLACE FUNCTION create_notification_for_customer_request()
RETURNS TRIGGER AS $$
DECLARE
  auth_user_id uuid;
BEGIN
  -- 현재 인증된 사용자 ID 가져오기
  auth_user_id := auth.uid();
  
  -- 새 요청사항이 생성될 때 알림 생성
  IF TG_OP = 'INSERT' THEN
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
      '새로운 고객 요청: ' || NEW.title,
      '요청 유형: ' || NEW.request_category || E'\n' ||
      '고객 ID: ' || NEW.user_id::text || E'\n' ||
      '요청 내용: ' || LEFT(NEW.description, 100) || 
      CASE WHEN LENGTH(NEW.description) > 100 THEN '...' ELSE '' END,
      CASE NEW.urgency_level
        WHEN 'urgent' THEN 'urgent'
        WHEN 'high' THEN 'high'
        ELSE 'normal'
      END,
      'unread',
      'customer_requests',
      NEW.id::text,
      jsonb_build_object(
        'request_type', NEW.request_type,
        'customer_id', NEW.user_id::text,
        'related_quote_id', COALESCE(NEW.related_quote_id::text, ''),
        'related_reservation_id', COALESCE(NEW.related_reservation_id::text, ''),
        'urgency_level', NEW.urgency_level
      ),
      now()
    );
    
    -- 히스토리 기록
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
      auth_user_id,
      '요청사항이 생성되었습니다.'
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
DROP TRIGGER IF EXISTS trigger_create_notification_for_customer_request ON customer_requests;
CREATE TRIGGER trigger_create_notification_for_customer_request
  AFTER INSERT ON customer_requests
  FOR EACH ROW
  EXECUTE FUNCTION create_notification_for_customer_request();

-- 요청사항 상태 업데이트 함수
CREATE OR REPLACE FUNCTION update_customer_request_status(
  p_request_id uuid,
  p_new_status text,
  p_response_message text DEFAULT NULL,
  p_assigned_user_id uuid DEFAULT NULL
)
RETURNS boolean AS $$
DECLARE
  current_status text;
  current_user_id uuid;
  auth_user_id uuid;
BEGIN
  -- 현재 인증된 사용자 ID 가져오기
  auth_user_id := auth.uid();
  
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
  
  -- 상태 변경 알림 생성 (고객에게)
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
      END,
      '요청사항 처리 결과 안내',
      CASE p_new_status 
        WHEN 'completed' THEN '요청하신 사항이 처리되었습니다.'
        WHEN 'rejected' THEN '요청하신 사항이 거부되었습니다.'
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
$$ LANGUAGE plpgsql;

-- 데이터 검증 함수
CREATE OR REPLACE FUNCTION validate_customer_request_data()
RETURNS TRIGGER AS $$
BEGIN
  -- 제목과 설명 필수 체크
  IF NEW.title IS NULL OR LENGTH(TRIM(NEW.title)) = 0 THEN
    RAISE EXCEPTION '요청 제목은 필수입니다.';
  END IF;
  
  IF NEW.description IS NULL OR LENGTH(TRIM(NEW.description)) = 0 THEN
    RAISE EXCEPTION '요청 내용은 필수입니다.';
  END IF;
  
  -- 관련 데이터 유효성 체크
  IF NEW.request_type = 'quote_modification' AND NEW.related_quote_id IS NULL THEN
    RAISE EXCEPTION '견적 수정 요청시 관련 견적 ID가 필요합니다.';
  END IF;
  
  IF NEW.request_type = 'reservation_modification' AND NEW.related_reservation_id IS NULL THEN
    RAISE EXCEPTION '예약 변경 요청시 관련 예약 ID가 필요합니다.';
  END IF;
  
  -- updated_at 자동 설정
  NEW.updated_at := now();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 데이터 검증 트리거
DROP TRIGGER IF EXISTS trigger_validate_customer_request_data ON customer_requests;
CREATE TRIGGER trigger_validate_customer_request_data
  BEFORE INSERT OR UPDATE ON customer_requests
  FOR EACH ROW
  EXECUTE FUNCTION validate_customer_request_data();

-- 요청사항 통계 조회 뷰
CREATE OR REPLACE VIEW customer_requests_stats AS
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

-- 테이블 코멘트
COMMENT ON TABLE customer_requests IS '고객 요청사항 관리 테이블 - 견적수정, 예약변경, 서비스문의 등';
COMMENT ON TABLE customer_request_attachments IS '고객 요청사항 첨부파일 테이블';
COMMENT ON TABLE customer_request_history IS '고객 요청사항 처리 히스토리 테이블';

-- 컬럼 코멘트
COMMENT ON COLUMN customer_requests.request_id IS '사용자 친화적 요청 ID (REQ-YYYYMMDD-XXXXXX)';
COMMENT ON COLUMN customer_requests.user_id IS '요청자 UUID (public.users.id)';
COMMENT ON COLUMN customer_requests.related_quote_id IS '관련 견적 UUID (public.quote.id)';
COMMENT ON COLUMN customer_requests.related_reservation_id IS '관련 예약 UUID (public.reservation.re_id)';
COMMENT ON COLUMN customer_requests.request_data IS '요청 관련 메타데이터 (JSON)';

-- 테이블 생성 완료 확인
DO $$
BEGIN
  RAISE NOTICE '✅ 고객 요청사항 시스템이 성공적으로 생성되었습니다!';
  RAISE NOTICE '📊 생성된 테이블: %', (
    SELECT COUNT(*) 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name LIKE 'customer_request%'
  );
  RAISE NOTICE '🔧 생성된 함수: create_notification_for_customer_request, update_customer_request_status, validate_customer_request_data';
  RAISE NOTICE '📈 생성된 뷰: customer_requests_stats';
END $$;
