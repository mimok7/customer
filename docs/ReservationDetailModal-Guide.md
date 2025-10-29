# ReservationDetailModal 컴포넌트 사용 가이드

## 개요
`ReservationDetailModal`은 모든 매니저 페이지에서 예약 상세 정보를 일관된 형태로 표시하기 위한 통합 모달 컴포넌트입니다.

## 사용법

### 1. 기본 임포트
```tsx
import ReservationDetailModal from '@/components/ReservationDetailModal';
```

### 2. 컴포넌트 사용
```tsx
<ReservationDetailModal
    isOpen={showModal}
    onClose={() => setShowModal(false)}
    reservation={selectedReservation}
    title="예약 상세 정보" // 선택사항
/>
```

## Props 인터페이스

```tsx
interface ReservationDetailModalProps {
    isOpen: boolean;          // 모달 표시 여부
    onClose: () => void;      // 모달 닫기 콜백
    reservation: any;         // 예약 데이터 객체
    title?: string;          // 모달 제목 (선택사항, 기본값: "예약 상세 정보")
}
```

## 예약 데이터 구조

컴포넌트는 다음과 같은 예약 데이터 구조를 기대합니다:

```tsx
{
    // 기본 예약 정보
    re_id: string,
    re_quote_id: string,
    re_type: 'cruise' | 'airport' | 'hotel' | 'tour' | 'rentcar' | 'car',
    re_status: string,
    re_created_at: string,
    re_updated_at?: string,
    
    // 고객 정보
    customer_name: string,
    customer_phone?: string,
    customer_email?: string,
    
    // 서비스별 상세 정보 (선택사항)
    service_details?: {
        // 크루즈
        room_price_code?: string,
        guest_count?: number,
        checkin?: string,
        room_total_price?: number,
        
        // 공항
        ra_airport_location?: string,
        ra_flight_number?: string,
        ra_datetime?: string,
        airport_price_code?: string,
        
        // 기타 서비스별 필드들...
        
        request_note?: string  // 모든 서비스 공통 요청사항
    }
}
```

## 지원 서비스 타입

1. **cruise**: 크루즈 예약
   - 객실 정보, 체크인 날짜, 투숙객 수, 가격 정보
   
2. **airport**: 공항 서비스
   - 공항 위치, 항공편, 승객/차량/수하물 정보
   
3. **hotel**: 호텔 예약
   - 체크인 날짜, 호텔 카테고리, 객실/투숙객 정보
   
4. **tour**: 투어 서비스
   - 투어 코드, 참가 인원, 픽업/드롭오프 장소
   
5. **rentcar**: 렌터카 예약
   - 차량 정보, 픽업/목적지, 승객/수하물 정보
   
6. **car/cruise_car/sht_car**: 차량 서비스
   - 차량 가격 코드, 차량번호, 좌석 수, 색상

## 주요 기능

### 1. 가격 테이블 정보 자동 로드
- 각 서비스의 가격 코드를 기반으로 관련 가격 테이블에서 상세 정보 자동 조회
- `room_price`, `car_price`, `airport_price`, `hotel_price` 등

### 2. Fallback 데이터 표시
- 서비스 상세 정보가 없는 경우 원시 예약 데이터 표시
- 다양한 키 패턴으로 데이터 조회 시도

### 3. 반응형 레이아웃
- 모바일/데스크톱 호환
- 스크롤 가능한 모달 구조

## 사용 예시

### 기본 사용법
```tsx
const [showDetails, setShowDetails] = useState(false);
const [selectedReservation, setSelectedReservation] = useState(null);

const handleViewDetails = (reservation) => {
    setSelectedReservation(reservation);
    setShowDetails(true);
};

return (
    <>
        <button onClick={() => handleViewDetails(reservation)}>
            상세 보기
        </button>
        
        <ReservationDetailModal
            isOpen={showDetails}
            onClose={() => setShowDetails(false)}
            reservation={selectedReservation}
        />
    </>
);
```

### 서비스별 제목 설정
```tsx
<ReservationDetailModal
    isOpen={showDetails}
    onClose={() => setShowDetails(false)}
    reservation={selectedReservation}
    title={`${getServiceName(selectedReservation.re_type)} 예약 상세정보`}
/>
```

## 스타일링

컴포넌트는 Tailwind CSS를 사용하며 다음과 같은 스타일 특징을 가집니다:

- **모달 배경**: 반투명 검은색 오버레이
- **컨테이너**: 흰색 배경, 둥근 모서리, 그림자
- **색상 구조**: 서비스별 구분된 색상 (파랑, 초록, 보라, 주황 등)
- **반응형**: 모바일에서 전체 너비, 데스크톱에서 최대 4xl 너비

## 의존성

- React 18+
- Next.js 13+ (App Router)
- Tailwind CSS
- Lucide React (아이콘)
- Supabase (데이터베이스 조회)

## 확장성

새로운 서비스 타입을 추가하려면:

1. `getServiceName()` 함수에 새 타입 추가
2. `renderServiceDetails()` 함수에 새 케이스 추가
3. `loadPriceDetails()` 함수에 새 가격 테이블 매핑 추가

## 호환 페이지

이 컴포넌트는 다음 매니저 페이지들에서 사용할 수 있습니다:

- `/manager/reservation-details` ✅ (이미 적용)
- `/manager/reservations`
- `/manager/payments`
- `/manager/schedule`
- `/manager/analytics` (예약 통계에서 상세 보기)

각 페이지에서 기존 모달 코드를 이 통합 컴포넌트로 교체하면 일관된 UX와 유지보수성을 확보할 수 있습니다.
