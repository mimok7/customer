-- 신규 사용자 예약 이관을 위한 RLS 비활성화
-- FK 제약 조건이 정상 작동하도록 RLS를 임시로 비활성화합니다

ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- 확인
SELECT 
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables 
WHERE tablename = 'users';
