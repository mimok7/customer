-- Sync payment_notifications -> notifications
-- Function and triggers to keep payment-related alerts visible in the main notifications table

BEGIN;

-- 1) Insert sync function: when a payment_notifications row is inserted, create a corresponding notifications row
CREATE OR REPLACE FUNCTION public.sync_payment_notification_on_insert()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists INTEGER;
    v_title TEXT;
    v_priority TEXT := COALESCE(NEW.priority, 'normal');
BEGIN
    -- Avoid duplicates by checking metadata.payment_notification_id
    SELECT 1 INTO v_exists
    FROM notifications
    WHERE (metadata->>'payment_notification_id') = NEW.id::text
    LIMIT 1;

    IF v_exists IS NOT NULL THEN
      RETURN NEW;
    END IF;

    -- Map notification_type to a human title
    v_title := CASE NEW.notification_type
      WHEN 'payment_due' THEN '결제 예정 알림'
      WHEN 'payment_overdue' THEN '결제 연체 알림'
      WHEN 'checkin_reminder' THEN '체크인 알림'
      ELSE NEW.notification_type
    END;

    INSERT INTO notifications(
      type, category, title, message, priority, status,
      target_table, target_id, metadata, created_at, updated_at
    ) VALUES (
      'business', -- type
      '결제', -- category
      v_title,
      COALESCE(NEW.message_content, NEW.message, ''),
      v_priority,
      CASE WHEN NEW.is_sent THEN 'read' ELSE 'unread' END,
      'reservation', -- target_table
      NEW.reservation_id::text,
      jsonb_build_object(
        'payment_notification_id', NEW.id::text,
        'reservation_id', COALESCE(NEW.reservation_id::text, ''),
        'notification_date', COALESCE(NEW.notification_date::text, '')
      ),
      COALESCE(NEW.created_at, now()),
      COALESCE(NEW.sent_at, NEW.created_at, now())
    );

    RETURN NEW;
END;
$$;

-- 2) Update sync function: when payment_notifications marked as sent/updated, update notifications status
CREATE OR REPLACE FUNCTION public.sync_payment_notification_on_update()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  -- If is_sent changed to true, mark corresponding notification as read
  IF NEW.is_sent IS DISTINCT FROM OLD.is_sent THEN
    IF NEW.is_sent = TRUE THEN
      UPDATE notifications
      SET status = 'read', updated_at = COALESCE(NEW.sent_at, now())
      WHERE (metadata->>'payment_notification_id') = NEW.id::text;
    ELSE
      -- if is_sent toggled back to false, mark as unread
      UPDATE notifications
      SET status = 'unread', updated_at = now()
      WHERE (metadata->>'payment_notification_id') = NEW.id::text;
    END IF;
  END IF;

  -- If message_content changed, sync message
  IF NEW.message_content IS DISTINCT FROM OLD.message_content THEN
    UPDATE notifications
    SET message = COALESCE(NEW.message_content, NEW.message), updated_at = now()
    WHERE (metadata->>'payment_notification_id') = NEW.id::text;
  END IF;

  RETURN NEW;
END;
$$;

-- 3) Triggers
DROP TRIGGER IF EXISTS trg_sync_payment_notifications_insert ON public.payment_notifications;
CREATE TRIGGER trg_sync_payment_notifications_insert
AFTER INSERT ON public.payment_notifications
FOR EACH ROW
EXECUTE FUNCTION public.sync_payment_notification_on_insert();

DROP TRIGGER IF EXISTS trg_sync_payment_notifications_update ON public.payment_notifications;
CREATE TRIGGER trg_sync_payment_notifications_update
AFTER UPDATE ON public.payment_notifications
FOR EACH ROW
WHEN (OLD.* IS DISTINCT FROM NEW.*)
EXECUTE FUNCTION public.sync_payment_notification_on_update();

COMMIT;

-- Usage:
-- Apply this migration in your database (psql / Supabase SQL editor).
-- After applying, new rows inserted into payment_notifications will produce entries under notifications.
