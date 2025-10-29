-- 통합 고객 요청사항 시스템 구축 스크립트
-- 2025.08.21 - 기존 알림 시스템 활용 (중복 방지)

-- 1. 먼저 알림 시스템 구축 (notifications 테이블)
\i sql/create-notifications-tables.sql

-- 2. 고객 요청사항 시스템 구축 (간단 버전)
\i sql/create-customer-requests-simple.sql

-- 3. 추가 알림 템플릿 및 연동
\i sql/integrate-customer-requests-notifications.sql

-- 완료 메시지
SELECT 'Integrated customer request system setup completed successfully!' as result;
