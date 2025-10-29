-- 알림 시스템 완전 개선 SQL
-- 1. notifications 테이블 target_id를 text로 변경
-- 2. customer_notifications 테이블 연동 보장
-- 3. 한국어화된 알림 처리 함수들 생성
-- 4. 실시간 알림 시스템 지원

-- 1. notifications 테이블 target_id 컬럼 타입 변경
DO $$
BEGIN
  -- notifications 테이블이 존재하고 target_id가 uuid라면 text로 변경
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'notifications' AND column_name = 'target_id' AND data_type = 'uuid'
  ) THEN
    ALTER TABLE notifications ALTER COLUMN target_id TYPE text USING target_id::text;
    RAISE NOTICE '✅ notifications.target_id 컬럼을 text로 변경했습니다.';
  END IF;
END $$;

-- 2. customer_notifications 테이블이 없다면 생성
CREATE TABLE IF NOT EXISTS customer_notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type text DEFAULT 'customer',
  category text NOT NULL,
  title text NOT NULL,
  message text NOT NULL,
  priority text DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent')),
  status text DEFAULT 'unread' CHECK (status IN ('unread','read','processing','completed','dismissed')),
  target_id text,
  target_table text,
  assigned_to text,
  due_date timestamptz,
  metadata jsonb DEFAULT '{}',
  
  -- 고객별 상세 정보
  customer_id text,
  customer_name text,
  customer_phone text,
  customer_email text,
  inquiry_type text,
  service_type text,
  response_deadline timestamptz,
  customer_satisfaction integer CHECK (customer_satisfaction BETWEEN 1 AND 5),
  follow_up_required boolean DEFAULT false,
  resolution_notes text,
  
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  processed_at timestamptz
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_customer_notifications_status ON customer_notifications(status);
CREATE INDEX IF NOT EXISTS idx_customer_notifications_priority ON customer_notifications(priority);
CREATE INDEX IF NOT EXISTS idx_customer_notifications_customer_id ON customer_notifications(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_notifications_created_at ON customer_notifications(created_at);

-- 3. 한국어화된 알림 생성 함수
CREATE OR REPLACE FUNCTION create_korean_notification(
  notification_type text,
  target_table text,
  target_id text,
  metadata jsonb DEFAULT '{}'
) RETURNS uuid AS $$
DECLARE
  notification_id uuid;
  korean_title text;
  korean_message text;
  korean_category text;
  notification_priority text DEFAULT 'normal';
BEGIN
  -- 타입별 한국어 메시지 생성
  CASE notification_type
    WHEN 'quote_submitted' THEN
      korean_category := '견적요청';
      korean_title := '새로운 견적 요청이 접수되었습니다';
      korean_message := '고객이 새로운 견적을 요청했습니다. 검토 후 승인/거부 처리해주세요.';
      notification_priority := 'high';
      
    WHEN 'quote_approved' THEN
      korean_category := '견적승인';
      korean_title := '견적이 승인되었습니다';
      korean_message := '요청하신 견적이 승인되었습니다. 예약 진행이 가능합니다.';
      
    WHEN 'reservation_created' THEN
      korean_category := '예약접수';
      korean_title := '새로운 예약이 접수되었습니다';
      korean_message := '고객이 새로운 예약을 생성했습니다. 예약 내용을 확인해주세요.';
      notification_priority := 'high';
      
    WHEN 'payment_pending' THEN
      korean_category := '결제대기';
      korean_title := '결제 확인이 필요합니다';
      korean_message := '고객의 결제 내역 확인이 필요합니다. 결제를 검토해주세요.';
      notification_priority := 'urgent';
      
    WHEN 'customer_inquiry' THEN
      korean_category := '고객문의';
      korean_title := '새로운 고객 문의가 접수되었습니다';
      korean_message := '고객이 새로운 문의를 남겼습니다. 빠른 답변 부탁드립니다.';
      notification_priority := 'high';
      
    WHEN 'system_alert' THEN
      korean_category := '시스템알림';
      korean_title := '시스템 알림';
      korean_message := '시스템에서 중요한 알림이 발생했습니다.';
      notification_priority := 'urgent';
      
    ELSE
      korean_category := '일반알림';
      korean_title := '새로운 알림';
      korean_message := '새로운 알림이 도착했습니다.';
  END CASE;

  -- notifications 테이블에 삽입
  INSERT INTO notifications (
    type, category, title, message, priority, status, 
    target_table, target_id, metadata, created_at
  ) VALUES (
    'business', korean_category, korean_title, korean_message, 
    notification_priority, 'unread', target_table, target_id, metadata, now()
  ) RETURNING id INTO notification_id;

  RAISE NOTICE '✅ 한국어 알림 생성: % (ID: %)', korean_title, notification_id;
  RETURN notification_id;
END;
$$ LANGUAGE plpgsql;

-- 4. 고객 알림 생성 함수
CREATE OR REPLACE FUNCTION create_customer_notification(
  customer_id text,
  inquiry_type text,
  title text,
  message text,
  priority text DEFAULT 'normal',
  metadata jsonb DEFAULT '{}'
) RETURNS uuid AS $$
DECLARE
  notification_id uuid;
BEGIN
  INSERT INTO customer_notifications (
    type, category, title, message, priority, status,
    customer_id, inquiry_type, metadata, created_at
  ) VALUES (
    'customer', inquiry_type, title, message, priority, 'unread',
    customer_id, inquiry_type, metadata, now()
  ) RETURNING id INTO notification_id;

  RAISE NOTICE '✅ 고객 알림 생성: % (고객ID: %)', title, customer_id;
  RETURN notification_id;
END;
$$ LANGUAGE plpgsql;

-- 5. 알림 처리 완료 함수
CREATE OR REPLACE FUNCTION complete_notification(
  notification_id uuid,
  manager_id text,
  processing_note text DEFAULT '',
  customer_satisfaction integer DEFAULT NULL
) RETURNS boolean AS $$
DECLARE
  table_name text;
  is_customer_notification boolean;
BEGIN
  -- customer_notifications 테이블인지 확인
  SELECT EXISTS(
    SELECT 1 FROM customer_notifications WHERE id = notification_id
  ) INTO is_customer_notification;

  IF is_customer_notification THEN
    -- customer_notifications 업데이트
    UPDATE customer_notifications SET
      status = 'completed',
      assigned_to = manager_id,
      resolution_notes = processing_note,
      customer_satisfaction = COALESCE(customer_satisfaction, customer_satisfaction),
      processed_at = now(),
      updated_at = now()
    WHERE id = notification_id;
    
    table_name := 'customer_notifications';
  ELSE
    -- notifications 업데이트
    UPDATE notifications SET
      status = 'completed',
      assigned_to = manager_id,
      processed_at = now(),
      updated_at = now()
    WHERE id = notification_id;
    
    table_name := 'notifications';
  END IF;

  RAISE NOTICE '✅ 알림 처리 완료: % 테이블의 ID %', table_name, notification_id;
  RETURN true;
END;
$$ LANGUAGE plpgsql;

-- 6. 관리자 대시보드 뷰 생성 (선택사항)
CREATE OR REPLACE VIEW v_manager_notification_dashboard AS
SELECT 
  n.id,
  n.type,
  n.category,
  n.title,
  n.message,
  n.priority,
  n.status,
  n.target_id,
  n.target_table,
  n.assigned_to,
  n.due_date,
  n.metadata,
  n.created_at,
  n.updated_at,
  n.processed_at,
  '업무' as type_korean,
  CASE n.priority
    WHEN 'low' THEN '낮음'
    WHEN 'normal' THEN '보통'
    WHEN 'high' THEN '높음'
    WHEN 'urgent' THEN '긴급'
  END as priority_korean,
  CASE n.status
    WHEN 'unread' THEN '읽지않음'
    WHEN 'read' THEN '읽음'
    WHEN 'processing' THEN '처리중'
    WHEN 'completed' THEN '완료'
    WHEN 'dismissed' THEN '무시됨'
  END as status_korean
FROM notifications n
WHERE n.type = 'business'

UNION ALL

SELECT 
  cn.id,
  cn.type,
  cn.category,
  cn.title,
  cn.message,
  cn.priority,
  cn.status,
  cn.target_id,
  cn.target_table,
  cn.assigned_to,
  cn.due_date,
  cn.metadata,
  cn.created_at,
  cn.updated_at,
  cn.processed_at,
  '고객' as type_korean,
  CASE cn.priority
    WHEN 'low' THEN '낮음'
    WHEN 'normal' THEN '보통'
    WHEN 'high' THEN '높음'
    WHEN 'urgent' THEN '긴급'
  END as priority_korean,
  CASE cn.status
    WHEN 'unread' THEN '읽지않음'
    WHEN 'read' THEN '읽음'
    WHEN 'processing' THEN '처리중'
    WHEN 'completed' THEN '완료'
    WHEN 'dismissed' THEN '무시됨'
  END as status_korean
FROM customer_notifications cn;

-- 7. 알림 트리거 업데이트 (customer_requests 등에서 사용)
CREATE OR REPLACE FUNCTION fn_create_customer_request_notification()
RETURNS TRIGGER AS $$
DECLARE
  current_user_id text;
BEGIN
  current_user_id := auth.uid()::text;
  IF TG_OP = 'INSERT' THEN
    -- customer_notifications 테이블에 고객 요청 알림 생성
    INSERT INTO customer_notifications (
      type, category, title, message, priority, status, 
      target_table, target_id, customer_id, inquiry_type, metadata, created_at
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
      COALESCE(NEW.user_id,''),
      COALESCE(NEW.request_type,''),
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

-- 8. 테스트 알림 생성 (선택사항)
DO $$
DECLARE
  test_notification_id uuid;
BEGIN
  -- 테스트 업무 알림 생성
  SELECT create_korean_notification(
    'quote_submitted',
    'quote',
    'test-quote-001',
    '{"test": true}'::jsonb
  ) INTO test_notification_id;
  
  -- 테스트 고객 알림 생성
  SELECT create_customer_notification(
    'test-customer-001',
    '서비스문의',
    '테스트 고객 문의',
    '이것은 테스트 고객 문의입니다.',
    'normal',
    '{"test": true}'::jsonb
  ) INTO test_notification_id;
  
  RAISE NOTICE '✅ 테스트 알림들이 생성되었습니다.';
END $$;

-- 완료 메시지
DO $$
BEGIN
  RAISE NOTICE '🎉 알림 시스템 완전 개선이 완료되었습니다!';
  RAISE NOTICE '📋 생성된 기능:';
  RAISE NOTICE '   • 한국어화된 알림 생성 함수';
  RAISE NOTICE '   • customer_notifications 테이블 연동';
  RAISE NOTICE '   • 실시간 알림 처리 함수';
  RAISE NOTICE '   • 관리자 대시보드 뷰';
  RAISE NOTICE '   • 알림 완료 처리 함수';
END $$;
