# 완전 초기화 실행 가이드

## 📋 개요
모든 사용자 데이터를 완전히 삭제하고 Google Sheets에서 새로 가져오기

---

## 🚀 실행 순서

### 1단계: Supabase SQL Editor에서 users 테이블 관련 데이터 삭제

1. **Supabase Dashboard 접속**
   - https://supabase.com/dashboard
   - 프로젝트 선택

2. **SQL Editor 열기**
   - 왼쪽 메뉴 → SQL Editor
   - 새 쿼리 생성

3. **SQL 파일 내용 복사 & 실행**
   ```bash
   # 파일 위치: scripts/delete-all-users.sql
   ```
   - 파일 내용을 복사하여 SQL Editor에 붙여넣기
   - "Run" 버튼 클릭 (또는 Ctrl+Enter)

4. **실행 결과 확인**
   ```
   ✅ users 테이블: 0개
   ✅ reservation: 0개
   ✅ quote: 0개
   ✅ payment: 0개
   ```

---

### 2단계: Auth 사용자 삭제 (Node.js 스크립트)

SQL로 users 테이블을 비운 후 실행:

```powershell
node scripts/delete-auth-users-only.js
```

**예상 출력:**
```
🔄 라운드 1 시작...
📋 916명 발견 (누적 삭제: 0명)
[50/916] 삭제 중... (라운드: 50, 전체: 50명)
[100/916] 삭제 중... (라운드: 100, 전체: 100명)
...
✅ 라운드 1 완료: 성공 916명, 실패 0명 (전체: 916명)
✅ 모든 Auth 사용자 삭제 완료!
```

---

### 3단계: Google Sheets에서 사용자 새로 가져오기

모든 사용자가 삭제되었으면 가져오기 실행:

```powershell
node scripts/step1-import-users-from-sh-m.js
```

**예상 출력:**
```
📖 SH_M 시트 읽는 중...
✅ 한글이름 컬럼 사용
✅ 유효한 사용자 데이터: 1807명

📤 Supabase에 사용자 이관 시작...
[1/1807] test@example.com (홍길동)
  ✅ 등록 완료 (ID: abc123...)
[2/1807] user2@example.com (김철수)
  ✅ 등록 완료 (ID: def456...)
...
✅ 이관 완료
```

---

## ⚠️ 중요 주의사항

### 1. 실행 순서를 반드시 지킬 것
```
SQL 삭제 (users 테이블) 
  ↓
Auth 사용자 삭제 (스크립트)
  ↓
새로 가져오기 (스크립트)
```

### 2. SQL 삭제를 먼저 하지 않으면
Auth 사용자 삭제 시 외래 키 에러 발생:
```
❌ Database error deleting user
```

### 3. 실행 중 에러 발생 시
- 에러 메시지 확인
- 해당 단계부터 다시 실행
- 중복 실행 가능 (멱등성 보장)

---

## 🔍 문제 해결

### Q1: SQL 실행 시 "permission denied" 에러
**해결:** Service Role Key가 아닌 일반 키를 사용 중일 수 있음
- Supabase Dashboard → Settings → API → service_role key 확인

### Q2: Auth 삭제 시 모두 실패
**원인:** users 테이블이 아직 비워지지 않음
**해결:** 1단계(SQL 삭제)를 먼저 실행

### Q3: 가져오기 시 일부만 성공
**확인사항:**
- Google Sheets 공유 설정
- 이메일 유효성
- Supabase 연결

---

## 📊 실행 시간 예상

| 단계 | 데이터 수 | 예상 시간 |
|------|----------|----------|
| SQL 삭제 | ~2000건 | 5-10초 |
| Auth 삭제 | 916명 | 2-3분 |
| 가져오기 | 1807명 | 3-5분 |
| **합계** | - | **약 5-8분** |

---

## ✅ 완료 확인

모든 단계 완료 후 확인:

```sql
-- Supabase SQL Editor에서 실행
SELECT 
    'users 테이블' as 항목,
    COUNT(*) as 개수
FROM users
UNION ALL
SELECT 
    'Auth 사용자' as 항목,
    COUNT(*) as 개수
FROM auth.users;
```

**예상 결과:**
```
users 테이블: 1807
Auth 사용자: 1807
```

---

## 📝 스크립트 파일 목록

```
scripts/
├── delete-all-users.sql              # 1단계: SQL 삭제
├── delete-auth-users-only.js         # 2단계: Auth 삭제
└── step1-import-users-from-sh-m.js   # 3단계: 가져오기
```

---

## 🎯 다음 단계

사용자 가져오기 완료 후:
1. Step 2: 예약 데이터 이관
2. Step 3: 결제 데이터 이관
3. Step 4: 견적 데이터 이관

---

**작성일:** 2025-10-14  
**버전:** 1.0
