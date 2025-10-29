-- 간단한 예약 총금액 시스템 테스트 SQL

-- 1. reservation 테이블에 total_amount 컬럼이 있는지 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'reservation' 
  AND column_name = 'total_amount';

-- 2. 간단한 테스트: 특정 예약의 서비스별 금액 확인
SELECT 
    'reservation_cruise' as service_type,
    COUNT(*) as count,
    SUM(COALESCE(room_total_price, unit_price * guest_count)) as total_amount
FROM reservation_cruise
WHERE reservation_id IS NOT NULL

UNION ALL

SELECT 
    'reservation_airport' as service_type,
    COUNT(*) as count,
    SUM(COALESCE(total_price, unit_price * ra_car_count)) as total_amount
FROM reservation_airport
WHERE reservation_id IS NOT NULL

UNION ALL

SELECT 
    'reservation_hotel' as service_type,
    COUNT(*) as count,
    SUM(COALESCE(total_price, 0)) as total_amount
FROM reservation_hotel
WHERE reservation_id IS NOT NULL

ORDER BY service_type;
