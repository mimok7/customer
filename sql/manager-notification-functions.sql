-- 매니저용 알림 처리 대시보드 뷰 및 함수들

-- ========================================
-- 매니저용 알림 대시보드 뷰
-- ========================================

-- 1. 전체 알림 요약 뷰
CREATE OR REPLACE VIEW v_notification_summary AS
SELECT 
    notification_type as "알림유형",
    category as "카테고리",
    priority as "우선순위",
    status as "상태",
    COUNT(*) as "건수",
    COUNT(CASE WHEN status = '미읽음' THEN 1 END) as "미읽음",
    COUNT(CASE WHEN status = '처리중' THEN 1 END) as "처리중",
    COUNT(CASE WHEN priority = '긴급' THEN 1 END) as "긴급건수",
    ROUND(AVG(importance_score), 1) as "평균중요도"
FROM notifications
WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY notification_type, category, priority, status
ORDER BY "긴급건수" DESC, "평균중요도" DESC;

-- 2. 매니저별 담당 업무 뷰
CREATE OR REPLACE VIEW v_manager_workload AS
SELECT 
    COALESCE(assigned_to_name, assigned_to, '미할당') as "담당매니저",
    COUNT(*) as "총건수",
    COUNT(CASE WHEN status = '미읽음' THEN 1 END) as "미읽음",
    COUNT(CASE WHEN status = '처리중' THEN 1 END) as "처리중",
    COUNT(CASE WHEN priority = '긴급' THEN 1 END) as "긴급",
    COUNT(CASE WHEN priority = '높음' THEN 1 END) as "높음",
    ROUND(AVG(importance_score), 1) as "평균중요도",
    COUNT(CASE WHEN due_date < NOW() AND status NOT IN ('완료', '취소') THEN 1 END) as "지연건수"
FROM notifications 
WHERE status NOT IN ('완료', '취소')
GROUP BY assigned_to, assigned_to_name
ORDER BY "긴급" DESC, "지연건수" DESC, "평균중요도" DESC;

-- 3. 고객별 알림 현황 뷰
CREATE OR REPLACE VIEW v_customer_notifications AS
SELECT 
    customer_name as "고객명",
    customer_phone as "연락처",
    COUNT(*) as "총알림수",
    COUNT(CASE WHEN status NOT IN ('완료', '취소') THEN 1 END) as "미완료",
    STRING_AGG(DISTINCT category, ', ') as "문의유형들",
    MAX(created_at) as "최근알림",
    COUNT(CASE WHEN priority IN ('긴급', '높음') THEN 1 END) as "중요알림수"
FROM notifications 
WHERE notification_type = '고객알림'
    AND created_at >= CURRENT_DATE - INTERVAL '30 days'
    AND customer_name IS NOT NULL
GROUP BY customer_name, customer_phone
ORDER BY "미완료" DESC, "최근알림" DESC;

-- 4. 일일 알림 통계 뷰
CREATE OR REPLACE VIEW v_daily_notification_stats AS
SELECT 
    DATE(created_at) as "날짜",
    notification_type as "유형",
    COUNT(*) as "생성건수",
    COUNT(CASE WHEN status = '완료' THEN 1 END) as "완료건수",
    ROUND(
        COUNT(CASE WHEN status = '완료' THEN 1 END) * 100.0 / COUNT(*), 1
    ) as "완료율(%)",
    COUNT(CASE WHEN priority = '긴급' THEN 1 END) as "긴급건수",
    ROUND(AVG(
        CASE WHEN processed_at IS NOT NULL 
        THEN EXTRACT(EPOCH FROM (processed_at - created_at))/3600 
        END
    ), 1) as "평균처리시간(시간)"
FROM notifications
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(created_at), notification_type
ORDER BY "날짜" DESC, "유형";

-- ========================================
-- 매니저용 알림 처리 함수들
-- ========================================

-- 알림 일괄 할당 함수
CREATE OR REPLACE FUNCTION assign_notifications_to_manager(
    p_manager_id TEXT,
    p_manager_name TEXT,
    p_department TEXT,
    p_category_filter TEXT DEFAULT NULL,
    p_priority_filter TEXT DEFAULT NULL,
    p_limit INTEGER DEFAULT 10
) RETURNS INTEGER AS $$
DECLARE
    assigned_count INTEGER := 0;
    notification_rec RECORD;
BEGIN
    -- 미할당 알림 중에서 조건에 맞는 것들을 할당
    FOR notification_rec IN 
        SELECT id FROM notifications 
        WHERE assigned_to IS NULL 
            AND status = '미읽음'
            AND (p_category_filter IS NULL OR category = p_category_filter)
            AND (p_priority_filter IS NULL OR priority = p_priority_filter)
        ORDER BY importance_score DESC, created_at ASC
        LIMIT p_limit
    LOOP
        -- 알림에 매니저 할당
        UPDATE notifications 
        SET 
            assigned_to = p_manager_id,
            assigned_to_name = p_manager_name,
            updated_at = NOW()
        WHERE id = notification_rec.id;
        
        -- 할당 테이블에 기록
        INSERT INTO notification_assignments (
            notification_id, manager_id, manager_name, department
        ) VALUES (
            notification_rec.id, p_manager_id, p_manager_name, p_department
        );
        
        assigned_count := assigned_count + 1;
    END LOOP;
    
    RETURN assigned_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 긴급 알림 자동 에스컬레이션 함수
CREATE OR REPLACE FUNCTION escalate_urgent_notifications() RETURNS INTEGER AS $$
DECLARE
    escalated_count INTEGER := 0;
    notification_rec RECORD;
BEGIN
    -- 2시간 이상 미처리된 긴급 알림을 관리자에게 에스컬레이션
    FOR notification_rec IN 
        SELECT n.id, n.title, n.customer_name
        FROM notifications n
        WHERE n.priority = '긴급'
            AND n.status IN ('미읽음', '읽음')
            AND n.created_at < NOW() - INTERVAL '2 hours'
    LOOP
        -- 관리자에게 에스컬레이션 알림 생성
        INSERT INTO notifications (
            notification_type, category, title, message, summary,
            priority, importance_score, target_table, target_id,
            metadata, created_at
        ) VALUES (
            '시스템알림',
            '긴급에스컬레이션',
            '🚨 긴급 알림 에스컬레이션: ' || notification_rec.title,
            '다음 긴급 알림이 2시간 이상 미처리 상태입니다:\n\n' ||
            '원본 알림: ' || notification_rec.title || '\n' ||
            '고객: ' || COALESCE(notification_rec.customer_name, '미상') || '\n\n' ||
            '즉시 확인 및 처리가 필요합니다.',
            '긴급알림 에스컬레이션',
            '긴급',
            100,
            'notifications',
            notification_rec.id::text,
            jsonb_build_object(
                'escalation_type', 'urgent_timeout',
                'original_notification_id', notification_rec.id
            ),
            NOW()
        );
        
        escalated_count := escalated_count + 1;
    END LOOP;
    
    RETURN escalated_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 매니저 성과 분석 함수
CREATE OR REPLACE FUNCTION get_manager_performance(
    p_manager_id TEXT,
    p_days INTEGER DEFAULT 30
) RETURNS TABLE (
    "매니저명" TEXT,
    "처리건수" BIGINT,
    "평균처리시간_시간" NUMERIC,
    "완료율_퍼센트" NUMERIC,
    "고객만족도_평균" NUMERIC,
    "긴급건수" BIGINT,
    "지연건수" BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(assigned_to_name, p_manager_id) as "매니저명",
        COUNT(*) as "처리건수",
        ROUND(AVG(
            CASE WHEN processed_at IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (processed_at - created_at))/3600 
            END
        ), 1) as "평균처리시간_시간",
        ROUND(
            COUNT(CASE WHEN status = '완료' THEN 1 END) * 100.0 / COUNT(*), 1
        ) as "완료율_퍼센트",
        ROUND(AVG(
            CASE WHEN metadata->>'customer_satisfaction' IS NOT NULL 
            THEN (metadata->>'customer_satisfaction')::numeric 
            END
        ), 1) as "고객만족도_평균",
        COUNT(CASE WHEN priority = '긴급' THEN 1 END) as "긴급건수",
        COUNT(CASE WHEN due_date < NOW() AND status NOT IN ('완료', '취소') THEN 1 END) as "지연건수"
    FROM notifications
    WHERE assigned_to = p_manager_id
        AND created_at >= CURRENT_DATE - INTERVAL (p_days || ' days')::INTERVAL
    GROUP BY assigned_to_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 알림 대량 처리 함수
CREATE OR REPLACE FUNCTION bulk_update_notifications(
    p_notification_ids UUID[],
    p_status TEXT,
    p_manager_id TEXT,
    p_resolution_note TEXT DEFAULT NULL
) RETURNS INTEGER AS $$
DECLARE
    updated_count INTEGER := 0;
    notification_id UUID;
BEGIN
    FOREACH notification_id IN ARRAY p_notification_ids
    LOOP
        PERFORM update_korean_notification_status(
            notification_id, p_status, p_manager_id, p_resolution_note
        );
        updated_count := updated_count + 1;
    END LOOP;
    
    RETURN updated_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================================
-- 알림 자동화 및 스케줄링 함수들
-- ========================================

-- 매일 실행할 알림 정리 함수
CREATE OR REPLACE FUNCTION daily_notification_cleanup() RETURNS TEXT AS $$
DECLARE
    deleted_old INTEGER := 0;
    escalated INTEGER := 0;
    result_text TEXT;
BEGIN
    -- 90일 이전 완료된 알림 삭제
    DELETE FROM notifications 
    WHERE status IN ('완료', '취소') 
        AND processed_at < CURRENT_DATE - INTERVAL '90 days';
    GET DIAGNOSTICS deleted_old = ROW_COUNT;
    
    -- 긴급 알림 에스컬레이션 실행
    SELECT escalate_urgent_notifications() INTO escalated;
    
    result_text := FORMAT(
        '일일 알림 정리 완료:\n- 삭제된 이전 알림: %s건\n- 에스컬레이션된 긴급 알림: %s건\n- 실행 시간: %s',
        deleted_old, escalated, NOW()
    );
    
    RETURN result_text;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================================
-- 알림 검색 및 필터링 함수
-- ========================================

-- 고급 알림 검색 함수
CREATE OR REPLACE FUNCTION search_notifications(
    p_search_text TEXT DEFAULT NULL,
    p_notification_type TEXT DEFAULT NULL,
    p_category TEXT DEFAULT NULL,
    p_status TEXT DEFAULT NULL,
    p_priority TEXT DEFAULT NULL,
    p_assigned_to TEXT DEFAULT NULL,
    p_customer_name TEXT DEFAULT NULL,
    p_date_from DATE DEFAULT NULL,
    p_date_to DATE DEFAULT NULL,
    p_limit INTEGER DEFAULT 50,
    p_offset INTEGER DEFAULT 0
) RETURNS TABLE (
    id UUID,
    "알림유형" TEXT,
    "카테고리" TEXT,
    "제목" TEXT,
    "상태" TEXT,
    "우선순위" TEXT,
    "담당자" TEXT,
    "고객명" TEXT,
    "생성일" TIMESTAMPTZ,
    "중요도" INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.id,
        n.notification_type,
        n.category,
        n.title,
        n.status,
        n.priority,
        COALESCE(n.assigned_to_name, n.assigned_to, '미할당'),
        n.customer_name,
        n.created_at,
        n.importance_score
    FROM notifications n
    WHERE (p_search_text IS NULL OR 
           n.title ILIKE '%' || p_search_text || '%' OR 
           n.message ILIKE '%' || p_search_text || '%')
        AND (p_notification_type IS NULL OR n.notification_type = p_notification_type)
        AND (p_category IS NULL OR n.category = p_category)
        AND (p_status IS NULL OR n.status = p_status)
        AND (p_priority IS NULL OR n.priority = p_priority)
        AND (p_assigned_to IS NULL OR n.assigned_to = p_assigned_to)
        AND (p_customer_name IS NULL OR n.customer_name ILIKE '%' || p_customer_name || '%')
        AND (p_date_from IS NULL OR DATE(n.created_at) >= p_date_from)
        AND (p_date_to IS NULL OR DATE(n.created_at) <= p_date_to)
    ORDER BY n.importance_score DESC, n.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 알림 통계 함수
CREATE OR REPLACE FUNCTION get_notification_statistics(
    p_days INTEGER DEFAULT 7
) RETURNS TABLE (
    "통계항목" TEXT,
    "값" TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH stats AS (
        SELECT 
            COUNT(*) as total_notifications,
            COUNT(CASE WHEN status = '미읽음' THEN 1 END) as unread_count,
            COUNT(CASE WHEN priority = '긴급' THEN 1 END) as urgent_count,
            COUNT(CASE WHEN notification_type = '고객알림' THEN 1 END) as customer_count,
            COUNT(CASE WHEN status = '완료' THEN 1 END) as completed_count,
            ROUND(AVG(importance_score), 1) as avg_importance
        FROM notifications
        WHERE created_at >= CURRENT_DATE - INTERVAL (p_days || ' days')::INTERVAL
    )
    SELECT unnest(ARRAY[
        '총 알림 수',
        '미읽음 알림',
        '긴급 알림',
        '고객 알림',
        '완료된 알림',
        '평균 중요도',
        '완료율 (%)'
    ]), unnest(ARRAY[
        total_notifications::TEXT,
        unread_count::TEXT,
        urgent_count::TEXT,
        customer_count::TEXT,
        completed_count::TEXT,
        avg_importance::TEXT,
        ROUND(completed_count * 100.0 / NULLIF(total_notifications, 0), 1)::TEXT
    ])
    FROM stats;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
