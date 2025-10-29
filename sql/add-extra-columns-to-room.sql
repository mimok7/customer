-- 객실 선택에서 엑스트라, 엑스트라 성인, 엑스트라 아동으로 구분하기 위한 컬럼 추가
ALTER TABLE room ADD COLUMN IF NOT EXISTS extra_adult_count INTEGER DEFAULT 0;
ALTER TABLE room ADD COLUMN IF NOT EXISTS extra_child_count INTEGER DEFAULT 0;

-- 기존 extra_count는 일반 엑스트라로 유지
-- adult_count, child_count는 더 이상 사용하지 않음 (기존 데이터 호환성 유지)
