-- 스하(SHT) 예약 데이터 삭제
-- 작성일: 2025-10-27
-- 설명: reservation 테이블의 re_type='sht' 데이터와 관련 reservation_car_sht 테이블 데이터를 삭제

-- 1단계: 삭제 전 데이터 확인
SELECT 
    'reservation 테이블 (re_type=sht)' as 테이블명,
    COUNT(*) as 삭제될_레코드_수
FROM reservation
WHERE re_type = 'sht'
UNION ALL
SELECT 
    'reservation_car_sht 테이블' as 테이블명,
    COUNT(*) as 삭제될_레코드_수
FROM reservation_car_sht;

-- 2단계: 외래키 제약으로 인해 자식 테이블부터 삭제
-- reservation_car_sht 테이블 데이터 삭제
DELETE FROM reservation_car_sht
WHERE reservation_id IN (
    SELECT re_id 
    FROM reservation 
    WHERE re_type = 'sht'
);

-- 3단계: reservation 테이블에서 re_type='sht' 데이터 삭제
DELETE FROM reservation
WHERE re_type = 'sht';

-- 4단계: 삭제 후 확인
SELECT 
    'reservation 테이블 (re_type=sht)' as 테이블명,
    COUNT(*) as 남은_레코드_수
FROM reservation
WHERE re_type = 'sht'
UNION ALL
SELECT 
    'reservation_car_sht 테이블' as 테이블명,
    COUNT(*) as 남은_레코드_수
FROM reservation_car_sht;
