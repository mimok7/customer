# ✅ SH_CC 데이터 이관 준비 완료 (최종본)

## 📊 현황 요약

### 구글시트
- **SH_CC**: 1,235건 (크루즈 1,233건, 렌트 2건)
  - Pickup: 620건
  - Drop-off: 615건
- **SH_C**: 위치 정보 (승차위치 K열, 하차위치 L열)
- **SH_M**: 주문ID → 이메일 매핑

### 데이터베이스
- **현재**: reservation(sht) 0건, reservation_car_sht 0건
- **이관 후**: 각각 1,235건 예상

---

## 🎯 수정 사항

### 1. **pickup/dropoff 위치 매핑 변경**
   - **이전**: SH_CC H열(이름)을 위치로 사용
   - **현재**: SH_C K열(승차위치), L열(하차위치) 사용 ✅

### 2. **sht_category 단순화**
   - **이전**: `"크루즈 - Pickup"` (D열 + E열 조합)
   - **현재**: `"Pickup"` 또는 `"Drop-off"` (E열만 사용) ✅

### 3. **request_note 간소화**
   - **이전**: `이메일 + 수정자 + 수정일시`
   - **현재**: `이메일: busy6424@naver.com` (이메일만) ✅

---

## 🚀 실행 방법

```powershell
# 1. 현재 상태 확인
node check-current-sht-data.js

# 2. 데이터 이관 실행
node scripts/import-sht-car-from-sh-cc.js

# 3. 결과 확인
node check-current-sht-data.js
```

---

## 📋 데이터 구조 (최종)

### reservation 테이블
```javascript
{
  re_user_id: userId,        // SH_M: 주문ID → users.id
  re_quote_id: null,         // 직접 예약
  re_type: 'sht',
  re_status: 'confirmed',
  re_created_at: '2026-04-21', // SH_CC C열
  total_amount: 0,
  paid_amount: 0,
  payment_status: 'unpaid'
}
```

### reservation_car_sht 테이블
```javascript
{
  reservation_id: re_id,
  vehicle_number: 'Vehicle 1',           // SH_CC F열
  seat_number: 'A1 , A2 , A3',          // SH_CC G열
  sht_category: 'Pickup',               // SH_CC E열
  usage_date: '2026-04-21T00:00:00Z',   // SH_CC C열
  pickup_location: 'L7 WEST LAKE HANOI', // SH_C K열 ✅
  dropoff_location: 'updating',          // SH_C L열 ✅
  car_price_code: null,
  passenger_count: 0,
  car_count: 1,
  unit_price: 0,
  car_total_price: 0,
  request_note: '이메일: busy6424@naver.com' // SH_CC K열
}
```

---

## 🔍 시트 구조 참고

### SH_CC (배차 기본 정보)
```
A: ID (fd1cc312)
B: 주문ID (2fcb6800)
C: 승차일 (2026. 4. 21)
D: 구분 (크루즈)
E: 분류 (Pickup/Drop-off) → sht_category
F: 차량번호 (Vehicle 1)
G: 좌석번호 (A1, A2, A3)
H: 이름 (김옥진)
K: Email (busy6424@naver.com)
```

### SH_C (위치 상세 정보)
```
B: 주문ID (2fcb6800) → 매칭 키
K: 승차위치 (L7 WEST LAKE HANOI) → pickup_location
L: 하차위치 (updating) → dropoff_location
```

---

## ⚠️ 주의사항

1. **SH_C 매칭**: 주문ID 기준으로 SH_C에서 위치 정보 자동 조회
2. **분류별 위치**: 
   - Pickup → pickup_location만 채움
   - Drop-off → dropoff_location만 채움
   - 분류 없음 → 둘 다 채움
3. **중복 실행 금지**: 재실행시 데이터 중복 생성됨

---

## 📈 예상 실행 로그

```
🚀 SH_CC 시트 → 예약 시스템 이관 시작
============================================================

📋 주문ID → 사용자ID 매핑 로드 중...
📊 SH_M 시트: 234행 조회
👥 등록된 사용자: 456명
✅ 123개 주문 매핑 완료

📥 SH_CC 시트 데이터 로드 중...
📊 SH_CC 시트: 1235행 조회

📥 SH_C 시트에서 위치 정보 로드 중...
📊 SH_C 시트: 789행 조회
🗺️ 위치 정보 매핑: 123개 주문

🚀 예약 데이터 생성 시작...
✅ 10건 처리 완료...
✅ 20건 처리 완료...
...
✅ 1230건 처리 완료...

✅ 이관 작업 완료!

📊 최종 결과:
  - 성공: 1235건
  - 건너뜀: 0건
  - 실패: 0건
```

---

## ✅ 체크리스트

- [x] SH_CC 시트 구조 확인 (1,235건)
- [x] SH_C 시트 구조 확인 (K열, L열)
- [x] pickup/dropoff 위치 매핑 수정
- [x] sht_category 단순화 (E열만)
- [x] request_note 간소화 (이메일만)
- [x] import 스크립트 업데이트
- [x] 문서 업데이트
- [ ] **실행 대기 중** ⏳

---

## 🎯 지금 실행하세요!

```powershell
node scripts/import-sht-car-from-sh-cc.js
```

모든 준비가 완료되었습니다! 🚀
