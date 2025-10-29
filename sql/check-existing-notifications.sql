-- 기존 notifications 테이블 데이터 확인
SELECT 
    category,
    COUNT(*) as count
FROM notifications 
WHERE category IS NOT NULL
GROUP BY category
ORDER BY count DESC;

-- 모든 고유 카테고리 조회
SELECT DISTINCT category 
FROM notifications 
WHERE category IS NOT NULL
ORDER BY category;

-- subcategory 컬럼 존재 여부 확인
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'notifications' 
AND table_schema = 'public'
ORDER BY ordinal_position;
