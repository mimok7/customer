-- ================================================================
-- Foreign Key 제약 조건을 위한 RLS 정책 수정
-- ================================================================
--
-- 문제: reservation 테이블 삽입 시 FK가 users 테이블을 확인할 때
--       RLS 정책으로 인해 사용자가 "존재하지 않는 것"으로 판단됨
--
-- 해결: FK 제약 조건 검사는 RLS를 우회해야 함
--
-- ================================================================

-- 1. 현재 RLS 정책 확인
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'users' OR tablename = 'reservation';

-- 2. 옵션 A: users 테이블의 RLS를 일시적으로 비활성화 (권장하지 않음)
-- ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- 3. 옵션 B: users 테이블에 PUBLIC SELECT 정책 추가 (권장)
--    FK 제약 조건은 SELECT만 필요하므로 읽기 권한만 부여
CREATE POLICY "Allow public read for FK constraints" 
ON users 
FOR SELECT 
USING (true);

-- 4. 옵션 C: reservation 테이블의 FK 제약 조건 삭제 후 트리거로 재구현
--    (복잡하므로 권장하지 않음)

-- 5. 검증: FK 제약 조건 정의 확인
SELECT 
  tc.constraint_name, 
  tc.table_name, 
  kcu.column_name, 
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name,
  pg_get_constraintdef(pgc.oid) AS constraint_definition
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
JOIN pg_constraint AS pgc
  ON pgc.conname = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_name='reservation'
  AND tc.constraint_name = 'reservation_re_user_id_fkey';

-- ================================================================
-- 적용 후 테스트
-- ================================================================
-- INSERT INTO reservation (re_user_id, re_type, re_status, total_amount, paid_amount, payment_status)
-- VALUES ('bab42fdc-a57a-4391-85f7-0e6831ab03ec', 'cruise', 'pending', 0, 0, 'pending');
-- 
-- 성공하면:
-- DELETE FROM reservation WHERE re_user_id = 'bab42fdc-a57a-4391-85f7-0e6831ab03ec' AND re_type = 'cruise';
