-- ========================================
-- 예약 총금액 자동계산 시스템 상태 확인
-- ========================================

-- 1. reservation 테이블에 total_amount 컬럼 존재 여부 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'reservation' 
  AND column_name = 'total_amount';

-- 2. 예약 총금액 현황 확인
SELECT 
    COUNT(*) as total_reservations,
    COUNT(CASE WHEN total_amount > 0 THEN 1 END) as reservations_with_amount,
    COUNT(CASE WHEN total_amount = 0 OR total_amount IS NULL THEN 1 END) as reservations_without_amount,
    MAX(total_amount) as max_amount,
    AVG(total_amount) as avg_amount
FROM reservation;

-- 3. 자동계산 함수 존재 여부 확인
SELECT 
    routine_name,
    routine_type,
    data_type
FROM information_schema.routines 
WHERE routine_name IN ('recompute_reservation_total', 'trg_after_service_change_update_total');

-- 4. 트리거 설정 상태 확인
SELECT 
    trigger_name,
    event_object_table,
    action_timing,
    event_manipulation
FROM information_schema.triggers 
WHERE trigger_name LIKE '%reservation%total%'
ORDER BY event_object_table;

-- 5. 실제 예약 데이터 샘플 확인 (총금액과 서비스별 금액 비교)
SELECT 
    r.re_id,
    r.total_amount as calculated_total,
    COALESCE(rc.room_total_price, 0) as cruise_room_amount,
    COALESCE(rcc.car_total_price, 0) as cruise_car_amount,
    COALESCE(ra.total_price, 0) as airport_amount,
    COALESCE(rh.total_price, 0) as hotel_amount,
    COALESCE(rt.total_price, 0) as tour_amount,
    COALESCE(rr.total_price, 0) as rentcar_amount
FROM reservation r
LEFT JOIN reservation_cruise rc ON r.re_id = rc.reservation_id
LEFT JOIN reservation_cruise_car rcc ON r.re_id = rcc.reservation_id  
LEFT JOIN reservation_airport ra ON r.re_id = ra.reservation_id
LEFT JOIN reservation_hotel rh ON r.re_id = rh.reservation_id
LEFT JOIN reservation_tour rt ON r.re_id = rt.reservation_id
LEFT JOIN reservation_rentcar rr ON r.re_id = rr.reservation_id
WHERE r.re_status = 'confirmed'
LIMIT 5;
