-- 고객 요청사항 시스템 - 완전 재작성 (UUID = VARCHAR 비교 오류 제거)
-- 핵심: auth.uid()와 비교되는 모든 컬럼을 TEXT로 통일하여 타입 충돌 제거

-- 0) 기존 객체 정리 (존재시)
-- 먼저 테이블을 삭제하면 트리거는 자동으로 삭제됩니다.
DROP VIEW IF EXISTS v_customer_requests_stats CASCADE;
DROP TABLE IF EXISTS customer_request_history CASCADE;
DROP TABLE IF EXISTS customer_request_attachments CASCADE;
DROP TABLE IF EXISTS customer_requests CASCADE;
-- 함수/트리거 함수 제거 (테이블과 무관)
DROP FUNCTION IF EXISTS fn_create_customer_request_notification() CASCADE;
DROP FUNCTION IF EXISTS fn_update_customer_request_status(uuid, text, text, text) CASCADE;
DROP FUNCTION IF EXISTS fn_update_customer_request_status(uuid, varchar, text, uuid) CASCADE;
DROP FUNCTION IF EXISTS fn_update_customer_request_status(uuid, text, text, uuid) CASCADE;
DROP FUNCTION IF EXISTS fn_validate_customer_request() CASCADE;

-- 1) 전제조건 확인: notifications 존재해야 함
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'notifications'
  ) THEN
    RAISE EXCEPTION 'notifications 테이블이 필요합니다.';
  END IF;
END $$;

-- 2) 메인 테이블 (TEXT 기반 사용자 필드)
CREATE TABLE customer_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id text UNIQUE NOT NULL DEFAULT 'REQ-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(EXTRACT(EPOCH FROM NOW())::text, 6, '0'),

  -- 사용자/처리자: TEXT로 저장 (auth.uid()와 직접 비교 가능)
  user_id text NOT NULL,

  -- 분류/내용
  request_type text NOT NULL CHECK (request_type IN ('quote_modification','reservation_modification','service_inquiry','complaint','cancellation','additional_service','other')),
  request_category text NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  urgency_level text DEFAULT 'normal' CHECK (urgency_level IN ('low','normal','high','urgent')),

  -- 관련 참조는 TEXT로 저장 (조인 시 필요하면 캐스팅)
  related_quote_id text,
  related_reservation_id text,
  related_table text,
  related_id text,

  -- 상태/처리 정보
  status text DEFAULT 'pending' CHECK (status IN ('pending','in_progress','completed','rejected','cancelled')),
  assigned_to text,
  processed_by text,
  response_message text,
  internal_notes text,
  request_data jsonb DEFAULT '{}',

  -- 시간
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  due_date timestamptz,
  processed_at timestamptz
);

-- 3) 첨부파일/히스토리 (request_id는 정확성을 위해 uuid 유지)
CREATE TABLE customer_request_attachments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id uuid NOT NULL REFERENCES customer_requests(id) ON DELETE CASCADE,
  file_name text NOT NULL,
  file_path text NOT NULL,
  file_size integer,
  file_type text,
  uploaded_by text NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE customer_request_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id uuid NOT NULL REFERENCES customer_requests(id) ON DELETE CASCADE,
  action_type text NOT NULL,
  previous_status text,
  new_status text,
  action_by text NOT NULL,
  action_note text,
  created_at timestamptz DEFAULT now()
);

-- 4) 인덱스
CREATE INDEX idx_customer_requests_user_id ON customer_requests(user_id);
CREATE INDEX idx_customer_requests_status ON customer_requests(status);
CREATE INDEX idx_customer_requests_type ON customer_requests(request_type);
CREATE INDEX idx_customer_requests_created_at ON customer_requests(created_at);
CREATE INDEX idx_customer_request_attachments_request_id ON customer_request_attachments(request_id);
CREATE INDEX idx_customer_request_attachments_uploaded_by ON customer_request_attachments(uploaded_by);
CREATE INDEX idx_customer_request_history_request_id ON customer_request_history(request_id);
CREATE INDEX idx_customer_request_history_action_by ON customer_request_history(action_by);
CREATE INDEX idx_customer_request_history_created_at ON customer_request_history(created_at);

-- 5) RLS 활성화 및 정책 (모두 TEXT 비교)
ALTER TABLE customer_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_request_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_request_history ENABLE ROW LEVEL SECURITY;

-- 고객: 본인 소유만 접근 (INSERT/UPDATE 시에도 동일 조건을 강제)
CREATE POLICY p_customer_requests_owner_select ON customer_requests
  FOR SELECT TO authenticated USING (user_id = auth.uid()::text);
CREATE POLICY p_customer_requests_owner_modify ON customer_requests
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid()::text);
CREATE POLICY p_customer_requests_owner_update ON customer_requests
  FOR UPDATE TO authenticated USING (user_id = auth.uid()::text) WITH CHECK (user_id = auth.uid()::text);

-- 스태프: users.id::text = auth.uid()로 역할 확인 (id는 public.users의 uuid, role은 text)
CREATE POLICY p_customer_requests_staff_read ON customer_requests
  FOR SELECT TO authenticated USING (
    EXISTS (
      SELECT 1 FROM users u WHERE u.id::text = auth.uid()::text AND u.role IN ('manager','admin')
    )
  );
CREATE POLICY p_customer_requests_staff_update ON customer_requests
  FOR UPDATE TO authenticated USING (
    EXISTS (
      SELECT 1 FROM users u WHERE u.id::text = auth.uid()::text AND u.role IN ('manager','admin')
    )
  );

-- 첨부파일 접근: 업로더/요청자/스태프
CREATE POLICY p_customer_request_attachments_access ON customer_request_attachments
  FOR ALL TO authenticated USING (
    uploaded_by = auth.uid()::text OR 
    EXISTS (
      SELECT 1 FROM customer_requests cr WHERE cr.id::text = request_id::text AND cr.user_id = auth.uid()::text
    ) OR
    EXISTS (
      SELECT 1 FROM users u WHERE u.id::text = auth.uid()::text AND u.role IN ('manager','admin')
    )
  );

-- 히스토리 접근: 요청자/스태프
CREATE POLICY p_customer_request_history_access ON customer_request_history
  FOR ALL TO authenticated USING (
    EXISTS (
      SELECT 1 FROM customer_requests cr 
      WHERE cr.id::text = request_id::text AND (
        cr.user_id = auth.uid()::text OR 
        EXISTS (SELECT 1 FROM users u WHERE u.id::text = auth.uid()::text AND u.role IN ('manager','admin'))
      )
    )
  );

-- 6) 알림 트리거 함수 (TEXT 안전)
CREATE OR REPLACE FUNCTION fn_create_customer_request_notification()
RETURNS TRIGGER AS $$
DECLARE
  current_user_id text;
BEGIN
  current_user_id := auth.uid()::text;
  IF TG_OP = 'INSERT' THEN
    INSERT INTO notifications (
      type, category, title, message, priority, status, target_table, target_id, metadata, created_at
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
      '새로운 고객 요청: ' || COALESCE(NEW.title,'제목없음'),
      '요청 유형: ' || COALESCE(NEW.request_category,'미분류') || E'\n' ||
      '고객 ID: ' || COALESCE(NEW.user_id,'알수없음') || E'\n' ||
      '요청 내용: ' || LEFT(COALESCE(NEW.description,'내용없음'), 100) || CASE WHEN LENGTH(COALESCE(NEW.description,'')) > 100 THEN '...' ELSE '' END,
      CASE COALESCE(NEW.urgency_level,'normal') WHEN 'urgent' THEN 'urgent' WHEN 'high' THEN 'high' ELSE 'normal' END,
      'unread',
      'customer_requests',
      NEW.id::text,
      jsonb_build_object(
        'request_type', COALESCE(NEW.request_type,''),
        'customer_id', COALESCE(NEW.user_id,''),
        'related_quote_id', COALESCE(NEW.related_quote_id,''),
        'related_reservation_id', COALESCE(NEW.related_reservation_id,''),
        'urgency_level', COALESCE(NEW.urgency_level,'normal')
      ),
      now()
    );

    -- 생성 히스토리 기록
    IF current_user_id IS NOT NULL THEN
      INSERT INTO customer_request_history (request_id, action_type, new_status, action_by, action_note)
      VALUES (NEW.id, 'created', NEW.status, current_user_id, '요청사항이 생성되었습니다.');
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7) 상태 업데이트 함수 (TEXT 인자)
CREATE OR REPLACE FUNCTION fn_update_customer_request_status(
  p_request_id uuid,
  p_new_status text,
  p_response_message text DEFAULT NULL,
  p_assigned_user_id text DEFAULT NULL
) RETURNS boolean AS $$
DECLARE
  v_prev_status text;
  v_owner_id text;
  v_auth_id text;
BEGIN
  v_auth_id := auth.uid()::text;
  IF v_auth_id IS NULL THEN RETURN false; END IF;

  SELECT status, user_id INTO v_prev_status, v_owner_id
  FROM customer_requests WHERE id = p_request_id;
  IF NOT FOUND THEN RETURN false; END IF;

  UPDATE customer_requests SET
    status = p_new_status,
    response_message = COALESCE(p_response_message, response_message),
    assigned_to = COALESCE(p_assigned_user_id, assigned_to),
    processed_by = CASE WHEN p_new_status = 'completed' THEN v_auth_id ELSE processed_by END,
    processed_at = CASE WHEN p_new_status = 'completed' THEN now() ELSE processed_at END,
    updated_at = now()
  WHERE id = p_request_id;

  INSERT INTO customer_request_history (request_id, action_type, previous_status, new_status, action_by, action_note)
  VALUES (p_request_id, 'status_changed', v_prev_status, p_new_status, v_auth_id, COALESCE(p_response_message,'상태가 변경되었습니다.'));

  IF p_new_status IN ('completed','rejected') THEN
    INSERT INTO notifications (
      type, category, title, message, priority, status, target_table, target_id, metadata, created_at
    ) VALUES (
      'customer',
      CASE p_new_status WHEN 'completed' THEN '요청처리완료' WHEN 'rejected' THEN '요청거부' ELSE '상태변경' END,
      '요청사항 처리 결과 안내',
      CASE p_new_status WHEN 'completed' THEN '요청하신 사항이 처리되었습니다.' WHEN 'rejected' THEN '요청하신 사항이 거부되었습니다.' ELSE '요청 상태가 변경되었습니다.' END || COALESCE(E'\n\n처리 내용: ' || p_response_message, ''),
      'normal', 'unread', 'customer_requests', p_request_id::text,
      jsonb_build_object('request_id', p_request_id::text, 'final_status', p_new_status, 'processed_at', now()::text),
      now()
    );
  END IF;

  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 8) 데이터 검증 트리거 함수
CREATE OR REPLACE FUNCTION fn_validate_customer_request()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.title IS NULL OR LENGTH(TRIM(NEW.title)) = 0 THEN
    RAISE EXCEPTION '요청 제목은 필수입니다.';
  END IF;
  IF NEW.description IS NULL OR LENGTH(TRIM(NEW.description)) = 0 THEN
    RAISE EXCEPTION '요청 내용은 필수입니다.';
  END IF;
  IF NEW.user_id IS NULL OR LENGTH(TRIM(NEW.user_id)) = 0 THEN
    NEW.user_id := auth.uid()::text;
  END IF;
  IF NEW.request_type = 'quote_modification' AND (NEW.related_quote_id IS NULL OR LENGTH(TRIM(NEW.related_quote_id)) = 0) THEN
    RAISE EXCEPTION '견적 수정 요청시 관련 견적 ID가 필요합니다.';
  END IF;
  IF NEW.request_type = 'reservation_modification' AND (NEW.related_reservation_id IS NULL OR LENGTH(TRIM(NEW.related_reservation_id)) = 0) THEN
    RAISE EXCEPTION '예약 변경 요청시 관련 예약 ID가 필요합니다.';
  END IF;
  NEW.updated_at := now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 9) 트리거 생성
CREATE TRIGGER trg_customer_request_notification
  AFTER INSERT ON customer_requests
  FOR EACH ROW EXECUTE FUNCTION fn_create_customer_request_notification();

CREATE TRIGGER trg_customer_request_validation
  BEFORE INSERT OR UPDATE ON customer_requests
  FOR EACH ROW EXECUTE FUNCTION fn_validate_customer_request();

-- 10) 통계 뷰/간편 생성 함수
CREATE VIEW v_customer_requests_stats AS
SELECT 
  COUNT(*) AS total_requests,
  COUNT(*) FILTER (WHERE status = 'pending') AS pending_requests,
  COUNT(*) FILTER (WHERE status = 'in_progress') AS in_progress_requests,
  COUNT(*) FILTER (WHERE status = 'completed') AS completed_requests,
  COUNT(*) FILTER (WHERE status = 'rejected') AS rejected_requests,
  COUNT(*) FILTER (WHERE urgency_level = 'urgent') AS urgent_requests,
  COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE) AS today_requests,
  COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '7 days') AS week_requests
FROM customer_requests;

CREATE OR REPLACE FUNCTION fn_create_simple_request(
  p_title text,
  p_description text,
  p_request_type text DEFAULT 'service_inquiry',
  p_urgency_level text DEFAULT 'normal'
) RETURNS uuid AS $$
DECLARE
  v_new_id uuid;
  v_auth_id text;
BEGIN
  v_auth_id := auth.uid()::text;
  IF v_auth_id IS NULL THEN RAISE EXCEPTION '로그인이 필요합니다.'; END IF;

  INSERT INTO customer_requests (user_id, request_type, request_category, title, description, urgency_level)
  VALUES (
    v_auth_id,
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
  ) RETURNING id INTO v_new_id;

  RETURN v_new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 11) 설명 주석
COMMENT ON TABLE customer_requests IS '고객 요청사항 관리 (auth.uid() 비교 필드 TEXT 통일)';
COMMENT ON TABLE customer_request_attachments IS '고객 요청사항 첨부파일';
COMMENT ON TABLE customer_request_history IS '고객 요청사항 처리 히스토리';

-- 완료 확인 셀렉트 (선택 실행)
-- SELECT 'customer_requests 시스템 생성 완료' AS message,
--        (SELECT COUNT(*) FROM information_schema.tables WHERE table_name LIKE 'customer_request%') AS tables_created;
