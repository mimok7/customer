-- 📋 매니저 정보 저장 컬럼 추가
-- notifications 테이블에 처리 매니저 이름 추가

-- 1. notifications 테이블에 매니저 이름 컬럼 추가
ALTER TABLE notifications 
ADD COLUMN IF NOT EXISTS processed_by_name character varying(100);

-- 2. notifications 테이블 주석 업데이트
COMMENT ON COLUMN notifications.processed_by_name IS '처리한 매니저 이름';

-- 3. customer_notifications 테이블에 해결 정보 컬럼 추가 (이미 있는지 확인)
ALTER TABLE customer_notifications 
ADD COLUMN IF NOT EXISTS resolution_notes text;

COMMENT ON COLUMN customer_notifications.resolution_notes IS '해결 메모';

-- 4. 확인 쿼리
SELECT 
    '✅ notifications 테이블에 processed_by_name 컬럼이 추가되었습니다!' as message
UNION ALL
SELECT 
    '✅ customer_notifications 테이블에 resolution_notes 컬럼이 추가되었습니다!' as message;
