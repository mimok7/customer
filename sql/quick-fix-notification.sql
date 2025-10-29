-- 🔧 알림 함수 빠른 수정 (오류 완전 해결)
-- Supabase SQL Editor에서 바로 실행하세요!

-- 기존 함수 삭제
DROP FUNCTION IF EXISTS complete_notification(uuid, text, text, integer);

-- 새로운 안전한 함수 생성
CREATE OR REPLACE FUNCTION complete_notification(
  p_notification_id uuid,
  p_manager_id text DEFAULT '',
  p_manager_name text DEFAULT '',
  p_processing_note text DEFAULT '',
  p_customer_satisfaction integer DEFAULT NULL
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
  v_result json;
  v_rows_updated integer;
BEGIN
  -- 1. notifications 테이블 업데이트
  UPDATE notifications 
  SET 
    status = 'completed',
    processed_at = now(),
    updated_at = now(),
    processed_by_name = p_manager_name,
    metadata = COALESCE(metadata, '{}'::jsonb) || 
      jsonb_build_object(
        'processed_by', p_manager_id,
        'processed_by_name', p_manager_name,
        'processing_note', p_processing_note,
        'completed_at', now()
      )
  WHERE id = p_notification_id;
  
  GET DIAGNOSTICS v_rows_updated = ROW_COUNT;
  
  IF v_rows_updated = 0 THEN
    v_result := json_build_object(
      'success', false,
      'message', '알림을 찾을 수 없습니다.',
      'notification_id', p_notification_id
    );
    RETURN v_result;
  END IF;
  
  -- 2. customer_notifications 테이블 업데이트 (안전하게)
  UPDATE customer_notifications AS cn
  SET 
    resolution_notes = p_processing_note,
    customer_satisfaction = CASE 
      WHEN p_customer_satisfaction IS NOT NULL THEN p_customer_satisfaction
      ELSE cn.customer_satisfaction
    END,
    updated_at = now()
  WHERE cn.notification_id = p_notification_id;
  
  -- 3. 성공 응답
  v_result := json_build_object(
    'success', true,
    'message', '알림이 완료되었습니다.',
    'notification_id', p_notification_id
  );
  
  RETURN v_result;

EXCEPTION
  WHEN OTHERS THEN
    v_result := json_build_object(
      'success', false,
      'message', '오류: ' || SQLERRM,
      'notification_id', p_notification_id
    );
    RETURN v_result;
END;
$$;

-- 테스트 (선택사항)
SELECT '✅ complete_notification 함수가 수정되었습니다!' as message;

-- 함수 테스트 (실제 알림 ID로 테스트 시)
-- SELECT complete_notification('실제-알림-ID'::uuid, 'test-manager', '테스트 처리', 5);
