-- 결제 예정일 컬럼 추가 (payment notifications 테이블 개선)
-- 2025-08-24 생성

-- 1. reservation_payments 테이블에 예정일 컬럼 추가
ALTER TABLE reservation_payments
ADD COLUMN IF NOT EXISTS interim_due_date date,
ADD COLUMN IF NOT EXISTS final_due_date date;

-- 2. payment_notifications 테이블에 긴급도 컬럼 추가
ALTER TABLE payment_notifications
ADD COLUMN IF NOT EXISTS priority text DEFAULT 'normal';

-- 3. 긴급도 제약 조건 추가
ALTER TABLE payment_notifications
ADD CONSTRAINT payment_notifications_priority_check 
CHECK (priority IN ('normal', 'high', 'urgent'));

-- 4. 인덱스 추가 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_payment_notifications_priority 
ON payment_notifications(priority);

CREATE INDEX IF NOT EXISTS idx_payment_notifications_is_sent_date 
ON payment_notifications(is_sent, notification_date);

CREATE INDEX IF NOT EXISTS idx_reservation_payments_due_dates 
ON reservation_payments(interim_due_date, final_due_date);

-- 5. 기존 알림 데이터에 기본 긴급도 설정
UPDATE payment_notifications 
SET priority = CASE 
    WHEN notification_type = 'payment_overdue' THEN 'urgent'
    WHEN notification_type = 'payment_due' THEN 'high'
    ELSE 'normal'
END
WHERE priority IS NULL;

COMMENT ON COLUMN reservation_payments.interim_due_date IS '중도금 결제 예정일';
COMMENT ON COLUMN reservation_payments.final_due_date IS '잔금 결제 예정일';
COMMENT ON COLUMN payment_notifications.priority IS '알림 긴급도: normal(일반), high(중요), urgent(긴급)';
