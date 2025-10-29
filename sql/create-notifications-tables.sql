-- 알림 시스템 테이블 생성 SQL
-- 업무와 고객 알림을 분리하여 관리

-- 1. 메인 알림 테이블
CREATE TABLE IF NOT EXISTS notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    type VARCHAR(50) NOT NULL, -- 'business' 또는 'customer'
    category VARCHAR(100) NOT NULL, -- 세부 카테고리 (예약, 결제, 견적, 문의 등)
    title VARCHAR(200) NOT NULL, -- 알림 제목
    message TEXT NOT NULL, -- 알림 내용
    target_id TEXT, -- 관련된 예약/견적/결제 등의 ID (다양한 타입 지원)
    target_table VARCHAR(50), -- 참조 테이블명 (reservation, quote, payment, customer_requests 등)
    priority VARCHAR(20) DEFAULT 'normal', -- 우선순위: low, normal, high, urgent
    status VARCHAR(20) DEFAULT 'unread', -- 상태: unread, read, processing, completed, dismissed
    created_by UUID, -- 알림 생성자 (시스템 또는 사용자 ID)
    assigned_to UUID, -- 담당자 ID (매니저/관리자)
    due_date TIMESTAMP, -- 처리 예정일 (업무 알림의 경우)
    metadata JSONB, -- 추가 데이터 (고객 정보, 예약 세부사항 등)
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    processed_at TIMESTAMP -- 처리 완료 시간
);

-- 2. 업무 알림 상세 테이블
CREATE TABLE IF NOT EXISTS business_notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    business_type VARCHAR(100) NOT NULL, -- 업무 유형: schedule, maintenance, report, approval, system
    department VARCHAR(50), -- 담당 부서: reservation, payment, customer_service, management
    urgency_level INTEGER DEFAULT 1, -- 긴급도 (1-5)
    estimated_duration INTEGER, -- 예상 소요 시간 (분)
    required_action TEXT, -- 필요한 조치사항
    checklist JSONB, -- 체크리스트
    related_users UUID[], -- 관련 담당자들
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 3. 고객 알림 상세 테이블
CREATE TABLE IF NOT EXISTS customer_notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    customer_id UUID REFERENCES users(id), -- 고객 ID
    customer_name VARCHAR(100), -- 고객명
    customer_phone VARCHAR(20), -- 고객 연락처
    customer_email VARCHAR(100), -- 고객 이메일
    inquiry_type VARCHAR(100), -- 문의 유형: reservation, payment, cancellation, complaint, general
    service_type VARCHAR(100), -- 서비스 유형: cruise, hotel, airport, tour, rentcar
    response_deadline TIMESTAMP, -- 응답 기한
    customer_satisfaction INTEGER, -- 고객 만족도 (1-5, 완료 후 입력)
    follow_up_required BOOLEAN DEFAULT FALSE, -- 후속 조치 필요 여부
    resolution_notes TEXT, -- 해결 내용
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 4. 알림 템플릿 테이블
CREATE TABLE IF NOT EXISTS notification_templates (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- 템플릿명
    type VARCHAR(50) NOT NULL, -- business 또는 customer
    category VARCHAR(100) NOT NULL,
    title_template VARCHAR(200) NOT NULL, -- 제목 템플릿
    message_template TEXT NOT NULL, -- 내용 템플릿
    default_priority VARCHAR(20) DEFAULT 'normal',
    auto_assign_rule JSONB, -- 자동 배정 규칙
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 5. 알림 읽음 상태 테이블 (다수 사용자가 같은 알림을 볼 수 있는 경우)
CREATE TABLE IF NOT EXISTS notification_reads (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    read_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(notification_id, user_id)
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_category ON notifications(category);
CREATE INDEX IF NOT EXISTS idx_notifications_status ON notifications(status);
CREATE INDEX IF NOT EXISTS idx_notifications_assigned_to ON notifications(assigned_to);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);
CREATE INDEX IF NOT EXISTS idx_notifications_priority ON notifications(priority);

CREATE INDEX IF NOT EXISTS idx_business_notifications_business_type ON business_notifications(business_type);
CREATE INDEX IF NOT EXISTS idx_business_notifications_department ON business_notifications(department);

CREATE INDEX IF NOT EXISTS idx_customer_notifications_customer_id ON customer_notifications(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_notifications_inquiry_type ON customer_notifications(inquiry_type);
CREATE INDEX IF NOT EXISTS idx_customer_notifications_service_type ON customer_notifications(service_type);

-- RLS (Row Level Security) 정책
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE business_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_reads ENABLE ROW LEVEL SECURITY;

-- 기존 정책 제거 (재실행 안전)
DROP POLICY IF EXISTS "Manager can view all notifications" ON notifications;
DROP POLICY IF EXISTS "Manager can manage notifications" ON notifications;
DROP POLICY IF EXISTS "Manager can view business notifications" ON business_notifications;
DROP POLICY IF EXISTS "Manager can manage business notifications" ON business_notifications;
DROP POLICY IF EXISTS "Manager can view customer notifications" ON customer_notifications;
DROP POLICY IF EXISTS "Manager can manage customer notifications" ON customer_notifications;
DROP POLICY IF EXISTS "Manager can view templates" ON notification_templates;
DROP POLICY IF EXISTS "Admin can manage templates" ON notification_templates;
DROP POLICY IF EXISTS "Users can manage their own reads" ON notification_reads;

-- 매니저/관리자만 알림 조회 가능
CREATE POLICY "Manager can view all notifications" ON notifications
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

-- 매니저/관리자만 알림 생성/수정 가능
CREATE POLICY "Manager can manage notifications" ON notifications
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

-- 업무 알림 정책
CREATE POLICY "Manager can view business notifications" ON business_notifications
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

CREATE POLICY "Manager can manage business notifications" ON business_notifications
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

-- 고객 알림 정책
CREATE POLICY "Manager can view customer notifications" ON customer_notifications
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

CREATE POLICY "Manager can manage customer notifications" ON customer_notifications
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

-- 알림 템플릿 정책
CREATE POLICY "Manager can view templates" ON notification_templates
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

CREATE POLICY "Admin can manage templates" ON notification_templates
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role = 'admin'
        )
    );

-- 읽음 상태 정책
CREATE POLICY "Users can manage their own reads" ON notification_reads
    FOR ALL TO authenticated
    USING (user_id::text = auth.uid()::text);

-- 기본 알림 템플릿 데이터 삽입
INSERT INTO notification_templates (name, type, category, title_template, message_template, default_priority) VALUES
-- 업무 알림 템플릿
('새 예약 접수', 'business', 'reservation_new', '신규 예약 접수: {customer_name}', '{service_type} 예약이 접수되었습니다. 고객: {customer_name}, 예약번호: {reservation_id}', 'normal'),
('결제 확인 필요', 'business', 'payment_verify', '결제 확인 필요: {amount}동', '결제 확인이 필요합니다. 금액: {amount}동, 예약번호: {reservation_id}', 'high'),
('견적 승인 요청', 'business', 'quote_approval', '견적 승인 요청: {quote_title}', '견적 승인이 요청되었습니다. 견적명: {quote_title}, 금액: {total_amount}동', 'normal'),
('시스템 점검 알림', 'business', 'system_maintenance', '시스템 점검 예정', '시스템 점검이 예정되어 있습니다. 일시: {maintenance_date}', 'low'),
('일일 매출 보고', 'business', 'daily_report', '일일 매출 보고', '오늘 매출: {daily_sales}동, 예약 건수: {reservation_count}건', 'low'),

-- 고객 알림 템플릿  
('고객 문의 접수', 'customer', 'inquiry_general', '고객 문의: {customer_name}', '{customer_name}님의 문의가 접수되었습니다. 문의 유형: {inquiry_type}', 'normal'),
('예약 취소 요청', 'customer', 'reservation_cancel', '예약 취소 요청: {customer_name}', '{customer_name}님의 예약 취소 요청입니다. 예약번호: {reservation_id}', 'high'),
('환불 요청', 'customer', 'refund_request', '환불 요청: {amount}동', '{customer_name}님의 환불 요청입니다. 금액: {amount}동', 'high'),
('고객 불만 접수', 'customer', 'complaint', '고객 불만: {customer_name}', '{customer_name}님의 불만이 접수되었습니다. 긴급 처리 필요', 'urgent'),
('예약 변경 요청', 'customer', 'reservation_modify', '예약 변경 요청: {customer_name}', '{customer_name}님의 예약 변경 요청입니다. 예약번호: {reservation_id}', 'normal');

-- 함수: 알림 생성 헬퍼
CREATE OR REPLACE FUNCTION create_notification(
    p_type VARCHAR,
    p_category VARCHAR,
    p_title VARCHAR,
    p_message TEXT,
    p_target_id UUID DEFAULT NULL,
    p_target_table VARCHAR DEFAULT NULL,
    p_priority VARCHAR DEFAULT 'normal',
    p_assigned_to UUID DEFAULT NULL,
    p_metadata JSONB DEFAULT '{}'::jsonb
) RETURNS UUID AS $$
DECLARE
    notification_id UUID;
BEGIN
    INSERT INTO notifications (
        type, category, title, message, target_id, target_table,
        priority, assigned_to, metadata
    ) VALUES (
        p_type, p_category, p_title, p_message, p_target_id, p_target_table,
        p_priority, p_assigned_to, p_metadata
    ) RETURNING id INTO notification_id;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 함수: 알림 상태 업데이트
CREATE OR REPLACE FUNCTION update_notification_status(
    p_notification_id UUID,
    p_status VARCHAR,
    p_user_id UUID DEFAULT NULL
) RETURNS BOOLEAN AS $$
BEGIN
    UPDATE notifications 
    SET 
        status = p_status,
        updated_at = NOW(),
        processed_at = CASE WHEN p_status IN ('completed', 'dismissed') THEN NOW() ELSE processed_at END
    WHERE id = p_notification_id;
    
    -- 읽음 상태 기록
    IF p_user_id IS NOT NULL AND p_status = 'read' THEN
        INSERT INTO notification_reads (notification_id, user_id)
        VALUES (p_notification_id, p_user_id)
        ON CONFLICT (notification_id, user_id) DO NOTHING;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
