-- 공항 서비스 매니저 뷰 생성
-- 크루즈 카 뷰와 동일한 구조로 예약자 정보 포함

-- 1. 공항 서비스 매니저 뷰 생성
CREATE OR REPLACE VIEW vw_manager_airport_report AS
SELECT 
    ra.id,
    ra.reservation_id,
    ra.ra_datetime,
    ra.ra_airport_location,
    ra.ra_flight_number,
    ra.ra_stopover_location,
    ra.ra_stopover_wait_minutes,
    ra.ra_car_count,
    ra.ra_passenger_count,
    ra.ra_luggage_count,
    ra.request_note,
    ra.dispatch_code,
    ra.airport_price_code,
    ra.pickup_confirmed_at,
    ra.dispatch_memo,
    ra.created_at,
    -- 예약자 정보
    COALESCE(u.name, u.email) as booker_name,
    u.email as booker_email,
    u.phone_number as booker_phone,
    -- 공항 정보
    ap.airport_category,
    ap.airport_route,
    ap.airport_car_type,
    ap.price as airport_price
FROM reservation_airport ra
LEFT JOIN reservation r ON ra.reservation_id = r.re_id
LEFT JOIN users u ON r.re_user_id = u.id
LEFT JOIN airport_price ap ON ra.airport_price_code = ap.airport_code
ORDER BY ra.ra_datetime DESC;

-- 2. 렌트카 서비스 매니저 뷰 생성
CREATE OR REPLACE VIEW vw_manager_rentcar_report AS
SELECT 
    rc.id,
    rc.reservation_id,
    rc.pickup_datetime,
    rc.pickup_location,
    rc.destination,
    rc.via_location,
    rc.via_waiting,
    rc.car_count,
    rc.passenger_count,
    rc.luggage_count,
    rc.request_note,
    rc.dispatch_code,
    rc.rentcar_price_code,
    rc.pickup_confirmed_at,
    rc.dispatch_memo,
    rc.total_price,
    rc.created_at,
    -- 예약자 정보
    COALESCE(u.name, u.email) as booker_name,
    u.email as booker_email,
    u.phone_number as booker_phone,
    -- 렌트카 정보
    rp.rent_category,
    rp.rent_route,
    rp.rent_car_type,
    rp.rent_type
FROM reservation_rentcar rc
LEFT JOIN reservation r ON rc.reservation_id = r.re_id
LEFT JOIN users u ON r.re_user_id = u.id
LEFT JOIN rent_price rp ON rc.rentcar_price_code = rp.rent_code
ORDER BY rc.pickup_datetime DESC;

-- 3. 뷰 권한 설정 (배차 담당자, 매니저, 관리자가 접근 가능)
-- RLS 정책 생성 (기존 정책이 있으면 먼저 삭제)
ALTER TABLE reservation_airport ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_rentcar ENABLE ROW LEVEL SECURITY;

-- 기존 정책 삭제 (존재하는 경우)
DROP POLICY IF EXISTS airport_dispatch_access ON reservation_airport;
DROP POLICY IF EXISTS rentcar_dispatch_access ON reservation_rentcar;

-- 공항 서비스 뷰 접근 권한
CREATE POLICY airport_dispatch_access ON reservation_airport
    FOR SELECT 
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid() 
            AND users.role IN ('dispatcher', 'manager', 'admin')
        )
    );

-- 렌트카 서비스 뷰 접근 권한  
CREATE POLICY rentcar_dispatch_access ON reservation_rentcar
    FOR SELECT 
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid() 
            AND users.role IN ('dispatcher', 'manager', 'admin')
        )
    );

-- 4. 뷰 생성 확인 쿼리
SELECT 
    schemaname,
    viewname,
    viewowner,
    definition
FROM pg_views 
WHERE viewname IN ('vw_manager_airport_report', 'vw_manager_rentcar_report')
ORDER BY viewname;

-- 5. 테스트 쿼리
-- 공항 뷰 테스트
SELECT 
    id, ra_datetime, booker_name, booker_email, 
    ra_airport_location, airport_car_type, dispatch_code
FROM vw_manager_airport_report 
WHERE ra_datetime >= CURRENT_DATE - INTERVAL '7 days'
LIMIT 5;

-- 렌트카 뷰 테스트
SELECT 
    id, pickup_datetime, booker_name, booker_email,
    pickup_location, destination, rent_car_type, dispatch_code
FROM vw_manager_rentcar_report 
WHERE pickup_datetime >= CURRENT_DATE - INTERVAL '7 days'
LIMIT 5;

-- 6. 성능 최적화를 위한 인덱스 (필요시 추가)
-- CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_reservation_airport_datetime 
--     ON reservation_airport (ra_datetime DESC);
-- CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_reservation_rentcar_pickup 
--     ON reservation_rentcar (pickup_datetime DESC);

COMMENT ON VIEW vw_manager_airport_report IS '공항 서비스 배차 관리용 뷰 - 예약자 정보 포함';
COMMENT ON VIEW vw_manager_rentcar_report IS '렌트카 서비스 배차 관리용 뷰 - 예약자 정보 포함';