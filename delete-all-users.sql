-- ════════════════════════════════════════════════════════════════
-- 모든 사용자 완전 삭제 SQL
-- Supabase SQL Editor에서 실행
-- 외래 키 제약 조건을 고려하여 순서대로 삭제
-- ════════════════════════════════════════════════════════════════

-- 실행 전 확인
SELECT 
    '현재 Auth 사용자 수' as 항목,
    COUNT(*) as 개수
FROM auth.users
UNION ALL
SELECT 
    '현재 users 테이블 사용자 수' as 항목,
    COUNT(*) as 개수
FROM users;

-- ════════════════════════════════════════════════════════════════
-- 1단계: users 테이블을 참조하는 모든 데이터 삭제
-- ════════════════════════════════════════════════════════════════

-- 알림 관련 테이블 삭제
DELETE FROM notification_reads WHERE user_id IS NOT NULL;
DELETE FROM notifications WHERE created_by IS NOT NULL;
DELETE FROM business_notifications;

-- 고객 요청 삭제
DELETE FROM customer_requests WHERE user_id IS NOT NULL;

-- 예약 결제 관련 테이블 삭제
DELETE FROM reservation_payment WHERE user_id IS NOT NULL;
DELETE FROM reservation_payments WHERE created_by IS NOT NULL;

-- 예약 관련 테이블 삭제 (reservation.re_user_id → users.id)
DELETE FROM reservation_airport WHERE reservation_id IN (
    SELECT re_id FROM reservation WHERE re_user_id IS NOT NULL
);

DELETE FROM reservation_cruise WHERE reservation_id IN (
    SELECT re_id FROM reservation WHERE re_user_id IS NOT NULL
);

DELETE FROM reservation_hotel WHERE reservation_id IN (
    SELECT re_id FROM reservation WHERE re_user_id IS NOT NULL
);

DELETE FROM reservation_rentcar WHERE reservation_id IN (
    SELECT re_id FROM reservation WHERE re_user_id IS NOT NULL
);

DELETE FROM reservation_tour WHERE reservation_id IN (
    SELECT re_id FROM reservation WHERE re_user_id IS NOT NULL
);

DELETE FROM reservation_car_sht WHERE reservation_id IN (
    SELECT re_id FROM reservation WHERE re_user_id IS NOT NULL
);

-- 확인 상태 테이블 삭제
DELETE FROM confirmation_status;

-- 메인 예약 테이블 삭제
DELETE FROM reservation WHERE re_user_id IS NOT NULL;

-- 견적 관련 데이터 삭제 (quote.user_id → users.id)
-- 먼저 quote_item 삭제 (외래 키: quote_id)
DELETE FROM quote_item WHERE quote_id IN (
    SELECT id FROM quote WHERE user_id IS NOT NULL
);

-- 견적 테이블 삭제
DELETE FROM quote WHERE user_id IS NOT NULL;

-- ════════════════════════════════════════════════════════════════
-- 2단계: users 테이블 완전 삭제
-- ════════════════════════════════════════════════════════════════

DELETE FROM users;

-- ════════════════════════════════════════════════════════════════
-- 3단계: Auth 사용자 삭제 (Supabase 함수 사용)
-- ════════════════════════════════════════════════════════════════

-- Auth 사용자는 Supabase Dashboard나 스크립트로 삭제해야 합니다.
-- SQL에서는 auth.users 테이블에 직접 접근할 수 없습니다.

-- ════════════════════════════════════════════════════════════════
-- 삭제 후 확인
-- ════════════════════════════════════════════════════════════════

SELECT 
    '삭제 후 users 테이블 사용자 수' as 항목,
    COUNT(*) as 개수
FROM users
UNION ALL
SELECT 
    '삭제 후 reservation 수' as 항목,
    COUNT(*) as 개수
FROM reservation
UNION ALL
SELECT 
    '삭제 후 quote 수' as 항목,
    COUNT(*) as 개수
FROM quote;

-- ════════════════════════════════════════════════════════════════
-- 완료 메시지
-- ════════════════════════════════════════════════════════════════
-- 
-- ✅ users 테이블과 관련 데이터가 모두 삭제되었습니다.
-- 
-- 다음 단계:
-- 1. Auth 사용자 삭제는 아래 스크립트를 실행하세요:
--    node scripts/delete-auth-users-only.js
-- 
-- 2. 또는 Supabase Dashboard에서:
--    Authentication → Users → 전체 선택 → Delete
-- 
-- ════════════════════════════════════════════════════════════════
