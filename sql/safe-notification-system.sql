-- 알림 시스템 안전 설치 SQL
-- 기존 테이블과 충돌하지 않도록 IF NOT EXISTS 사용

-- 1. notifications 테이블 생성 (존재하지 않는 경우에만)
CREATE TABLE IF NOT EXISTS notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type text DEFAULT 'business' CHECK (type IN ('business', 'customer')),
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
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  processed_at timestamptz
);

-- 2. customer_notifications 테이블 생성
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

-- 3. 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_notifications_status ON notifications(status);
CREATE INDEX IF NOT EXISTS idx_notifications_priority ON notifications(priority);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);
CREATE INDEX IF NOT EXISTS idx_customer_notifications_status ON customer_notifications(status);
CREATE INDEX IF NOT EXISTS idx_customer_notifications_priority ON customer_notifications(priority);
CREATE INDEX IF NOT EXISTS idx_customer_notifications_customer_id ON customer_notifications(customer_id);

-- 4. RLS 정책 설정
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_notifications ENABLE ROW LEVEL SECURITY;

-- 기존 정책 삭제 후 재생성
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

-- 5. 알림 처리 함수
CREATE OR REPLACE FUNCTION complete_notification(
  notification_id uuid,
  manager_id text,
  processing_note text DEFAULT '',
  customer_satisfaction integer DEFAULT NULL
) RETURNS boolean AS $$
DECLARE
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
  ELSE
    -- notifications 업데이트
    UPDATE notifications SET
      status = 'completed',
      assigned_to = manager_id,
      processed_at = now(),
      updated_at = now()
    WHERE id = notification_id;
  END IF;

  RETURN true;
END;
$$ LANGUAGE plpgsql;

-- 6. 테스트 데이터 삽입
INSERT INTO notifications (category, title, message, priority, status) VALUES
('견적관리', '🔥 긴급: 대용량 견적 승인 대기', '100명 이상 크루즈 견적이 승인 대기 중입니다. 빠른 검토가 필요합니다.', 'urgent', 'unread'),
('예약관리', '📋 예약 확인 필요', '오늘 출발 예정인 예약 5건의 최종 확인이 필요합니다.', 'high', 'unread'),
('결제관리', '💰 결제 오류 발생', '신용카드 결제 처리 중 오류가 발생했습니다.', 'high', 'unread'),
('시스템', '🔧 시스템 점검 예정', '내일 오전 2시-4시 시스템 점검이 예정되어 있습니다.', 'normal', 'read')
ON CONFLICT DO NOTHING;

INSERT INTO customer_notifications (category, title, message, priority, status, customer_name, customer_phone, inquiry_type) VALUES
('고객문의', '🚨 긴급: 고객 불만 접수', '크루즈 서비스에 대한 심각한 불만이 접수되었습니다. 즉시 대응이 필요합니다.', 'urgent', 'unread', '김고객', '010-1234-5678', '불만사항'),
('예약변경', '📞 예약 변경 요청', '고객이 예약 날짜 변경을 요청했습니다.', 'high', 'unread', '박여행', '010-9876-5432', '예약변경'),
('환불요청', '💸 환불 처리 요청', '개인 사정으로 인한 환불 요청이 들어왔습니다.', 'normal', 'processing', '최취소', '010-5555-1111', '환불'),
('칭찬고객', '👏 고객 칭찬 후기', '서비스에 매우 만족한다는 좋은 후기를 남겨주셨습니다.', 'low', 'read', '이만족', '010-7777-8888', '칭찬')
ON CONFLICT DO NOTHING;

-- 완료 메시지
SELECT '✅ 알림 시스템이 성공적으로 설치되었습니다!' as message;
