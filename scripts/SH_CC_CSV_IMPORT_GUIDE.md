# SH_CC 데이터 이관 가이드 (CSV 방식)

## 📋 개요

SH_CC 시트의 스하차량 데이터를 CSV 파일을 통해 예약 시스템(`reservation` + `reservation_car_sht` 테이블)으로 이관합니다.

## 🎯 목표

- ✅ `reservation` 테이블: 메인 예약 정보 (`re_type='sht'`)
- ✅ `reservation_car_sht` 테이블: 차량 상세 정보
- ✅ 주문ID → 사용자ID 직접 변환 (users.reservation_date 필드 사용)

## 📊 CSV 파일 형식

### 필수 컬럼

```csv
order_id,reservation_date,vehicle_number,seat_number,sht_category,pickup_location,dropoff_location,pickup_datetime,passenger_count,request_note,car_price_code,unit_price,total_price
```

### 컬럼 설명

| 컬럼명 | 설명 | 예시 | 필수 여부 |
|--------|------|------|-----------|
| `order_id` | 주문ID (users.reservation_date와 매칭) | ORD001 | ✅ |
| `reservation_date` | 예약 생성일 | 2025-01-15 | ✅ |
| `vehicle_number` | 차량번호 | 서울12가3456 | ❌ |
| `seat_number` | 좌석번호 | A1 | ❌ |
| `sht_category` | 카테고리 | 크루즈, 공항 | ❌ |
| `pickup_location` | 픽업 위치 | 서울역 | ❌ |
| `dropoff_location` | 드롭오프 위치 | 인천항 | ❌ |
| `pickup_datetime` | 픽업 일시 | 2025-01-15 | ❌ |
| `passenger_count` | 승객 수 | 4 | ❌ |
| `request_note` | 요청사항 | 조용한 곳 희망 | ❌ |
| `car_price_code` | 가격 코드 | SHT_CRUISE_01 | ❌ |
| `unit_price` | 단가 | 50000 | ❌ |
| `total_price` | 총 금액 | 200000 | ❌ |

### 날짜 형식 지원

다음 형식들이 자동으로 `YYYY-MM-DD`로 변환됩니다:
- `YYYY-MM-DD`: 2025-01-15
- `YYYYMMDD`: 20250115
- `YYYY.MM.DD`: 2025.01.15
- `YYYY/MM/DD`: 2025/01/15
- Excel 날짜 숫자: 45307 → 2025-01-15

## 🚀 실행 방법

### 방법 1: Google Sheets에서 자동 변환

#### Step 1: Google Sheets → CSV 변환
```bash
node scripts/export-sh-cc-to-csv-with-mapping.js
```

**이 스크립트는 자동으로:**
- ✅ SH_CC 시트 데이터 조회
- ✅ SH_M 시트에서 주문ID → 이메일 매핑
- ✅ CSV 파일 생성 (`scripts/sh_cc_data.csv`)

#### Step 2: CSV 파일 확인 및 수정
```bash
# CSV 파일 위치
scripts/sh_cc_data.csv
```

필요시 엑셀이나 텍스트 편집기로 열어서 데이터 확인/수정

#### Step 3: 예약 시스템으로 이관
```bash
node scripts/import-sht-car-from-csv.js
```

### 방법 2: 수동 CSV 작성

#### Step 1: 템플릿 복사
```bash
cp scripts/sh_cc_data_template.csv scripts/sh_cc_data.csv
```

#### Step 2: CSV 파일 작성
엑셀이나 텍스트 편집기로 `scripts/sh_cc_data.csv` 파일을 열어서 데이터 입력

**예시:**
```csv
order_id,reservation_date,vehicle_number,seat_number,sht_category,pickup_location,dropoff_location,pickup_datetime,passenger_count,request_note,car_price_code,unit_price,total_price
ORD001,2025-01-15,서울12가3456,A1,크루즈,서울역,인천항,2025-01-15,4,조용한 곳 희망,SHT_CRUISE_01,50000,200000
ORD002,2025-01-16,서울23나4567,B2,공항,김포공항,강남역,2025-01-16,2,,SHT_AIRPORT_01,30000,60000
```

#### Step 3: 예약 시스템으로 이관
```bash
node scripts/import-sht-car-from-csv.js
```

## 📦 생성되는 데이터 구조

### 1. `reservation` 테이블

```sql
INSERT INTO reservation (
    re_user_id,        -- users 테이블의 id (이메일로 조회)
    re_quote_id,       -- NULL (견적 없이 직접 예약)
    re_type,           -- 'sht' (고정)
    re_status,         -- 'confirmed' (기존 데이터는 확정 상태)
    re_created_at,     -- CSV의 reservation_date
    total_amount,      -- CSV의 total_price
    paid_amount,       -- 0 (초기값)
    payment_status     -- 'unpaid' (초기값)
)
```

### 2. `reservation_car_sht` 테이블

```sql
INSERT INTO reservation_car_sht (
    reservation_id,      -- 위에서 생성된 reservation.re_id
    vehicle_number,      -- CSV의 vehicle_number
    seat_number,         -- CSV의 seat_number
    sht_category,        -- CSV의 sht_category
    usage_date,          -- CSV의 pickup_datetime (timestamp)
    pickup_location,     -- CSV의 pickup_location
    dropoff_location,    -- CSV의 dropoff_location
    pickup_datetime,     -- CSV의 pickup_datetime (date)
    car_price_code,      -- CSV의 car_price_code
    passenger_count,     -- CSV의 passenger_count
    car_count,           -- 1 (기본값)
    unit_price,          -- CSV의 unit_price
    car_total_price,     -- CSV의 total_price
    request_note,        -- CSV의 request_note
    created_at           -- 현재 시간
)
```

## ✅ 실행 결과 예시

```
🚀 CSV 파일 → 예약 시스템 이관 시작
============================================================

📋 사용자 매핑 로드 중...
👥 등록된 사용자: 150명

📥 CSV 파일 로드 중...
📄 파일: C:\Users\saint\sht\scripts\sh_cc_data.csv
📊 CSV 파일: 1202행 로드

🚀 예약 데이터 생성 시작...
✅ 10건 처리 완료...
✅ 20건 처리 완료...
...
✅ 1200건 처리 완료...

============================================================
📊 이관 결과 요약
============================================================
✅ 성공: 1150건
⏭️  건너뜀: 50건
❌ 실패: 2건
============================================================

✅ 이관 작업 완료!

📊 최종 결과:
  - 성공: 1150건
  - 건너뜀: 50건
  - 실패: 2건
```

## ⚠️ 주의사항

### 1. 주문ID 필수
- CSV의 `order_id`가 `users.reservation_date` 컬럼에 존재해야 함
- 없는 주문ID는 자동으로 건너뜀
- **중요**: users 테이블의 `reservation_date` 컬럼에 주문ID가 저장되어 있어야 함

### 2. 중복 확인
- 같은 사용자가 같은 날짜에 여러 예약 가능
- 필요시 수동으로 중복 제거

### 3. 데이터 검증
- CSV 파일을 먼저 확인하고 테스트 실행 권장
- 소량 데이터로 먼저 테스트 (첫 10개 행만)

### 4. 롤백
- 이관 후 문제 발생시 수동 삭제 필요:
```sql
-- 특정 날짜 이후 생성된 sht 예약 삭제
DELETE FROM reservation_car_sht 
WHERE reservation_id IN (
    SELECT re_id FROM reservation 
    WHERE re_type = 'sht' 
    AND re_created_at >= '2025-01-15'
);

DELETE FROM reservation 
WHERE re_type = 'sht' 
AND re_created_at >= '2025-01-15';
```

## 🐛 문제 해결

### 1. "CSV 파일을 찾을 수 없습니다"
```bash
# 파일 경로 확인
ls scripts/sh_cc_data.csv

# 없으면 템플릿 복사
cp scripts/sh_cc_data_template.csv scripts/sh_cc_data.csv
```

### 1. "주문ID에 대한 사용자 없음"
```sql
-- users 테이블에 주문ID(reservation_date)가 있는지 확인
SELECT id, reservation_date FROM users WHERE reservation_date = 'ORD001';

-- 없으면 users 테이블의 reservation_date 컬럼에 주문ID 먼저 저장 필요
```

### 3. "reservation 테이블 삽입 실패"
- RLS (Row Level Security) 정책 확인
- 서비스 키 권한 확인
- 테이블 제약 조건 확인

### 4. 부분 성공 후 재실행
- 성공한 데이터는 이미 삽입됨
- CSV에서 실패한 행만 남기고 재실행
- 또는 중복 체크 로직 추가

## 📝 체크리스트

### 실행 전
- [ ] `.env.local` 파일에 환경변수 설정 확인
- [ ] `users` 테이블에 사용자 데이터 존재 확인
- [ ] **중요**: `users.reservation_date` 컬럼에 주문ID가 저장되어 있는지 확인
- [ ] CSV 파일 형식 확인 (헤더, 컬럼 순서)
- [ ] 날짜 형식 확인 (자동 파싱 가능한 형식)

### 실행 중
- [ ] 진행 상황 로그 모니터링
- [ ] 오류 메시지 확인 및 기록

### 실행 후
- [ ] 성공/실패/건너뜀 통계 확인
- [ ] 데이터베이스에서 데이터 확인
```sql
-- 이관된 데이터 확인
SELECT COUNT(*) FROM reservation WHERE re_type = 'sht';
SELECT COUNT(*) FROM reservation_car_sht;

-- 최근 이관 데이터 샘플
SELECT r.*, rc.* 
FROM reservation r
JOIN reservation_car_sht rc ON r.re_id = rc.reservation_id
WHERE r.re_type = 'sht'
ORDER BY r.re_created_at DESC
LIMIT 10;
```

## 🔧 고급 사용

### 테스트 모드 (처음 10개 행만)
CSV 파일 수정:
```bash
head -n 11 scripts/sh_cc_data.csv > scripts/sh_cc_data_test.csv
```

스크립트 수정:
```javascript
// import-sht-car-from-csv.js
const CSV_FILE_PATH = path.join(process.cwd(), 'scripts', 'sh_cc_data_test.csv');
```

### 배치 처리
대량 데이터를 여러 번에 나누어 처리:
```bash
# 1-500행
head -n 501 scripts/sh_cc_data.csv > scripts/sh_cc_data_batch1.csv
node scripts/import-sht-car-from-csv.js

# 501-1000행
tail -n +502 scripts/sh_cc_data.csv | head -n 500 > scripts/sh_cc_data_batch2.csv
node scripts/import-sht-car-from-csv.js
```

## 📞 지원

문제 발생시:
1. 로그 메시지 전체 복사
2. CSV 파일 샘플 (민감 정보 제거)
3. 환경 정보 (Node.js 버전, OS)
