# 모든 서비스 표시 기능 완료 ✅

## 구현 완료 서비스 (7개)

### 1. 크루즈 (SH_R) - 파란색 테마
- **아이콘**: 🚢 Ship
- **날짜 필드**: `checkin` (체크인)
- **주요 정보**: 크루즈명, 객실종류, 체크인날짜/시간, 인원(성인/아동/유아), 객실수, 할인, 승선도움, 비고
- **색상**: `bg-blue-50`, `text-blue-600`

### 2. 차량 (SH_C) - 파란색 테마
- **아이콘**: 🚗 Car
- **날짜 필드**: `pickupDatetime` (승차일시)
- **주요 정보**: 차량종류, 승차일시, 승차/하차위치, 인원수, 차량수, 금액
- **색상**: `bg-blue-50`, `text-blue-600`

### 3. 스하차량 (SH_CC) - 보라색 테마
- **아이콘**: 🚗 Car
- **날짜 필드**: `boardingDate` (승차일)
- **주요 정보**: 구분(크루즈/일반), 분류(Pickup/Drop-off), 승차일, 차량번호, 좌석번호, 탑승자명
- **색상**: `bg-purple-50`, `text-purple-600`

### 4. 공항 (SH_P) - 초록색 테마
- **아이콘**: ✈️ Plane
- **날짜 필드**: `date` (일자)
- **주요 정보**: 구분(왕복/편도), 분류(픽업/샌딩), 경로, 일자/시간, 공항명, 항공편, 승차인원, 캐리어수량, 장소명, 차량수, 금액
- **색상**: `bg-green-50`, `text-green-600`

### 5. 호텔 (SH_H) - 주황색 테마
- **아이콘**: 🏨 Building
- **날짜 필드**: `checkinDate` (체크인날짜)
- **주요 정보**: 호텔명, 객실명, 객실종류, 체크인날짜, 숙박일수, 인원(성인/아동/유아), 객실수, 조식서비스, 금액
- **색상**: `bg-orange-50`, `text-orange-600`

### 6. 투어 (SH_T) - 분홍색 테마
- **아이콘**: 📍 MapPin
- **날짜 필드**: `startDate` (시작일자)
- **주요 정보**: 투어명, 투어종류, 시작일자, 투어인원, 픽업위치, 수량, 금액
- **색상**: `bg-pink-50`, `text-pink-600`

### 7. 렌트카 (SH_RC) - 인디고 테마
- **아이콘**: 🚗 Car
- **날짜 필드**: `pickupDate` (승차일자)
- **주요 정보**: 차량종류, 경로, 구분(왕복/편도), 승차일자/시간, 승차장소, 목적지, 승차인원, 차량수, 사용기간, 금액
- **색상**: `bg-indigo-50`, `text-indigo-600`

## 공통 기능

### 모든 서비스 카드에 포함된 정보
1. **고객 이름** (상단, 굵은 글씨)
   - SH_M 시트의 한글이름 자동 매핑
   - 주문ID와 함께 표시: `{고객이름} ({주문ID})`

2. **상태 배지**
   - 예정: 해당 서비스 색상 배지
   - 완료: 회색 배지 + 카드 투명도 60%

3. **날짜 정보**
   - 달력 아이콘과 함께 한글 날짜 형식으로 표시
   - 각 서비스별 고유 날짜 필드 사용

4. **금액 정보** (해당 서비스만)
   - 공항, 호텔, 투어, 렌트카: `totalPrice` 표시
   - 천 단위 콤마 포맷: `formatPrice()` 함수 사용

## 타입 가드 함수

```typescript
// 각 서비스 타입 구분을 위한 타입 가드 함수들
isCruiseData()    // checkin + cruise 존재 여부
isVehicleData()   // boardingDate + vehicleNumber 존재 여부
isAirportData()   // airportName + flightNumber 존재 여부
isHotelData()     // hotelName + checkinDate 존재 여부
isTourData()      // tourName + startDate 존재 여부
isRentcarData()   // pickupDate + usagePeriod 존재 여부
isCarData()       // pickupDatetime 존재 (다른 날짜 필드 없음)
```

## API 엔드포인트

```typescript
// 각 서비스별 데이터 조회
GET /api/schedule/google-sheets?type=cruise   // 크루즈
GET /api/schedule/google-sheets?type=car      // 차량
GET /api/schedule/google-sheets?type=vehicle  // 스하차량
GET /api/schedule/google-sheets?type=airport  // 공항
GET /api/schedule/google-sheets?type=hotel    // 호텔
GET /api/schedule/google-sheets?type=tour     // 투어
GET /api/schedule/google-sheets?type=rentcar  // 렌트카
```

## TypeScript 인터페이스

모든 서비스별 인터페이스 정의 완료:
- `SHRReservation` (크루즈)
- `SHCReservation` (차량)
- `SHCCReservation` (스하차량)
- `SHPReservation` (공항)
- `SHHReservation` (호텔)
- `SHTReservation` (투어)
- `SHRCReservation` (렌트카)

## 카드 레이아웃 구조

```tsx
<div className="bg-gray-50 rounded-lg shadow-sm p-3">
  {/* 헤더: 아이콘 + 서비스명 + 상태 배지 */}
  <div className="flex items-center gap-2 border-b">
    <아이콘 />
    <서비스명 />
    <상태배지 />
  </div>
  
  {/* 본문: 고객 정보 + 서비스 상세 */}
  <div className="flex flex-col gap-1">
    {/* 고객 이름 (최우선 표시) */}
    <고객이름 + 주문ID />
    
    {/* 서비스별 상세 정보 */}
    <서비스정보1 />
    <서비스정보2 />
    <날짜정보 />
    <기타정보 />
    <금액정보 />
  </div>
</div>
```

## 파일 위치

- **API 라우트**: `app/api/schedule/google-sheets/route.ts`
- **프론트엔드 페이지**: `app/manager/schedule/page.tsx`
- **인터페이스 정의**: `app/manager/schedule/page.tsx` 상단
- **타입 가드 함수**: `app/manager/schedule/page.tsx` 내부
- **카드 렌더링 함수**: `renderGoogleSheetsCard()` 함수

## 작동 방식

1. **데이터 로드**
   - API 라우트에서 각 시트(SH_R, SH_C, SH_CC, SH_P, SH_H, SH_T, SH_RC) 조회
   - SH_M 시트에서 주문ID-한글이름 매핑 데이터 로드
   - 각 예약 데이터에 `customerName` 필드 자동 추가

2. **타입 구분**
   - `renderGoogleSheetsCard()` 함수에서 타입 가드로 서비스 타입 판별
   - 각 서비스별로 다른 UI 렌더링

3. **날짜 필터링**
   - 각 서비스의 날짜 필드를 기준으로 선택된 날짜와 비교
   - 일간/주간/월간 뷰 모드 지원

4. **표시**
   - 3열 그리드로 카드 표시
   - 서비스별로 다른 색상 테마 적용
   - 과거 예약은 투명도 낮춤 (opacity-60)

---

**마지막 업데이트**: 2025년 10월 15일
**구현 완료**: 7개 서비스 전체
