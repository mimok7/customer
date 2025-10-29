-- sql/add_assignment_and_dispatch_codes.sql
-- 2025-08-30
-- 목적: reservation_hotel에 배정코드(assignment_code)를 추가하고
--       예약 관련 차량/렌터카/공항 테이블에 배차코드(dispatch_code)를 추가합니다.
-- 주의: 안전하게 여러 번 실행할 수 있도록 IF NOT EXISTS 사용

BEGIN;

-- 1) 호텔 예약: 배정코드 (assignment_code)
ALTER TABLE public.reservation_hotel
    ADD COLUMN IF NOT EXISTS assignment_code text;

-- 인덱스 (필요 시 배정코드로 빠르게 조회하기 위함)
CREATE INDEX IF NOT EXISTS idx_reservation_hotel_assignment_code ON public.reservation_hotel (assignment_code);

-- 2) 크루즈 카 예약: 배차코드 (dispatch_code)
ALTER TABLE public.reservation_cruise_car
    ADD COLUMN IF NOT EXISTS dispatch_code text;
CREATE INDEX IF NOT EXISTS idx_reservation_cruise_car_dispatch_code ON public.reservation_cruise_car (dispatch_code);

-- 3) 렌터카 예약: 배차코드 (dispatch_code)
ALTER TABLE public.reservation_rentcar
    ADD COLUMN IF NOT EXISTS dispatch_code text;
CREATE INDEX IF NOT EXISTS idx_reservation_rentcar_dispatch_code ON public.reservation_rentcar (dispatch_code);

-- 4) 공항(픽업/샌딩) 예약: 배차코드 (dispatch_code)
ALTER TABLE public.reservation_airport
    ADD COLUMN IF NOT EXISTS dispatch_code text;
CREATE INDEX IF NOT EXISTS idx_reservation_airport_dispatch_code ON public.reservation_airport (dispatch_code);

-- 5) 추가: 스하 차량 예약에도 배차코드 필요하면 포함 (옵션)
ALTER TABLE public.reservation_car_sht
    ADD COLUMN IF NOT EXISTS dispatch_code text;
CREATE INDEX IF NOT EXISTS idx_reservation_car_sht_dispatch_code ON public.reservation_car_sht (dispatch_code);

COMMIT;

-- 실행 예시 (psql, 또는 supabase SQL 실행기):
-- psql "postgresql://<user>:<pass>@<host>:<port>/<db>" -f sql/add_assignment_and_dispatch_codes.sql
-- 또는 repo 내 run-sql.js가 있다면 해당 스크립트로 실행

-- 변경 후 권장 작업:
-- - 운영환경에서는 먼저 스테이징에서 실행 후 마이그레이션을 적용하세요.
-- - 백업을 한 뒤 실행하세요(특히 인덱스 생성은 테이블 크기에 따라 영향 있음).
-- - 필요한 경우 NOT NULL 제약/유니크/외래키 규칙은 별도 스크립트로 추가하세요.
