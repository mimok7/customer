-- reservation 테이블 관련 트리거 조회
SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'reservation';

-- reservation 테이블 RLS 정책 조회
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'reservation';

-- reservation 테이블 실제 컬럼 조회
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'reservation'
ORDER BY ordinal_position;
