-- ================================================================
-- 이메일 중복 문제 해결: users_email_key 제약 조건 처리
-- ================================================================
-- 
-- 문제: 마이그레이션된 데이터의 이메일과 신규 회원가입 이메일이 충돌
-- 원인: users 테이블의 email 컬럼에 UNIQUE 제약 조건이 있음
-- 
-- 해결책 옵션:
-- 1. UNIQUE 제약 조건 제거 (비추천 - 데이터 무결성 문제)
-- 2. 이메일 중복 시 병합 로직 (복잡)
-- 3. 마이그레이션 데이터의 이메일에 접두사 추가 (권장)
--
-- ================================================================

-- 현재 제약 조건 확인
SELECT 
  conname AS constraint_name,
  contype AS constraint_type,
  pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'users'::regclass
  AND conname LIKE '%email%';

-- ================================================================
-- 옵션 1: UNIQUE 제약 조건 제거 (비추천)
-- ================================================================
-- ALTER TABLE users DROP CONSTRAINT users_email_key;

-- ================================================================
-- 옵션 2: 마이그레이션 데이터 이메일 수정 (권장)
-- ================================================================

-- 2-1. Auth에 없는 사용자의 이메일에 '[migrated]' 태그 추가
-- 주의: 실제 이메일 발송이 필요한 경우 문제가 될 수 있음

-- 먼저 백업 테이블 생성
CREATE TABLE IF NOT EXISTS users_backup_20251014 AS 
SELECT * FROM users;

-- Auth에 없는 사용자 확인 (마이그레이션 데이터)
-- 이 쿼리로 먼저 확인만 하세요
SELECT 
  id,
  email,
  name,
  role,
  status,
  created_at
FROM users
WHERE email NOT IN (
  -- Auth 사용자 이메일 목록은 수동으로 확인 필요
  SELECT email FROM auth.users WHERE email IS NOT NULL
)
LIMIT 10;

-- ================================================================
-- 옵션 3: 애플리케이션 레벨에서 처리 (가장 안전)
-- ================================================================

-- 회원가입 시 이메일이 이미 users 테이블에 있는지 확인
-- 있으면:
--   1) Auth에도 있는지 확인
--   2) Auth에 없으면 기존 레코드의 ID를 새 Auth User에 연결
--   3) Auth에 있으면 중복 계정 오류 표시

-- ================================================================
-- 임시 해결: 특정 이메일의 UNIQUE 제약 우회
-- ================================================================

-- 회원가입하려는 특정 이메일의 기존 레코드를 찾아서 처리
-- 예: test@example.com

-- 1. 기존 레코드 확인
SELECT * FROM users WHERE email = 'test@example.com';

-- 2. Auth User ID 확인 (Supabase Dashboard > Authentication)
-- 새로 가입한 Auth User의 ID를 확인

-- 3. 기존 레코드의 ID를 새 Auth User ID로 변경
-- UPDATE users 
-- SET id = '새로운-auth-user-uuid',
--     updated_at = now()
-- WHERE email = 'test@example.com' 
--   AND id != '새로운-auth-user-uuid';

-- 또는 기존 레코드 삭제 후 새로 생성
-- DELETE FROM users WHERE email = 'test@example.com';

-- ================================================================
-- 권장 솔루션: 이메일 중복 허용 + 복합 UNIQUE 제약
-- ================================================================

-- UNIQUE 제약을 email 단독이 아닌 (email, status) 조합으로 변경
-- 같은 이메일이라도 status가 다르면 허용

-- 1. 기존 제약 삭제
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_email_key;

-- 2. 새로운 복합 UNIQUE 제약 추가 (선택사항)
-- CREATE UNIQUE INDEX users_email_active_idx 
-- ON users (email) 
-- WHERE status = 'active';

-- 또는 email + status 복합 인덱스
-- CREATE UNIQUE INDEX users_email_status_idx 
-- ON users (email, status);

-- 3. 검증
SELECT 
  indexname,
  indexdef
FROM pg_indexes
WHERE tablename = 'users'
  AND indexname LIKE '%email%';

-- ================================================================
-- 최종 권장: email UNIQUE 제약 제거
-- ================================================================
-- 회원가입 시 애플리케이션에서 중복 체크하는 것이 더 유연함

ALTER TABLE users DROP CONSTRAINT IF EXISTS users_email_key;

-- 대신 인덱스는 유지하여 검색 성능 확보
CREATE INDEX IF NOT EXISTS users_email_idx ON users (email);

-- 검증
SELECT 
  conname AS constraint_name,
  contype AS constraint_type
FROM pg_constraint
WHERE conrelid = 'users'::regclass
  AND conname LIKE '%email%';
