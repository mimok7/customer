# 🎯 예약 총금액 자동계산 시스템 적용 가이드

## 📋 개요
`reservation` 테이블에 `total_amount` 컬럼을 추가하고, 각 서비스별 예약 테이블의 변경사항을 자동으로 반영하는 시스템입니다.

## 🚀 적용 단계

### 1단계: 데이터베이스 마이그레이션 실행

```bash
# 1. Supabase SQL Editor에서 실행
# 파일: sql/add-reservation-total-amount.sql
```

**실행 내용:**
- `reservation.total_amount` 컬럼 추가 (NUMERIC(14,2))
- 자동 계산 함수 `recompute_reservation_total()` 생성
- 각 서비스 테이블에 트리거 설정
- 기존 데이터 백필 (모든 예약의 총금액 일괄 계산)

### 2단계: 결제 관리 시스템 개선 확인

**변경된 파일:** `app/manager/payments/page.tsx`

**주요 개선사항:**
1. **성능 향상**: 복잡한 서비스별 금액 계산 제거
2. **데이터 일관성**: DB에서 자동 계산된 `total_amount` 활용
3. **코드 간소화**: 결제 생성/조회 로직 대폭 단순화

## 🔧 핵심 기능

### 자동 총금액 계산 공식
```sql
total_amount = 
  크루즈객실 (unit_price × guest_count) +
  크루즈차량 (unit_price × car_count) +
  공항서비스 (unit_price × ra_car_count) +
  호텔서비스 (unit_price × room_count) +
  투어서비스 (unit_price × guest_count) +
  렌터카서비스 (unit_price × car_count) +
  차량서비스 (unit_price × car_count)
```

### 서비스별 수량 컬럼 매핑
| 서비스 테이블 | 수량 컬럼 | 계산식 |
|--------------|----------|--------|
| `reservation_cruise` | `guest_count` | unit_price × guest_count |
| `reservation_cruise_car` | `car_count` | unit_price × car_count |
| `reservation_airport` | `ra_car_count` | unit_price × ra_car_count |
| `reservation_hotel` | `room_count` | unit_price × room_count |
| `reservation_tour` | `guest_count` | unit_price × guest_count |
| `reservation_rentcar` | `car_count` | unit_price × car_count |
| `reservation_car_sht` | `car_count` | unit_price × car_count |

## ⚡ 트리거 시스템

### 자동 업데이트 시점
- 서비스 예약 **추가**시
- 서비스 예약 **수정**시 (unit_price, 수량 변경)
- 서비스 예약 **삭제**시

### 수동 재계산 (필요시)
```sql
-- 특정 예약의 총금액 재계산
SELECT recompute_reservation_total('예약ID');

-- 모든 예약의 총금액 재계산
SELECT * FROM recompute_all_reservation_totals();
```

## 📊 결제 관리 개선사항

### Before (기존)
```typescript
// 복잡한 서비스별 금액 조회 및 계산
const [cruiseData, cruiseCarData, airportData, ...] = await Promise.all([
  // 7개 서비스 테이블 개별 조회
]);
// 수동으로 모든 서비스 금액 합산
```

### After (개선 후)
```typescript
// 간단한 총금액 조회
const { data: reservations } = await supabase
  .from('reservation')
  .select('re_id, total_amount, ...')
  .eq('re_status', 'confirmed');
// DB에서 자동 계산된 total_amount 직접 사용
```

## 🎯 장점

### 1. **성능 향상**
- 복잡한 조인 쿼리 제거
- 결제 생성 시간 대폭 단축
- API 호출 횟수 감소

### 2. **데이터 일관성**
- 서비스 변경시 자동 총금액 업데이트
- 수동 계산 오류 방지
- 실시간 반영

### 3. **코드 간소화**
- 복잡한 계산 로직 제거
- 유지보수성 향상
- 버그 발생 가능성 감소

## 🚨 주의사항

### 1. **기존 데이터 검증**
```sql
-- 백필 후 데이터 검증
SELECT 
  re_id,
  total_amount,
  CASE WHEN total_amount = 0 THEN '❌ 확인필요' ELSE '✅ 정상' END as status
FROM reservation 
WHERE re_status = 'confirmed'
ORDER BY total_amount DESC;
```

### 2. **트리거 성능**
- 대량 데이터 변경시 성능 영향 가능
- 필요시 트리거 일시 비활성화 후 수동 재계산

### 3. **RLS 권한**
- 트리거 함수는 `SECURITY DEFINER`로 설정
- Supabase RLS 정책과 호환

## 🔍 테스트 방법

### 1. 자동 계산 테스트
```sql
-- 테스트 예약 생성
INSERT INTO reservation (re_id, re_user_id, re_status) 
VALUES (gen_random_uuid(), 'user-id', 'confirmed');

-- 서비스 추가
INSERT INTO reservation_cruise (reservation_id, unit_price, guest_count)
VALUES ('예약ID', 100000, 2);

-- 총금액 확인 (200000이어야 함)
SELECT total_amount FROM reservation WHERE re_id = '예약ID';
```

### 2. 결제 생성 테스트
1. 매니저 결제 페이지 접속
2. "결제 자료 가져오기" 클릭
3. 콘솔에서 로그 확인:
   - `🔍 확정된 예약 조회: X건`
   - `📋 견적별 그룹화: X개 견적`
   - `🆕 신규 결제 생성 대상: X개 견적`

## ✅ 적용 완료 체크리스트

- [ ] SQL 마이그레이션 실행 완료
- [ ] 기존 데이터 백필 완료
- [ ] 트리거 동작 테스트 완료
- [ ] 결제 생성 기능 테스트 완료
- [ ] 성능 확인 (응답시간 개선 체크)
- [ ] 데이터 정합성 검증 완료

## 📞 문의사항
트리거 시스템이나 자동 계산에 문제가 있으면 수동 재계산 함수를 사용하여 복구할 수 있습니다.
