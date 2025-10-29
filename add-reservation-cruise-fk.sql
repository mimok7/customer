-- Add foreign key relationship between reservation_cruise and room_price
-- 2025.01.08 - Fix schema relationship for reservation_cruise.room_price_code

-- 1. 먼저 기존 데이터의 무결성 확인
SELECT 
    rc.reservation_id,
    rc.room_price_code,
    rp.room_code
FROM reservation_cruise rc
LEFT JOIN room_price rp ON rc.room_price_code = rp.room_code
WHERE rc.room_price_code IS NOT NULL 
  AND rp.room_code IS NULL
LIMIT 10;

-- 2. 외래키 제약조건 추가 (기존 제약조건이 있으면 먼저 삭제)
DO $$ 
BEGIN
    -- 기존 외래키가 있다면 삭제
    IF EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'reservation_cruise_room_price_code_fkey'
    ) THEN
        ALTER TABLE reservation_cruise 
        DROP CONSTRAINT reservation_cruise_room_price_code_fkey;
    END IF;
    
    -- 새로운 외래키 추가
    ALTER TABLE reservation_cruise
    ADD CONSTRAINT reservation_cruise_room_price_code_fkey
    FOREIGN KEY (room_price_code) 
    REFERENCES room_price(room_code)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
    
    RAISE NOTICE 'Foreign key constraint added successfully';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Cannot add foreign key: Some room_price_code values do not exist in room_price table';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding foreign key: %', SQLERRM;
END $$;

-- 3. 제약조건 확인
SELECT
    conname AS constraint_name,
    contype AS constraint_type,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint
WHERE conrelid = 'reservation_cruise'::regclass
  AND conname LIKE '%room_price%';

-- 4. 외래키 관계 확인
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.constraint_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'reservation_cruise'
  AND kcu.column_name = 'room_price_code';

-- 5. 인덱스 추가 (외래키 성능 향상)
CREATE INDEX IF NOT EXISTS idx_reservation_cruise_room_price_code 
ON reservation_cruise(room_price_code)
WHERE room_price_code IS NOT NULL;

-- 6. 스키마 캐시 새로고침 (PostgREST용)
NOTIFY pgrst, 'reload schema';

COMMIT;
