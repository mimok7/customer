-- reservation 테이블 외래 키 제약 조건 확인
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.match_option,
    rc.update_rule,
    rc.delete_rule,
    pg_get_constraintdef(pgc.oid) as constraint_definition
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints AS rc
    ON rc.constraint_name = tc.constraint_name
JOIN pg_constraint AS pgc
    ON pgc.conname = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_name = 'reservation'
AND kcu.column_name = 're_user_id';

-- 실패한 사용자 한 명의 상태 확인
SELECT id, email, name, status, role
FROM users
WHERE id = 'bab42fdc-a57a-4391-85f7-0e6831ab03ec';

-- 성공한 사용자 샘플 확인 (비교용)
SELECT id, email, name, status, role
FROM users
WHERE status = 'active'
LIMIT 5;
