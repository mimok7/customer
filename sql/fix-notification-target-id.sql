-- 견적/예약/요청사항 관리 및 알림 오류 해결 통합 SQL
-- 1. 예약/견적/요청사항 테이블은 기존 구조 유지
-- 2. notifications 테이블 target_id 컬럼을 text로 변경
-- 3. 알림 트리거에서 target_id ::text로 저장

-- notifications 테이블 target_id 컬럼 타입 변경
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'notifications' AND column_name = 'target_id' AND data_type = 'uuid'
  ) THEN
    ALTER TABLE notifications ALTER COLUMN target_id TYPE text USING target_id::text;
  END IF;
END $$;

-- 알림 트리거 함수 예시 (이미 적용되어 있으면 생략)
CREATE OR REPLACE FUNCTION fn_create_customer_request_notification()
RETURNS TRIGGER AS $$
DECLARE
  current_user_id text;
BEGIN
  current_user_id := auth.uid()::text;
  IF TG_OP = 'INSERT' THEN
    INSERT INTO notifications (
      type, category, title, message, priority, status, target_table, target_id, metadata, created_at
    ) VALUES (
      'customer',
      CASE NEW.request_type
        WHEN 'quote_modification' THEN '견적수정요청'
        WHEN 'reservation_modification' THEN '예약변경요청'
        WHEN 'service_inquiry' THEN '서비스문의'
        WHEN 'complaint' THEN '불만접수'
        WHEN 'cancellation' THEN '취소요청'
        WHEN 'additional_service' THEN '추가서비스요청'
        ELSE '기타요청'
      END,
      '새로운 고객 요청: ' || COALESCE(NEW.title,'제목없음'),
      '요청 유형: ' || COALESCE(NEW.request_category,'미분류') || E'\n' ||
      '고객 ID: ' || COALESCE(NEW.user_id,'알수없음') || E'\n' ||
      '요청 내용: ' || LEFT(COALESCE(NEW.description,'내용없음'), 100) || CASE WHEN LENGTH(COALESCE(NEW.description,'')) > 100 THEN '...' ELSE '' END,
      CASE COALESCE(NEW.urgency_level,'normal') WHEN 'urgent' THEN 'urgent' WHEN 'high' THEN 'high' ELSE 'normal' END,
      'unread',
      'customer_requests',
      NEW.id::text,
      jsonb_build_object(
        'request_type', COALESCE(NEW.request_type,''),
        'customer_id', COALESCE(NEW.user_id,''),
        'related_quote_id', COALESCE(NEW.related_quote_id,''),
        'related_reservation_id', COALESCE(NEW.related_reservation_id,''),
        'urgency_level', COALESCE(NEW.urgency_level,'normal')
      ),
      now()
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 트리거 생성 예시 (이미 있으면 생략)
DROP TRIGGER IF EXISTS trg_customer_request_notification ON customer_requests;
CREATE TRIGGER trg_customer_request_notification
AFTER INSERT ON customer_requests
FOR EACH ROW EXECUTE FUNCTION fn_create_customer_request_notification();

-- 모든 변경사항은 한 번에 실행 가능
-- 오류 발생 시 롤백 또는 개별 적용 가능
