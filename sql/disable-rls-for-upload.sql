-- reservation 업로드를 위한 RLS 임시 비활성화
-- FK 제약 조건 문제 해결

-- 1. RLS 비활성화
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservation DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_cruise DISABLE ROW LEVEL SECURITY;

-- 2. 데이터 업로드 후 다시 실행할 쿼리
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE reservation ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE reservation_cruise ENABLE ROW LEVEL SECURITY;

-- 3. 업로드 후 확인 쿼리
-- SELECT COUNT(*) FROM reservation;
-- SELECT COUNT(*) FROM reservation_cruise;
-- SELECT u.order_id, u.name, r.re_type FROM users u JOIN reservation r ON u.order_id = r.order_id LIMIT 5;
