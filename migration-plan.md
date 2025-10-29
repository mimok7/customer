# 구글시트 → Supabase 데이터 이관 마스터 플랜

## 📊 현재 상황 분석 (2025.10.14)

### ✅ 완료된 작업
- [x] **SH_M → users 테이블**: 2,144명 사용자 이관 완료
- [x] **추가 컬럼 업데이트**: phone_number, english_name, nickname, kakao_id, birth_date, reservation_date
- [x] **Supabase Auth 계정 생성**: 모든 사용자 계정 생성 완료 (비밀번호: qwe123!)
- [x] **데이터 구조 파악**: SH_R 시트 2,932개 예약 데이터 확인

### ⚠️ 발견된 문제
1. **주문ID 저장 문제**: users 테이블에 order_id 컬럼 없음
2. **객실코드 부재**: SH_R에 객실코드 컬럼이 없음 (자동 매칭 필요)
3. **데이터 정합성**: 크루즈명, 객실종류가 표준화되지 않음
4. **날짜 형식**: 여러 형식 혼재 ("2025. 9. 22", "2025-07-30")

### 📋 미완료 작업
- [ ] SH_R → reservation + reservation_cruise 이관 (2,932건)
- [ ] 객실코드 자동 매칭 및 검증
- [ ] 주문ID 기반 사용자 매칭
- [ ] 데이터 정합성 검증

---

## 🎯 최적 작업 순서 제안

### **Phase 1: 기초 데이터 준비** (예상 시간: 30분)

#### Step 1-1: 매칭 테이블 준비
**목적**: SH_R 데이터와 Supabase 테이블 간 매핑 기준 정립

```bash
# 작업 내용:
1. 크루즈명 매핑 테이블 생성 (SH_R → room_price.cruise)
2. 객실종류 매핑 테이블 생성 (SH_R → room_price.room_type)
3. 날짜 형식 통일 로직 구현

# 산출물:
- scripts/mapping-cruise-names.json
- scripts/mapping-room-types.json
- scripts/utils/date-parser.js
```

**체크포인트**: ✅ 매핑 테이블 생성 완료

---

#### Step 1-2: room_price 매칭 로직 개발
**목적**: SH_R 데이터로 자동으로 room_code 찾기

```bash
# 작업 내용:
1. 크루즈명 + 객실종류 + 날짜 기반 room_code 조회 함수
2. 매칭 실패 케이스 로깅
3. 매칭률 통계 산출

# 산출물:
- lib/matchRoomCode.js
- scripts/test-room-matching.js (테스트 스크립트)
```

**체크포인트**: ✅ 매칭 테스트 결과 95% 이상

---

#### Step 1-3: 주문ID-사용자 매핑 테이블 생성
**목적**: 주문ID로 users.id 찾기 위한 임시 매핑

```bash
# 작업 내용:
1. SH_M 주문ID + Email/이름/전화번호 읽기
2. Supabase users 테이블에서 매칭하여 users.id 찾기
3. 메모리 맵 또는 임시 테이블 생성

# 산출물:
- scripts/build-order-user-map.js
- order_user_mapping.json (임시 파일)
```

**체크포인트**: ✅ 2,147개 주문ID → users.id 매핑 완료

---

### **Phase 2: 데이터 검증 및 테스트** (예상 시간: 1시간)

#### Step 2-1: 소규모 테스트 이관 (10건)
**목적**: 전체 이관 전 프로세스 검증

```bash
# 작업 내용:
1. SH_R 첫 10개 데이터 선택
2. 주문ID → users.id 매칭
3. room_code 자동 매칭
4. reservation + reservation_cruise 저장
5. 저장된 데이터 검증

# 산출물:
- scripts/test-migration-10-records.js
- migration-test-report.json
```

**체크포인트**: ✅ 10건 중 9건 이상 성공

---

#### Step 2-2: 매칭 실패 케이스 분석
**목적**: 예외 케이스 처리 로직 보완

```bash
# 작업 내용:
1. 주문ID 매칭 실패 분석 (사용자 없음)
2. room_code 매칭 실패 분석 (가격 테이블 부재)
3. 날짜 파싱 실패 분석
4. 예외 처리 로직 추가

# 산출물:
- scripts/analyze-matching-failures.js
- matching-failures-report.json
```

**체크포인트**: ✅ 예외 케이스 처리 로직 완료

---

#### Step 2-3: 중규모 테스트 이관 (100건)
**목적**: 스케일업 전 안정성 검증

```bash
# 작업 내용:
1. SH_R 100개 데이터 이관
2. 성공률 및 소요 시간 측정
3. 데이터 정합성 검증 (금액, 인원수 등)
4. 롤백 테스트 (필요시)

# 산출물:
- scripts/test-migration-100-records.js
- migration-100-report.json
```

**체크포인트**: ✅ 100건 중 95건 이상 성공, 성능 문제 없음

---

### **Phase 3: 전체 데이터 이관** (예상 시간: 2시간)

#### Step 3-1: 배치 이관 스크립트 실행
**목적**: 전체 2,932건 데이터 이관

```bash
# 작업 내용:
1. 배치 단위 이관 (100건씩)
2. 진행률 실시간 표시
3. 실패 케이스 로깅
4. 재시도 로직 (최대 3회)

# 산출물:
- scripts/migrate-all-sh-r-to-reservations.js
- migration-full-report.json
- migration-failures.json
```

**실행 방법**:
```bash
node scripts/migrate-all-sh-r-to-reservations.js
```

**체크포인트**: ✅ 2,700건 이상 성공 (92% 이상)

---

#### Step 3-2: 실패 케이스 수동 처리
**목적**: 자동 이관 실패 건 수동 처리

```bash
# 작업 내용:
1. 실패 케이스 분류 (사용자 미등록, room_code 없음 등)
2. 수동 매칭 또는 데이터 수정
3. 재이관 실행

# 산출물:
- scripts/manual-fix-failed-migrations.js
- manual-fixes.json
```

**체크포인트**: ✅ 실패 건 95% 이상 해결

---

#### Step 3-3: 데이터 정합성 검증
**목적**: 이관된 데이터 완전성 검증

```bash
# 작업 내용:
1. SH_R 총 예약 수 vs Supabase reservation 수 비교
2. 금액 합계 검증
3. 중복 데이터 확인
4. 필수 필드 누락 검증 (user_id, room_price_code 등)

# 산출물:
- scripts/verify-migration-integrity.js
- integrity-check-report.json
```

**체크포인트**: ✅ 데이터 정합성 99% 이상

---

### **Phase 4: 후처리 및 정리** (예상 시간: 30분)

#### Step 4-1: 인덱스 및 제약조건 확인
**목적**: 데이터베이스 성능 및 무결성 보장

```sql
-- 실행 내용:
1. reservation 테이블 인덱스 확인
2. 외래키 제약조건 검증
3. RLS 정책 적용 확인

-- 산출물:
- sql/verify-indexes.sql
```

**체크포인트**: ✅ 인덱스 및 제약조건 정상

---

#### Step 4-2: 최종 리포트 생성
**목적**: 이관 작업 완료 보고서

```bash
# 작업 내용:
1. 전체 이관 통계 (성공/실패/수동처리)
2. 데이터 정합성 검증 결과
3. 성능 메트릭 (처리 시간, 속도)
4. 알려진 이슈 및 제약사항

# 산출물:
- MIGRATION_FINAL_REPORT.md
```

**체크포인트**: ✅ 최종 리포트 작성 완료

---

#### Step 4-3: 백업 및 문서화
**목적**: 이관 작업 기록 보존

```bash
# 작업 내용:
1. 이관 전/후 데이터 스냅샷 비교
2. 스크립트 및 매핑 파일 아카이브
3. 문제 해결 가이드 작성

# 산출물:
- backups/sh-r-original.json
- backups/reservations-snapshot.json
- docs/MIGRATION_TROUBLESHOOTING.md
```

**체크포인트**: ✅ 백업 및 문서화 완료

---

## 🚨 위험 요소 및 대응 방안

### 위험 1: room_code 매칭 실패율 높음
**대응**: 
- 매핑 테이블 사전 검증
- 매칭 실패시 수동 매핑 테이블 사용
- 최악의 경우 NULL 허용 후 나중에 업데이트

### 위험 2: 사용자 매칭 실패 (주문ID → users.id)
**대응**:
- 이름+전화번호 조합으로 2차 매칭
- 매칭 실패시 스킵하고 로그 기록
- 수동으로 users 테이블에 추가 후 재이관

### 위험 3: 중복 예약 생성
**대응**:
- 이관 전 기존 reservation 체크
- 주문ID 기반 중복 방지 로직
- 트랜잭션 처리로 원자성 보장

### 위험 4: 데이터 타입 불일치
**대응**:
- 날짜: 여러 형식 대응 파서 구현
- 숫자: 문자열 → 숫자 변환 검증
- NULL 처리: 기본값 설정

---

## 📊 예상 소요 시간 및 리소스

| Phase | 작업 단계 | 예상 시간 | 담당 |
|-------|----------|----------|------|
| Phase 1 | 기초 데이터 준비 | 30분 | AI Agent |
| Phase 2 | 데이터 검증 및 테스트 | 1시간 | AI Agent + 사용자 검토 |
| Phase 3 | 전체 데이터 이관 | 2시간 | AI Agent |
| Phase 4 | 후처리 및 정리 | 30분 | AI Agent + 사용자 검토 |
| **총계** | | **4시간** | |

---

## ✅ 작업 시작 전 체크리스트

- [ ] Supabase 데이터베이스 백업 완료
- [ ] 테스트 환경 준비 (개발/스테이징)
- [ ] room_price 테이블 데이터 확인
- [ ] users 테이블 2,144명 정상 확인
- [ ] Google Sheets API 접근 권한 확인
- [ ] 작업 시간대 선정 (서비스 영향 최소화)

---

## 🎯 다음 즉시 실행할 작업

### 추천: Phase 1-1부터 시작
```bash
# 1. 크루즈명 매핑 분석
node scripts/analyze-cruise-name-mapping.js

# 2. 객실종류 매핑 분석
node scripts/analyze-room-type-mapping.js

# 3. room_code 매칭 테스트
node scripts/test-room-matching.js
```

---

## 📞 의사결정 필요 사항

1. **room_code 매칭 실패시 처리 방침**
   - A) NULL로 저장 후 나중에 업데이트
   - B) 수동 매핑 테이블 사용
   - C) 해당 예약 스킵

2. **주문ID 저장 여부**
   - A) users 테이블에 order_id 컬럼 추가
   - B) 별도 매핑 테이블 생성
   - C) 이관 작업에만 사용 후 폐기 (현재 방침)

3. **데이터 검증 기준**
   - 최소 성공률: ___% 이상
   - 수동 처리 허용 범위: ___건 이하

---

이 플랜을 검토하시고 진행 여부를 알려주세요!
시작하실 준비가 되셨다면 **Phase 1-1**부터 바로 시작하겠습니다.
