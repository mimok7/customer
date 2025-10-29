-- 알림 처리 함수 수정 (컬럼명 모호성 완전 해결)
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
BEGIN
  -- notifications 테이블에 해당 ID가 존재하는지 확인
  SELECT EXISTS(
    SELECT 1 FROM notifications WHERE id = p_notification_id
  ) INTO v_notification_exists;
  
  IF v_notification_exists THEN
    -- notifications 테이블 업데이트
    UPDATE notifications 
    SET 
      status = 'completed',
      processed_at = now(),
      updated_at = now(),
      assigned_to = CASE 
        WHEN p_manager_id != '' AND p_manager_id ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
        THEN p_manager_id::uuid 
        ELSE assigned_to 
      END,
      metadata = COALESCE(metadata, '{}'::jsonb) || 
        jsonb_build_object(
          'processed_by', p_manager_id,
          'processing_note', p_processing_note,
          'completed_at', now()
        )
    WHERE id = p_notification_id;
    
    -- 연결된 customer_notifications 업데이트 (테이블 별칭 사용)
    UPDATE customer_notifications AS cn
    SET 
      resolution_notes = p_processing_note,
      customer_satisfaction = COALESCE(p_customer_satisfaction, cn.customer_satisfaction),
      updated_at = now()
    WHERE cn.notification_id = p_notification_id;
    
    v_result := json_build_object(
      'success', true,
      'message', '알림이 완료되었습니다.',
      'notification_id', p_notification_id,
      'processed_by', p_manager_id
    );
    
    RAISE NOTICE '✅ 알림 처리 완료: % by %', p_notification_id, p_manager_id;
  ELSE
    v_result := json_build_object(
      'success', false,
      'message', '알림을 찾을 수 없습니다.',
      'notification_id', p_notification_id
    );
    
    RAISE NOTICE '❌ 알림을 찾을 수 없음: %', p_notification_id;
  END IF;
  
  RETURN v_result;
EXCEPTION
  WHEN OTHERS THEN
    v_result := json_build_object(
      'success', false,
      'message', '알림 처리 중 오류가 발생했습니다: ' || SQLERRM,
      'notification_id', p_notification_id
    );
    RAISE NOTICE '❌ 알림 처리 오류: % - %', p_notification_id, SQLERRM;
    RETURN v_result;
END;
$$;

-- 테스트 쿼리
SELECT '✅ complete_notification 함수가 업데이트되었습니다!' as message;
