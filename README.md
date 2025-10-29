# 스테이하롱 크루즈 - 고객 예약 시스템 (Customer)

## 프로젝트 개요
스테이하롱 크루즈 고객 예약 시스템입니다. 고객이 견적을 조회하고 예약을 생성/관리하는 기능을 제공합니다.

## 주요 기능
- ✅ 견적 조회 및 상세보기
- ✅ 크루즈 객실/차량 예약
- ✅ 공항 서비스 예약
- ✅ 호텔 예약
- ✅ 렌터카 예약
- ✅ 투어 예약
- ✅ 예약 현황 조회 및 관리
- ✅ 마이페이지

## 기술 스택
- **Framework**: Next.js 15.3.5 (App Router)
- **Language**: TypeScript 5
- **Styling**: Tailwind CSS 3.4.17
- **Database**: Supabase PostgreSQL
- **Authentication**: Supabase Auth
- **UI Components**: React 19

## 사용자 권한
- **guest** (견적자): Supabase 인증만, 견적 조회/상세보기 가능
- **member** (예약자): 예약 생성 시 자동 등록, 예약 관리 권한

## 프로젝트 구조
```
sht-customer/
├── app/
│   ├── page.tsx              # 메인 페이지 (역할별 리다이렉트)
│   ├── login/                # 로그인
│   ├── signup/               # 회원가입
│   ├── mypage/               # 마이페이지
│   │   ├── quotes/          # 견적 목록/상세
│   │   ├── reservations/    # 예약 목록/상세
│   │   └── direct-booking/  # 직접 예약
│   ├── quote/                # 견적 관련
│   └── reservation/          # 예약 관련
├── components/               # 공용 컴포넌트
│   ├── PageWrapper.tsx      # 페이지 래퍼
│   ├── SectionBox.tsx       # 섹션 박스
│   ├── QuoteForm.tsx        # 견적 폼
│   └── ...
├── lib/                      # 유틸리티 및 비즈니스 로직
│   ├── supabase.ts          # Supabase 클라이언트
│   ├── getRoomPriceCode.ts  # 가격 코드 조회
│   └── ...
└── sql/                      # 데이터베이스 스키마 정보
    └── db.csv               # 테이블 구조 정의
```

## 환경 설정
1. `.env.local` 파일 생성
```bash
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

2. 의존성 설치
```bash
npm install
```

3. 개발 서버 실행
```bash
npm run dev
```

4. 브라우저에서 접속
```
http://localhost:3000
```

## 배포
- **Domain**: reservation.stayhalong.com
- **Platform**: Vercel / Railway
- **Port**: 3000 (기본)

## 데이터베이스
- **Provider**: Supabase PostgreSQL
- **Connection**: 관리자 시스템과 동일한 데이터베이스 사용
- **RLS Policy**: 
  - 견적 테이블: 인증된 모든 사용자 조회 가능
  - 예약 테이블: 소유자만 접근 가능

## 주요 개발 패턴
### 인증 흐름
```typescript
// 견적자 (Guest) - Supabase 인증만
const { data: { user } } = await supabase.auth.getUser();
// users 테이블 등록 없이 견적 조회 가능

// 예약자 (Member) - 예약 시점에 등록
const registerUserForReservation = async (authUser, additionalData) => {
  await supabase.from('users').insert({
    id: authUser.id,
    email: authUser.email,
    role: 'member',
    ...additionalData
  });
};
```

### 예약 저장 패턴 (크루즈 기반 통합 모델)
```typescript
// 1. 가격 옵션 로드
const { data: priceOptions } = await supabase
  .from('service_price')
  .select('*')
  .eq('service_code', serviceCode);

// 2. 메인 예약 생성
const { data: reservation } = await supabase
  .from('reservation')
  .insert({
    re_user_id: user.id,
    re_quote_id: quoteId,
    re_type: 'service_type',
    re_status: 'pending'
  });

// 3. 서비스별 상세 저장 (단일 행)
await supabase.from('reservation_service').insert({
  reservation_id: reservation.re_id,
  service_price_code: selectedService.code,
  request_note: additionalServices.join('\n')
});
```

## 스크립트
- `npm run dev` - 개발 서버 실행
- `npm run build` - 프로덕션 빌드
- `npm run start` - 프로덕션 서버 실행
- `npm run lint` - ESLint 검사
- `npm run lint:fix` - ESLint 자동 수정

## 성능 최적화
- **모듈 수**: ~400-600개 (관리자 시스템 분리 후)
- **로딩 시간**: 1-2초 (기존 3-8초에서 50-70% 개선)
- **번들 크기**: 고객 전용 코드만 포함

## 관련 프로젝트
- **관리자 시스템**: `sht-manager` (admin.stayhalong.com)
  - 견적 승인, 예약 관리, 결제 처리
  - 매니저/관리자/배차 담당자 전용

## 문의
- 개발팀: tech@stayhalong.com
- 버전: 1.0.0 (Customer Edition)
- 최종 업데이트: 2025.10.29
