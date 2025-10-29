# 객실코드가 있는 데이터만 Supabase로 이관하기

## 📊 현재 상태
- ✅ **users.csv**: 2,151명
- ✅ **reservations.csv**: 1,457개 (객실코드 있는 데이터만)
- ✅ **reservation_cruise.csv**: 1,457개 (모두 room_price_code 포함)
- ⚠️ **제외됨**: 1,478개 (객실코드 없음)

## 🚀 Supabase Table Editor로 수동 업로드 (권장)

### 1단계: Supabase SQL Editor에서 RLS 비활성화

```sql
-- RLS 비활성화 (FK 제약 조건이 RLS 때문에 실패하는 문제 해결)
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservation DISABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_cruise DISABLE ROW LEVEL SECURITY;
```

### 2단계: Table Editor에서 CSV 업로드

**순서 중요!** (FK 제약 조건 때문)

#### 1. **users** 테이블
1. Supabase Dashboard → Table Editor → `users` 테이블 선택
2. 우측 상단 `...` 메뉴 → "Import data from CSV" 클릭
3. 파일 선택: `users.csv`
4. ✅ **"First row is header"** 체크
5. 컬럼 매핑 확인 (자동 감지됨)
6. "Import" 클릭
7. **결과**: 2,151명 업로드 완료

#### 2. **reservation** 테이블
1. Supabase Dashboard → Table Editor → `reservation` 테이블 선택
2. 우측 상단 `...` 메뉴 → "Import data from CSV" 클릭
3. 파일 선택: `reservations.csv`
4. ✅ **"First row is header"** 체크
5. 컬럼 매핑 확인
6. "Import" 클릭
7. **결과**: 1,457개 업로드 완료

#### 3. **reservation_cruise** 테이블
1. Supabase Dashboard → Table Editor → `reservation_cruise` 테이블 선택
2. 우측 상단 `...` 메뉴 → "Import data from CSV" 클릭
3. 파일 선택: `reservation_cruise.csv`
4. ✅ **"First row is header"** 체크
5. 컬럼 매핑 확인
6. "Import" 클릭
7. **결과**: 1,457개 업로드 완료

### 3단계: 업로드 검증

```sql
-- 업로드된 데이터 확인
SELECT COUNT(*) FROM users;  -- 예상: 2151
SELECT COUNT(*) FROM reservation;  -- 예상: 1457
SELECT COUNT(*) FROM reservation_cruise;  -- 예상: 1457

-- room_price_code가 있는 데이터 확인
SELECT COUNT(*) 
FROM reservation_cruise 
WHERE room_price_code IS NOT NULL 
  AND room_price_code LIKE 'R%';  -- 예상: 1457 (100%)

-- 샘플 데이터 확인
SELECT 
    r.re_id,
    u.name,
    rc.room_price_code,
    rc.checkin,
    rc.room_total_price
FROM reservation r
JOIN users u ON r.re_user_id = u.id
JOIN reservation_cruise rc ON rc.reservation_id = r.re_id
LIMIT 10;
```

### 4단계: RLS 재활성화 (선택)

업로드 완료 후 보안을 위해 RLS를 다시 활성화하세요:

```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_cruise ENABLE ROW LEVEL SECURITY;
```

## ✅ 완료 후 결과

- ✅ Users: 2,151명
- ✅ Reservations: 1,457개
- ✅ Reservation Cruise: 1,457개 (100% room_price_code 포함)
- 📊 총 이관률: 49.6% (객실코드가 있는 데이터만 이관)

## ⚠️ 주의사항

1. **CSV 업로드 순서 반드시 지키기**: users → reservation → reservation_cruise
2. **"First row is header" 체크 필수**
3. **RLS 비활성화**: FK 제약 조건이 RLS 때문에 실패하는 경우가 있음
4. **객실코드 없는 데이터**: 1,478개는 제외됨 (구글 시트에서 객실코드 추가 필요)

## 🔧 문제 해결

### 문제: CSV 업로드 시 FK 오류 발생
**원인**: RLS가 활성화되어 있어서 FK 검증이 실패함  
**해결**: SQL Editor에서 RLS 비활성화 후 재시도

### 문제: 일부 데이터만 업로드됨
**원인**: 컬럼 매핑이 잘못되었거나 데이터 형식 오류  
**해결**: CSV 파일의 첫 행(헤더)과 테이블 컬럼명이 일치하는지 확인

### 문제: room_price_code가 NULL로 표시됨
**원인**: CSV에서 빈 문자열이 NULL로 변환됨 (정상)  
**확인**: `WHERE room_price_code LIKE 'R%'`로 실제 코드가 있는 행만 확인

## 📌 다음 단계

1. ✅ CSV 파일 업로드 완료
2. 🔄 객실코드 없는 1,478개 데이터 처리 방법 결정
   - Option A: 구글 시트에서 수동으로 객실코드 추가 후 재이관
   - Option B: 해당 데이터는 제외하고 진행
3. 🎯 애플리케이션에서 데이터 확인 및 테스트
