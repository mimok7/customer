# 🚀 데이터 이관 실행 전 필수 체크리스트

## ⚡ 즉시 확인해야 할 3가지

### 1️⃣ 구글 시트 공유 권한 확인 (필수!)
```
✅ 스프레드시트 ID: 1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA
✅ 공유 대상: sheets-importer@cruise-7683b.iam.gserviceaccount.com
✅ 권한 수준: 뷰어(읽기 전용) 이상
```

**확인 방법:**
1. Google Sheets에서 해당 스프레드시트 열기
2. 우측 상단 "공유" 버튼 클릭
3. "sheets-importer@cruise-7683b.iam.gserviceaccount.com" 이메일이 있는지 확인
4. 없다면 → "사용자 및 그룹 추가" → 이메일 입력 → "뷰어" 권한 → "전송"

---

### 2️⃣ 구글 시트 탭 이름 확인
**현재 설정된 탭 이름:**
- `렌트카` 또는 `렌터카`
- `공항`
- `호텔`
- `크루즈`
- `크루즈 차량` 또는 `차량`
- `투어`

**확인 방법:**
```powershell
# 구글 시트에 접속하여 하단의 탭 이름 확인
# 탭 이름이 다르면 utils/sheets-column-maps.js의 sheetName 수정 필요
```

---

### 3️⃣ 환경 변수 재확인
```powershell
# PowerShell에서 실행
node -e "console.log('Supabase URL:', process.env.NEXT_PUBLIC_SUPABASE_URL ? '✅' : '❌'); console.log('Service Key:', process.env.SUPABASE_SERVICE_ROLE_KEY ? '✅' : '❌'); console.log('Sheets ID:', process.env.GOOGLE_SHEETS_ID ? '✅' : '❌'); console.log('Service Account:', process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL ? '✅' : '❌'); console.log('Private Key:', process.env.GOOGLE_SERVICE_ACCOUNT_KEY ? '✅' : '❌');"
```

**예상 출력:**
```
Supabase URL: ✅
Service Key: ✅
Sheets ID: ✅
Service Account: ✅
Private Key: ✅
```

---

## 📋 구글 시트 데이터 형식 확인

### 필수 컬럼 (각 시트별)

#### 렌터카 시트
```
필수: 주문ID, 차량코드 (또는 가격코드)
선택: 차량대수, 승차인원, 승차장소, 목적지, 금액, 메모
```

#### 공항 시트
```
필수: 주문ID, 차량코드, 공항명, 일시 (또는 일자+시간), 승차인원, 캐리어수량
선택: 항공편, 경유지, 차량수, 금액, 요청사항
```

#### 호텔 시트
```
필수: 주문ID, 호텔코드, 체크인날짜
선택: 객실수, 조식서비스, 투숙인원, 일정, 비고, 합계
```

#### 크루즈 시트
```
필수: 주문ID, 객실코드 (또는 지난코드), 체크인, 승선인원
선택: ADULT, CHILD, TODDLER, 금액, 합계, 승선도움, 비고, 커넥팅룸
```

#### 크루즈 차량 / 차량 시트
```
필수: 주문ID
선택: 차량코드, 차량수, 승차인원, 승차일시, 승차위치, 하차위치, 합계, 비고
```

#### 투어 시트
```
필수: 주문ID, 투어코드
선택: 투어인원, 픽업위치, 드랍위치, 합계, 메모
```

---

## 🧪 테스트 실행 (선택 사항)

### 구글 시트 접근 테스트
```powershell
node -e "const {google} = require('googleapis'); const auth = new google.auth.GoogleAuth({ credentials: { client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL, private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\\\n/g, '\\n') }, scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'] }); google.sheets({version:'v4', auth}).then(s => s.spreadsheets.get({spreadsheetId: process.env.GOOGLE_SHEETS_ID})).then(r => console.log('✅ 구글 시트 접근 성공:', r.data.properties.title)).catch(e => console.error('❌ 접근 실패:', e.message));"
```

**성공 시 출력 예시:**
```
✅ 구글 시트 접근 성공: 스테이하롱 예약 데이터
```

**실패 시 주요 원인:**
- ❌ `The caller does not have permission` → 공유 권한 미설정
- ❌ `Unable to parse range` → 시트 탭 이름 불일치
- ❌ `Invalid Credentials` → 서비스 계정 키 오류

---

## 🎯 실행 단계

### 방법 1: PowerShell 스크립트 (권장)
```powershell
# 1. 프로젝트 루트 디렉토리로 이동
cd c:\Users\saint\sht

# 2. PowerShell 스크립트 실행
pwsh ./scripts/run-import-from-sheets.ps1

# 3. 확인 메시지가 나오면 'YES' 입력

# 4. 로그 파일 확인
# reports/import-sheets_20251014_*.log 파일 생성됨
```

**예상 출력:**
```
== Import from Google Sheets - quick check ==
Supabase URL:  https://jkhookaflhibrcafmlxn.supabase.co
Supabase Service Key:  vpk_...******************...
Google Sheets ID:  1GZR...******************...
Google Service Account Email:  sheets-importer@cruise-7683b.iam.gserviceaccount.com

Please confirm you have shared the Google Sheet with the service account email above.
Type YES to proceed: YES

Running import, logging to reports\import-sheets_20251014_143022.log

=== ▶ 렌터카 (→ reservation_rentcar)
Inserted: 25, Skipped: 3

=== ▶ 공항 (→ reservation_airport)
Inserted: 40, Skipped: 2

...

Import finished with exit code: 0
```

---

### 방법 2: Node 직접 실행
```powershell
# 환경 변수 로드된 상태에서
node utils/import-from-sheets.js
```

---

## ⚠️ 주의사항

### 중복 데이터 처리
- **Upsert 방식**: `(reservation_id, *_price_code)` 조합으로 중복 처리
- 동일한 주문ID + 가격코드 → 기존 데이터 업데이트
- 신규 데이터 → 삽입

### 예약 자동 생성
- 서비스 상세 데이터 삽입 전에 `reservation` 테이블에 기본 예약 자동 생성
- `re_status: 'confirmed'`, `re_type: 'pending'`으로 생성됨

### 스킵되는 데이터
- 필수 컬럼이 비어있는 행
- reservation_id가 없는 행
- 날짜/숫자 형식이 잘못된 행 (파서 실패)

---

## 🔍 실행 후 확인 사항

### Supabase 콘솔에서 확인
```sql
-- 이관된 데이터 확인
SELECT 'rentcar' as type, COUNT(*) as count FROM reservation_rentcar
UNION ALL
SELECT 'airport', COUNT(*) FROM reservation_airport
UNION ALL
SELECT 'hotel', COUNT(*) FROM reservation_hotel
UNION ALL
SELECT 'cruise', COUNT(*) FROM reservation_cruise
UNION ALL
SELECT 'cruise_car', COUNT(*) FROM reservation_cruise_car
UNION ALL
SELECT 'tour', COUNT(*) FROM reservation_tour;
```

### 예약 데이터 확인
```sql
-- 자동 생성된 예약 확인
SELECT re_id, re_status, re_type, created_at 
FROM reservation 
ORDER BY created_at DESC 
LIMIT 10;
```

---

## 🆘 문제 발생 시 대응

### 로그 파일 확인
```powershell
# 최신 로그 파일 열기
notepad (Get-ChildItem reports\import-sheets_*.log | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
```

### 주요 에러 메시지

#### `Missing SUPABASE env`
→ `.env.local` 파일 확인, 환경 변수 재설정

#### `Unable to parse range`
→ 시트 탭 이름 확인, `utils/sheets-column-maps.js` 수정

#### `The caller does not have permission`
→ 구글 시트 공유 권한 재확인

#### `기본 예약 생성 실패`
→ `reservation` 테이블 RLS 정책 확인, Service Role Key 확인

#### `Upsert error` 또는 `Insert error`
→ 데이터 형식 확인 (날짜, 숫자 등), 외래키 제약 조건 확인

---

## ✅ 체크리스트 요약

실행 전에 모두 체크하세요:

- [ ] 구글 시트가 서비스 계정과 공유됨
- [ ] 시트 탭 이름이 설정과 일치함
- [ ] 환경 변수가 모두 설정됨
- [ ] 구글 시트 접근 테스트 성공
- [ ] Supabase 테이블 구조 확인
- [ ] 백업 계획 수립 (필요시)
- [ ] 로그 저장 폴더 존재 (`reports/`)

---

**모든 항목이 ✅ 상태면 즉시 실행 가능합니다!**

```powershell
pwsh ./scripts/run-import-from-sheets.ps1
```
