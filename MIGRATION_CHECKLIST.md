# 구글 시트 → Supabase 데이터 이관 점검 리포트
**점검일:** 2025년 10월 14일

## 📋 1. 환경 설정 현황

### ✅ Supabase 연결 정보
- **URL**: `https://jkhookaflhibrcafmlxn.supabase.co`
- **Anon Key**: ✅ 설정됨
- **Service Role Key**: ✅ 설정됨 (필수)

### ✅ Google Sheets API 설정
- **Sheets ID**: `1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA`
- **Service Account Email**: `sheets-importer@cruise-7683b.iam.gserviceaccount.com`
- **Private Key**: ✅ 설정됨

### ⚠️ 필수 확인 사항
1. **구글 시트 공유 권한**
   - 스프레드시트를 `sheets-importer@cruise-7683b.iam.gserviceaccount.com`와 공유했는지 확인
   - 권한: **뷰어(읽기 전용)** 이상

2. **패키지 설치 확인**
   ```bash
   npm install googleapis google-auth-library @supabase/supabase-js dotenv
   ```

---

## 📁 2. 이관 스크립트 현황

### 🎯 주요 이관 스크립트

| 스크립트 | 대상 테이블 | 상태 | 비고 |
|---------|-----------|------|------|
| `utils/import-from-sheets.js` | 전체 서비스 | ✅ 완성 | 메인 이관 스크립트 |
| `utils/simple-import.js` | 전체 서비스 | ✅ 완성 | 간단한 insert 전용 |
| `import-airport-reservations-fixed.js` | 공항 예약 | ✅ 완성 | 공항 전용 |
| `utils/import-cruise-reservations.js` | 크루즈 예약 | ✅ 완성 | 크루즈 전용 |
| `migrate-google-sheets-vehicle-data.js` | 차량 데이터 | ⚠️ 부분 완성 | 실제 API 연동 필요 |

### 📂 서비스별 이관 스크립트 (scripts 폴더)
- `import-airport-reservations-final.js` - ❌ 비어있음
- `import-cruise-reservations-final.js` - ❌ 비어있음
- `import-hotel-reservations-final.js` - ❌ 비어있음
- `import-rentcar-reservations-final.js` - ❌ 비어있음
- `import-tour-reservations-final.js` - ❌ 비어있음
- `import-cruise-vehicles-final.js` - ❌ 비어있음
- `import-sht-car-reservations-final.js` - ❌ 비어있음

### 🔧 보조 스크립트
- `scripts/run-import-from-sheets.ps1` - ✅ PowerShell 실행 래퍼
- `utils/sheets-column-maps.js` - ✅ 컬럼 매핑 설정 (필수)

---

## 🗂️ 3. 구글 시트 구조

### 예상되는 시트 탭 구조
```
스프레드시트 ID: 1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA
├── 사용자 (Users)
├── 공항 (Airport)
├── 크루즈 (Cruise)
├── 호텔 (Hotel)
├── 렌터카 (Rentcar)
├── 투어 (Tour)
├── 차량 (Vehicle/Car)
└── SHT 차량 (SHT Car)
```

### 필수 컬럼 (한글/영문 모두 지원)
- **주문ID / Order ID** → `reservation_id`
- **이메일 / Email** → 사용자 조회용
- **날짜 / Date** → 각 서비스별 일시 필드
- **가격 / Price** → 가격 정보

---

## 🔄 4. 이관 프로세스

### 권장 이관 순서
```
1️⃣ 사용자 (Users)
   ↓
2️⃣ 예약 메인 (Reservation)
   ↓
3️⃣ 서비스별 상세 데이터
   ├── 공항 (reservation_airport)
   ├── 크루즈 (reservation_cruise)
   ├── 호텔 (reservation_hotel)
   ├── 렌터카 (reservation_rentcar)
   └── 투어 (reservation_tour)
   ↓
4️⃣ 차량 데이터
   ├── reservation_cruise_car
   └── reservation_car_sht
```

### 📋 실행 방법

#### 방법 1: PowerShell 스크립트 사용 (권장)
```powershell
# 프로젝트 루트에서 실행
pwsh ./scripts/run-import-from-sheets.ps1
```

#### 방법 2: Node 직접 실행
```bash
# 전체 서비스 이관
node utils/import-from-sheets.js

# 간단 이관 (insert만)
node utils/simple-import.js

# 공항만 이관
node import-airport-reservations-fixed.js

# 사용자만 이관
node utils/import-users-to-supabase-auth.js
```

---

## ⚠️ 5. 주요 이슈 및 해결 방안

### 🔴 Issue 1: scripts 폴더의 final 스크립트가 비어있음
**영향**: 서비스별 개별 이관 불가

**해결방안**:
```bash
# utils 폴더의 스크립트 사용
node utils/import-from-sheets.js  # 전체 이관 (권장)
```

### 🟡 Issue 2: 차량 데이터 이관 미완성
**파일**: `migrate-google-sheets-vehicle-data.js`

**문제점**:
- Google Sheets API 연동 부분이 TODO 상태
- 샘플 데이터만 하드코딩되어 있음

**해결방안**:
```javascript
// fetchDataFromGoogleSheets 함수 구현 필요
// 또는 utils/import-from-sheets.js의 차량 탭 설정 활용
```

### 🟡 Issue 3: 컬럼 매핑 확인 필요
**파일**: `utils/sheets-column-maps.js`

**확인사항**:
- 구글 시트의 실제 컬럼명과 매핑 설정이 일치하는지 확인
- 한글/영문 컬럼명 모두 지원되는지 테스트

---

## ✅ 6. 사전 점검 체크리스트

### 환경 설정
- [ ] `.env.local` 파일에 모든 필수 환경 변수 설정됨
- [ ] 구글 시트가 서비스 계정과 공유됨
- [ ] Supabase Service Role Key가 올바름
- [ ] 필요한 npm 패키지가 모두 설치됨

### 데이터베이스 준비
- [ ] Supabase 테이블 구조가 생성됨
  - [ ] `users` 테이블
  - [ ] `reservation` 테이블
  - [ ] `reservation_airport` 테이블
  - [ ] `reservation_cruise` 테이블
  - [ ] `reservation_hotel` 테이블
  - [ ] `reservation_rentcar` 테이블
  - [ ] `reservation_tour` 테이블
  - [ ] `reservation_cruise_car` 테이블
  - [ ] `reservation_car_sht` 테이블
- [ ] RLS 정책이 적절히 설정됨 (Service Role은 우회 가능)
- [ ] 외래키 제약 조건 확인

### 구글 시트 데이터
- [ ] 각 탭의 1행에 헤더가 있음
- [ ] 필수 컬럼(주문ID, 이메일 등)이 존재함
- [ ] 데이터 형식이 일관됨 (날짜, 숫자 등)

### 백업 및 안전성
- [ ] 기존 DB 데이터 백업 완료 (있다면)
- [ ] 테스트 환경에서 먼저 실행 계획됨
- [ ] 로그 저장 경로 확인 (`reports/` 폴더)

---

## 🚀 7. 권장 실행 절차

### Step 1: 환경 확인
```bash
# 환경 변수 확인
node -e "console.log(process.env.GOOGLE_SHEETS_ID)"
node -e "console.log(process.env.SUPABASE_SERVICE_ROLE_KEY ? 'OK' : 'MISSING')"
```

### Step 2: 구글 시트 접근 테스트
```bash
# 간단한 테스트 스크립트 실행
node -e "
const {google} = require('googleapis');
const auth = new google.auth.GoogleAuth({
  credentials: {
    client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
    private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\\\n/g, '\\n')
  },
  scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly']
});
google.sheets({version:'v4', auth}).then(s => 
  s.spreadsheets.get({spreadsheetId: process.env.GOOGLE_SHEETS_ID})
).then(r => console.log('✅ 구글 시트 접근 성공:', r.data.properties.title))
.catch(e => console.error('❌ 접근 실패:', e.message));
"
```

### Step 3: 드라이런 (선택적)
```bash
# 실제 삽입 없이 데이터만 확인
# (스크립트에 --dry-run 옵션 추가 필요)
```

### Step 4: 실제 이관 실행
```powershell
# PowerShell에서 실행 (로그 저장됨)
pwsh ./scripts/run-import-from-sheets.ps1
```

### Step 5: 결과 확인
```bash
# Supabase 콘솔에서 데이터 확인
# 또는 SQL 쿼리로 확인
```

---

## 📊 8. 예상 이관 데이터 규모

### 테이블별 예상 레코드 수
| 테이블 | 예상 레코드 수 | 비고 |
|--------|--------------|------|
| users | ? | 사용자 수 |
| reservation | ? | 전체 예약 수 |
| reservation_airport | ? | 공항 예약 |
| reservation_cruise | ? | 크루즈 예약 |
| reservation_hotel | ? | 호텔 예약 |
| reservation_rentcar | ? | 렌터카 예약 |
| reservation_tour | ? | 투어 예약 |
| reservation_cruise_car | ? | 크루즈 차량 |
| reservation_car_sht | ? | SHT 차량 |

**예상 소요 시간**: 데이터 규모에 따라 수분 ~ 수십분

---

## 🔧 9. 트러블슈팅

### 문제: "Unable to parse range" 오류
**원인**: 시트 탭 이름이 존재하지 않음

**해결**:
- 구글 시트에서 탭 이름 확인
- `utils/sheets-column-maps.js`의 `sheetName` 수정

### 문제: "Permission denied" 오류
**원인**: 구글 시트 공유 권한 없음

**해결**:
- 스프레드시트를 서비스 계정 이메일과 공유
- 권한: 뷰어 이상

### 문제: "Foreign key constraint" 오류
**원인**: 참조 테이블에 데이터가 없음

**해결**:
- 이관 순서 확인 (사용자 → 예약 → 서비스 상세)
- 외래키 제약 조건 임시 비활성화 (주의)

### 문제: "Duplicate key" 오류
**원인**: 이미 존재하는 데이터

**해결**:
- `simple-import.js` 사용 (중복 무시)
- 또는 기존 데이터 삭제 후 재실행

---

## 📝 10. 참고 문서

### 프로젝트 내 문서
- `README.md` - 프로젝트 개요
- `AIRPORT_IMPORT_README.md` - 공항 이관 가이드
- `AIRPORT_TWO_PHASE_GUIDE.md` - 2단계 이관 가이드

### 외부 문서
- [Google Sheets API](https://developers.google.com/sheets/api)
- [Supabase JavaScript Client](https://supabase.com/docs/reference/javascript)
- [Service Account 인증](https://cloud.google.com/docs/authentication)

---

## ✨ 11. 권장 사항

### 🎯 즉시 실행 가능한 작업
1. **환경 변수 검증**
   ```bash
   node -e "
   const keys = ['NEXT_PUBLIC_SUPABASE_URL', 'SUPABASE_SERVICE_ROLE_KEY', 
                 'GOOGLE_SHEETS_ID', 'GOOGLE_SERVICE_ACCOUNT_EMAIL', 
                 'GOOGLE_SERVICE_ACCOUNT_KEY'];
   keys.forEach(k => console.log(k, ':', process.env[k] ? '✅' : '❌'));
   "
   ```

2. **메인 이관 스크립트 실행**
   ```bash
   node utils/import-from-sheets.js
   ```

3. **결과 로그 확인**
   ```bash
   ls reports/import-sheets*.log
   ```

### 🔜 향후 개선 사항
1. **scripts 폴더 정리**
   - final 스크립트들을 utils 스크립트로 통합 또는 삭제

2. **차량 이관 완성**
   - `migrate-google-sheets-vehicle-data.js`의 API 연동 구현

3. **에러 핸들링 강화**
   - 부분 실패 시 롤백 메커니즘
   - 재시도 로직 추가

4. **모니터링 대시보드**
   - 이관 진행 상황 실시간 표시
   - 성공/실패 통계

---

## 📞 12. 지원 및 문의

### 현재 설정된 계정
- **Supabase Project**: jkhookaflhibrcafmlxn
- **Google Service Account**: sheets-importer@cruise-7683b.iam.gserviceaccount.com

### 주요 스크립트 위치
- 메인: `utils/import-from-sheets.js`
- 설정: `utils/sheets-column-maps.js`
- 실행기: `scripts/run-import-from-sheets.ps1`

---

**마지막 업데이트**: 2025-10-14
**점검자**: GitHub Copilot
**상태**: ✅ 이관 준비 완료 (환경 설정 확인 후 실행 가능)
