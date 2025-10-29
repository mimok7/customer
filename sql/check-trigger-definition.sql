-- trg_reservation_creation_notification 트리거 정의 확인
SELECT 
    pg_get_triggerdef(63457) as trigger_definition;

-- 트리거가 실행하는 함수 확인
SELECT 
    p.proname as function_name,
    pg_get_functiondef(p.oid) as function_definition
FROM pg_proc p
WHERE p.oid = 63454;

-- 임시 해결책: 트리거 비활성화
-- ALTER TABLE reservation DISABLE TRIGGER trg_reservation_creation_notification;

-- 또는 트리거 삭제 (백업 후)
-- DROP TRIGGER IF EXISTS trg_reservation_creation_notification ON reservation;
