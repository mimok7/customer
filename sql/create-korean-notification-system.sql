-- 완전한 알림 시스템 구축 및 한글화 (2025.08.21)
-- 1. 기존 알림 관련 테이블/함수 정리
-- 2. 새로운 한글화된 알림 시스템 구축
-- 3. 매니저용 알림 처리 시스템 포함

-- ========================================
-- 1단계: 기존 알림 관련 정리
-- ========================================

-- 기존 알림 관련 객체 제거 (안전하게)
DROP TRIGGER IF EXISTS trg_customer_request_notification ON customer_requests;
DROP FUNCTION IF EXISTS fn_create_customer_request_notification() CASCADE;
DROP FUNCTION IF EXISTS create_notification(VARCHAR, VARCHAR, VARCHAR, TEXT, UUID, VARCHAR, VARCHAR, UUID, JSONB) CASCADE;
DROP FUNCTION IF EXISTS update_notification_status(UUID, VARCHAR, UUID) CASCADE;

DROP TABLE IF EXISTS notification_reads CASCADE;
DROP TABLE IF EXISTS customer_notifications CASCADE;
DROP TABLE IF EXISTS business_notifications CASCADE;
DROP TABLE IF EXISTS notification_templates CASCADE;
DROP TABLE IF EXISTS notifications CASCADE;

-- ========================================
-- 2단계: 새로운 한글화된 알림 시스템 구축
-- ========================================

-- 메인 알림 테이블 (한글화)
CREATE TABLE notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    
    -- 기본 분류 (한글)
    notification_type TEXT NOT NULL CHECK (notification_type IN ('업무알림', '고객알림', '시스템알림')),
    category TEXT NOT NULL, -- '신규예약', '결제확인', '고객문의', '예약취소', '시스템점검' 등
    priority TEXT NOT NULL DEFAULT '보통' CHECK (priority IN ('낮음', '보통', '높음', '긴급')),
    
    -- 알림 내용 (한글)
    title TEXT NOT NULL, -- 한글 제목
    message TEXT NOT NULL, -- 한글 메시지
    summary TEXT, -- 요약 (대시보드용)
    
    -- 상태 관리 (한글)
    status TEXT NOT NULL DEFAULT '미읽음' CHECK (status IN ('미읽음', '읽음', '처리중', '완료', '보류', '취소')),
    
    -- 담당자 관리
    created_by TEXT, -- 생성자 (시스템 또는 사용자 ID)
    assigned_to TEXT, -- 담당 매니저 ID
    assigned_to_name TEXT, -- 담당자명 (캐시)
    
    -- 관련 데이터
    target_table TEXT, -- 관련 테이블명
    target_id TEXT, -- 관련 데이터 ID (TEXT로 통일)
    customer_id TEXT, -- 고객 ID (있는 경우)
    customer_name TEXT, -- 고객명 (캐시)
    customer_phone TEXT, -- 고객 연락처 (캐시)
    
    -- 시간 관리
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    due_date TIMESTAMPTZ, -- 처리 기한
    processed_at TIMESTAMPTZ, -- 처리 완료 시간
    
    -- 추가 정보
    metadata JSONB DEFAULT '{}', -- 상세 데이터
    action_required TEXT, -- 필요한 조치사항 (한글)
    resolution_note TEXT, -- 처리 결과 (한글)
    
    -- 중요도 점수 (정렬용)
    importance_score INTEGER DEFAULT 50 -- 1-100 (높을수록 중요)
);

-- 알림 템플릿 테이블 (한글화)
CREATE TABLE notification_templates (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    
    -- 템플릿 기본 정보
    template_name TEXT NOT NULL, -- '신규예약알림', '결제확인알림' 등
    notification_type TEXT NOT NULL,
    category TEXT NOT NULL,
    
    -- 한글 템플릿
    title_template TEXT NOT NULL, -- '신규 {service_name} 예약: {customer_name}님'
    message_template TEXT NOT NULL, -- 한글 메시지 템플릿
    summary_template TEXT, -- 요약 템플릿
    
    -- 기본 설정
    default_priority TEXT DEFAULT '보통',
    default_importance INTEGER DEFAULT 50,
    auto_assign_department TEXT, -- '예약팀', '고객서비스팀', '결제팀' 등
    expected_response_hours INTEGER DEFAULT 24, -- 예상 응답시간(시간)
    
    -- 활성화 여부
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 매니저 알림 할당 테이블
CREATE TABLE notification_assignments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    
    -- 할당 정보
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    manager_id TEXT NOT NULL, -- 매니저 ID
    manager_name TEXT, -- 매니저명 (캐시)
    department TEXT, -- 담당 부서
    
    -- 할당 상태
    assignment_status TEXT DEFAULT '할당됨' CHECK (assignment_status IN ('할당됨', '진행중', '완료', '이관', '보류')),
    assigned_at TIMESTAMPTZ DEFAULT NOW(),
    started_at TIMESTAMPTZ, -- 처리 시작
    completed_at TIMESTAMPTZ, -- 처리 완료
    
    -- 처리 정보
    work_notes TEXT, -- 작업 메모
    time_spent_minutes INTEGER DEFAULT 0, -- 소요 시간(분)
    
    UNIQUE(notification_id, manager_id)
);

-- 알림 읽음 상태 테이블
CREATE TABLE notification_reads (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    user_id TEXT NOT NULL,
    user_name TEXT, -- 사용자명 (캐시)
    read_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(notification_id, user_id)
);

-- ========================================
-- 3단계: 인덱스 생성
-- ========================================

CREATE INDEX idx_notifications_type ON notifications(notification_type);
CREATE INDEX idx_notifications_category ON notifications(category);
CREATE INDEX idx_notifications_status ON notifications(status);
CREATE INDEX idx_notifications_priority ON notifications(priority);
CREATE INDEX idx_notifications_assigned_to ON notifications(assigned_to);
CREATE INDEX idx_notifications_customer_id ON notifications(customer_id);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);
CREATE INDEX idx_notifications_importance ON notifications(importance_score DESC);
CREATE INDEX idx_notifications_target ON notifications(target_table, target_id);

CREATE INDEX idx_assignments_manager ON notification_assignments(manager_id);
CREATE INDEX idx_assignments_status ON notification_assignments(assignment_status);
CREATE INDEX idx_assignments_department ON notification_assignments(department);

-- ========================================
-- 4단계: RLS 정책 설정
-- ========================================

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_reads ENABLE ROW LEVEL SECURITY;

-- 매니저/관리자 전체 접근
CREATE POLICY "매니저는 모든 알림 조회 가능" ON notifications
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

CREATE POLICY "매니저는 알림 관리 가능" ON notifications
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

-- 템플릿 접근
CREATE POLICY "매니저는 템플릿 조회 가능" ON notification_templates
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

CREATE POLICY "관리자는 템플릿 관리 가능" ON notification_templates
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role = 'admin'
        )
    );

-- 할당 관리
CREATE POLICY "매니저는 자신의 할당 조회 가능" ON notification_assignments
    FOR SELECT TO authenticated
    USING (
        manager_id = auth.uid()::text OR 
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role = 'admin'
        )
    );

CREATE POLICY "매니저는 할당 관리 가능" ON notification_assignments
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id::text = auth.uid()::text 
            AND users.role IN ('manager', 'admin')
        )
    );

-- 읽음 상태
CREATE POLICY "사용자는 자신의 읽음 상태 관리" ON notification_reads
    FOR ALL TO authenticated
    USING (user_id = auth.uid()::text);

-- ========================================
-- 5단계: 기본 템플릿 데이터 삽입 (한글화)
-- ========================================

INSERT INTO notification_templates (
    template_name, notification_type, category, 
    title_template, message_template, summary_template,
    default_priority, default_importance, auto_assign_department, expected_response_hours
) VALUES 
-- 업무 알림 템플릿
('신규예약알림', '업무알림', '신규예약', 
 '신규 {service_name} 예약: {customer_name}님', 
 '{customer_name}님의 {service_name} 예약이 접수되었습니다.\n예약번호: {reservation_id}\n예약일: {reservation_date}\n금액: {amount:,}원\n\n확인 및 처리 부탁드립니다.',
 '{customer_name}님 {service_name} 예약 ({amount:,}원)',
 '보통', 70, '예약팀', 2),

('결제확인알림', '업무알림', '결제확인',
 '결제 확인 필요: {customer_name}님 {amount:,}원',
 '{customer_name}님의 결제 확인이 필요합니다.\n결제금액: {amount:,}원\n결제방법: {payment_method}\n예약번호: {reservation_id}\n\n결제 확인 후 예약 승인 처리 부탁드립니다.',
 '{customer_name}님 결제확인 ({amount:,}원)',
 '높음', 80, '결제팀', 1),

('견적승인요청', '업무알림', '견적승인',
 '견적 승인 요청: {quote_title}',
 '견적 승인이 요청되었습니다.\n견적명: {quote_title}\n고객: {customer_name}님\n총 금액: {total_amount:,}원\n\n검토 후 승인 처리 부탁드립니다.',
 '{quote_title} 승인요청 ({total_amount:,}원)',
 '보통', 60, '영업팀', 4),

-- 고객 알림 템플릿
('고객문의접수', '고객알림', '고객문의',
 '고객 문의: {customer_name}님 ({inquiry_type})',
 '{customer_name}님의 문의가 접수되었습니다.\n문의유형: {inquiry_type}\n연락처: {customer_phone}\n\n문의내용:\n{inquiry_message}\n\n신속한 답변 부탁드립니다.',
 '{customer_name}님 {inquiry_type} 문의',
 '보통', 65, '고객서비스팀', 4),

('예약취소요청', '고객알림', '예약취소',
 '예약 취소 요청: {customer_name}님',
 '{customer_name}님의 예약 취소 요청입니다.\n예약번호: {reservation_id}\n서비스: {service_name}\n취소사유: {cancel_reason}\n\n취소 처리 및 환불 확인 부탁드립니다.',
 '{customer_name}님 예약취소 요청',
 '높음', 85, '고객서비스팀', 2),

('고객불만접수', '고객알림', '고객불만',
 '🚨 고객 불만: {customer_name}님 (긴급)',
 '{customer_name}님의 불만이 접수되었습니다.\n연락처: {customer_phone}\n\n불만내용:\n{complaint_message}\n\n⚠️ 긴급 처리가 필요합니다. 즉시 대응 부탁드립니다.',
 '{customer_name}님 불만접수 (긴급)',
 '긴급', 95, '고객서비스팀', 1),

('환불요청', '고객알림', '환불처리',
 '환불 요청: {customer_name}님 {amount:,}원',
 '{customer_name}님의 환불 요청입니다.\n환불금액: {amount:,}원\n예약번호: {reservation_id}\n환불사유: {refund_reason}\n\n환불 처리 부탁드립니다.',
 '{customer_name}님 환불요청 ({amount:,}원)',
 '높음', 80, '결제팀', 2),

-- 시스템 알림 템플릿
('시스템점검안내', '시스템알림', '시스템점검',
 '시스템 점검 예정: {maintenance_date}',
 '시스템 점검이 예정되어 있습니다.\n점검일시: {maintenance_date}\n예상소요시간: {duration}시간\n점검내용: {maintenance_scope}\n\n사전 준비 및 고객 안내 부탁드립니다.',
 '{maintenance_date} 시스템점검',
 '보통', 50, 'IT팀', 24),

('일일매출보고', '업무알림', '매출보고',
 '일일 매출 보고 ({report_date})',
 '오늘 매출 현황을 보고드립니다.\n\n📊 매출 현황:\n- 총 매출: {total_sales:,}원\n- 예약 건수: {reservation_count}건\n- 평균 단가: {average_amount:,}원\n\n상세 내역은 관리 시스템에서 확인하세요.',
 '일일매출 {total_sales:,}원 ({reservation_count}건)',
 '낮음', 30, '영업팀', 24);

-- ========================================
-- 6단계: 알림 관리 함수들 (한글화)
-- ========================================

-- 알림 생성 함수 (한글화)
CREATE OR REPLACE FUNCTION create_korean_notification(
    p_template_name TEXT,
    p_variables JSONB DEFAULT '{}',
    p_customer_id TEXT DEFAULT NULL,
    p_target_table TEXT DEFAULT NULL,
    p_target_id TEXT DEFAULT NULL,
    p_assigned_to TEXT DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    template_rec RECORD;
    notification_id UUID;
    final_title TEXT;
    final_message TEXT;
    final_summary TEXT;
    var_key TEXT;
    var_value TEXT;
BEGIN
    -- 템플릿 조회
    SELECT * INTO template_rec 
    FROM notification_templates 
    WHERE template_name = p_template_name AND is_active = TRUE;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION '템플릿을 찾을 수 없습니다: %', p_template_name;
    END IF;
    
    -- 변수 치환
    final_title := template_rec.title_template;
    final_message := template_rec.message_template;
    final_summary := template_rec.summary_template;
    
    FOR var_key, var_value IN SELECT * FROM jsonb_each_text(p_variables)
    LOOP
        final_title := REPLACE(final_title, '{' || var_key || '}', var_value);
        final_message := REPLACE(final_message, '{' || var_key || '}', var_value);
        final_summary := REPLACE(final_summary, '{' || var_key || '}', var_value);
    END LOOP;
    
    -- 알림 생성
    INSERT INTO notifications (
        notification_type, category, title, message, summary,
        priority, target_table, target_id, customer_id,
        assigned_to, importance_score, metadata, created_at
    ) VALUES (
        template_rec.notification_type,
        template_rec.category,
        final_title,
        final_message,
        final_summary,
        template_rec.default_priority,
        p_target_table,
        p_target_id,
        p_customer_id,
        p_assigned_to,
        template_rec.default_importance,
        p_variables,
        NOW()
    ) RETURNING id INTO notification_id;
    
    -- 매니저 할당 (있는 경우)
    IF p_assigned_to IS NOT NULL THEN
        INSERT INTO notification_assignments (
            notification_id, manager_id, department
        ) VALUES (
            notification_id, p_assigned_to, template_rec.auto_assign_department
        );
    END IF;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 알림 상태 업데이트 함수 (한글화)
CREATE OR REPLACE FUNCTION update_korean_notification_status(
    p_notification_id UUID,
    p_status TEXT,
    p_manager_id TEXT DEFAULT NULL,
    p_resolution_note TEXT DEFAULT NULL
) RETURNS BOOLEAN AS $$
BEGIN
    -- 알림 상태 업데이트
    UPDATE notifications 
    SET 
        status = p_status,
        updated_at = NOW(),
        processed_at = CASE 
            WHEN p_status IN ('완료', '취소') THEN NOW() 
            ELSE processed_at 
        END,
        resolution_note = COALESCE(p_resolution_note, resolution_note)
    WHERE id = p_notification_id;
    
    -- 할당 상태 업데이트
    IF p_manager_id IS NOT NULL THEN
        UPDATE notification_assignments
        SET 
            assignment_status = CASE
                WHEN p_status = '처리중' THEN '진행중'
                WHEN p_status = '완료' THEN '완료'
                WHEN p_status = '보류' THEN '보류'
                ELSE assignment_status
            END,
            started_at = CASE 
                WHEN p_status = '처리중' AND started_at IS NULL THEN NOW()
                ELSE started_at
            END,
            completed_at = CASE 
                WHEN p_status = '완료' THEN NOW()
                ELSE completed_at
            END
        WHERE notification_id = p_notification_id AND manager_id = p_manager_id;
        
        -- 읽음 상태 기록
        INSERT INTO notification_reads (notification_id, user_id)
        VALUES (p_notification_id, p_manager_id)
        ON CONFLICT (notification_id, user_id) DO NOTHING;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================================
-- 7단계: customer_requests 트리거 연동 (한글화)
-- ========================================

-- customer_requests 알림 트리거 함수 (한글화)
CREATE OR REPLACE FUNCTION fn_create_customer_request_korean_notification()
RETURNS TRIGGER AS $$
DECLARE
    template_name TEXT;
    variables JSONB;
    customer_info RECORD;
BEGIN
    -- 고객 정보 조회
    SELECT name, phone_number, email INTO customer_info
    FROM users WHERE id = NEW.user_id::uuid;
    
    -- 요청 유형별 템플릿 결정
    template_name := CASE NEW.request_type
        WHEN 'quote_modification' THEN '견적수정요청'
        WHEN 'reservation_modification' THEN '예약변경요청'
        WHEN 'service_inquiry' THEN '고객문의접수'
        WHEN 'complaint' THEN '고객불만접수'
        WHEN 'cancellation' THEN '예약취소요청'
        WHEN 'additional_service' THEN '추가서비스요청'
        ELSE '고객문의접수'
    END;
    
    -- 변수 설정
    variables := jsonb_build_object(
        'customer_name', COALESCE(customer_info.name, '고객'),
        'customer_phone', COALESCE(customer_info.phone_number, ''),
        'inquiry_type', NEW.request_category,
        'inquiry_message', NEW.description,
        'request_id', NEW.request_id,
        'urgency_level', CASE NEW.urgency_level
            WHEN 'urgent' THEN '긴급'
            WHEN 'high' THEN '높음'
            WHEN 'normal' THEN '보통'
            ELSE '낮음'
        END
    );
    
    -- 한글 알림 생성
    PERFORM create_korean_notification(
        template_name,
        variables,
        NEW.user_id,
        'customer_requests',
        NEW.id::text,
        NULL -- 자동 할당은 별도 로직으로
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 트리거 생성
DROP TRIGGER IF EXISTS trg_customer_request_korean_notification ON customer_requests;
CREATE TRIGGER trg_customer_request_korean_notification
AFTER INSERT ON customer_requests
FOR EACH ROW EXECUTE FUNCTION fn_create_customer_request_korean_notification();

-- ========================================
-- 완료
-- ========================================

-- 알림: 시스템 구축 완료
SELECT 'Korean notification system setup completed!' as status;
