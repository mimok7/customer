# SH_CC 구글시트 데이터 이관 가이드

## 📊 현재 상태 요약

### 구글시트 SH_CC
- **총 데이터**: 1,235건
- **구분 통계**:
  - 크루즈: 1,233건
  - 렌트: 2건
- **분류 통계**:
  - Pickup: 620건
  - Drop-off: 615건
- **날짜 범위**: 2024-10-07 ~ 2026-04-21

### 데이터베이스
- **reservation (re_type='sht')**: 0건
- **reservation_car_sht**: 0건
- **이관 필요**: 1,235건

## 🔧 준비 작업

### 1. 기존 데이터 삭제 (필요시)
```powershell
# 방법 1: SQL 직접 실행 (Supabase Dashboard)
# delete-sht-reservations.sql 파일 내용을 Supabase SQL Editor에 복사/실행

# 방법 2: Node.js 스크립트 실행
node delete-sht-reservations.js
# ⚠️ CONFIRM_DELETE = true로 설정 후 실행
```

### 2. 데이터 확인
```powershell
# 구글시트 데이터 개수 확인
node count-sh-cc-data.js

# 현재 DB 상태 확인
node check-current-sht-data.js
```

## 🚀 데이터 이관 실행

### 방법: Google Sheets API 직접 연동
```powershell
# 스크립트 실행
node scripts/import-sht-car-from-sh-cc.js
```

### 스크립트 동작 흐름
1. **Google Sheets 연결**: SH_CC 시트에서 1,235건 데이터 로드
2. **주문ID → 사용자ID 매핑**: SH_M 시트에서 이메일 정보 조회
3. **위치 정보 로드**: SH_C 시트에서 pickup/dropoff 위치 조회
4. **데이터 변환**: 시트 컬럼을 DB 테이블 구조로 변환
5. **reservation 테이블 생성**: 각 행마다 메인 예약 레코드 생성
6. **reservation_car_sht 테이블 생성**: 상세 차량 배차 정보 저장

### 컬럼 매핑 (실제 확인됨)
| 시트 | 컬럼 | 컬럼명 | reservation_car_sht |
|-----|------|-------|---------------------|
| SH_CC | A열 | ID | (내부 참조용) |
| SH_CC | B열 | 주문ID | → users.id 매핑 |
| SH_CC | C열 | 승차일 | usage_date, pickup_datetime |
| SH_CC | D열 | 구분 | (크루즈/렌트) |
| SH_CC | E열 | 분류 | sht_category (Pickup/Drop-off) |
| SH_CC | F열 | 차량번호 | vehicle_number |
| SH_CC | G열 | 좌석번호 | seat_number |
| SH_CC | H열 | 이름 | (참조용) |
| SH_CC | K열 | Email | request_note |
| SH_C | B열 | 주문ID | → 매칭 키 |
| SH_C | K열 | 승차위치 | pickup_location |
| SH_C | L열 | 하차위치 | dropoff_location |

### 생성되는 데이터 구조

#### reservation 테이블
```javascript
{
  re_user_id: userId,        // 주문ID → 사용자ID 변환
  re_quote_id: null,         // 견적 없이 직접 예약
  re_type: 'sht',            // 서비스 타입
  re_status: 'confirmed',    // 기존 데이터는 확정 상태
  re_created_at: usageDate,  // 승차일 기준
  total_amount: 0,           // 가격 정보 나중에 계산
  paid_amount: 0,
  payment_status: 'unpaid'
}
```

#### reservation_car_sht 테이블
```javascript
{
  reservation_id: re_id,                    // 예약 ID
  vehicle_number: '차량번호',               // SH_CC F열
  seat_number: '좌석번호',                  // SH_CC G열
  sht_category: 'Pickup',                   // SH_CC E열 (Pickup/Drop-off)
  usage_date: '2026-04-21',                 // SH_CC C열 (승차일)
  pickup_location: 'L7 WEST LAKE HANOI',    // SH_C K열 (승차위치)
  dropoff_location: 'updating',             // SH_C L열 (하차위치)
  car_price_code: null,                     // 나중에 계산
  passenger_count: 0,                       // 시트에 정보 없음
  car_count: 1,                             // 기본값
  unit_price: 0,                            // 나중에 계산
  car_total_price: 0,                       // 나중에 계산
  request_note: '이메일: busy6424@naver.com'  // SH_CC K열
}
```

## 🔍 실행 후 확인

### 1. 데이터 개수 확인
```powershell
node check-current-sht-data.js
```

**예상 결과**:
```
✅ reservation 테이블 (re_type='sht'): 1235건
✅ reservation_car_sht 테이블: 1235건

📋 카테고리별 통계:
  - 크루즈 - Pickup: 620건
  - 크루즈 - Drop-off: 615건
  - 렌트 - Pickup: X건
  - 렌트 - Drop-off: X건

📅 사용일 범위:
  - 최소: 2024-10-07
  - 최대: 2026-04-21
```

### 2. 웹 페이지 확인
```
http://localhost:3000/manager/dispatch/sht-car
```

- 날짜 필터 선택
- 데이터 목록 표시 확인
- 차량번호, 좌석번호, 카테고리 등 정보 표시 확인

## ⚠️ 주의사항

1. **주문ID 매핑**: SH_M 시트에 없는 주문ID는 건너뜀
2. **날짜 형식**: 여러 날짜 형식 자동 변환 (YYYY.MM.DD, YYYYMMDD 등)
3. **가격 정보**: 시트에 가격 정보 없음 → 나중에 별도 계산 필요
4. **중복 실행**: 스크립트 재실행시 중복 데이터 생성됨 → 삭제 후 재실행 권장

## 🐛 문제 해결

### 주문ID 매핑 실패
```
⚠️ 행 X: 주문ID 'XXXXX'에 대한 사용자 매핑 없음
```
→ SH_M 시트에 해당 주문ID 없음. 수동으로 users 테이블에 사용자 추가 필요.

### Google Sheets API 오류
```
❌ Missing Google Sheets env variables.
```
→ `.env.local` 파일에 다음 변수 확인:
- GOOGLE_SHEETS_ID
- GOOGLE_SERVICE_ACCOUNT_EMAIL
- GOOGLE_SERVICE_ACCOUNT_KEY

### Supabase 연결 오류
```
❌ Missing SUPABASE env variables.
```
→ `.env.local` 파일에 다음 변수 확인:
- NEXT_PUBLIC_SUPABASE_URL
- SUPABASE_SERVICE_ROLE_KEY

## 📝 다음 단계

1. ✅ **데이터 이관 완료** → 1,235건
2. ⏳ **가격 코드 계산** → `car_price` 테이블 기준으로 업데이트
3. ⏳ **결제 정보 입력** → 실제 결제 내역 있는 경우 업데이트
4. ⏳ **배차 코드 할당** → 관리자가 수동 할당 또는 자동 생성

## 📞 지원

문제 발생시 아래 스크립트로 상세 로그 확인:
```powershell
node scripts/import-sht-car-from-sh-cc.js > import-log.txt 2>&1
```
