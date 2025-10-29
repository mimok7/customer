-- 예약 결제 시스템 수정 버전 (실제 DB 구조 반영)
-- 기존 reservation 테이블에 필요한 컬럼 추가

-- 1. reservation 테이블에 결제 관련 컬럼 추가
ALTER TABLE public.reservation 
ADD COLUMN IF NOT EXISTS paid_amount NUMERIC DEFAULT 0,
ADD COLUMN IF NOT EXISTS payment_status TEXT DEFAULT 'pending';

-- payment_status 값 제약 조건 추가
DO $$
BEGIN
    -- payment_status 제약 조건이 없으면 추가
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'reservation_payment_status_check'
    ) THEN
        ALTER TABLE public.reservation 
        ADD CONSTRAINT reservation_payment_status_check 
        CHECK (payment_status IN ('pending', 'partial', 'completed', 'cancelled'));
    END IF;
END $$;

-- 2. reservation_payments 테이블 생성 (이미 생성된 경우 스킵)
CREATE TABLE IF NOT EXISTS public.reservation_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES public.reservation(re_id) ON DELETE CASCADE,
    payment_type TEXT NOT NULL CHECK (payment_type IN ('deposit', 'interim', 'final', 'full')),
    payment_amount NUMERIC NOT NULL CHECK (payment_amount > 0),
    payment_date DATE NOT NULL,
    payment_status TEXT NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'cancelled', 'overdue')),
    payment_method TEXT,
    transaction_id TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES auth.users(id)
);

-- 3. payment_notifications 테이블 생성 (이미 생성된 경우 스킵)
CREATE TABLE IF NOT EXISTS public.payment_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES public.reservation(re_id) ON DELETE CASCADE,
    notification_type TEXT NOT NULL CHECK (notification_type IN ('checkin_reminder', 'payment_due', 'payment_overdue', 'payment_completed')),
    notification_date DATE NOT NULL,
    message_content TEXT NOT NULL,
    is_sent BOOLEAN DEFAULT false,
    sent_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    recipient_email TEXT,
    recipient_phone TEXT
);

-- 4. 트리거 함수 수정 (실제 컬럼명 사용)
CREATE OR REPLACE FUNCTION update_reservation_payment_status()
RETURNS TRIGGER AS $$
BEGIN
    -- reservation 테이블의 paid_amount와 payment_status 업데이트
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
        re_update_at = CURRENT_TIMESTAMP
    WHERE re_id = NEW.reservation_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 5. 트리거 생성 (기존 트리거가 있으면 교체)
DROP TRIGGER IF EXISTS payment_status_update_trigger ON public.reservation_payments;
CREATE TRIGGER payment_status_update_trigger
    AFTER INSERT OR UPDATE OF payment_status ON public.reservation_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_reservation_payment_status();

-- 6. RLS 정책 설정
ALTER TABLE public.reservation_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_notifications ENABLE ROW LEVEL SECURITY;

-- 관리자/매니저는 모든 결제 데이터 접근 가능
DO $$
BEGIN
    -- reservation_payments 정책
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'reservation_payments' AND policyname = 'reservation_payments_admin_access'
    ) THEN
        CREATE POLICY reservation_payments_admin_access ON public.reservation_payments
            FOR ALL TO authenticated
            USING (
                EXISTS (
                    SELECT 1 FROM public.users 
                    WHERE id = auth.uid() 
                    AND role IN ('admin', 'manager')
                )
            );
    END IF;

    -- 사용자는 자신의 예약 결제만 조회 가능
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'reservation_payments' AND policyname = 'reservation_payments_user_access'
    ) THEN
        CREATE POLICY reservation_payments_user_access ON public.reservation_payments
            FOR SELECT TO authenticated
            USING (
                EXISTS (
                    SELECT 1 FROM public.reservation 
                    WHERE re_id = reservation_payments.reservation_id 
                    AND re_user_id = auth.uid()
                )
            );
    END IF;

    -- payment_notifications 정책
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'payment_notifications' AND policyname = 'payment_notifications_admin_access'
    ) THEN
        CREATE POLICY payment_notifications_admin_access ON public.payment_notifications
            FOR ALL TO authenticated
            USING (
                EXISTS (
                    SELECT 1 FROM public.users 
                    WHERE id = auth.uid() 
                    AND role IN ('admin', 'manager')
                )
            );
    END IF;
END $$;

-- 7. 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_reservation_payments_reservation_id ON public.reservation_payments(reservation_id);
CREATE INDEX IF NOT EXISTS idx_reservation_payments_payment_date ON public.reservation_payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_reservation_payments_status ON public.reservation_payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_payment_notifications_reservation_id ON public.payment_notifications(reservation_id);
CREATE INDEX IF NOT EXISTS idx_payment_notifications_date ON public.payment_notifications(notification_date);
CREATE INDEX IF NOT EXISTS idx_payment_notifications_sent ON public.payment_notifications(is_sent);

-- 8. 기존 예약 데이터에 기본값 설정
UPDATE public.reservation 
SET 
    paid_amount = 0,
    payment_status = 'pending'
WHERE paid_amount IS NULL OR payment_status IS NULL;

-- 9. 샘플 데이터 삽입 (테스트용)
-- 실제 예약이 있는 경우에만 실행되도록 조건부 삽입
DO $$
DECLARE
    sample_reservation_id UUID;
BEGIN
    -- 첫 번째 예약 ID 가져오기
    SELECT re_id INTO sample_reservation_id 
    FROM public.reservation 
    LIMIT 1;
    
    -- 예약이 있으면 샘플 결제 데이터 삽입
    IF sample_reservation_id IS NOT NULL THEN
        -- 예약금 결제 데이터
        INSERT INTO public.reservation_payments (
            reservation_id, 
            payment_type, 
            payment_amount, 
            payment_date, 
            payment_status,
            notes
        ) VALUES (
            sample_reservation_id,
            'deposit',
            500000,
            CURRENT_DATE + INTERVAL '7 days',
            'pending',
            '예약금 결제 (샘플 데이터)'
        ) ON CONFLICT DO NOTHING;
        
        -- 체크인 알림 데이터
        INSERT INTO public.payment_notifications (
            reservation_id,
            notification_type,
            notification_date,
            message_content
        ) VALUES (
            sample_reservation_id,
            'checkin_reminder',
            CURRENT_DATE + INTERVAL '10 days',
            '체크인 3일 전 알림입니다. (샘플 데이터)'
        ) ON CONFLICT DO NOTHING;
        
        RAISE NOTICE '샘플 데이터가 삽입되었습니다. 예약 ID: %', sample_reservation_id;
    ELSE
        RAISE NOTICE '기존 예약 데이터가 없어 샘플 데이터를 삽입하지 않았습니다.';
    END IF;
END $$;
