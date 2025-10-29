-- 체크인 알림을 자동으로 생성하는 함수
-- 이 함수는 예약 생성/수정 시 또는 주기적으로 실행될 수 있습니다.

CREATE OR REPLACE FUNCTION generate_checkin_notifications()
RETURNS TEXT AS $$
DECLARE
    notification_count INT := 0;
    reservation_record RECORD;
BEGIN
    -- 체크인 3일 전 알림 생성 대상 예약 찾기
    FOR reservation_record IN
        SELECT 
            r.re_id,
            r.checkin_date,
            u.name as customer_name
        FROM reservation r
        JOIN users u ON r.re_user_id = u.id
        WHERE r.checkin_date IS NOT NULL
        AND r.checkin_date >= CURRENT_DATE + INTERVAL '3 days'
        AND r.checkin_date <= CURRENT_DATE + INTERVAL '5 days' -- 3-5일 사이
        AND NOT EXISTS (
            SELECT 1 FROM payment_notifications pn
            WHERE pn.reservation_id = r.re_id 
            AND pn.notification_type = 'checkin_reminder'
        )
    LOOP
        -- 체크인 3일 전 알림 생성
        INSERT INTO payment_notifications (
            reservation_id,
            notification_type,
            notification_date,
            message_content
        ) VALUES (
            reservation_record.re_id,
            'checkin_reminder',
            reservation_record.checkin_date - INTERVAL '3 days',
            format('안녕하세요 %s님! 체크인일이 3일 앞으로 다가왔습니다. 체크인일: %s', 
                   reservation_record.customer_name, 
                   to_char(reservation_record.checkin_date, 'YYYY-MM-DD'))
        );
        
        notification_count := notification_count + 1;
    END LOOP;
    
    RETURN format('체크인 알림 %s개가 생성되었습니다.', notification_count);
END;
$$ LANGUAGE plpgsql;

-- 결제 기한 알림을 생성하는 함수
CREATE OR REPLACE FUNCTION generate_payment_due_notifications()
RETURNS TEXT AS $$
DECLARE
    notification_count INT := 0;
    payment_record RECORD;
BEGIN
    -- 결제 기한 1일 전 알림 생성 대상 찾기
    FOR payment_record IN
        SELECT 
            rp.reservation_id,
            rp.payment_date,
            rp.payment_amount,
            rp.payment_type,
            u.name as customer_name
        FROM reservation_payments rp
        JOIN reservation r ON rp.reservation_id = r.re_id
        JOIN users u ON r.re_user_id = u.id
        WHERE rp.payment_status = 'pending'
        AND rp.payment_date = CURRENT_DATE + INTERVAL '1 day' -- 내일이 결제일
        AND NOT EXISTS (
            SELECT 1 FROM payment_notifications pn
            WHERE pn.reservation_id = rp.reservation_id 
            AND pn.notification_type = 'payment_due'
            AND pn.notification_date = rp.payment_date - INTERVAL '1 day'
        )
    LOOP
        -- 결제 기한 알림 생성
        INSERT INTO payment_notifications (
            reservation_id,
            notification_type,
            notification_date,
            message_content
        ) VALUES (
            payment_record.reservation_id,
            'payment_due',
            payment_record.payment_date - INTERVAL '1 day',
            format('안녕하세요 %s님! %s (%s원) 결제 기한이 내일(%s)입니다.', 
                   payment_record.customer_name,
                   CASE payment_record.payment_type
                       WHEN 'deposit' THEN '예약금'
                       WHEN 'interim' THEN '중도금'
                       WHEN 'final' THEN '잔금'
                       ELSE '결제'
                   END,
                   payment_record.payment_amount,
                   to_char(payment_record.payment_date, 'YYYY-MM-DD'))
        );
        
        notification_count := notification_count + 1;
    END LOOP;
    
    RETURN format('결제 기한 알림 %s개가 생성되었습니다.', notification_count);
END;
$$ LANGUAGE plpgsql;

-- 연체 알림을 생성하는 함수
CREATE OR REPLACE FUNCTION generate_overdue_notifications()
RETURNS TEXT AS $$
DECLARE
    notification_count INT := 0;
    overdue_record RECORD;
BEGIN
    -- 연체된 결제에 대한 알림 생성
    FOR overdue_record IN
        SELECT 
            rp.id as payment_id,
            rp.reservation_id,
            rp.payment_date,
            rp.payment_amount,
            rp.payment_type,
            u.name as customer_name,
            CURRENT_DATE - rp.payment_date as overdue_days
        FROM reservation_payments rp
        JOIN reservation r ON rp.reservation_id = r.re_id
        JOIN users u ON r.re_user_id = u.id
        WHERE rp.payment_status = 'pending'
        AND rp.payment_date < CURRENT_DATE -- 결제일이 지났음
        AND NOT EXISTS (
            SELECT 1 FROM payment_notifications pn
            WHERE pn.reservation_id = rp.reservation_id 
            AND pn.notification_type = 'payment_overdue'
            AND pn.created_at::date = CURRENT_DATE -- 오늘 이미 연체 알림이 있는지 확인
        )
    LOOP
        -- 연체 알림 생성
        INSERT INTO payment_notifications (
            reservation_id,
            notification_type,
            notification_date,
            message_content
        ) VALUES (
            overdue_record.reservation_id,
            'payment_overdue',
            CURRENT_DATE,
            format('안녕하세요 %s님! %s (%s원) 결제가 %s일 연체되었습니다. 빠른 처리 부탁드립니다.', 
                   overdue_record.customer_name,
                   CASE overdue_record.payment_type
                       WHEN 'deposit' THEN '예약금'
                       WHEN 'interim' THEN '중도금'  
                       WHEN 'final' THEN '잔금'
                       ELSE '결제'
                   END,
                   overdue_record.payment_amount,
                   overdue_record.overdue_days)
        );
        
        -- 해당 결제를 연체 상태로 업데이트
        UPDATE reservation_payments 
        SET payment_status = 'overdue'
        WHERE id = overdue_record.payment_id;
        
        notification_count := notification_count + 1;
    END LOOP;
    
    RETURN format('연체 알림 %s개가 생성되었습니다.', notification_count);
END;
$$ LANGUAGE plpgsql;

-- 모든 알림을 한번에 생성하는 통합 함수
CREATE OR REPLACE FUNCTION generate_all_notifications()
RETURNS TEXT AS $$
DECLARE
    checkin_result TEXT;
    payment_due_result TEXT;
    overdue_result TEXT;
BEGIN
    -- 각 함수 실행
    SELECT generate_checkin_notifications() INTO checkin_result;
    SELECT generate_payment_due_notifications() INTO payment_due_result;
    SELECT generate_overdue_notifications() INTO overdue_result;
    
    RETURN format('알림 생성 완료 - %s | %s | %s', 
                  checkin_result, 
                  payment_due_result, 
                  overdue_result);
END;
$$ LANGUAGE plpgsql;

-- 예시: 알림 생성 함수 실행
-- SELECT generate_all_notifications();

-- 알림 정리 함수 (30일 이상 된 처리된 알림 삭제)
CREATE OR REPLACE FUNCTION cleanup_old_notifications()
RETURNS TEXT AS $$
DECLARE
    deleted_count INT;
BEGIN
    DELETE FROM payment_notifications 
    WHERE is_sent = true 
    AND created_at < CURRENT_DATE - INTERVAL '30 days';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    
    RETURN format('30일 이상 된 알림 %s개가 정리되었습니다.', deleted_count);
END;
$$ LANGUAGE plpgsql;
