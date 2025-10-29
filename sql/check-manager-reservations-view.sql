-- manager_reservations 뷰 정의 확인
SELECT pg_get_viewdef('manager_reservations', true);

-- 뷰가 참조하는 컬럼 확인
SELECT 
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'manager_reservations'
ORDER BY ordinal_position;
