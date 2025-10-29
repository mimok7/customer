# CSV 업로드 순서 가이드 (Foreign Key 오류 방지)

## ⚠️ 중요: 업로드 순서 준수 필수

Foreign Key 제약 조건으로 인해 **반드시 아래 순서대로** 업로드해야 합니다.

## 📋 업로드 순서

### 1단계: Supabase 테이블 준비
```sql
-- SQL Editor에서 실행 (sql/add-order-id-columns.sql)
ALTER TABLE users ADD COLUMN IF NOT EXISTS order_id TEXT;
ALTER TABLE reservation ADD COLUMN IF NOT EXISTS order_id TEXT;
CREATE INDEX IF NOT EXISTS idx_users_order_id ON users(order_id);
CREATE INDEX IF NOT EXISTS idx_reservation_order_id ON reservation(order_id);
```

### 2단계: RLS 임시 비활성화 (선택사항)
```sql
-- 업로드 중 권한 문제 방지
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservation DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_cruise DISABLE ROW LEVEL SECURITY;
```

### 3단계: CSV 업로드 (순서 중요!)

#### ✅ 1. users.csv 먼저 업로드 (필수!)
- **파일**: `users.csv`
- **행 수**: 2,151 rows
- **컬럼 수**: 16 columns (order_id 포함)
- **방법**: Supabase Dashboard → Table Editor → users → "Import data from CSV"
- **중요**: 이것을 먼저 완료해야 reservation을 업로드할 수 있습니다!

#### ✅ 2. reservation.csv 업로드
- **파일**: `reservations.csv`
- **행 수**: 1,457 rows
- **컬럼 수**: 11 columns (order_id 포함)
- **의존성**: users 테이블의 re_user_id 참조 (FK)
- **방법**: Supabase Dashboard → Table Editor → reservation → "Import data from CSV"

#### ✅ 3. reservation_cruise.csv 업로드
- **파일**: `reservation_cruise.csv`
- **행 수**: 1,457 rows
- **컬럼 수**: 11 columns
- **의존성**: reservation 테이블의 reservation_id 참조 (FK)
- **방법**: Supabase Dashboard → Table Editor → reservation_cruise → "Import data from CSV"

### 4단계: RLS 재활성화
```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_cruise ENABLE ROW LEVEL SECURITY;
```

### 5단계: 데이터 검증
```sql
-- 업로드된 데이터 확인
SELECT COUNT(*) as total_users FROM users;
-- 예상: 2151

SELECT COUNT(*) as total_reservations FROM reservation;
-- 예상: 1457

SELECT COUNT(*) as total_cruise_reservations FROM reservation_cruise;
-- 예상: 1457

-- order_id가 제대로 입력되었는지 확인
SELECT COUNT(order_id) as users_with_order_id FROM users;
-- 예상: 2151

SELECT COUNT(order_id) as reservations_with_order_id FROM reservation;
-- 예상: 1457

-- order_id 관계 테스트
SELECT u.order_id, u.name, r.re_type, r.total_amount
FROM users u
JOIN reservation r ON u.order_id = r.order_id
LIMIT 10;
```

## 🔍 트러블슈팅

### 오류: "violates foreign key constraint reservation_re_user_id_fkey"
**원인**: users 테이블에 데이터가 없거나 업로드가 완료되지 않음
**해결**: 
1. users 테이블을 먼저 완전히 업로드
2. users 테이블 데이터 확인: `SELECT COUNT(*) FROM users;`
3. 2,151개가 확인되면 reservation 업로드 진행

### 오류: "violates foreign key constraint reservation_cruise_reservation_id_fkey"
**원인**: reservation 테이블에 데이터가 없거나 업로드가 완료되지 않음
**해결**:
1. reservation 테이블을 먼저 완전히 업로드
2. reservation 테이블 데이터 확인: `SELECT COUNT(*) FROM reservation;`
3. 1,457개가 확인되면 reservation_cruise 업로드 진행

### 오류: RLS 정책으로 인한 권한 오류
**해결**: 
```sql
ALTER TABLE [테이블명] DISABLE ROW LEVEL SECURITY;
-- 업로드 후
ALTER TABLE [테이블명] ENABLE ROW LEVEL SECURITY;
```

## 📊 업로드 체크리스트

- [ ] SQL로 order_id 컬럼 추가 완료
- [ ] RLS 비활성화 (선택사항)
- [ ] ✅ **1순위: users.csv 업로드 (2,151 rows)**
- [ ] users 테이블 데이터 개수 확인 (2,151개)
- [ ] ✅ **2순위: reservations.csv 업로드 (1,457 rows)**
- [ ] reservation 테이블 데이터 개수 확인 (1,457개)
- [ ] ✅ **3순위: reservation_cruise.csv 업로드 (1,457 rows)**
- [ ] reservation_cruise 테이블 데이터 개수 확인 (1,457개)
- [ ] order_id 데이터 검증
- [ ] order_id 관계 쿼리 테스트
- [ ] RLS 재활성화

## 🎯 핵심 원칙

**"부모 테이블을 먼저, 자식 테이블은 나중에"**

```
users (부모)
  ↓ FK: re_user_id
reservation (자식, 부모)
  ↓ FK: reservation_id
reservation_cruise (자식)
```

이 순서를 지키면 Foreign Key 오류 없이 깔끔하게 업로드됩니다!
