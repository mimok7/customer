-- confirmation_status 테이블 생성 및 동기화 트리거
-- 실행 전제: public 스키마, uuid 기본키/외래키 사용

-- 1) 테이블 생성
CREATE TABLE IF NOT EXISTS public.confirmation_status (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reservation_id uuid NOT NULL REFERENCES public.reservation(re_id) ON DELETE CASCADE,
  quote_id uuid REFERENCES public.quote(id) ON DELETE SET NULL,
  status text NOT NULL CHECK (status IN ('waiting','generated','sent')) DEFAULT 'waiting',
  generated_at timestamptz,
  sent_at timestamptz,
  email_sent_to text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- 1-1) 유니크 제약: 예약 당 1행
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint c
    JOIN pg_class t ON c.conrelid = t.oid
    WHERE t.relname = 'confirmation_status' AND c.conname = 'confirmation_status_reservation_unique'
  ) THEN
    ALTER TABLE public.confirmation_status
      ADD CONSTRAINT confirmation_status_reservation_unique UNIQUE (reservation_id);
  END IF;
END$$;

-- 1-2) 인덱스
CREATE INDEX IF NOT EXISTS idx_confirmation_status_reservation_id ON public.confirmation_status(reservation_id);
CREATE INDEX IF NOT EXISTS idx_confirmation_status_quote_id ON public.confirmation_status(quote_id);
CREATE INDEX IF NOT EXISTS idx_confirmation_status_status ON public.confirmation_status(status);

-- 2) 타임스탬프/상태 추적 트리거 함수
CREATE OR REPLACE FUNCTION public.update_confirmation_status_timestamp()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();

  IF TG_OP = 'INSERT' THEN
    IF NEW.status = 'generated' AND NEW.generated_at IS NULL THEN
      NEW.generated_at := now();
    END IF;
    IF NEW.status = 'sent' AND NEW.sent_at IS NULL THEN
      NEW.sent_at := now();
    END IF;
  END IF;

  IF TG_OP = 'UPDATE' THEN
    IF NEW.status = 'generated' AND (OLD.status IS DISTINCT FROM 'generated') THEN
      NEW.generated_at := now();
    END IF;
    IF NEW.status = 'sent' AND (OLD.status IS DISTINCT FROM 'sent') THEN
      NEW.sent_at := now();
    END IF;
  END IF;

  RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_confirmation_status_timestamp ON public.confirmation_status;
CREATE TRIGGER trg_update_confirmation_status_timestamp
BEFORE INSERT OR UPDATE ON public.confirmation_status
FOR EACH ROW EXECUTE FUNCTION public.update_confirmation_status_timestamp();

-- 3) 결제 완료 시 자동으로 waiting 행 생성
CREATE OR REPLACE FUNCTION public.auto_create_confirmation_waiting()
RETURNS trigger AS $$
BEGIN
  IF NEW.payment_status = 'completed' AND (OLD.payment_status IS DISTINCT FROM 'completed') THEN
    -- 존재 여부 확인 후 생성
    IF NOT EXISTS (
      SELECT 1 FROM public.confirmation_status cs WHERE cs.reservation_id = NEW.reservation_id
    ) THEN
      INSERT INTO public.confirmation_status (reservation_id, quote_id, status)
      SELECT NEW.reservation_id, r.re_quote_id, 'waiting'
      FROM public.reservation r
      WHERE r.re_id = NEW.reservation_id;
    END IF;
  END IF;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auto_create_confirmation_waiting ON public.reservation_payment;
CREATE TRIGGER trg_auto_create_confirmation_waiting
AFTER INSERT OR UPDATE ON public.reservation_payment
FOR EACH ROW EXECUTE FUNCTION public.auto_create_confirmation_waiting();

-- 4) 초기 데이터 백필: 완료 결제에 대해 waiting 생성
INSERT INTO public.confirmation_status (reservation_id, quote_id, status)
SELECT DISTINCT rp.reservation_id, r.re_quote_id, 'waiting'
FROM public.reservation_payment rp
JOIN public.reservation r ON r.re_id = rp.reservation_id
WHERE rp.payment_status = 'completed'
  AND NOT EXISTS (
    SELECT 1 FROM public.confirmation_status cs WHERE cs.reservation_id = rp.reservation_id
  );
