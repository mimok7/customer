-- 한국어 알림 시스템 - 단순 버전
-- notifications 테이블
CREATE TABLE IF NOT EXISTS notifications (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  type text NOT NULL DEFAULT 'business', -- 'business' 또는 'customer'
  category text NOT NULL,
  title text NOT NULL,
  message text NOT NULL,
  priority text NOT NULL DEFAULT 'normal', -- 'low', 'normal', 'high', 'urgent'
  status text NOT NULL DEFAULT 'unread', -- 'unread', 'read', 'processing', 'completed', 'dismissed'
  target_id text,
  target_table text,
  assigned_to text,
  due_date timestamptz,
  metadata jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  processed_at timestamptz
);

-- customer_notifications 테이블 (고객 알림 전용)
CREATE TABLE IF NOT EXISTS customer_notifications (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  type text NOT NULL DEFAULT 'customer',
  category text NOT NULL,
  title text NOT NULL,
  message text NOT NULL,
  priority text NOT NULL DEFAULT 'normal',
  status text NOT NULL DEFAULT 'unread',
  customer_id text,
  customer_name text,
  customer_phone text,
  customer_email text,
  inquiry_type text,
  service_type text,
  response_deadline timestamptz,
  customer_satisfaction integer CHECK (customer_satisfaction >= 1 AND customer_satisfaction <= 5),
  follow_up_required boolean DEFAULT false,
  resolution_notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  processed_at timestamptz
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_notifications_status ON notifications(status);
CREATE INDEX IF NOT EXISTS idx_notifications_priority ON notifications(priority);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);
CREATE INDEX IF NOT EXISTS idx_customer_notifications_status ON customer_notifications(status);
CREATE INDEX IF NOT EXISTS idx_customer_notifications_priority ON customer_notifications(priority);

-- RLS 정책 활성화
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_notifications ENABLE ROW LEVEL SECURITY;

-- 정책 생성 (관리자/매니저만 접근)
DROP POLICY IF EXISTS notifications_manager_access ON notifications;
CREATE POLICY notifications_manager_access ON notifications
  FOR ALL 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role IN ('manager', 'admin')
    )
  );

DROP POLICY IF EXISTS customer_notifications_manager_access ON customer_notifications;
CREATE POLICY customer_notifications_manager_access ON customer_notifications
  FOR ALL 
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users 
      WHERE users.id = auth.uid() 
      AND users.role IN ('manager', 'admin')
    )
  );

-- 알림 처리 함수 (한국어 버전)
CREATE OR REPLACE FUNCTION complete_notification(
  notification_id uuid,
  manager_id text DEFAULT '',
  processing_note text DEFAULT '',
  customer_satisfaction integer DEFAULT NULL
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
  result json;
  notification_record record;
BEGIN
  -- notifications 테이블에서 찾기
  SELECT * INTO notification_record 
  FROM notifications 
  WHERE id = notification_id;
  
  IF FOUND THEN
    UPDATE notifications 
    SET 
      status = 'completed',
      processed_at = now(),
      updated_at = now(),
      metadata = COALESCE(metadata, '{}'::jsonb) || 
        jsonb_build_object(
          'processed_by', manager_id,
          'processing_note', processing_note,
          'completed_at', now()
        )
    WHERE id = notification_id;
    
    result := json_build_object(
      'success', true,
      'message', '업무 알림이 완료되었습니다.',
      'table', 'notifications'
    );
  ELSE
    -- customer_notifications 테이블에서 찾기
    SELECT * INTO notification_record 
    FROM customer_notifications 
    WHERE id = notification_id;
    
    IF FOUND THEN
      UPDATE customer_notifications 
      SET 
        status = 'completed',
        processed_at = now(),
        updated_at = now(),
        resolution_notes = processing_note,
        customer_satisfaction = COALESCE(customer_satisfaction, customer_satisfaction)
      WHERE id = notification_id;
      
      result := json_build_object(
        'success', true,
        'message', '고객 알림이 완료되었습니다.',
        'table', 'customer_notifications'
      );
    ELSE
      result := json_build_object(
        'success', false,
        'message', '알림을 찾을 수 없습니다.'
      );
    END IF;
  END IF;
  
  RETURN result;
END;
$$;

-- 테스트 데이터 삽입 (한국어)
INSERT INTO notifications (category, title, message, priority, status) VALUES
('견적관리', '🔥 긴급: 대용량 견적 승인 대기', '100명 이상 크루즈 견적이 승인 대기 중입니다. 빠른 검토가 필요합니다.', 'urgent', 'unread'),
('예약관리', '📋 예약 확인 필요', '오늘 출발 예정인 예약 5건의 최종 확인이 필요합니다.', 'high', 'unread'),
('결제관리', '💰 결제 오류 발생', '신용카드 결제 처리 중 오류가 발생했습니다.', 'high', 'unread'),
('시스템', '🔧 시스템 점검 예정', '내일 오전 2시-4시 시스템 점검이 예정되어 있습니다.', 'normal', 'read');

INSERT INTO customer_notifications (category, title, message, priority, status, customer_name, customer_phone, inquiry_type) VALUES
('고객문의', '🚨 긴급: 고객 불만 접수', '크루즈 서비스에 대한 심각한 불만이 접수되었습니다. 즉시 대응이 필요합니다.', 'urgent', 'unread', '김고객', '010-1234-5678', '불만사항'),
('예약변경', '📞 예약 변경 요청', '고객이 예약 날짜 변경을 요청했습니다.', 'high', 'unread', '박여행', '010-9876-5432', '예약변경'),
('환불요청', '💸 환불 처리 요청', '개인 사정으로 인한 환불 요청이 들어왔습니다.', 'normal', 'processing', '최취소', '010-5555-1111', '환불'),
('칭찬고객', '👏 고객 칭찬 후기', '서비스에 매우 만족한다는 좋은 후기를 남겨주셨습니다.', 'low', 'read', '이만족', '010-7777-8888', '칭찬');

-- 성공 메시지
SELECT '✅ 한국어 알림 시스템이 성공적으로 설치되었습니다!' as message;
