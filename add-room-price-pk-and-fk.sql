-- ============================================================
-- room_price 테이블 PRIMARY KEY 추가 및 외래키 설정
-- ============================================================
-- 문제: room_price 테이블에 PRIMARY KEY가 없어서 
--       외래키 관계를 설정할 수 없음
-- 해결: room_code를 PRIMARY KEY로 설정 후 외래키 추가
-- ============================================================

-- STEP 1: room_price 테이블의 현재 제약 조건 확인
SELECT 
  conname AS constraint_name,
  contype AS constraint_type,
  pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'room_price'::regclass;

-- STEP 2: room_code에 중복 데이터가 있는지 확인
SELECT 
  room_code, 
  COUNT(*) as count
FROM room_price
WHERE room_code IS NOT NULL
GROUP BY room_code
HAVING COUNT(*) > 1
LIMIT 10;

-- STEP 3: NULL 값이 있는지 확인
SELECT COUNT(*) as null_count
FROM room_price
WHERE room_code IS NULL;

-- ============================================================
-- 해결 방법 선택
-- ============================================================
-- 🔴 만약 STEP 2에서 중복 데이터가 있다면:
--    - 중복 데이터를 수정해야 합니다 (id 추가 또는 복합키 사용)
--    - 아래 OPTION B를 사용하세요
--
-- 🟢 중복 데이터가 없다면:
--    - 아래 OPTION A를 사용하세요 (권장)
-- ============================================================

-- ============================================================
-- OPTION A: room_code를 PRIMARY KEY로 설정 (중복 없을 때)
-- ============================================================
DO $$ 
BEGIN
    -- 기존 PRIMARY KEY가 있다면 먼저 삭제
    IF EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conrelid = 'room_price'::regclass 
          AND contype = 'p'
    ) THEN
        EXECUTE (
            SELECT 'ALTER TABLE room_price DROP CONSTRAINT ' || conname
            FROM pg_constraint
            WHERE conrelid = 'room_price'::regclass 
              AND contype = 'p'
        );
        RAISE NOTICE 'Existing primary key dropped';
    END IF;
    
    -- room_code를 PRIMARY KEY로 설정
    ALTER TABLE room_price
    ADD CONSTRAINT room_price_pkey PRIMARY KEY (room_code);
    
    RAISE NOTICE '✅ PRIMARY KEY added successfully: room_price(room_code)';
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION '❌ Cannot add PRIMARY KEY: Duplicate values exist in room_code column. Please check STEP 2 results.';
    WHEN not_null_violation THEN
        RAISE EXCEPTION '❌ Cannot add PRIMARY KEY: NULL values exist in room_code column. Please check STEP 3 results.';
    WHEN OTHERS THEN
        RAISE EXCEPTION '❌ Error adding PRIMARY KEY: %', SQLERRM;
END $$;

-- ============================================================
-- OPTION B: 복합 PRIMARY KEY 설정 (중복 있을 때)
-- ============================================================
-- room_code에 중복이 있다면 다른 컬럼과 함께 복합키를 만들어야 합니다
-- 예: (room_code, schedule) 또는 (room_code, start_date, end_date)
/*
DO $$ 
BEGIN
    ALTER TABLE room_price
    ADD CONSTRAINT room_price_pkey PRIMARY KEY (room_code, schedule, start_date);
    
    RAISE NOTICE '✅ Composite PRIMARY KEY added: room_price(room_code, schedule, start_date)';
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION '❌ Error adding composite PRIMARY KEY: %', SQLERRM;
END $$;
*/

-- ============================================================
-- STEP 4: PRIMARY KEY 확인
-- ============================================================
SELECT 
  conname AS constraint_name,
  contype AS constraint_type,
  pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'room_price'::regclass
  AND contype = 'p';

-- ============================================================
-- STEP 5: 외래키 추가 (PRIMARY KEY 설정 후)
-- ============================================================
DO $$ 
BEGIN
    -- 기존 외래키가 있다면 삭제
    IF EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'reservation_cruise_room_price_code_fkey'
    ) THEN
        ALTER TABLE reservation_cruise 
        DROP CONSTRAINT reservation_cruise_room_price_code_fkey;
        RAISE NOTICE 'Existing foreign key dropped';
    END IF;
    
    -- 새로운 외래키 추가
    ALTER TABLE reservation_cruise
    ADD CONSTRAINT reservation_cruise_room_price_code_fkey
    FOREIGN KEY (room_price_code) 
    REFERENCES room_price(room_code)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
    
    RAISE NOTICE '✅ Foreign key constraint added successfully';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION '❌ Cannot add foreign key: Some room_price_code values in reservation_cruise do not exist in room_price.room_code';
    WHEN OTHERS THEN
        RAISE EXCEPTION '❌ Error adding foreign key: %', SQLERRM;
END $$;

-- ============================================================
-- STEP 6: 외래키 확인
-- ============================================================
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.update_rule,
    rc.delete_rule
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints AS rc
    ON tc.constraint_name = rc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'reservation_cruise'
  AND kcu.column_name = 'room_price_code';

-- ============================================================
-- STEP 7: 성능 인덱스 추가
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_reservation_cruise_room_price_code 
ON reservation_cruise(room_price_code)
WHERE room_price_code IS NOT NULL;

-- ============================================================
-- STEP 8: PostgREST 스키마 캐시 새로고침
-- ============================================================
NOTIFY pgrst, 'reload schema';

-- ============================================================
-- 완료 메시지
-- ============================================================
DO $$
BEGIN
    RAISE NOTICE '
    ✅ 마이그레이션 완료!
    
    📋 실행 결과:
    1. room_price 테이블에 PRIMARY KEY 추가
    2. reservation_cruise → room_price 외래키 관계 설정
    3. 성능 인덱스 추가
    4. PostgREST 스키마 캐시 새로고침
    
    🔄 다음 단계:
    - 브라우저를 새로고침하여 변경사항 확인
    - 크루즈 예약 상세 페이지에서 데이터 표시 확인
    ';
END $$;

COMMIT;
