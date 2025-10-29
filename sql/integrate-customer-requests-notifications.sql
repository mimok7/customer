-- 기존 알림 시스템에 고객 요청사항 연동 추가
-- 2025.08.21 - 기존 notifications 테이블 활용

-- 1. target_id 타입 변경 (이미 테이블이 있다면)
-- ALTER TABLE notifications ALTER COLUMN target_id TYPE TEXT;

-- 2. 고객 요청사항 알림 템플릿 추가
INSERT INTO notification_templates (name, type, category, title_template, message_template, default_priority) VALUES
('견적 수정 요청', 'customer', '견적수정요청', '견적 수정 요청: {customer_name}', '{customer_name}님의 견적 수정 요청입니다. 요청번호: {request_id}', 'normal'),
('예약 변경 요청', 'customer', '예약변경요청', '예약 변경 요청: {customer_name}', '{customer_name}님의 예약 변경 요청입니다. 요청번호: {request_id}', 'normal'),
('서비스 문의', 'customer', '서비스문의', '서비스 문의: {customer_name}', '{customer_name}님의 서비스 문의입니다. 요청번호: {request_id}', 'normal'),
('불만 접수', 'customer', '불만접수', '고객 불만: {customer_name}', '{customer_name}님의 불만이 접수되었습니다. 요청번호: {request_id}', 'urgent'),
('취소 요청', 'customer', '취소요청', '취소 요청: {customer_name}', '{customer_name}님의 취소 요청입니다. 요청번호: {request_id}', 'high'),
('추가 서비스 요청', 'customer', '추가서비스요청', '추가 서비스 요청: {customer_name}', '{customer_name}님의 추가 서비스 요청입니다. 요청번호: {request_id}', 'normal'),
('기타 요청', 'customer', '기타요청', '기타 요청: {customer_name}', '{customer_name}님의 기타 요청입니다. 요청번호: {request_id}', 'normal')
ON CONFLICT (name, type, category) DO NOTHING;

-- 3. 고객 요청사항 알림 자동 생성 함수 (기존 notifications 테이블 사용)
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

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. 고객 요청사항 상태 변경시 알림 업데이트 함수
CREATE OR REPLACE FUNCTION update_customer_request_notification()
RETURNS TRIGGER AS $$
DECLARE
    customer_info RECORD;
BEGIN
    -- 상태가 변경된 경우에만 처리
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        -- 고객 정보 조회
        SELECT name, email FROM users WHERE id = NEW.user_id INTO customer_info;
        
        -- 기존 알림 상태 업데이트
        UPDATE notifications 
        SET 
            status = CASE 
                WHEN NEW.status = 'completed' THEN 'completed'
                WHEN NEW.status = 'rejected' THEN 'completed'
                WHEN NEW.status = 'in_progress' THEN 'processing'
                ELSE 'unread'
            END,
            updated_at = NOW(),
            processed_at = CASE 
                WHEN NEW.status IN ('completed', 'rejected') THEN NOW() 
                ELSE processed_at 
            END
        WHERE target_table = 'customer_requests' 
        AND target_id = NEW.id::text;

        -- 처리 완료시 고객에게 결과 알림 생성 (선택사항)
        IF NEW.status IN ('completed', 'rejected') AND NEW.response_message IS NOT NULL THEN
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
                CASE NEW.status 
                    WHEN 'completed' THEN '요청처리완료'
                    WHEN 'rejected' THEN '요청거부'
                END,
                '요청사항 처리 결과 안내',
                '요청번호: ' || NEW.request_id || E'\n' ||
                CASE NEW.status 
                    WHEN 'completed' THEN '요청하신 사항이 처리되었습니다.'
                    WHEN 'rejected' THEN '요청하신 사항이 거부되었습니다.'
                END || E'\n\n처리 내용: ' || NEW.response_message,
                'normal',
                'unread',
                'customer_requests',
                NEW.id::text,
                jsonb_build_object(
                    'request_id', NEW.request_id,
                    'final_status', NEW.status,
                    'processed_at', NOW(),
                    'customer_name', customer_info.name
                ),
                NOW()
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 알림 시스템과 고객 요청사항 연동 완료 메시지
SELECT 'Customer requests integrated with existing notification system successfully' as result;
