-- reservation FK 제약 조건 임시 제거 및 복구 가이드

-- ========================================
-- 1단계: 기존 FK 제약 조건 확인 및 저장
-- ========================================
-- 실행하여 현재 FK 제약 조건 확인 (복구용)
SELECT conname, conrelid::regclass AS table_name, 
       pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint
WHERE conrelid IN ('reservation'::regclass, 'reservation_cruise'::regclass)
  AND contype = 'f';

-- ========================================
-- 2단계: FK 제약 조건 제거
-- ========================================
-- reservation 테이블의 FK 제약 조건 제거
ALTER TABLE reservation DROP CONSTRAINT IF EXISTS reservation_re_user_id_fkey;
ALTER TABLE reservation DROP CONSTRAINT IF EXISTS reservation_re_quote_id_fkey;

-- reservation_cruise 테이블의 FK 제약 조건 제거
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_cruise_reservation_id_fkey;
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_cruise_room_price_code_fkey;
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_cruise_car_price_code_fkey;

-- ========================================
-- 3단계: 데이터 업로드
-- ========================================
-- 이제 node upload-reservations-direct.js 실행
-- 그 다음 reservation_cruise 업로드

-- ========================================
-- 4단계: FK 제약 조건 복구 (업로드 완료 후 실행)
-- ========================================
-- reservation 테이블 FK 복구
ALTER TABLE reservation 
  ADD CONSTRAINT reservation_re_user_id_fkey 
  FOREIGN KEY (re_user_id) REFERENCES users(id) ON DELETE CASCADE;

-- ALTER TABLE reservation 
--   ADD CONSTRAINT reservation_re_quote_id_fkey 
--   FOREIGN KEY (re_quote_id) REFERENCES quote(id) ON DELETE SET NULL;

-- reservation_cruise 테이블 FK 복구
ALTER TABLE reservation_cruise 
  ADD CONSTRAINT reservation_cruise_reservation_id_fkey 
  FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- ALTER TABLE reservation_cruise 
--   ADD CONSTRAINT reservation_cruise_room_price_code_fkey 
--   FOREIGN KEY (room_price_code) REFERENCES room_price(room_code);

-- ALTER TABLE reservation_cruise 
--   ADD CONSTRAINT reservation_cruise_car_price_code_fkey 
--   FOREIGN KEY (car_price_code) REFERENCES car_price(car_code);

-- ========================================
-- 5단계: 데이터 무결성 검증 (FK 복구 전 실행)
-- ========================================
-- reservation에서 존재하지 않는 user_id 확인 (결과 0개여야 함)
-- SELECT COUNT(*) as invalid_user_refs
-- FROM reservation r 
-- LEFT JOIN users u ON r.re_user_id = u.id 
-- WHERE u.id IS NULL;

-- reservation_cruise에서 존재하지 않는 reservation_id 확인 (결과 0개여야 함)
-- SELECT COUNT(*) as invalid_reservation_refs
-- FROM reservation_cruise rc 
-- LEFT JOIN reservation r ON rc.reservation_id = r.re_id 
-- WHERE r.re_id IS NULL;

-- ========================================
-- 6단계: 업로드 완료 확인
-- ========================================
-- SELECT COUNT(*) as total_users FROM users;           -- 예상: 2151
-- SELECT COUNT(*) as total_reservations FROM reservation;  -- 예상: 1457
-- SELECT COUNT(*) as total_cruise FROM reservation_cruise; -- 예상: 1457

-- SELECT u.order_id, u.name, r.re_type, r.total_amount
-- FROM users u 
-- JOIN reservation r ON u.order_id = r.order_id 
-- LIMIT 10;
