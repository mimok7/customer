-- 🎯 CSV 직접 업로드를 위한 준비 SQL (한 번에 실행)

-- ==========================================
-- 1단계: FK 제약 조건 모두 제거
-- ==========================================
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_room_reservation_id_fkey;
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_cruise_reservation_id_fkey;
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_cruise_room_price_code_fkey;
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_cruise_car_price_code_fkey;

ALTER TABLE reservation DROP CONSTRAINT IF EXISTS reservation_re_user_id_fkey;
ALTER TABLE reservation DROP CONSTRAINT IF EXISTS fk_reservation_user;
ALTER TABLE reservation DROP CONSTRAINT IF EXISTS reservation_re_quote_id_fkey;

-- ==========================================
-- 2단계: RLS 비활성화
-- ==========================================
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservation DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_cruise DISABLE ROW LEVEL SECURITY;

-- ==========================================
-- 3단계: 기존 데이터 삭제 (선택사항)
-- ==========================================
-- 주의: 기존 데이터를 모두 삭제합니다!
-- 필요한 경우에만 주석을 해제하고 실행하세요.

-- DELETE FROM reservation_cruise;  -- 크루즈 예약 삭제
-- DELETE FROM reservation;          -- 예약 삭제
-- DELETE FROM users;                -- 사용자 삭제 (주의!)

-- ==========================================
-- 실행 결과 확인
-- ==========================================
SELECT 
  'users' as table_name, 
  COUNT(*) as row_count 
FROM users
UNION ALL
SELECT 
  'reservation' as table_name, 
  COUNT(*) as row_count 
FROM reservation
UNION ALL
SELECT 
  'reservation_cruise' as table_name, 
  COUNT(*) as row_count 
FROM reservation_cruise;

-- ==========================================
-- 📌 다음 단계:
-- ==========================================
-- 1. Supabase Table Editor에서 CSV 업로드
--    - users.csv → users 테이블
--    - reservations.csv → reservation 테이블  
--    - reservation_cruise.csv → reservation_cruise 테이블
--
-- 2. 업로드 완료 후 "restore-constraints-after-upload.sql" 실행
