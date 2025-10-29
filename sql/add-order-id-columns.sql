-- 사용자 및 예약 테이블에 order_id 컬럼 추가
-- Google Sheets의 주문ID를 저장하여 비즈니스 로직 쿼리 지원

-- users 테이블에 order_id 추가
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS order_id TEXT;

-- reservation 테이블에 order_id 추가
ALTER TABLE reservation 
ADD COLUMN IF NOT EXISTS order_id TEXT;

-- order_id 인덱스 생성 (조회 성능 최적화)
CREATE INDEX IF NOT EXISTS idx_users_order_id ON users(order_id);
CREATE INDEX IF NOT EXISTS idx_reservation_order_id ON reservation(order_id);

-- 데이터 확인 쿼리
-- SELECT COUNT(*) FROM users WHERE order_id IS NOT NULL;
-- SELECT COUNT(*) FROM reservation WHERE order_id IS NOT NULL;
-- SELECT u.order_id, u.name, r.re_type FROM users u JOIN reservation r ON u.order_id = r.order_id LIMIT 5;
