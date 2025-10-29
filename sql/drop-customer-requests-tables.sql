-- 고객 요청사항 시스템 테이블 삭제 (재생성 전 정리용)
-- 2025.08.21

-- 기존 테이블 삭제 (연관된 트리거, 함수도 함께 삭제)
DROP TABLE IF EXISTS customer_requests CASCADE;
DROP TABLE IF EXISTS customer_request_attachments CASCADE;
DROP TABLE IF EXISTS customer_request_history CASCADE;

-- 관련 함수 삭제
DROP FUNCTION IF EXISTS create_notification_for_customer_request() CASCADE;
DROP FUNCTION IF EXISTS update_customer_request_status(UUID, VARCHAR, TEXT, UUID) CASCADE;
DROP FUNCTION IF EXISTS validate_customer_request_data() CASCADE;

-- 정리 완료 메시지
SELECT 'Customer requests tables and functions dropped successfully' as result;
