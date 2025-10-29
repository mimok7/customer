-- ================================================================
-- Users 테이블 RLS 정책 확인 및 수정
-- ================================================================
-- 
-- 문제: 회원가입 시 "프로필 생성 오류" 발생
-- 원인: users 테이블의 RLS 정책이 INSERT를 막고 있을 가능성
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
WHERE tablename = 'users'
ORDER BY policyname;

-- 2. users 테이블의 RLS 활성화 상태 확인
SELECT 
  tablename, 
  rowsecurity as rls_enabled
FROM pg_tables 
WHERE tablename = 'users';

-- ================================================================
-- 해결책 A: 회원가입을 위한 INSERT 정책 추가
-- ================================================================

-- 기존 정책 삭제 후 재생성
DROP POLICY IF EXISTS "Users can insert their own profile" ON users;
DROP POLICY IF EXISTS "Service role full access to users" ON users;

-- 인증된 사용자가 자신의 프로필을 생성할 수 있도록 허용
CREATE POLICY "Users can insert their own profile" 
ON users 
FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = id);

-- Service Role은 모든 작업 가능하도록 설정
CREATE POLICY "Service role full access to users" 
ON users 
FOR ALL 
TO service_role
USING (true)
WITH CHECK (true);

-- ================================================================
-- 해결책 B: 기존 정책이 너무 제한적인 경우
-- ================================================================

-- 기존 INSERT 정책 삭제 (필요시)
-- DROP POLICY IF EXISTS "정책이름" ON users;

-- ================================================================
-- 권장 RLS 정책 세트 (전체)
-- ================================================================

-- 기존 정책 삭제 (이미 있는 경우)
DROP POLICY IF EXISTS "Allow all select for users" ON users;
DROP POLICY IF EXISTS "Users can insert their own profile" ON users;
DROP POLICY IF EXISTS "Users can update their own profile" ON users;
DROP POLICY IF EXISTS "Only admins can delete users" ON users;
DROP POLICY IF EXISTS "Service role full access" ON users;

-- 1. SELECT: FK 제약 조건 및 일반 조회를 위해 모두 허용
CREATE POLICY "Allow all select for users" 
ON users 
FOR SELECT 
USING (true);

-- 2. INSERT: 인증된 사용자가 자신의 프로필만 생성
CREATE POLICY "Users can insert their own profile" 
ON users 
FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = id);

-- 3. UPDATE: 사용자가 자신의 프로필만 수정
CREATE POLICY "Users can update their own profile" 
ON users 
FOR UPDATE 
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- 4. DELETE: Admin만 가능
CREATE POLICY "Only admins can delete users" 
ON users 
FOR DELETE 
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE id = auth.uid() 
    AND role = 'admin'
  )
);

-- 5. Service Role은 모든 작업 가능
CREATE POLICY "Service role full access" 
ON users 
FOR ALL 
TO service_role
USING (true)
WITH CHECK (true);

-- ================================================================
-- 검증 쿼리
-- ================================================================

-- 정책 목록 다시 확인
SELECT 
  policyname,
  cmd,
  roles,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'users'
ORDER BY cmd, policyname;

-- ================================================================
-- 테스트 (선택사항)
-- ================================================================

-- 실제 Auth User ID로 테스트 (현재 로그인한 사용자)
-- INSERT INTO users (id, email, name, role, status, created_at, updated_at)
-- VALUES (
--   auth.uid(),
--   auth.email(),
--   'Test User',
--   'guest',
--   'active',
--   now(),
--   now()
-- );

-- 테스트 데이터 삭제
-- DELETE FROM users WHERE email LIKE '%test%' AND role = 'guest';
