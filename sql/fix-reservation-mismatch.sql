-- ⚠️ Reservation 테이블 재업로드 가이드

-- ==========================================
-- 문제: CSV의 reservation_id와 DB의 re_id가 불일치
-- ==========================================
-- reservation_cruise.csv의 reservation_id가 
-- Supabase reservation 테이블의 re_id와 일치하지 않습니다.
-- 
-- 원인: CSV를 새로 생성하면서 UUID가 변경되었기 때문
-- 해결: reservation 테이블을 완전히 재업로드

-- ==========================================
-- 1단계: 기존 데이터 완전 삭제
-- ==========================================

-- 자식 테이블부터 삭제 (FK 관계)
DELETE FROM reservation_cruise;
DELETE FROM reservation;

-- ⚠️ users는 삭제하지 마세요! (이미 정상 업로드됨)

-- 확인
SELECT 'reservation' as table_name, COUNT(*) as row_count FROM reservation
UNION ALL
SELECT 'reservation_cruise' as table_name, COUNT(*) as row_count FROM reservation_cruise;
-- 결과: 둘 다 0이어야 함

-- ==========================================
-- 2단계: Supabase Table Editor에서 CSV 업로드
-- ==========================================

-- 📤 순서대로 업로드:
-- 
-- 1. reservations.csv → reservation 테이블
--    - Table Editor → reservation → "..." → "Import data from CSV"
--    - reservations.csv 선택
--    - "First row is header" 체크
--    - 1,457 rows 임포트 확인
--
-- 2. reservation_cruise.csv → reservation_cruise 테이블
--    - Table Editor → reservation_cruise → "..." → "Import data from CSV"  
--    - reservation_cruise.csv 선택
--    - "First row is header" 체크
--    - 1,457 rows 임포트 확인

-- ==========================================
-- 3단계: 업로드 확인 (이 SQL을 실행)
-- ==========================================

-- 데이터 개수 확인
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
-- reservation: 1457 rows (order_id 1457개)
-- reservation_cruise: 1457 rows (boarding_code ~40개)

-- ==========================================
-- 4단계: reservation_id 매칭 확인
-- ==========================================

-- reservation_cruise의 모든 reservation_id가 reservation에 존재하는지 확인
SELECT COUNT(*) as unmatched_reservations
FROM reservation_cruise rc
LEFT JOIN reservation r ON rc.reservation_id = r.re_id
WHERE r.re_id IS NULL;

-- 결과: 0이어야 함 (모든 reservation_id가 매칭됨)

-- ==========================================
-- 5단계: 샘플 데이터 조회
-- ==========================================

-- order_id로 연결된 전체 데이터 확인
SELECT 
  u.order_id,
  u.name,
  r.re_id as reservation_id,
  r.total_amount,
  rc.room_price_code,
  rc.boarding_code,
  rc.boarding_assist,
  LEFT(rc.request_note, 60) as request_preview
FROM users u
JOIN reservation r ON u.order_id = r.order_id
JOIN reservation_cruise rc ON r.re_id = rc.reservation_id
LIMIT 10;

-- ==========================================
-- 6단계: 추가 필드 통계 확인
-- ==========================================

SELECT 
  COUNT(*) as total_cruises,
  COUNT(CASE WHEN boarding_code IS NOT NULL AND boarding_code != 'TBA' THEN 1 END) as with_valid_boarding_code,
  COUNT(CASE WHEN boarding_assist = true THEN 1 END) as with_boarding_assist,
  COUNT(CASE WHEN request_note LIKE '%요청사항:%' THEN 1 END) as with_request_from_shm,
  COUNT(CASE WHEN request_note LIKE '%특이사항:%' THEN 1 END) as with_special_notes
FROM reservation_cruise;

-- 예상 결과:
-- total_cruises: 1457
-- with_valid_boarding_code: ~40개
-- with_boarding_assist: 일부
-- with_request_from_shm: 수백 개
-- with_special_notes: 일부

-- ==========================================
-- ✅ 완료!
-- ==========================================
-- 업로드 완료 후 "restore-constraints-after-upload.sql"을 실행하여
-- FK 제약 조건과 인덱스를 복구하세요.
