-- 🔄 전체 데이터 재업로드 가이드 (최종 해결)

-- ==========================================
-- 문제: CSV를 새로 생성하면서 모든 UUID가 변경됨
-- ==========================================
-- users.csv, reservations.csv, reservation_cruise.csv의 UUID가
-- Supabase 테이블의 UUID와 완전히 다릅니다.
-- 
-- 원인: export-to-csv.js를 재실행하면서 새로운 UUID 생성
-- 해결: 모든 테이블을 완전히 재업로드

-- ==========================================
-- 1단계: 모든 데이터 삭제
-- ==========================================

-- 역순으로 삭제 (FK 관계)
DELETE FROM reservation_cruise;
DELETE FROM reservation;
DELETE FROM users;

-- 확인 (모두 0이어야 함)
SELECT 
  'users' as table_name, COUNT(*) as row_count FROM users
UNION ALL
SELECT 
  'reservation' as table_name, COUNT(*) as row_count FROM reservation
UNION ALL
SELECT 
  'reservation_cruise' as table_name, COUNT(*) as row_count FROM reservation_cruise;

-- ==========================================
-- 2단계: Supabase Table Editor에서 순서대로 CSV 업로드
-- ==========================================

-- 📤 반드시 이 순서대로 업로드하세요!
-- 
-- ✅ 1. users.csv → users 테이블
--    - Table Editor → users → "..." → "Import data from CSV"
--    - users.csv 선택
--    - "First row is header" 체크
--    - 컬럼 매핑:
--      * id → id
--      * order_id → order_id ⭐ (새로 추가)
--      * reservation_date → reservation_date
--      * email, name, english_name, nickname...
--    - 📊 예상: 2,151 rows
--
-- ✅ 2. reservations.csv → reservation 테이블
--    - Table Editor → reservation → "..." → "Import data from CSV"
--    - reservations.csv 선택
--    - "First row is header" 체크
--    - 컬럼 매핑:
--      * re_id → re_id
--      * re_user_id → re_user_id (users.id 참조)
--      * order_id → order_id ⭐ (새로 추가)
--      * re_quote_id, re_type, re_status...
--    - 📊 예상: 1,457 rows
--
-- ✅ 3. reservation_cruise.csv → reservation_cruise 테이블
--    - Table Editor → reservation_cruise → "..." → "Import data from CSV"
--    - reservation_cruise.csv 선택
--    - "First row is header" 체크
--    - 컬럼 매핑:
--      * id → id
--      * reservation_id → reservation_id (reservation.re_id 참조)
--      * room_price_code, checkin, guest_count...
--      * request_note → request_note ⭐ (SH_M 통합)
--      * boarding_code → boarding_code ⭐ (SH_R 처리)
--      * boarding_assist → boarding_assist ⭐ (SH_R 승선도움)
--    - 📊 예상: 1,457 rows

-- ==========================================
-- 3단계: 업로드 완료 확인
-- ==========================================

-- 데이터 개수 확인
SELECT 
  'users' as table_name,
  COUNT(*) as total_rows,
  COUNT(order_id) as with_order_id
FROM users
UNION ALL
SELECT 
  'reservation' as table_name,
  COUNT(*) as total_rows,
  COUNT(order_id) as with_order_id
FROM reservation
UNION ALL
SELECT 
  'reservation_cruise' as table_name,
  COUNT(*) as total_rows,
  COUNT(boarding_code) as with_boarding_code
FROM reservation_cruise;

-- 예상 결과:
-- users: 2151 rows (order_id 2151개)
-- reservation: 1457 rows (order_id 1457개)
-- reservation_cruise: 1457 rows (boarding_code ~40개)

-- ==========================================
-- 4단계: FK 관계 검증
-- ==========================================

-- reservation → users 관계 확인 (0이어야 함)
SELECT COUNT(*) as invalid_user_refs
FROM reservation r
LEFT JOIN users u ON r.re_user_id = u.id
WHERE u.id IS NULL;

-- reservation_cruise → reservation 관계 확인 (0이어야 함)
SELECT COUNT(*) as invalid_reservation_refs
FROM reservation_cruise rc
LEFT JOIN reservation r ON rc.reservation_id = r.re_id
WHERE r.re_id IS NULL;

-- ⚠️ 위 두 쿼리 결과가 모두 0이어야 합니다!

-- ==========================================
-- 5단계: order_id 연결 확인
-- ==========================================

-- order_id로 전체 연결 테스트
SELECT 
  u.order_id,
  u.name,
  r.re_type,
  r.total_amount,
  rc.room_price_code,
  rc.boarding_code,
  rc.boarding_assist,
  LEFT(rc.request_note, 80) as request_preview
FROM users u
JOIN reservation r ON u.order_id = r.order_id
JOIN reservation_cruise rc ON r.re_id = rc.reservation_id
LIMIT 10;

-- 정상적으로 10개의 데이터가 조회되어야 합니다!

-- ==========================================
-- 6단계: 새로운 필드 확인
-- ==========================================

-- SH_M에서 가져온 요청사항 확인
SELECT 
  COUNT(*) as total,
  COUNT(CASE WHEN request_note LIKE '%요청사항:%' THEN 1 END) as with_requests,
  COUNT(CASE WHEN request_note LIKE '%특이사항:%' THEN 1 END) as with_special,
  COUNT(CASE WHEN request_note LIKE '%메모:%' THEN 1 END) as with_memo
FROM reservation_cruise;

-- SH_R에서 가져온 승선 정보 확인
SELECT 
  COUNT(*) as total,
  COUNT(CASE WHEN boarding_code IS NOT NULL AND boarding_code != 'TBA' THEN 1 END) as with_boarding_code,
  COUNT(CASE WHEN boarding_assist = true THEN 1 END) as with_boarding_assist
FROM reservation_cruise;

-- ==========================================
-- 7단계: 샘플 데이터 확인 (상세)
-- ==========================================

-- 요청사항이 있는 예약 샘플
SELECT 
  u.name,
  u.order_id,
  rc.room_price_code,
  rc.boarding_code,
  rc.boarding_assist,
  rc.request_note
FROM users u
JOIN reservation r ON u.order_id = r.order_id
JOIN reservation_cruise rc ON r.re_id = rc.reservation_id
WHERE rc.request_note LIKE '%요청사항:%'
LIMIT 5;

-- ==========================================
-- ✅ 완료!
-- ==========================================
-- 모든 확인이 정상이면 
-- "restore-constraints-after-upload.sql"을 실행하여
-- FK 제약 조건과 인덱스를 복구하세요.

-- ==========================================
-- 📋 체크리스트
-- ==========================================
-- [ ] 1. 모든 테이블 데이터 삭제 완료
-- [ ] 2. users.csv 업로드 완료 (2,151 rows)
-- [ ] 3. reservations.csv 업로드 완료 (1,457 rows)
-- [ ] 4. reservation_cruise.csv 업로드 완료 (1,457 rows)
-- [ ] 5. FK 관계 검증 통과 (invalid_refs = 0)
-- [ ] 6. order_id 연결 확인 완료
-- [ ] 7. 새로운 필드 데이터 확인 완료
-- [ ] 8. FK 제약 조건 복구 (restore-constraints-after-upload.sql)
