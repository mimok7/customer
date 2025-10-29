-- 확인서 상태 관리 테이블 생성
CREATE TABLE IF NOT EXISTS confirmation_status (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    reservation_id TEXT NOT NULL REFERENCES reservation(re_id),
    quote_id TEXT,
    status TEXT CHECK (status IN ('waiting', 'generated', 'sent')) DEFAULT 'waiting',
    generated_at TIMESTAMP,
    sent_at TIMESTAMP,
    email_sent_to TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 예약 ID에 대한 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_confirmation_status_reservation_id ON confirmation_status(reservation_id);
CREATE INDEX IF NOT EXISTS idx_confirmation_status_quote_id ON confirmation_status(quote_id);
CREATE INDEX IF NOT EXISTS idx_confirmation_status_status ON confirmation_status(status);

-- 확인서 상태 업데이트 트리거 함수
CREATE OR REPLACE FUNCTION update_confirmation_status_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    
    -- 상태별 타임스탬프 자동 설정
    IF NEW.status = 'generated' AND OLD.status != 'generated' THEN
        NEW.generated_at = NOW();
    END IF;
    
    IF NEW.status = 'sent' AND OLD.status != 'sent' THEN
        NEW.sent_at = NOW();
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
DROP TRIGGER IF EXISTS trigger_update_confirmation_status_timestamp ON confirmation_status;
CREATE TRIGGER trigger_update_confirmation_status_timestamp
    BEFORE UPDATE ON confirmation_status
    FOR EACH ROW
    EXECUTE FUNCTION update_confirmation_status_timestamp();

-- 결제 완료시 자동으로 확인서 대기 상태 생성하는 트리거 함수
CREATE OR REPLACE FUNCTION auto_create_confirmation_waiting()
RETURNS TRIGGER AS $$
BEGIN
    -- 결제가 completed로 변경될 때만 실행
    IF NEW.payment_status = 'completed' AND (OLD.payment_status IS NULL OR OLD.payment_status != 'completed') THEN
        -- 이미 확인서 상태가 있는지 확인
        IF NOT EXISTS (
            SELECT 1 FROM confirmation_status 
            WHERE reservation_id = NEW.reservation_id
        ) THEN
            -- 예약에서 quote_id 가져오기
            INSERT INTO confirmation_status (reservation_id, quote_id, status)
            SELECT NEW.reservation_id, r.re_quote_id, 'waiting'
            FROM reservation r
            WHERE r.re_id = NEW.reservation_id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 결제 테이블에 트리거 생성
DROP TRIGGER IF EXISTS trigger_auto_create_confirmation_waiting ON reservation_payment;
CREATE TRIGGER trigger_auto_create_confirmation_waiting
    AFTER INSERT OR UPDATE ON reservation_payment
    FOR EACH ROW
    EXECUTE FUNCTION auto_create_confirmation_waiting();

-- 기존 완료된 결제에 대해 확인서 상태 생성 (초기 데이터)
INSERT INTO confirmation_status (reservation_id, quote_id, status)
SELECT DISTINCT 
    rp.reservation_id,
    r.re_quote_id,
    'waiting'
FROM reservation_payment rp
JOIN reservation r ON r.re_id = rp.reservation_id
WHERE rp.payment_status = 'completed'
AND NOT EXISTS (
    SELECT 1 FROM confirmation_status cs 
    WHERE cs.reservation_id = rp.reservation_id
);
