-- 고객 요청사항 시스템 - 기존 알림 시스템 활용 (중복 방지)
-- 2025.08.21 - 견적수정, 예약수정, 기타 요청사항 관리

-- 1. 고객 요청사항 메인 테이블
CREATE TABLE IF NOT EXISTS customer_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id VARCHAR(50) UNIQUE NOT NULL DEFAULT 'REQ-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(EXTRACT(EPOCH FROM NOW())::TEXT, 6, '0'),
  
  -- 요청자 정보
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- 요청 유형 및 분류
  request_type VARCHAR(50) NOT NULL CHECK (request_type IN ('quote_modification', 'reservation_modification', 'service_inquiry', 'complaint', 'cancellation', 'additional_service', 'other')),
  request_category VARCHAR(100) NOT NULL, -- '견적 수정', '예약 변경', '서비스 문의' 등
  
  -- 요청 내용
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  urgency_level VARCHAR(20) DEFAULT 'normal' CHECK (urgency_level IN ('low', 'normal', 'high', 'urgent')),
  
  -- 관련 데이터 참조
  related_quote_id VARCHAR(50), -- 견적 관련 요청시 (quote.quote_id 참조)
  related_reservation_id UUID, -- 예약 관련 요청시 (reservation.re_id 참조)
  related_table VARCHAR(50), -- 참조 테이블명
  related_id UUID, -- 참조 데이터 ID
  
  -- 요청 상태
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'rejected', 'cancelled')),
  
  -- 처리 정보
  assigned_to UUID REFERENCES auth.users(id), -- 담당자
  processed_by UUID REFERENCES auth.users(id), -- 처리자
  
  -- 응답 및 처리 내용
  response_message TEXT,
  internal_notes TEXT, -- 내부 처리 메모
  
  -- 메타데이터 (JSON)
  request_data JSONB DEFAULT '{}', -- 요청 관련 상세 데이터
  
  -- 시간 정보
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  due_date TIMESTAMP WITH TIME ZONE, -- 처리 마감일
  processed_at TIMESTAMP WITH TIME ZONE -- 처리 완료일
);

-- 2. 고객 요청사항 첨부파일 테이블
CREATE TABLE IF NOT EXISTS customer_request_attachments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id UUID NOT NULL REFERENCES customer_requests(id) ON DELETE CASCADE,
  
  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  file_size INTEGER,
  file_type VARCHAR(100),
  
  uploaded_by UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 요청사항 처리 히스토리 테이블
CREATE TABLE IF NOT EXISTS customer_request_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id UUID NOT NULL REFERENCES customer_requests(id) ON DELETE CASCADE,
  
  action_type VARCHAR(50) NOT NULL, -- 'created', 'assigned', 'status_changed', 'responded', 'completed'
  previous_status VARCHAR(20),
  new_status VARCHAR(20),
  
  action_by UUID NOT NULL REFERENCES auth.users(id),
  action_note TEXT,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_customer_requests_user_id ON customer_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_customer_requests_status ON customer_requests(status);
CREATE INDEX IF NOT EXISTS idx_customer_requests_type ON customer_requests(request_type);
CREATE INDEX IF NOT EXISTS idx_customer_requests_created_at ON customer_requests(created_at);
CREATE INDEX IF NOT EXISTS idx_customer_requests_quote_id ON customer_requests(related_quote_id);
CREATE INDEX IF NOT EXISTS idx_customer_requests_reservation_id ON customer_requests(related_reservation_id);

-- RLS 정책 설정
ALTER TABLE customer_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_request_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_request_history ENABLE ROW LEVEL SECURITY;

-- 고객은 자신의 요청만 조회/생성 가능
CREATE POLICY customer_requests_owner_policy ON customer_requests
  FOR ALL 
  TO authenticated
  USING (user_id = auth.uid());

-- 매니저/관리자는 모든 요청 조회 가능
CREATE POLICY customer_requests_manager_policy ON customer_requests
  FOR SELECT 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = auth.uid() 
      AND role IN ('manager', 'admin')
    )
  );

-- 매니저/관리자는 요청 상태 변경 가능
CREATE POLICY customer_requests_manager_update_policy ON customer_requests
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
CREATE POLICY customer_request_attachments_owner_policy ON customer_request_attachments
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
      WHERE id = auth.uid() 
      AND role IN ('manager', 'admin')
    )
  );

-- 히스토리 정책
CREATE POLICY customer_request_history_read_policy ON customer_request_history
  FOR SELECT 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM customer_requests cr
      WHERE cr.id = request_id AND cr.user_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM users 
      WHERE id = auth.uid() 
      AND role IN ('manager', 'admin')
    )
  );

CREATE POLICY customer_request_history_insert_policy ON customer_request_history
  FOR INSERT 
  TO authenticated
  WITH CHECK (action_by = auth.uid());

-- 기존 알림 시스템 활용을 위한 트리거 함수
-- (notifications 테이블 재활용)
CREATE OR REPLACE FUNCTION create_customer_request_notification()
RETURNS TRIGGER AS $$
DECLARE
    customer_info RECORD;
BEGIN
    -- 고객 정보 조회
    SELECT name, email, phone INTO customer_info
    FROM users 
    WHERE id = NEW.user_id;

    -- 기존 notifications 테이블에 알림 생성
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
        '고객: ' || COALESCE(customer_info.name, '미등록') || E'\n' ||
        '요청 번호: ' || NEW.request_id || E'\n' ||
        '내용: ' || LEFT(NEW.description, 100) || 
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
            'request_id', NEW.request_id,
            'request_type', NEW.request_type,
            'customer_id', NEW.user_id,
            'customer_name', customer_info.name,
            'customer_email', customer_info.email,
            'customer_phone', customer_info.phone,
            'related_quote_id', NEW.related_quote_id,
            'related_reservation_id', NEW.related_reservation_id,
            'urgency_level', NEW.urgency_level
        ),
        NOW()
    );

    -- 히스토리 기록
    INSERT INTO customer_request_history (
        request_id,
        action_type,
        action_by,
        action_note
    ) VALUES (
        NEW.id,
        'created',
        NEW.user_id,
        '요청사항이 생성되었습니다.'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 설정
CREATE TRIGGER trigger_create_customer_request_notification
  AFTER INSERT ON customer_requests
  FOR EACH ROW
  EXECUTE FUNCTION create_customer_request_notification();

-- 요청사항 상태 업데이트 함수 (기존 알림 시스템 연동)
CREATE OR REPLACE FUNCTION update_customer_request_status(
  p_request_id UUID,
  p_new_status VARCHAR(20),
  p_response_message TEXT DEFAULT NULL,
  p_assigned_user_id UUID DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
  current_status VARCHAR(20);
  current_user_id UUID;
  customer_info RECORD;
BEGIN
  -- 현재 상태 조회
  SELECT status, user_id INTO current_status, current_user_id
  FROM customer_requests 
  WHERE id = p_request_id;
  
  IF NOT FOUND THEN
    RETURN FALSE;
  END IF;
  
  -- 요청사항 업데이트
  UPDATE customer_requests SET
    status = p_new_status,
    response_message = COALESCE(p_response_message, response_message),
    assigned_to = COALESCE(p_assigned_user_id, assigned_to),
    processed_by = CASE WHEN p_new_status = 'completed' THEN auth.uid() ELSE processed_by END,
    processed_at = CASE WHEN p_new_status = 'completed' THEN NOW() ELSE processed_at END,
    updated_at = NOW()
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
    auth.uid(),
    p_response_message
  );
  
  -- 고객 정보 조회
  SELECT name, email INTO customer_info
  FROM users 
  WHERE id = current_user_id;
  
  -- 기존 notifications 테이블에 상태 변경 알림 생성
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
        'request_id', p_request_id,
        'final_status', p_new_status,
        'processed_at', NOW(),
        'customer_name', customer_info.name
      ),
      NOW()
    );
  END IF;
  
  RETURN TRUE;
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
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 데이터 검증 트리거
CREATE TRIGGER trigger_validate_customer_request_data
  BEFORE INSERT OR UPDATE ON customer_requests
  FOR EACH ROW
  EXECUTE FUNCTION validate_customer_request_data();

COMMENT ON TABLE customer_requests IS '고객 요청사항 관리 테이블 - 견적수정, 예약변경, 서비스문의 등 (기존 notifications 테이블 활용)';
COMMENT ON TABLE customer_request_attachments IS '고객 요청사항 첨부파일 테이블';
COMMENT ON TABLE customer_request_history IS '고객 요청사항 처리 히스토리 테이블';

-- 고객 요청사항 시스템 생성 완료 메시지
SELECT 'Customer requests system created with existing notification integration' as result;
