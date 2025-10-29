# CSV 파일 직접 업로드 가이드

## 📋 준비된 CSV 파일
- ✅ **users.csv** (2,151 rows)
- ✅ **reservations.csv** (1,457 rows) - order_id 포함
- ✅ **reservation_cruise.csv** (1,457 rows) - 승선코드, 승선도움, 통합 요청사항 포함

## 🎯 업로드 전 필수 작업 (Supabase SQL Editor)

### 1단계: FK 제약 조건 제거
```sql
-- reservation_cruise의 FK 제약 조건 제거
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_room_reservation_id_fkey;
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_cruise_reservation_id_fkey;
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_cruise_room_price_code_fkey;
ALTER TABLE reservation_cruise DROP CONSTRAINT IF EXISTS reservation_cruise_car_price_code_fkey;

-- reservation의 FK 제약 조건 제거 (만약 실패한다면)
ALTER TABLE reservation DROP CONSTRAINT IF EXISTS reservation_re_user_id_fkey;
ALTER TABLE reservation DROP CONSTRAINT IF EXISTS fk_reservation_user;
ALTER TABLE reservation DROP CONSTRAINT IF EXISTS reservation_re_quote_id_fkey;
```

### 2단계: RLS 비활성화
```sql
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservation DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_cruise DISABLE ROW LEVEL SECURITY;
```

### 3단계: 기존 데이터 삭제 (선택사항)
```sql
-- 순서대로 삭제 (FK 관계 때문에)
DELETE FROM reservation_cruise;
DELETE FROM reservation;
-- DELETE FROM users;  -- users는 이미 있으므로 삭제 안 함
```

## 📤 CSV 업로드 순서 (Supabase Table Editor)

### Step 1: users 테이블 (선택사항 - 이미 업로드되어 있음)
1. Supabase Dashboard → **Table Editor**
2. **users** 테이블 선택
3. 우측 상단 **"..."** → **"Import data from CSV"**
4. **users.csv** 파일 선택
5. ✅ **"First row is header"** 체크
6. 컬럼 매핑 확인:
   - id → id
   - order_id → order_id ⭐ (새로 추가된 컬럼)
   - reservation_date → reservation_date
   - email → email
   - name → name
   - ... (나머지 자동 매핑)
7. **"Import"** 클릭
8. ✅ 2,151 rows 임포트 확인

### Step 2: reservation 테이블
1. **reservation** 테이블 선택
2. **"..."** → **"Import data from CSV"**
3. **reservations.csv** 파일 선택
4. ✅ **"First row is header"** 체크
5. 컬럼 매핑 확인:
   - re_id → re_id
   - re_user_id → re_user_id
   - order_id → order_id ⭐ (새로 추가된 컬럼)
   - re_quote_id → re_quote_id
   - re_type → re_type
   - re_status → re_status
   - re_created_at → re_created_at
   - re_update_at → re_update_at
   - total_amount → total_amount
   - paid_amount → paid_amount
   - payment_status → payment_status
6. **"Import"** 클릭
7. ✅ 1,457 rows 임포트 확인

### Step 3: reservation_cruise 테이블
1. **reservation_cruise** 테이블 선택
2. **"..."** → **"Import data from CSV"**
3. **reservation_cruise.csv** 파일 선택
4. ✅ **"First row is header"** 체크
5. 컬럼 매핑 확인:
   - id → id
   - reservation_id → reservation_id
   - room_price_code → room_price_code
   - checkin → checkin
   - guest_count → guest_count
   - unit_price → unit_price
   - room_total_price → room_total_price
   - request_note → request_note ⭐ (SH_M 요청사항/특이사항/메모 통합)
   - boarding_code → boarding_code ⭐ (SH_R 처리 컬럼)
   - boarding_assist → boarding_assist ⭐ (SH_R 승선도움 컬럼)
   - created_at → created_at
6. **"Import"** 클릭
7. ✅ 1,457 rows 임포트 확인

## ✅ 업로드 완료 후 확인 (SQL Editor)

### 1. 데이터 개수 확인
```sql
SELECT COUNT(*) as total_users FROM users;
-- 예상: 2151

SELECT COUNT(*) as total_reservations FROM reservation;
-- 예상: 1457

SELECT COUNT(*) as total_cruise FROM reservation_cruise;
-- 예상: 1457
```

### 2. order_id 확인
```sql
-- users 테이블의 order_id
SELECT COUNT(*) as users_with_order_id 
FROM users 
WHERE order_id IS NOT NULL;
-- 예상: 2151

-- reservation 테이블의 order_id
SELECT COUNT(*) as reservations_with_order_id 
FROM reservation 
WHERE order_id IS NOT NULL;
-- 예상: 1457
```

### 3. 추가 필드 확인 (reservation_cruise)
```sql
-- boarding_code가 있는 데이터
SELECT COUNT(*) as with_boarding_code
FROM reservation_cruise
WHERE boarding_code IS NOT NULL AND boarding_code != 'TBA';
-- 예상: ~40개

-- boarding_assist가 true인 데이터
SELECT COUNT(*) as with_boarding_assist
FROM reservation_cruise
WHERE boarding_assist = true;

-- request_note에 요청사항이 포함된 데이터
SELECT COUNT(*) as with_requests
FROM reservation_cruise
WHERE request_note LIKE '%요청사항:%';
-- 예상: 수백 개
```

### 4. 샘플 데이터 확인
```sql
-- order_id로 연결된 데이터 조회
SELECT 
  u.order_id,
  u.name,
  r.re_type,
  r.total_amount,
  rc.room_price_code,
  rc.boarding_code,
  rc.boarding_assist,
  LEFT(rc.request_note, 100) as request_note_preview
FROM users u
JOIN reservation r ON u.order_id = r.order_id
JOIN reservation_cruise rc ON r.re_id = rc.reservation_id
LIMIT 10;
```

## 🔧 업로드 완료 후 복구 작업

### 1. FK 제약 조건 복구
```sql
-- reservation FK 복구
ALTER TABLE reservation 
  ADD CONSTRAINT reservation_re_user_id_fkey 
  FOREIGN KEY (re_user_id) REFERENCES users(id) ON DELETE CASCADE;

-- reservation_cruise FK 복구
ALTER TABLE reservation_cruise 
  ADD CONSTRAINT reservation_cruise_reservation_id_fkey 
  FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;
```

### 2. RLS 재활성화 (선택사항)
```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_cruise ENABLE ROW LEVEL SECURITY;
```

### 3. 인덱스 생성 (성능 최적화)
```sql
-- order_id 인덱스 (이미 있을 수 있음)
CREATE INDEX IF NOT EXISTS idx_users_order_id ON users(order_id);
CREATE INDEX IF NOT EXISTS idx_reservation_order_id ON reservation(order_id);

-- boarding_code 인덱스
CREATE INDEX IF NOT EXISTS idx_reservation_cruise_boarding_code 
  ON reservation_cruise(boarding_code);
```

## ⚠️ 주의사항

### 1. CSV 인코딩
- 파일 인코딩: **UTF-8**
- Supabase Table Editor가 자동으로 인식하므로 별도 설정 불필요

### 2. 줄바꿈이 포함된 필드
- `request_note` 필드에는 `\n` 문자로 줄바꿈이 포함되어 있음
- CSV에서는 따옴표로 감싸져 있어 정상 처리됨
- 예: `"일반요금\n요청사항: Citadines Marina Ha long 1/1,1/2 왕복 택시 예약요청\n특이사항: 무료픽업"`

### 3. 업로드 제한
- Supabase Table Editor는 한 번에 **약 1,000~2,000 rows** 정도 업로드 가능
- 모든 CSV 파일이 이 범위 안에 있으므로 문제없음

### 4. FK 오류 발생 시
- FK 제약 조건을 제거했는지 확인
- 업로드 순서를 지켰는지 확인 (users → reservation → reservation_cruise)
- 기존 데이터가 남아있는지 확인 (DELETE 쿼리 실행)

## 🎉 완료!

업로드가 완료되면:
1. ✅ users: 2,151명 (order_id 포함)
2. ✅ reservation: 1,457개 (order_id 포함)
3. ✅ reservation_cruise: 1,457개 (승선코드, 승선도움, 통합 요청사항 포함)

모든 데이터가 **주문ID(order_id)**로 연결되어 있으며, 추가 요청하신 필드들이 모두 포함되어 있습니다!
