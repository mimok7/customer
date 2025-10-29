-- 2025.08.21 고객 요청사항 시스템 통합 테스트
-- 기존 알림 시스템 + 고객 요청사항 연동 확인

-- 1. notifications 테이블이 있는지 확인
SELECT 
    'notifications' as table_name,
    COUNT(*) as record_count
FROM notifications
WHERE 1=1
UNION ALL
-- 2. customer_requests 테이블이 있는지 확인  
SELECT 
    'customer_requests' as table_name,
    COUNT(*) as record_count
FROM customer_requests
WHERE 1=1;
