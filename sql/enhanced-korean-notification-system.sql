-- 한국어화 알림 시스템 점검 및 개선
-- 기존 알림 테이블 구조를 유지하면서 한국어 메시지 및 매니저 처리 시스템 강화

-- 1. 알림 메시지 한국어화 함수
CREATE OR REPLACE FUNCTION get_korean_notification_message(
    p_type TEXT,
    p_category TEXT,
    p_metadata JSONB DEFAULT '{}'::jsonb
) RETURNS TABLE(
    title TEXT,
    message TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        CASE 
            -- 고객 요청사항 관련
            WHEN p_type = 'customer' AND p_category = '견적수정요청' THEN '💼 견적 수정 요청'
            WHEN p_type = 'customer' AND p_category = '예약변경요청' THEN '📅 예약 변경 요청'
            WHEN p_type = 'customer' AND p_category = '서비스문의' THEN '❓ 서비스 문의'
            WHEN p_type = 'customer' AND p_category = '불만접수' THEN '⚠️ 고객 불만 접수'
            WHEN p_type = 'customer' AND p_category = '취소요청' THEN '❌ 취소 요청'
            WHEN p_type = 'customer' AND p_category = '추가서비스요청' THEN '➕ 추가 서비스 요청'
            
            -- 예약 관련
            WHEN p_type = 'business' AND p_category = '새로운예약' THEN '🎉 새로운 예약 접수'
            WHEN p_type = 'business' AND p_category = '예약승인필요' THEN '✅ 예약 승인 필요'
            WHEN p_type = 'business' AND p_category = '결제확인' THEN '💰 결제 확인 필요'
            WHEN p_type = 'business' AND p_category = '예약변경' THEN '🔄 예약 내용 변경'
            
            -- 시스템 관련
            WHEN p_type = 'business' AND p_category = '시스템점검' THEN '🔧 시스템 점검 안내'
            WHEN p_type = 'business' AND p_category = '일정관리' THEN '📋 일정 관리 알림'
            
            ELSE p_category
        END::TEXT,
        
        CASE 
            -- 고객 요청사항 메시지
            WHEN p_type = 'customer' AND p_category = '견적수정요청' THEN 
                format('고객이 견적 수정을 요청했습니다. 견적번호: %s, 고객명: %s', 
                       COALESCE(p_metadata->>'quote_id', '미확인'), 
                       COALESCE(p_metadata->>'customer_name', '미확인'))
            WHEN p_type = 'customer' AND p_category = '예약변경요청' THEN 
                format('고객이 예약 변경을 요청했습니다. 예약번호: %s, 고객명: %s', 
                       COALESCE(p_metadata->>'reservation_id', '미확인'), 
                       COALESCE(p_metadata->>'customer_name', '미확인'))
            WHEN p_type = 'customer' AND p_category = '서비스문의' THEN 
                format('고객 서비스 문의가 접수되었습니다. 문의유형: %s', 
                       COALESCE(p_metadata->>'inquiry_type', '일반문의'))
            WHEN p_type = 'customer' AND p_category = '불만접수' THEN 
                format('고객 불만이 접수되었습니다. 긴급도: %s, 즉시 처리가 필요합니다.', 
                       COALESCE(p_metadata->>'urgency_level', '보통'))
            WHEN p_type = 'customer' AND p_category = '취소요청' THEN 
                format('고객이 취소를 요청했습니다. 서비스: %s, 취소 사유 확인이 필요합니다.', 
                       COALESCE(p_metadata->>'service_type', '미확인'))
            
            -- 업무 관련 메시지
            WHEN p_type = 'business' AND p_category = '새로운예약' THEN 
                format('새로운 예약이 접수되었습니다. 서비스: %s, 예약일: %s', 
                       COALESCE(p_metadata->>'service_type', '미확인'),
                       COALESCE(p_metadata->>'reservation_date', '미확인'))
            WHEN p_type = 'business' AND p_category = '예약승인필요' THEN 
                format('예약 승인이 필요합니다. 예약번호: %s, 고객명: %s', 
                       COALESCE(p_metadata->>'reservation_id', '미확인'),
                       COALESCE(p_metadata->>'customer_name', '미확인'))
            WHEN p_type = 'business' AND p_category = '결제확인' THEN 
                format('결제 확인이 필요합니다. 금액: %s원, 결제방법: %s', 
                       COALESCE(p_metadata->>'amount', '미확인'),
                       COALESCE(p_metadata->>'payment_method', '미확인'))
            
            ELSE '알림 내용을 확인해 주세요.'
        END::TEXT;
END;
$$ LANGUAGE plpgsql;

-- 2. 매니저 자동 배정 함수
CREATE OR REPLACE FUNCTION assign_notification_to_manager(
    p_notification_id UUID,
    p_category TEXT,
    p_metadata JSONB DEFAULT '{}'::jsonb
) RETURNS UUID AS $$
DECLARE
    v_assigned_manager_id UUID;
BEGIN
    -- 카테고리별 매니저 자동 배정 로직
    SELECT id INTO v_assigned_manager_id
    FROM users 
    WHERE role IN ('manager', 'admin') 
    AND status = 'active'
    AND CASE 
        -- 예약 관련은 예약 담당 매니저
        WHEN p_category IN ('새로운예약', '예약변경요청', '예약승인필요') THEN 
            jsonb_extract_path_text(raw_user_meta_data, 'department') = 'reservation'
        -- 결제 관련은 결제 담당 매니저
        WHEN p_category IN ('결제확인', '환불요청') THEN 
            jsonb_extract_path_text(raw_user_meta_data, 'department') = 'payment'
        -- 고객 서비스 관련은 CS 담당 매니저
        WHEN p_category IN ('서비스문의', '불만접수', '취소요청') THEN 
            jsonb_extract_path_text(raw_user_meta_data, 'department') = 'customer_service'
        -- 기타는 일반 매니저
        ELSE TRUE
    END
    ORDER BY 
        -- 긴급도가 높은 경우 관리자 우선
        CASE WHEN p_metadata->>'urgency_level' = 'urgent' THEN 
            CASE WHEN role = 'admin' THEN 1 ELSE 2 END
        ELSE 
            CASE WHEN role = 'manager' THEN 1 ELSE 2 END
        END,
        created_at ASC -- 가입이 빠른 순서로
    LIMIT 1;
    
    -- 배정된 매니저가 없으면 첫 번째 관리자에게 배정
    IF v_assigned_manager_id IS NULL THEN
        SELECT id INTO v_assigned_manager_id
        FROM users 
        WHERE role = 'admin' 
        AND status = 'active'
        ORDER BY created_at ASC
        LIMIT 1;
    END IF;
    
    -- 알림에 매니저 배정
    UPDATE notifications 
    SET assigned_to = v_assigned_manager_id,
        updated_at = NOW()
    WHERE id = p_notification_id;
    
    RETURN v_assigned_manager_id;
END;
$$ LANGUAGE plpgsql;

-- 3. 알림 생성 통합 함수 (한국어 메시지 + 매니저 배정)
CREATE OR REPLACE FUNCTION create_korean_notification(
    p_type TEXT,
    p_category TEXT,
    p_target_id TEXT DEFAULT NULL,
    p_target_table TEXT DEFAULT NULL,
    p_priority TEXT DEFAULT 'normal',
    p_metadata JSONB DEFAULT '{}'::jsonb,
    p_created_by UUID DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_notification_id UUID;
    v_title TEXT;
    v_message TEXT;
    v_assigned_manager UUID;
BEGIN
    -- 한국어 메시지 생성
    SELECT title, message INTO v_title, v_message
    FROM get_korean_notification_message(p_type, p_category, p_metadata);
    
    -- 알림 생성
    INSERT INTO notifications (
        type, category, title, message, target_id, target_table, 
        priority, status, created_by, metadata, created_at
    ) VALUES (
        p_type, p_category, v_title, v_message, p_target_id, p_target_table,
        p_priority, 'unread', p_created_by, p_metadata, NOW()
    ) RETURNING id INTO v_notification_id;
    
    -- 매니저 자동 배정
    SELECT assign_notification_to_manager(v_notification_id, p_category, p_metadata) 
    INTO v_assigned_manager;
    
    -- 업무 알림인 경우 상세 정보 추가
    IF p_type = 'business' THEN
        INSERT INTO business_notifications (
            notification_id, business_type, department, urgency_level,
            estimated_duration, required_action, created_at
        ) VALUES (
            v_notification_id,
            CASE 
                WHEN p_category IN ('새로운예약', '예약변경요청', '예약승인필요') THEN 'reservation'
                WHEN p_category IN ('결제확인', '환불요청') THEN 'payment'
                WHEN p_category IN ('서비스문의', '불만접수') THEN 'customer_service'
                ELSE 'general'
            END,
            CASE 
                WHEN p_category IN ('새로운예약', '예약변경요청') THEN 'reservation'
                WHEN p_category IN ('결제확인', '환불요청') THEN 'payment'
                ELSE 'customer_service'
            END,
            CASE 
                WHEN p_metadata->>'urgency_level' = 'urgent' THEN 5
                WHEN p_metadata->>'urgency_level' = 'high' THEN 4
                WHEN p_metadata->>'urgency_level' = 'normal' THEN 3
                WHEN p_metadata->>'urgency_level' = 'low' THEN 2
                ELSE 1
            END,
            CASE 
                WHEN p_category = '불만접수' THEN 60 -- 1시간
                WHEN p_category IN ('견적수정요청', '예약변경요청') THEN 120 -- 2시간
                ELSE 240 -- 4시간
            END,
            CASE 
                WHEN p_category = '견적수정요청' THEN '견적 내용 검토 후 수정안 제시'
                WHEN p_category = '예약변경요청' THEN '변경 가능 여부 확인 후 처리'
                WHEN p_category = '불만접수' THEN '즉시 고객 연락 후 해결 방안 제시'
                WHEN p_category = '결제확인' THEN '결제 내역 확인 후 예약 상태 업데이트'
                ELSE '내용 확인 후 적절한 조치'
            END,
            NOW()
        );
    END IF;
    
    -- 고객 알림인 경우 상세 정보 추가
    IF p_type = 'customer' THEN
        INSERT INTO customer_notifications (
            notification_id, customer_id, customer_name, customer_phone, customer_email,
            inquiry_type, service_type, response_deadline, follow_up_required, created_at
        ) VALUES (
            v_notification_id,
            (p_metadata->>'customer_id')::UUID,
            p_metadata->>'customer_name',
            p_metadata->>'customer_phone',
            p_metadata->>'customer_email',
            p_category,
            p_metadata->>'service_type',
            NOW() + INTERVAL '1 day', -- 기본 24시간 응답 기한
            CASE WHEN p_category IN ('불만접수', '취소요청') THEN TRUE ELSE FALSE END,
            NOW()
        );
    END IF;
    
    RETURN v_notification_id;
END;
$$ LANGUAGE plpgsql;

-- 4. 매니저용 알림 대시보드 뷰
CREATE OR REPLACE VIEW v_manager_notification_dashboard AS
SELECT 
    n.id,
    n.type,
    n.category,
    n.title,
    n.message,
    n.priority,
    n.status,
    n.created_at,
    n.assigned_to,
    u_assigned.name as assigned_manager_name,
    u_created.name as created_by_name,
    
    -- 고객 정보 (고객 알림인 경우)
    cn.customer_name,
    cn.customer_phone,
    cn.customer_email,
    cn.inquiry_type,
    cn.service_type,
    cn.response_deadline,
    
    -- 업무 정보 (업무 알림인 경우)
    bn.business_type,
    bn.department,
    bn.urgency_level,
    bn.estimated_duration,
    bn.required_action,
    
    -- 처리 상태
    CASE 
        WHEN n.status = 'unread' THEN '미처리'
        WHEN n.status = 'read' THEN '확인됨'
        WHEN n.status = 'processing' THEN '처리중'
        WHEN n.status = 'completed' THEN '완료'
        WHEN n.status = 'dismissed' THEN '무시됨'
        ELSE n.status
    END as status_korean,
    
    -- 우선순위 표시
    CASE 
        WHEN n.priority = 'urgent' THEN '🔴 긴급'
        WHEN n.priority = 'high' THEN '🟠 높음'
        WHEN n.priority = 'normal' THEN '🟡 보통'
        WHEN n.priority = 'low' THEN '🟢 낮음'
        ELSE n.priority
    END as priority_korean,
    
    -- 소요 시간
    EXTRACT(EPOCH FROM (NOW() - n.created_at)) / 60 as minutes_elapsed
    
FROM notifications n
LEFT JOIN customer_notifications cn ON n.id = cn.notification_id
LEFT JOIN business_notifications bn ON n.id = bn.notification_id
LEFT JOIN users u_assigned ON n.assigned_to = u_assigned.id
LEFT JOIN users u_created ON n.created_by = u_created.id
WHERE n.status != 'completed'
ORDER BY 
    CASE n.priority
        WHEN 'urgent' THEN 1
        WHEN 'high' THEN 2
        WHEN 'normal' THEN 3
        WHEN 'low' THEN 4
    END,
    n.created_at ASC;

-- 5. 알림 처리 완료 함수
CREATE OR REPLACE FUNCTION complete_notification(
    p_notification_id UUID,
    p_processed_by UUID,
    p_resolution_notes TEXT DEFAULT NULL,
    p_customer_satisfaction INTEGER DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
    v_notification_type TEXT;
BEGIN
    -- 알림 타입 확인
    SELECT type INTO v_notification_type FROM notifications WHERE id = p_notification_id;
    
    -- 알림 상태 업데이트
    UPDATE notifications 
    SET status = 'completed',
        processed_at = NOW(),
        updated_at = NOW()
    WHERE id = p_notification_id;
    
    -- 고객 알림인 경우 추가 정보 업데이트
    IF v_notification_type = 'customer' THEN
        UPDATE customer_notifications 
        SET resolution_notes = p_resolution_notes,
            customer_satisfaction = p_customer_satisfaction,
            updated_at = NOW()
        WHERE notification_id = p_notification_id;
    END IF;
    
    -- 처리 이력 기록 (customer_request_history 테이블이 있는 경우)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'customer_request_history') THEN
        INSERT INTO customer_request_history (
            request_id, action_type, new_status, action_by, action_note, created_at
        )
        SELECT 
            (n.target_id)::UUID, 'notification_completed', 'completed', 
            p_processed_by, p_resolution_notes, NOW()
        FROM notifications n 
        WHERE n.id = p_notification_id AND n.target_table = 'customer_requests';
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- 6. 샘플 알림 생성 (테스트용)
DO $$
DECLARE
    v_admin_id UUID;
    v_test_notification_id UUID;
BEGIN
    -- 관리자 ID 가져오기
    SELECT id INTO v_admin_id FROM users WHERE role = 'admin' LIMIT 1;
    
    -- 샘플 고객 요청 알림 생성
    SELECT create_korean_notification(
        'customer',
        '견적수정요청',
        'quote_123',
        'quote',
        'high',
        jsonb_build_object(
            'customer_id', v_admin_id,
            'customer_name', '김고객',
            'customer_phone', '010-1234-5678',
            'quote_id', 'quote_123',
            'urgency_level', 'high'
        ),
        v_admin_id
    ) INTO v_test_notification_id;
    
    -- 샘플 업무 알림 생성
    SELECT create_korean_notification(
        'business',
        '새로운예약',
        'reservation_456',
        'reservation',
        'normal',
        jsonb_build_object(
            'reservation_id', 'reservation_456',
            'customer_name', '박예약',
            'service_type', 'cruise',
            'reservation_date', '2025-09-01'
        ),
        v_admin_id
    ) INTO v_test_notification_id;
    
END $$;

-- 7. 권한 설정 (RLS 정책)
DROP POLICY IF EXISTS manager_notification_access ON notifications;
CREATE POLICY manager_notification_access ON notifications
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users u 
            WHERE u.id::text = auth.uid()::text 
            AND u.role IN ('manager', 'admin')
        )
    );

-- 알림 통계 뷰
CREATE OR REPLACE VIEW v_notification_stats AS
SELECT 
    DATE(created_at) as date,
    type,
    category,
    status,
    priority,
    COUNT(*) as count,
    AVG(EXTRACT(EPOCH FROM (COALESCE(processed_at, NOW()) - created_at)) / 60) as avg_processing_minutes
FROM notifications
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at), type, category, status, priority
ORDER BY date DESC, count DESC;
