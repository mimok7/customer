-- Users 테이블 role 필드 check constraint 수정
-- dispatcher 역할을 추가하기 위해 constraint 확장

-- 1. 기존 constraint 삭제
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_role_check;

-- 2. 새로운 constraint 생성 (dispatcher 역할 추가)
ALTER TABLE users ADD CONSTRAINT users_role_check
CHECK (role IN ('guest', 'member', 'manager', 'admin', 'dispatcher'));

-- 3. 확인 쿼리 (필요시)
-- SELECT conname, conrelid::regclass, pg_get_constraintdef(oid)
-- FROM pg_constraint
-- WHERE conname = 'users_role_check';