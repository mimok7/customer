-- 기존 테이블 구조에 맞는 알림 시스템 SQL
-- notifications와 customer_notifications 테이블이 이미 존재함

-- 1. 알림 처리 함수 (완전히 수정된 버전 - 모든 모호성 제거)
CREATE OR REPLACE FUNCTION complete_notification(
  p_notification_id uuid,
  p_manager_id text DEFAULT '',
  p_processing_note text DEFAULT '',
  p_customer_satisfaction integer DEFAULT NULL
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
  v_result json;
  v_notification_exists boolean;
  v_manager_uuid uuid;
BEGIN
  -- notifications 테이블에 해당 ID가 존재하는지 확인
  SELECT EXISTS(
    SELECT 1 FROM notifications WHERE id = p_notification_id
  ) INTO v_notification_exists;
  
  IF NOT v_notification_exists THEN
    v_result := json_build_object(
      'success', false,
      'message', '알림을 찾을 수 없습니다.',
      'notification_id', p_notification_id
    );
    RETURN v_result;
  END IF;

  -- manager_id를 UUID로 변환 (안전하게)
  BEGIN
    IF p_manager_id != '' AND p_manager_id ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' THEN
      v_manager_uuid := p_manager_id::uuid;
    ELSE
      v_manager_uuid := NULL;
    END IF;
  EXCEPTION
    WHEN invalid_text_representation THEN
      v_manager_uuid := NULL;
  END;

  -- notifications 테이블 업데이트
  UPDATE notifications 
  SET 
    status = 'completed',
    processed_at = now(),
    updated_at = now(),
    assigned_to = COALESCE(v_manager_uuid, assigned_to),
    metadata = COALESCE(metadata, '{}'::jsonb) || 
      jsonb_build_object(
        'processed_by', p_manager_id,
        'processing_note', p_processing_note,
        'completed_at', now()
      )
  WHERE id = p_notification_id;
  
  -- customer_notifications 테이블 업데이트 (완전히 명시적)
  UPDATE customer_notifications 
  SET 
    resolution_notes = p_processing_note,
    customer_satisfaction = CASE 
      WHEN p_customer_satisfaction IS NOT NULL THEN p_customer_satisfaction
      ELSE customer_notifications.customer_satisfaction
    END,
    updated_at = now()
  WHERE customer_notifications.notification_id = p_notification_id;
  
  v_result := json_build_object(
    'success', true,
    'message', '알림이 완료되었습니다.',
    'notification_id', p_notification_id,
    'processed_by', p_manager_id
  );
  
  RAISE NOTICE '✅ 알림 처리 완료: % by %', p_notification_id, p_manager_id;
  RETURN v_result;

EXCEPTION
  WHEN OTHERS THEN
    v_result := json_build_object(
      'success', false,
      'message', '알림 처리 중 오류가 발생했습니다: ' || SQLERRM,
      'notification_id', p_notification_id,
      'error_code', SQLSTATE
    );
    RAISE NOTICE '❌ 알림 처리 오류: % - %', p_notification_id, SQLERRM;
    RETURN v_result;
END;
$$;

-- 2. 한국어 알림 생성 함수 (기존 구조 기준)
CREATE OR REPLACE FUNCTION create_korean_notification(
  notification_type text,
  target_table text DEFAULT '',
  target_id text DEFAULT '',
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

  -- notifications 테이블에 삽입 (기존 구조 기준)
  INSERT INTO notifications (
    type, category, title, message, priority, status, 
    target_table, target_id, metadata, created_at, updated_at
  ) VALUES (
    'business', korean_category, korean_title, korean_message, 
    notification_priority, 'unread', target_table, target_id, metadata, now(), now()
  ) RETURNING id INTO notification_id;

  RAISE NOTICE '✅ 한국어 알림 생성: % (ID: %)', korean_title, notification_id;
  RETURN notification_id;
END;
$$ LANGUAGE plpgsql;

-- 3. 테스트 한국어 알림 데이터 생성
DO $$
DECLARE
  test_notification_id uuid;
BEGIN
  -- 기존 데이터와 중복되지 않도록 확인 후 삽입
  IF NOT EXISTS (SELECT 1 FROM notifications WHERE category = '견적관리' AND title LIKE '%긴급%') THEN
    INSERT INTO notifications (type, category, title, message, priority, status, created_at, updated_at) VALUES
    ('business', '견적관리', '🔥 긴급: 대용량 견적 승인 대기', '100명 이상 크루즈 견적이 승인 대기 중입니다. 빠른 검토가 필요합니다.', 'urgent', 'unread', now(), now()),
    ('business', '예약관리', '📋 예약 확인 필요', '오늘 출발 예정인 예약 5건의 최종 확인이 필요합니다.', 'high', 'unread', now(), now()),
    ('business', '결제관리', '💰 결제 오류 발생', '신용카드 결제 처리 중 오류가 발생했습니다.', 'high', 'unread', now(), now()),
    ('business', '시스템', '🔧 시스템 점검 예정', '내일 오전 2시-4시 시스템 점검이 예정되어 있습니다.', 'normal', 'read', now(), now());
    
    RAISE NOTICE '✅ 테스트 업무 알림 4개가 생성되었습니다.';
  ELSE
    RAISE NOTICE '⚠️ 테스트 데이터가 이미 존재합니다.';
  END IF;
  
  -- 한국어 알림 생성 함수 테스트
  SELECT create_korean_notification(
    'quote_submitted',
    'quote',
    'test-quote-001',
    '{"test": true}'::jsonb
  ) INTO test_notification_id;
  
  RAISE NOTICE '✅ 한국어 알림 생성 함수 테스트 완료: %', test_notification_id;
END $$;

-- 4. 고객 알림 데이터 추가 (올바른 customer_notifications 연동)
DO $$
DECLARE
  business_notification_id uuid;
  customer_notification_id uuid;
BEGIN
  -- 고객 문의 관련 업무 알림 생성
  IF NOT EXISTS (SELECT 1 FROM notifications WHERE category = '고객문의' AND title LIKE '%불만%') THEN
    INSERT INTO notifications (type, category, title, message, priority, status, created_at, updated_at) 
    VALUES ('customer', '고객문의', '🚨 긴급: 고객 불만 접수', '크루즈 서비스에 대한 심각한 불만이 접수되었습니다. 즉시 대응이 필요합니다.', 'urgent', 'unread', now(), now())
    RETURNING id INTO business_notification_id;
    
    -- 연결된 customer_notifications 데이터 생성
    INSERT INTO customer_notifications (
      notification_id, customer_name, customer_phone, inquiry_type, 
      service_type, customer_satisfaction, follow_up_required, created_at, updated_at
    ) VALUES (
      business_notification_id, '김고객', '010-1234-5678', '불만사항', 
      '크루즈', 1, true, now(), now()
    );
    
    -- 추가 고객 알림들
    INSERT INTO notifications (type, category, title, message, priority, status, created_at, updated_at) 
    VALUES 
    ('customer', '예약변경', '📞 예약 변경 요청', '고객이 예약 날짜 변경을 요청했습니다.', 'high', 'unread', now(), now()),
    ('customer', '환불요청', '💸 환불 처리 요청', '개인 사정으로 인한 환불 요청이 들어왔습니다.', 'normal', 'processing', now(), now()),
    ('customer', '칭찬고객', '👏 고객 칭찬 후기', '서비스에 매우 만족한다는 좋은 후기를 남겨주셨습니다.', 'low', 'read', now(), now())
    RETURNING id INTO customer_notification_id;
    
    -- 각각에 대한 customer_notifications 데이터
    INSERT INTO customer_notifications (notification_id, customer_name, customer_phone, inquiry_type, service_type, follow_up_required, created_at, updated_at)
    SELECT 
      n.id,
      CASE 
        WHEN n.category = '예약변경' THEN '박여행'
        WHEN n.category = '환불요청' THEN '최취소' 
        WHEN n.category = '칭찬고객' THEN '이만족'
      END,
      CASE 
        WHEN n.category = '예약변경' THEN '010-9876-5432'
        WHEN n.category = '환불요청' THEN '010-5555-1111'
        WHEN n.category = '칭찬고객' THEN '010-7777-8888'
      END,
      CASE 
        WHEN n.category = '예약변경' THEN '예약변경'
        WHEN n.category = '환불요청' THEN '환불'
        WHEN n.category = '칭찬고객' THEN '칭찬'
      END,
      '크루즈',
      CASE WHEN n.category = '칭찬고객' THEN false ELSE true END,
      now(),
      now()
    FROM notifications n 
    WHERE n.type = 'customer' 
    AND n.category IN ('예약변경', '환불요청', '칭찬고객')
    AND n.id != business_notification_id;
    
    RAISE NOTICE '✅ 고객 알림 연동 데이터가 생성되었습니다.';
  END IF;
END $$;

-- 5. 알림 통계 뷰 생성
CREATE OR REPLACE VIEW v_notification_stats AS
SELECT 
  COUNT(*) as total_notifications,
  COUNT(CASE WHEN status = 'unread' THEN 1 END) as unread_count,
  COUNT(CASE WHEN status = 'read' THEN 1 END) as read_count,
  COUNT(CASE WHEN status = 'processing' THEN 1 END) as processing_count,
  COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_count,
  COUNT(CASE WHEN priority = 'urgent' THEN 1 END) as urgent_count,
  COUNT(CASE WHEN priority = 'high' THEN 1 END) as high_count,
  COUNT(CASE WHEN type = 'business' THEN 1 END) as business_count,
  COUNT(CASE WHEN type = 'customer' THEN 1 END) as customer_count
FROM notifications;

-- 완료 메시지
SELECT '✅ 기존 테이블 구조에 맞는 알림 시스템이 설치되었습니다!' as message;
SELECT '📊 알림 통계:' as info;
SELECT * FROM v_notification_stats;
