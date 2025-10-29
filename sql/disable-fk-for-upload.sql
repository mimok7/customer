-- reservation 업로드를 위한 FK 제약 조건 임시 비활성화
-- 주의: 데이터 무결성이 보장되는 경우에만 사용

-- 1. FK 제약 조건 비활성화
ALTER TABLE reservation DISABLE TRIGGER ALL;
ALTER TABLE reservation_cruise DISABLE TRIGGER ALL;

-- 2. 데이터 업로드 후 다시 실행할 쿼리
-- ALTER TABLE reservation ENABLE TRIGGER ALL;
-- ALTER TABLE reservation_cruise ENABLE TRIGGER ALL;

-- 3. FK 제약 조건 검증 (업로드 후 실행)
-- SELECT r.re_user_id, u.id 
-- FROM reservation r 
-- LEFT JOIN users u ON r.re_user_id = u.id 
-- WHERE u.id IS NULL;  -- 결과가 0개여야 함

-- 4. 업로드 후 확인 쿼리
-- SELECT COUNT(*) FROM reservation;
-- SELECT COUNT(*) FROM reservation_cruise;
-- SELECT u.order_id, u.name, r.re_type FROM users u JOIN reservation r ON u.order_id = r.order_id LIMIT 5;
