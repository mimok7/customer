-- 트리거 비활성화 (이관 작업을 위해)
ALTER TABLE reservation DISABLE TRIGGER trg_reservation_creation_notification;

-- 확인
SELECT 
    tgname,
    tgenabled
FROM pg_trigger
WHERE tgname = 'trg_reservation_creation_notification';
-- tgenabled = 'O' (활성), 'D' (비활성)
