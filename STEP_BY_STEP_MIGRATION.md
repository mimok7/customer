# 단계별 데이터 이관 가이드

## 📋 이관 순서

### Step 1: SH_M 시트 → users 테이블 ✅
**목적**: 사용자 정보 이관 및 Auth 계정 생성

**스크립트**: `scripts/step1-import-users-from-sh-m.js`

**실행 방법**:
```powershell
node scripts/step1-import-users-from-sh-m.js
```

**처리 내용**:
- SH_M 시트에서 이메일, 이름, 전화번호 읽기
- Supabase Auth 계정 생성 (비밀번호: qwe123!)
- users 테이블에 사용자 정보 저장
- 중복 사용자 자동 스킵

**예상 결과**:
```
✅ 신규 등록: X명
⚠️  기존 사용자: Y명
❌ 실패: Z명
```

---

### Step 2: 예약 데이터 이관 (예정)
**목적**: 각 서비스별 예약 데이터 이관

**순서**:
1. reservation 테이블 생성
2. reservation_airport 이관
3. reservation_cruise 이관
4. reservation_hotel 이관
5. reservation_rentcar 이관
6. reservation_tour 이관
7. reservation_cruise_car 이관

---

## 🚀 Step 1 실행 전 체크리스트

- [ ] `.env.local`에 환경 변수 설정됨
- [ ] 구글 시트가 서비스 계정과 공유됨
- [ ] SH_M 시트 탭이 존재함
- [ ] SH_M 시트에 이메일 컬럼 있음

---

## 📝 Step 1 실행 후 확인

### Supabase 콘솔에서 확인
```sql
-- 이관된 사용자 수 확인
SELECT COUNT(*) FROM auth.users;

-- users 테이블 확인
SELECT id, email, name, role, created_at 
FROM users 
ORDER BY created_at DESC 
LIMIT 10;
```

### 로그 파일 확인
```powershell
ls reports/step1-users-import_*.log
notepad reports/step1-users-import_*.log
```

---

## ⚠️ 문제 해결

### "Unable to parse range" 오류
→ SH_M 시트 탭이 없습니다. 시트 이름 확인 필요

### "already registered" 오류
→ 이미 등록된 사용자입니다. 정상적으로 스킵됨

### "Invalid email" 오류
→ 이메일 형식이 잘못되었습니다. 시트 데이터 확인 필요

---

## 📊 현재 진행 상태

- [x] Step 1 스크립트 작성 완료
- [ ] Step 1 실행
- [ ] Step 2 스크립트 작성
- [ ] Step 2 실행

---

**다음 단계**: `node scripts/step1-import-users-from-sh-m.js` 실행
