-- 🎯 예약 결제 시스템 완전 설치 스크립트
-- 한 번에 실행 가능한 통합 SQL

-- ====================================
-- 1. reservation 테이블에 결제 관련 컬럼 추가
-- ====================================
ALTER TABLE public.reservation 
ADD COLUMN IF NOT EXISTS paid_amount NUMERIC DEFAULT 0,
ADD COLUMN IF NOT EXISTS payment_status TEXT DEFAULT 'pending';

-- payment_status 값 제약 조건 추가
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'reservation_payment_status_check'
    ) THEN
        ALTER TABLE public.reservation 
        ADD CONSTRAINT reservation_payment_status_check 
        CHECK (payment_status IN ('pending', 'partial', 'completed', 'cancelled'));
    END IF;
END $$;

-- ====================================
-- 2. reservation_payments 테이블 생성
-- ====================================
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

-- ====================================
-- 3. payment_notifications 테이블 생성
-- ====================================
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

-- ====================================
-- 4. 트리거 함수 생성
-- ====================================
CREATE OR REPLACE FUNCTION update_reservation_payment_status()
RETURNS TRIGGER AS $$
BEGIN
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
            ) >= COALESCE(total_amount, 0) THEN 'completed'
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

-- ====================================
-- 5. 트리거 생성
-- ====================================
DROP TRIGGER IF EXISTS payment_status_update_trigger ON public.reservation_payments;
CREATE TRIGGER payment_status_update_trigger
    AFTER INSERT OR UPDATE OF payment_status ON public.reservation_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_reservation_payment_status();

-- ====================================
-- 6. RLS 정책 설정
-- ====================================
ALTER TABLE public.reservation_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_notifications ENABLE ROW LEVEL SECURITY;

-- 기존 정책 삭제 후 재생성
DROP POLICY IF EXISTS reservation_payments_admin_access ON public.reservation_payments;
DROP POLICY IF EXISTS reservation_payments_user_access ON public.reservation_payments;
DROP POLICY IF EXISTS payment_notifications_admin_access ON public.payment_notifications;

-- 관리자/매니저 전체 접근 정책
CREATE POLICY reservation_payments_admin_access ON public.reservation_payments
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() 
            AND role IN ('admin', 'manager')
        )
    );

-- 사용자 본인 예약 접근 정책
CREATE POLICY reservation_payments_user_access ON public.reservation_payments
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.reservation 
            WHERE re_id = reservation_payments.reservation_id 
            AND re_user_id = auth.uid()
        )
    );

-- 알림 테이블 관리자/매니저 접근 정책
CREATE POLICY payment_notifications_admin_access ON public.payment_notifications
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() 
            AND role IN ('admin', 'manager')
        )
    );

-- ====================================
-- 7. 인덱스 생성 (성능 최적화)
-- ====================================
CREATE INDEX IF NOT EXISTS idx_reservation_payments_reservation_id ON public.reservation_payments(reservation_id);
CREATE INDEX IF NOT EXISTS idx_reservation_payments_payment_date ON public.reservation_payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_reservation_payments_status ON public.reservation_payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_payment_notifications_reservation_id ON public.payment_notifications(reservation_id);
CREATE INDEX IF NOT EXISTS idx_payment_notifications_date ON public.payment_notifications(notification_date);
CREATE INDEX IF NOT EXISTS idx_payment_notifications_sent ON public.payment_notifications(is_sent);

-- ====================================
-- 8. 기존 예약 데이터 업데이트
-- ====================================
UPDATE public.reservation 
SET 
    paid_amount = 0,
    payment_status = 'pending'
WHERE paid_amount IS NULL OR payment_status IS NULL;

-- ====================================
-- 9. 알림 생성 함수들
-- ====================================

-- 체크인 알림 생성 함수
CREATE OR REPLACE FUNCTION generate_checkin_notifications()
RETURNS TEXT AS $$
DECLARE
    notification_count INT := 0;
    reservation_record RECORD;
BEGIN
    FOR reservation_record IN
        SELECT 
            r.re_id,
            r.checkin_date,
            u.name as customer_name
        FROM reservation r
        JOIN users u ON r.re_user_id = u.id
        WHERE r.checkin_date IS NOT NULL
        AND r.checkin_date >= CURRENT_DATE + INTERVAL '3 days'
        AND r.checkin_date <= CURRENT_DATE + INTERVAL '5 days'
        AND NOT EXISTS (
            SELECT 1 FROM payment_notifications pn
            WHERE pn.reservation_id = r.re_id 
            AND pn.notification_type = 'checkin_reminder'
        )
    LOOP
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

-- 결제 기한 알림 생성 함수
CREATE OR REPLACE FUNCTION generate_payment_due_notifications()
RETURNS TEXT AS $$
DECLARE
    notification_count INT := 0;
    payment_record RECORD;
BEGIN
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
        AND rp.payment_date = CURRENT_DATE + INTERVAL '1 day'
        AND NOT EXISTS (
            SELECT 1 FROM payment_notifications pn
            WHERE pn.reservation_id = rp.reservation_id 
            AND pn.notification_type = 'payment_due'
            AND pn.notification_date = rp.payment_date - INTERVAL '1 day'
        )
    LOOP
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

-- 모든 알림 생성 통합 함수
CREATE OR REPLACE FUNCTION generate_all_notifications()
RETURNS TEXT AS $$
DECLARE
    checkin_result TEXT;
    payment_due_result TEXT;
BEGIN
    SELECT generate_checkin_notifications() INTO checkin_result;
    SELECT generate_payment_due_notifications() INTO payment_due_result;
    
    RETURN format('알림 생성 완료 - %s | %s', 
                  checkin_result, 
                  payment_due_result);
END;
$$ LANGUAGE plpgsql;

-- ====================================
-- 10. 샘플 데이터 삽입 (선택사항)
-- ====================================
DO $$
DECLARE
    sample_reservation_id UUID;
BEGIN
    SELECT re_id INTO sample_reservation_id 
    FROM public.reservation 
    LIMIT 1;
    
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
        
        RAISE NOTICE '✅ 샘플 데이터가 삽입되었습니다. 예약 ID: %', sample_reservation_id;
    ELSE
        RAISE NOTICE '⚠️ 기존 예약 데이터가 없어 샘플 데이터를 삽입하지 않았습니다.';
    END IF;
END $$;

-- ====================================
-- 11. 설치 완료 확인
-- ====================================
DO $$
BEGIN
    RAISE NOTICE '🎉 예약 결제 시스템 설치가 완료되었습니다!';
    RAISE NOTICE '📋 생성된 테이블: reservation_payments, payment_notifications';
    RAISE NOTICE '🔧 생성된 함수: generate_checkin_notifications, generate_payment_due_notifications, generate_all_notifications';
    RAISE NOTICE '⚡ 트리거: payment_status_update_trigger (자동 결제 상태 업데이트)';
    RAISE NOTICE '🔒 RLS 정책: 관리자/매니저 전체 접근, 사용자 본인 예약만 접근';
END $$;
