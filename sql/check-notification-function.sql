-- create_reservation_notification 함수 정의 확인
SELECT 
    p.proname as function_name,
    pg_get_functiondef(p.oid) as function_definition
FROM pg_proc p
WHERE p.proname = 'create_reservation_notification';
