-- phone 컬럼이 어디에 있는지 정확히 확인
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE column_name = 'phone'
AND table_schema = 'public';

-- create_reservation_notification 함수가 어떤 테이블을 참조하는지 확인
SELECT 
    pg_get_functiondef(oid) as function_definition
FROM pg_proc
WHERE proname = 'create_reservation_notification';
