-- ================================================================
-- 회원가입 오류 긴급 수정 (최소한의 정책만)
-- ================================================================
-- 
-- 실행 방법: Supabase Dashboard > SQL Editor에 복사하여 실행
--
-- ================================================================

-- 1. 기존 충돌 가능한 정책 삭제
DROP POLICY IF EXISTS "Users can insert their own profile" ON users;
DROP POLICY IF EXISTS "Service role full access" ON users;
DROP POLICY IF EXISTS "Allow all select for users" ON users;

-- 2. 필수 정책만 추가

-- SELECT 정책 (FK 제약 조건 및 조회용)
CREATE POLICY "Allow all select for users" 
ON users 
FOR SELECT 
USING (true);

-- INSERT 정책 (회원가입용 - 핵심!)
CREATE POLICY "Users can insert their own profile" 
ON users 
FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = id);

-- Service Role 전체 권한 (마이그레이션 및 관리용)
CREATE POLICY "Service role full access" 
ON users 
FOR ALL 
TO service_role
USING (true)
WITH CHECK (true);

-- 3. 확인
SELECT 
  policyname,
  cmd,
  roles
FROM pg_policies 
WHERE tablename = 'users'
ORDER BY policyname;
