-- 🔧 CSV 업로드 완료 후 제약 조건 복구 SQL

-- ==========================================
-- 1단계: 데이터 무결성 검증 (FK 복구 전 확인)
-- ==========================================

-- reservation에서 존재하지 않는 user_id 확인 (0개여야 함)
SELECT COUNT(*) as invalid_user_refs,
       'reservation → users' as check_type
FROM reservation r 
LEFT JOIN users u ON r.re_user_id = u.id 
WHERE u.id IS NULL;

-- reservation_cruise에서 존재하지 않는 reservation_id 확인 (0개여야 함)
SELECT COUNT(*) as invalid_reservation_refs,
       'reservation_cruise → reservation' as check_type
FROM reservation_cruise rc 
LEFT JOIN reservation r ON rc.reservation_id = r.re_id 
WHERE r.re_id IS NULL;

-- ⚠️ 위 쿼리 결과가 모두 0이어야 FK를 안전하게 복구할 수 있습니다!

-- ==========================================
-- 2단계: FK 제약 조건 복구
-- ==========================================

-- reservation 테이블 FK 복구
ALTER TABLE reservation 
  ADD CONSTRAINT reservation_re_user_id_fkey 
  FOREIGN KEY (re_user_id) 
  REFERENCES users(id) 
  ON DELETE CASCADE;

-- reservation_cruise 테이블 FK 복구
ALTER TABLE reservation_cruise 
  ADD CONSTRAINT reservation_cruise_reservation_id_fkey 
  FOREIGN KEY (reservation_id) 
  REFERENCES reservation(re_id) 
  ON DELETE CASCADE;

-- ==========================================
-- 3단계: RLS 재활성화 (선택사항)
-- ==========================================
-- 주의: RLS를 활성화하면 정책이 필요합니다
-- 정책이 없으면 데이터 접근이 제한될 수 있습니다

-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE reservation ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE reservation_cruise ENABLE ROW LEVEL SECURITY;

-- ==========================================
-- 4단계: 인덱스 생성 (성능 최적화)
-- ==========================================

-- order_id 인덱스 (조회 성능 향상)
CREATE INDEX IF NOT EXISTS idx_users_order_id 
  ON users(order_id);

CREATE INDEX IF NOT EXISTS idx_reservation_order_id 
  ON reservation(order_id);

-- boarding_code 인덱스 (승선코드 검색용)
CREATE INDEX IF NOT EXISTS idx_reservation_cruise_boarding_code 
  ON reservation_cruise(boarding_code);

-- checkin 날짜 인덱스 (날짜별 조회용)
CREATE INDEX IF NOT EXISTS idx_reservation_cruise_checkin 
  ON reservation_cruise(checkin);

-- ==========================================
-- 5단계: 최종 데이터 확인
-- ==========================================

-- 테이블별 데이터 개수
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

-- 추가 필드 통계
SELECT 
  COUNT(*) as total_cruise_reservations,
  COUNT(CASE WHEN boarding_code IS NOT NULL AND boarding_code != 'TBA' THEN 1 END) as with_boarding_code,
  COUNT(CASE WHEN boarding_assist = true THEN 1 END) as with_boarding_assist,
  COUNT(CASE WHEN request_note LIKE '%요청사항:%' THEN 1 END) as with_request_notes
FROM reservation_cruise;

-- 샘플 데이터 조회 (order_id 연결 확인)
SELECT 
  u.order_id,
  u.name,
  r.re_type,
  r.total_amount,
  rc.room_price_code,
  rc.boarding_code,
  rc.boarding_assist,
  LEFT(rc.request_note, 80) as request_note_preview
FROM users u
JOIN reservation r ON u.order_id = r.order_id
JOIN reservation_cruise rc ON r.re_id = rc.reservation_id
LIMIT 10;

-- ==========================================
-- ✅ 완료!
-- ==========================================
-- 예상 결과:
-- - users: 2,151 rows (order_id 100%)
-- - reservation: 1,457 rows (order_id 100%)
-- - reservation_cruise: 1,457 rows
--   * boarding_code: ~40개 (TBA 제외)
--   * boarding_assist: 일부
--   * request_note: 대부분 (요청사항/특이사항/메모 통합)
