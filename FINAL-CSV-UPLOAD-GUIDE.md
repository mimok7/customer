# 🚀 CSV 전체 재업로드 가이드 (최종)

## ⚠️ 문제 상황
CSV 파일을 새로 생성하면서 **모든 UUID가 변경**되었습니다.
- Supabase의 기존 데이터: 오래된 UUID
- 새로운 CSV 파일: 새로운 UUID
- **결과**: FK 관계가 모두 깨짐

## ✅ 해결 방법: 전체 재업로드

---

## 📋 Step 1: Supabase SQL Editor에서 실행

```sql
-- 모든 데이터 삭제 (역순)
DELETE FROM reservation_cruise;
DELETE FROM reservation;
DELETE FROM users;

-- 확인 (모두 0이어야 함)
SELECT 'users' as table_name, COUNT(*) FROM users
UNION ALL
SELECT 'reservation' as table_name, COUNT(*) FROM reservation
UNION ALL
SELECT 'reservation_cruise' as table_name, COUNT(*) FROM reservation_cruise;
```

---

## 📤 Step 2: Supabase Table Editor에서 CSV 업로드

### 1️⃣ users.csv 업로드

1. Supabase Dashboard → **Table Editor**
2. **users** 테이블 선택
3. 우측 상단 **"..."** → **"Import data from CSV"**
4. **users.csv** 파일 선택
5. ✅ **"First row is header"** 체크
6. 컬럼 자동 매핑 확인 (특히 **order_id**)
7. **"Import"** 클릭
8. ✅ **2,151 rows** 임포트 확인

### 2️⃣ reservations.csv 업로드

1. **reservation** 테이블 선택
2. **"..."** → **"Import data from CSV"**
3. **reservations.csv** 파일 선택
4. ✅ **"First row is header"** 체크
5. 컬럼 자동 매핑 확인 (특히 **order_id**)
6. **"Import"** 클릭
7. ✅ **1,457 rows** 임포트 확인

### 3️⃣ reservation_cruise.csv 업로드

1. **reservation_cruise** 테이블 선택
2. **"..."** → **"Import data from CSV"**
3. **reservation_cruise.csv** 파일 선택
4. ✅ **"First row is header"** 체크
5. 컬럼 자동 매핑 확인:
   - **request_note** ⭐ (SH_M 요청사항/특이사항/메모 통합)
   - **boarding_code** ⭐ (SH_R 처리 컬럼)
   - **boarding_assist** ⭐ (SH_R 승선도움)
6. **"Import"** 클릭
7. ✅ **1,457 rows** 임포트 확인

---

## ✅ Step 3: Supabase SQL Editor에서 검증

```sql
-- 1. 데이터 개수 확인
SELECT 
  'users' as table_name, COUNT(*) as rows
FROM users
UNION ALL
SELECT 'reservation', COUNT(*) FROM reservation
UNION ALL
SELECT 'reservation_cruise', COUNT(*) FROM reservation_cruise;

-- 예상: users=2151, reservation=1457, reservation_cruise=1457

-- 2. FK 관계 검증 (모두 0이어야 함)
SELECT COUNT(*) as invalid_user_refs
FROM reservation r
LEFT JOIN users u ON r.re_user_id = u.id
WHERE u.id IS NULL;

SELECT COUNT(*) as invalid_reservation_refs
FROM reservation_cruise rc
LEFT JOIN reservation r ON rc.reservation_id = r.re_id
WHERE r.re_id IS NULL;

-- 3. order_id 연결 확인
SELECT 
  u.order_id,
  u.name,
  rc.boarding_code,
  rc.boarding_assist,
  LEFT(rc.request_note, 60) as request_preview
FROM users u
JOIN reservation r ON u.order_id = r.order_id
JOIN reservation_cruise rc ON r.re_id = rc.reservation_id
LIMIT 5;
```

---

## 🔧 Step 4: FK 제약 조건 복구

```sql
-- FK 제약 조건 복구
ALTER TABLE reservation 
  ADD CONSTRAINT reservation_re_user_id_fkey 
  FOREIGN KEY (re_user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE reservation_cruise 
  ADD CONSTRAINT reservation_cruise_reservation_id_fkey 
  FOREIGN KEY (reservation_id) REFERENCES reservation(re_id) ON DELETE CASCADE;

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_users_order_id ON users(order_id);
CREATE INDEX IF NOT EXISTS idx_reservation_order_id ON reservation(order_id);
CREATE INDEX IF NOT EXISTS idx_reservation_cruise_boarding_code ON reservation_cruise(boarding_code);
```

---

## 🎉 완료!

### 최종 결과
- ✅ **users**: 2,151 rows (order_id 포함)
- ✅ **reservation**: 1,457 rows (order_id 포함)
- ✅ **reservation_cruise**: 1,457 rows
  - **boarding_code**: SH_R의 "처리" 컬럼 (~40개)
  - **boarding_assist**: SH_R의 "승선도움" (일부)
  - **request_note**: SH_M의 요청사항/특이사항/메모 통합

### 새로운 필드 확인
```sql
-- 통합된 요청사항 확인
SELECT 
  COUNT(*) as total,
  COUNT(CASE WHEN request_note LIKE '%요청사항:%' THEN 1 END) as with_requests,
  COUNT(CASE WHEN boarding_code IS NOT NULL AND boarding_code != 'TBA' THEN 1 END) as with_boarding_code
FROM reservation_cruise;
```

---

## 📚 참고 파일
- 📄 **sql/full-reload-guide.sql** - 상세한 SQL 가이드
- 📄 **sql/prepare-for-csv-upload.sql** - 업로드 전 준비
- 📄 **sql/restore-constraints-after-upload.sql** - 업로드 후 복구

---

## ⚠️ 주의사항

1. **순서 엄수**: users → reservation → reservation_cruise
2. **FK 제거**: 업로드 전에 FK 제약 조건 제거 필수
3. **전체 삭제**: 부분 업데이트는 불가, 전체 재업로드 필요
4. **검증 필수**: 각 단계마다 데이터 개수 확인

---

모든 단계를 순서대로 진행하면 성공적으로 업로드됩니다! 🚀
