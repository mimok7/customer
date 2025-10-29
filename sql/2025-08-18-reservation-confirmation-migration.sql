-- 예약확인서 테이블 구조 개선: 예약ID(reservation_id) 필수화, 견적ID(quote_id) 옵션화
-- 적용일: 2025-08-18

ALTER TABLE public.reservation_confirmation
  ADD COLUMN IF NOT EXISTS reservation_id uuid;

-- 기존 quote_id는 NOT NULL → NULL 허용
ALTER TABLE public.reservation_confirmation
  ALTER COLUMN quote_id DROP NOT NULL;

-- 예약ID 필수화 (기존 데이터가 모두 채워진 후 적용 권장)
ALTER TABLE public.reservation_confirmation
  ALTER COLUMN reservation_id SET NOT NULL;

-- FK 연결: 예약ID → reservation.re_id
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint c
    JOIN pg_class t ON c.conrelid = t.oid
    WHERE t.relname = 'reservation_confirmation'
      AND c.conname = 'reservation_confirmation_reservation_fk'
  ) THEN
    EXECUTE 'ALTER TABLE public.reservation_confirmation
             ADD CONSTRAINT reservation_confirmation_reservation_fk
             FOREIGN KEY (reservation_id) REFERENCES public.reservation(re_id) ON DELETE CASCADE';
  END IF;
END$$;

-- 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_reservation_confirmation_reservation_id
  ON public.reservation_confirmation (reservation_id);

-- (선택) 기존 데이터 마이그레이션 예시
-- UPDATE public.reservation_confirmation rc
--   SET reservation_id = r.re_id
--  FROM public.reservation r
-- WHERE rc.quote_id = r.re_quote_id
--   AND rc.reservation_id IS NULL;
