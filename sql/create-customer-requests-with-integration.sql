-- 고객 요청사항 시스템 - 기존 알림 시스템과 연동
-- 2025.08.21 - customer_notifications는 이미 존재, customer_requests만 생성

-- 고객 요청사항 테이블이 없는 경우에만 생성
DO $$
BEGIN
    -- customer_requests 테이블 존재 여부 확인
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'customer_requests'
    ) THEN
        -- 1. 고객 요청사항 메인 테이블 생성
        CREATE TABLE customer_requests (
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
        CREATE TABLE customer_request_attachments (
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
        CREATE TABLE customer_request_history (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          request_id UUID NOT NULL REFERENCES customer_requests(id) ON DELETE CASCADE,
          
          action_type VARCHAR(50) NOT NULL, -- 'created', 'assigned', 'status_changed', 'responded', 'completed'
          previous_status VARCHAR(20),
          new_status VARCHAR(20),
          
          action_by UUID NOT NULL REFERENCES auth.users(id),
          action_note TEXT,
          
          created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );

        RAISE NOTICE 'customer_requests 테이블들이 생성되었습니다.';
    ELSE
        RAISE NOTICE 'customer_requests 테이블이 이미 존재합니다.';
    END IF;
END
$$;

-- 인덱스 생성 (중복 생성 방지)
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

-- 기존 정책이 있는지 확인 후 생성
DO $$
BEGIN
    -- 고객은 자신의 요청만 조회/생성 가능
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'customer_requests' 
        AND policyname = 'customer_requests_owner_policy'
    ) THEN
        CREATE POLICY customer_requests_owner_policy ON customer_requests
          FOR ALL 
          TO authenticated
          USING (user_id = auth.uid());
    END IF;

    -- 매니저/관리자는 모든 요청 조회 가능
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'customer_requests' 
        AND policyname = 'customer_requests_manager_policy'
    ) THEN
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
    END IF;

    -- 매니저/관리자는 요청 상태 변경 가능
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'customer_requests' 
        AND policyname = 'customer_requests_manager_update_policy'
    ) THEN
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
    END IF;
END
$$;

-- 첨부파일 및 히스토리 정책 (동일하게 중복 방지)
DO $$
BEGIN
    -- 첨부파일 정책
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'customer_request_attachments' 
        AND policyname = 'customer_request_attachments_owner_policy'
    ) THEN
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
    END IF;

    -- 히스토리 읽기 정책
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'customer_request_history' 
        AND policyname = 'customer_request_history_read_policy'
    ) THEN
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
    END IF;

    -- 히스토리 생성 정책
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'customer_request_history' 
        AND policyname = 'customer_request_history_insert_policy'
    ) THEN
        CREATE POLICY customer_request_history_insert_policy ON customer_request_history
          FOR INSERT 
          TO authenticated
          WITH CHECK (action_by = auth.uid());
    END IF;
END
$$;

-- 기존 customer_notifications와 연동하는 트리거 함수
CREATE OR REPLACE FUNCTION create_customer_request_notification()
RETURNS TRIGGER AS $$
DECLARE
    customer_info RECORD;
    notification_rec RECORD;
BEGIN
    -- 고객 정보 조회
    SELECT name, email, phone INTO customer_info
    FROM users 
    WHERE id = NEW.user_id;

    -- 1. 메인 notifications 테이블에 알림 생성
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
    ) RETURNING * INTO notification_rec;

    -- 2. 기존 customer_notifications 테이블에 상세 정보 저장
    INSERT INTO customer_notifications (
        notification_id,
        customer_id,
        customer_name,
        customer_phone,
        customer_email,
        inquiry_type,
        service_type,
        response_deadline,
        follow_up_required,
        created_at
    ) VALUES (
        notification_rec.id,
        NEW.user_id,
        customer_info.name,
        customer_info.phone,
        customer_info.email,
        NEW.request_category,
        CASE NEW.request_type
            WHEN 'quote_modification' THEN 'cruise'
            WHEN 'reservation_modification' THEN 'general'
            ELSE 'general'
        END,
        -- 긴급도에 따른 응답 기한 설정
        CASE NEW.urgency_level
            WHEN 'urgent' THEN NOW() + INTERVAL '4 hours'
            WHEN 'high' THEN NOW() + INTERVAL '1 day'
            WHEN 'normal' THEN NOW() + INTERVAL '2 days'
            ELSE NOW() + INTERVAL '3 days'
        END,
        CASE NEW.urgency_level
            WHEN 'urgent' THEN TRUE
            WHEN 'high' THEN TRUE
            ELSE FALSE
        END,
        NOW()
    );

    -- 3. 히스토리 기록
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

-- 트리거가 이미 있는지 확인 후 생성
DROP TRIGGER IF EXISTS trigger_create_customer_request_notification ON customer_requests;
CREATE TRIGGER trigger_create_customer_request_notification
  AFTER INSERT ON customer_requests
  FOR EACH ROW
  EXECUTE FUNCTION create_customer_request_notification();

-- 요청사항 상태 업데이트 함수 (기존 customer_notifications 연동)
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
  notification_id UUID;
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
  
  -- 기존 알림 상태 업데이트
  UPDATE notifications 
  SET 
    status = CASE 
      WHEN p_new_status = 'completed' THEN 'completed'
      WHEN p_new_status = 'rejected' THEN 'completed'
      WHEN p_new_status = 'in_progress' THEN 'processing'
      ELSE 'unread'
    END,
    updated_at = NOW(),
    processed_at = CASE 
      WHEN p_new_status IN ('completed', 'rejected') THEN NOW() 
      ELSE processed_at 
    END
  WHERE target_table = 'customer_requests' 
  AND target_id = p_request_id::text;
  
  -- customer_notifications 업데이트
  UPDATE customer_notifications 
  SET 
    resolution_notes = p_response_message,
    customer_satisfaction = CASE WHEN p_new_status = 'completed' THEN 5 ELSE customer_satisfaction END,
    updated_at = NOW()
  WHERE notification_id IN (
    SELECT id FROM notifications 
    WHERE target_table = 'customer_requests' 
    AND target_id = p_request_id::text
  );
  
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
DROP TRIGGER IF EXISTS trigger_validate_customer_request_data ON customer_requests;
CREATE TRIGGER trigger_validate_customer_request_data
  BEFORE INSERT OR UPDATE ON customer_requests
  FOR EACH ROW
  EXECUTE FUNCTION validate_customer_request_data();

-- 테이블 코멘트
COMMENT ON TABLE customer_requests IS '고객 요청사항 관리 테이블 - 견적수정, 예약변경, 서비스문의 등 (customer_notifications와 연동)';
COMMENT ON TABLE customer_request_attachments IS '고객 요청사항 첨부파일 테이블';
COMMENT ON TABLE customer_request_history IS '고객 요청사항 처리 히스토리 테이블';

-- 완료 메시지
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'customer_requests')
        THEN '✅ customer_requests 시스템이 생성되어 기존 customer_notifications와 연동되었습니다.'
        ELSE '❌ customer_requests 테이블 생성에 실패했습니다.'
    END as result;
