# Google Sheets 시트 이름 매핑

## 스테이하롱 크루즈 예약 시스템 시트 구조

### 주요 시트 매핑 (한글 → 영문)

| 한글 이름 | 영문 시트명 | 용도 | 행 수 |
|----------|-----------|------|-------|
| 사용자 | **SH_M** | 회원 정보 관리 | 2,159행 |
| 크루즈 | **SH_R** | 크루즈 예약 데이터 | 2,949행 |
| 차량 | **SH_C** | 차량 예약 데이터 | 2,014행 |
| 공항 | **SH_P** | 공항 서비스 | 1,999행 |
| 호텔 | **SH_H** | 호텔 예약 | 975행 |
| 투어 | **SH_T** | 투어 예약 | 978행 |
| 렌트카 | **SH_RC** | 렌트카 예약 | 967행 |
| 스하차량 | **SH_CC** | 스하 차량 서비스 | 1,202행 |
| 특별 | **SH_SP** | 특별 서비스 | 1,000행 |

### API 사용법

```typescript
// API 라우트: /api/schedule/google-sheets?type={type}

const typeMapping = {
  'car': 'SH_C',        // 차량
  'cruise': 'SH_R',     // 크루즈
  'vehicle': 'SH_CC',   // 스하차량
  'airport': 'SH_P',    // 공항
  'hotel': 'SH_H',      // 호텔
  'tour': 'SH_T',       // 투어
  'rentcar': 'SH_RC',   // 렌트카
  'user': 'SH_M',       // 사용자
};
```

### 각 서비스별 날짜 필드

| 서비스 | 타입 | 날짜 필드 | 설명 |
|--------|------|----------|------|
| 크루즈 | cruise | `checkin` | 체크인 날짜 (J열) |
| 차량 | car | `pickupDatetime` | 승차일시 (J열) |
| 스하차량 | vehicle | `boardingDate` | 승차일 (C열) |
| 공항 | airport | `date` | 일자 (H열) |
| 호텔 | hotel | `checkinDate` | 체크인날짜 (I열) |
| 투어 | tour | `startDate` | 시작일자 (H열) |
| 렌트카 | rentcar | `pickupDate` | 승차일자 (I열) |

### 예시

```typescript
// 크루즈 데이터 조회
fetch('/api/schedule/google-sheets?type=cruise')

// 차량 데이터 조회
fetch('/api/schedule/google-sheets?type=car')

// 공항 데이터 조회
fetch('/api/schedule/google-sheets?type=airport')
```

### 기타 시트 목록

- **APPEND_LOG**: 추가 로그 (873행)
- **_SYNC_LOG**: 동기화 로그 (1,000행)
- **컬럼목록**: 컬럼 정의
- **Template**: 템플릿
- **cruise, car, rcar, tour, hotel, users, room**: 레거시 시트
- **Export**: 내보내기 데이터 (1,890행)
- **Price**: 가격 정보 (1,967행)
- **room_price**: 객실 가격 (6,308행)

## 개발 규칙

1. **앞으로 한글 시트명을 언급하면 자동으로 영문 시트명으로 변환하여 작업**
   - 예: "차량 시트" → `SH_C` 시트
   - 예: "크루즈 데이터" → `SH_R` 시트

2. **API 호출시 type 파라미터 사용**
   - 영문 시트명이 아닌 type 값 사용 (car, cruise, airport 등)

3. **시트 접근 우선순위**
   - SH_* 시트 (최신 데이터) > 레거시 시트 (cruise, car 등)

---
**마지막 업데이트**: 2025년 10월 15일
**확인된 시트 개수**: 23개
