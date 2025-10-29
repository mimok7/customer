-- 예약 결제 시스템을 위한 테이블 생성 SQL

-- 1. 예약 결제 내역 테이블 (reservation_payments)
-- 목적: 예약금, 중도금, 잔금 등의 분할 결제 내역 관리
CREATE TABLE IF NOT EXISTS public.reservation_payments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    reservation_id UUID NOT NULL REFERENCES public.reservation(re_id) ON DELETE CASCADE,
    payment_type TEXT NOT NULL CHECK (payment_type IN ('deposit', 'interim', 'final', 'full')), 
    -- deposit: 예약금, interim: 중도금, final: 잔금, full: 일시불
    payment_amount NUMERIC(12,2) NOT NULL CHECK (payment_amount > 0),
    payment_date DATE NOT NULL,
    payment_status TEXT NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'cancelled', 'overdue')),
    payment_method TEXT CHECK (payment_method IN ('card', 'bank_transfer', 'cash', 'other')),
    payment_reference TEXT, -- 결제 참조번호 (PG사 거래번호 등)
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. 기존 reservation 테이블에 결제 관련 컬럼 추가
ALTER TABLE public.reservation 
ADD COLUMN IF NOT EXISTS total_amount NUMERIC(12,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS paid_amount NUMERIC(12,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN ('pending', 'partial', 'completed', 'overdue')),
-- pending: 미결제, partial: 부분결제, completed: 완료, overdue: 연체
ADD COLUMN IF NOT EXISTS checkin_date DATE, -- 체크인 날짜 (알림용)
ADD COLUMN IF NOT EXISTS payment_plan TEXT DEFAULT 'full' CHECK (payment_plan IN ('full', 'split')); 
-- full: 일시불, split: 분할결제

-- 3. 결제 알림 테이블 (payment_notifications)
-- 목적: 체크인 3일 전 알림, 결제 기한 알림 등
CREATE TABLE IF NOT EXISTS public.payment_notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    reservation_id UUID NOT NULL REFERENCES public.reservation(re_id) ON DELETE CASCADE,
    notification_type TEXT NOT NULL CHECK (notification_type IN ('checkin_reminder', 'payment_due', 'payment_overdue')),
    -- checkin_reminder: 체크인 알림, payment_due: 결제 기한, payment_overdue: 연체 알림
    notification_date DATE NOT NULL,
    is_sent BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP WITH TIME ZONE,
    message_content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_reservation_payments_reservation_id ON public.reservation_payments(reservation_id);
CREATE INDEX IF NOT EXISTS idx_reservation_payments_payment_date ON public.reservation_payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_reservation_payments_status ON public.reservation_payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_payment_notifications_reservation_id ON public.payment_notifications(reservation_id);
CREATE INDEX IF NOT EXISTS idx_payment_notifications_date ON public.payment_notifications(notification_date);
CREATE INDEX IF NOT EXISTS idx_reservation_checkin_date ON public.reservation(checkin_date);
CREATE INDEX IF NOT EXISTS idx_reservation_payment_status ON public.reservation(payment_status);

-- 5. RLS (Row Level Security) 정책 설정
ALTER TABLE public.reservation_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_notifications ENABLE ROW LEVEL SECURITY;

-- 예약 결제 내역: 소유자 및 매니저/관리자만 접근
CREATE POLICY reservation_payments_access ON public.reservation_payments
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.reservation r 
            WHERE r.re_id = reservation_id 
            AND (
                r.re_user_id = auth.uid() OR 
                EXISTS (
                    SELECT 1 FROM public.users u 
                    WHERE u.id = auth.uid() 
                    AND u.role IN ('manager', 'admin')
                )
            )
        )
    );

-- 결제 알림: 매니저/관리자만 접근
CREATE POLICY payment_notifications_access ON public.payment_notifications
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.users u 
            WHERE u.id = auth.uid() 
            AND u.role IN ('manager', 'admin')
        )
    );

-- 6. 트리거 함수: 결제 완료시 예약 상태 자동 업데이트
CREATE OR REPLACE FUNCTION update_reservation_payment_status()
RETURNS TRIGGER AS $$
BEGIN
    -- 해당 예약의 총 결제액과 총 예약액 계산
    UPDATE public.reservation 
    SET 
        paid_amount = (
            SELECT COALESCE(SUM(payment_amount), 0) 
            FROM public.reservation_payments 
            WHERE reservation_id = NEW.reservation_id 
            AND payment_status = 'completed'
        ),
        payment_status = CASE 
            WHEN (
                SELECT COALESCE(SUM(payment_amount), 0) 
                FROM public.reservation_payments 
                WHERE reservation_id = NEW.reservation_id 
                AND payment_status = 'completed'
            ) >= total_amount THEN 'completed'
            WHEN (
                SELECT COALESCE(SUM(payment_amount), 0) 
                FROM public.reservation_payments 
                WHERE reservation_id = NEW.reservation_id 
                AND payment_status = 'completed'
            ) > 0 THEN 'partial'
            ELSE 'pending'
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE re_id = NEW.reservation_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
CREATE TRIGGER trigger_update_reservation_payment_status
    AFTER INSERT OR UPDATE ON public.reservation_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_reservation_payment_status();

-- 7. 체크인 알림 자동 생성 함수
CREATE OR REPLACE FUNCTION create_checkin_notifications()
RETURNS VOID AS $$
BEGIN
    -- 체크인 3일 전 알림 생성 (기존에 없는 것만)
    INSERT INTO public.payment_notifications (reservation_id, notification_type, notification_date, message_content)
    SELECT 
        re_id,
        'checkin_reminder',
        checkin_date - INTERVAL '3 days',
        '체크인 3일 전입니다. 준비사항을 확인해주세요.'
    FROM public.reservation 
    WHERE checkin_date IS NOT NULL
    AND checkin_date >= CURRENT_DATE + INTERVAL '3 days'
    AND NOT EXISTS (
        SELECT 1 FROM public.payment_notifications 
        WHERE reservation_id = re_id 
        AND notification_type = 'checkin_reminder'
    );
END;
$$ LANGUAGE plpgsql;

-- 8. 데이터 샘플 삽입 (테스트용)
-- 예시: 크루즈 예약에 분할 결제 계획 추가
INSERT INTO public.reservation_payments (reservation_id, payment_type, payment_amount, payment_date, payment_status)
SELECT 
    re_id,
    'deposit',
    total_amount * 0.3, -- 예약금 30%
    CURRENT_DATE,
    'completed'
FROM public.reservation 
WHERE total_amount > 0
ON CONFLICT DO NOTHING;

-- 중도금 및 잔금 계획 (미래 날짜)
INSERT INTO public.reservation_payments (reservation_id, payment_type, payment_amount, payment_date, payment_status)
SELECT 
    re_id,
    'interim',
    total_amount * 0.4, -- 중도금 40%
    CURRENT_DATE + INTERVAL '30 days',
    'pending'
FROM public.reservation 
WHERE total_amount > 0
ON CONFLICT DO NOTHING;

INSERT INTO public.reservation_payments (reservation_id, payment_type, payment_amount, payment_date, payment_status)
SELECT 
    re_id,
    'final',
    total_amount * 0.3, -- 잔금 30%
    CURRENT_DATE + INTERVAL '60 days',
    'pending'
FROM public.reservation 
WHERE total_amount > 0
ON CONFLICT DO NOTHING;
