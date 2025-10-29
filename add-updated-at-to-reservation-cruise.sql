-- reservation_cruise 테이블에 updated_at 컬럼 추가
-- 이미 존재하면 무시하도록 IF NOT EXISTS 사용

DO $$ 
BEGIN
    -- updated_at 컬럼이 없으면 추가
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'reservation_cruise' 
        AND column_name = 'updated_at'
    ) THEN
        ALTER TABLE reservation_cruise 
        ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
        
        -- 기존 데이터의 updated_at을 created_at으로 초기화
        UPDATE reservation_cruise 
        SET updated_at = created_at 
        WHERE updated_at IS NULL;
        
        RAISE NOTICE 'updated_at 컬럼이 reservation_cruise 테이블에 추가되었습니다.';
    ELSE
        RAISE NOTICE 'updated_at 컬럼이 이미 존재합니다.';
    END IF;
END $$;

-- 자동으로 updated_at을 갱신하는 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 기존 트리거가 있으면 삭제
DROP TRIGGER IF EXISTS update_reservation_cruise_updated_at ON reservation_cruise;

-- 트리거 생성: UPDATE 시 자동으로 updated_at 갱신
CREATE TRIGGER update_reservation_cruise_updated_at
    BEFORE UPDATE ON reservation_cruise
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 확인 쿼리
SELECT 
    column_name, 
    data_type, 
    column_default
FROM information_schema.columns
WHERE table_name = 'reservation_cruise'
AND column_name IN ('created_at', 'updated_at')
ORDER BY ordinal_position;
