# 회원가입 "프로필 생성 오류" 해결 가이드

## 문제 상황
회원가입 후 로그인 시 "프로필 생성에 오류가 발생했다"는 메시지 표시

## 원인 분석
1. ✅ **코드 문제**: 없음 (테스트 통과)
2. ⚠️ **RLS 정책**: users 테이블의 INSERT 정책 확인 필요
3. ⚠️ **이메일 중복**: 이미 가입된 이메일로 재가입 시도
4. ⚠️ **Status 필드**: users 테이블의 status='pending'일 경우 제약 가능

## 해결 방법

### Step 1: RLS 정책 확인 및 수정 (필수)

Supabase Dashboard → SQL Editor에서 실행:

**간단 버전 (권장):**
```sql
-- 기존 정책 삭제
DROP POLICY IF EXISTS "Users can insert their own profile" ON users;
DROP POLICY IF EXISTS "Service role full access" ON users;
DROP POLICY IF EXISTS "Allow all select for users" ON users;

-- 필수 정책 추가
CREATE POLICY "Allow all select for users" 
ON users FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile" 
ON users FOR INSERT TO authenticated
WITH CHECK (auth.uid() = id);

CREATE POLICY "Service role full access" 
ON users FOR ALL TO service_role
USING (true) WITH CHECK (true);
```

**또는 파일 사용:**
- `sql/fix-signup-quick.sql` 파일 내용 복사하여 실행

**전체 정책 (선택사항):**

**전체 정책 (선택사항):**
```sql
-- 1. 현재 정책 확인
SELECT 
  policyname,
  cmd,
  roles,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'users'
ORDER BY cmd, policyname;

-- 2. 기존 정책 삭제 후 재생성
DROP POLICY IF EXISTS "Allow all select for users" ON users;
DROP POLICY IF EXISTS "Users can insert their own profile" ON users;
DROP POLICY IF EXISTS "Users can update their own profile" ON users;
DROP POLICY IF EXISTS "Only admins can delete users" ON users;
DROP POLICY IF EXISTS "Service role full access" ON users;

-- 2-1. SELECT 정책 (FK 제약 조건 및 조회용)
CREATE POLICY "Allow all select for users" 
ON users 
FOR SELECT 
USING (true);

-- 2-2. INSERT 정책 (회원가입용)
CREATE POLICY "Users can insert their own profile" 
ON users 
FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = id);

-- 2-3. UPDATE 정책 (프로필 수정용)
CREATE POLICY "Users can update their own profile" 
ON users 
FOR UPDATE 
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- 2-4. Service Role 전체 권한 (마이그레이션용)
CREATE POLICY "Service role full access" 
ON users 
FOR ALL 
TO service_role
USING (true)
WITH CHECK (true);

-- 3. 정책 적용 확인
SELECT 
  policyname,
  cmd,
  roles
FROM pg_policies 
WHERE tablename = 'users'
ORDER BY cmd, policyname;
```

### Step 2: 중복 사용자 확인 및 정리

```sql
-- 이메일 중복 확인
SELECT email, COUNT(*) as count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- 특정 사용자의 Auth와 DB 동기화 확인
SELECT 
  u.id,
  u.email,
  u.role,
  u.status,
  u.created_at
FROM users u
WHERE u.email = '사용자이메일@example.com';

-- 필요시 status 업데이트
UPDATE users 
SET status = 'active' 
WHERE email = '사용자이메일@example.com' 
AND status = 'pending';
```

### Step 3: 코드 개선 사항 (이미 적용됨)

1. **signup/page.tsx**: 에러 메시지 개선, Auth 성공 후 프로필 저장 실패 시에도 진행
2. **login/page.tsx**: upsertUserProfile 사용, 상세한 에러 로깅 추가
3. **lib/userUtils.ts**: 프로필 생성/업데이트 로직 표준화

## 테스트 방법

### 터미널에서 테스트:
```bash
# 회원가입 흐름 테스트
node scripts/test-signup-flow.js

# RLS 정책 검증
node scripts/verify-rls-policy.js

# Users 테이블 상태 확인
node scripts/test-user-creation.js
```

### 브라우저에서 테스트:
1. 새 이메일로 회원가입 시도
2. 브라우저 콘솔(F12) 확인
3. 에러 발생 시 정확한 에러 메시지 확인
4. Supabase Dashboard > Authentication > Users 확인

## 사용자 안내

회원가입 시 오류가 발생하면:

1. **이미 가입된 이메일인지 확인**
   - "이미 가입된 이메일입니다" 메시지 확인
   - 비밀번호 재설정 시도

2. **브라우저 캐시 삭제**
   - Ctrl + Shift + Delete
   - 쿠키 및 캐시 삭제

3. **다른 브라우저 시도**
   - Chrome, Firefox, Edge 등

4. **관리자 문의**
   - 정확한 에러 메시지 캡처
   - 사용한 이메일 주소 전달

## 체크리스트

- [ ] RLS 정책 확인 및 적용
- [ ] SELECT 정책: `USING (true)`
- [ ] INSERT 정책: `WITH CHECK (auth.uid() = id)`
- [ ] Service Role 정책: `USING (true) WITH CHECK (true)`
- [ ] 중복 이메일 확인
- [ ] Status 필드 확인 (pending → active)
- [ ] 테스트 스크립트 실행
- [ ] 실제 브라우저 회원가입 테스트
- [ ] 콘솔 에러 로그 확인

## 예상 결과

✅ **정상 동작**:
1. 회원가입 → "회원가입이 완료되었습니다" 알림
2. 로그인 → 메인 페이지로 이동
3. users 테이블에 role='guest', status='active'로 저장

❌ **여전히 오류 발생 시**:
1. Supabase Dashboard > Logs 확인
2. 브라우저 콘솔의 정확한 에러 메시지 확인
3. Network 탭에서 API 요청/응답 확인
4. 해당 정보로 추가 디버깅 진행
