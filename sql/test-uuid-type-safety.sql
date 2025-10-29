-- UUID 타입 불일치 문제 해결 확인
-- 2025.08.21

-- 테스트 쿼리: 타입 캐스팅 문제 확인
SELECT 
    'UUID 타입 테스트' as test_type,
    auth.uid()::uuid as current_user_uuid,
    auth.uid()::text as current_user_text;

-- notifications 테이블의 target_id가 TEXT 타입인지 확인
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'notifications' 
AND column_name = 'target_id';

-- customer_requests 테이블이 존재하는지 확인
SELECT 
    table_name,
    CASE WHEN table_name IS NOT NULL THEN '존재함' ELSE '없음' END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'customer_requests';
