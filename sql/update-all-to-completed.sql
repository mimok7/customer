-- ⚠️  **문제 확인 완료**
-- reservation_cruise.reservation_id ≠ reservation.re_id
-- 오늘(10월 15일) 데이터 9개 있지만, reservation 테이블과 매칭 0개
-- → Schedule 페이지에 데이터가 표시되지 않는 원인

-- 🔧 해결: 데이터베이스 정리 후 CSV 재업로드

-- ============================================================
-- 1단계: 기존 데이터 삭제
-- ============================================================

DELETE FROM reservation_cruise;
DELETE FROM reservation;
DELETE FROM users;

-- 삭제 확인
SELECT 
    'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'reservation' as table_name, COUNT(*) FROM reservation
UNION ALL
SELECT 'reservation_cruise' as table_name, COUNT(*) FROM reservation_cruise;

-- 예상 결과: 모두 0개

-- ============================================================
-- 2단계: CSV 파일 재업로드 (Supabase Dashboard에서 수행)
-- ============================================================

-- 업로드 순서:
-- 1. users 테이블 ← users-auth.csv (2,115개)
-- 2. reservation 테이블 ← reservations-auth.csv (1,414개)
-- 3. reservation_cruise 테이블 ← reservation-cruise-auth.csv (1,414개)

-- ============================================================
-- 3단계: 업로드 후 데이터 검증
-- ============================================================

-- 데이터 개수 확인
SELECT 'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'reservation' as table_name, COUNT(*) as count FROM reservation
UNION ALL
SELECT 'reservation_cruise' as table_name, COUNT(*) as count FROM reservation_cruise;

-- reservation_cruise와 reservation 연결 확인
SELECT COUNT(*) as matched_count
FROM reservation_cruise rc
INNER JOIN reservation r ON rc.reservation_id = r.re_id;

-- 예상 결과: 1414개 (모두 일치해야 함)
