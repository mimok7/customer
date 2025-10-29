-- 알림 시스템 강화: 견적/예약/결제 카테고리 분리 및 자동 알림 생성
-- 실행일: 2025.08.26 (SQL Editor용 완전판)

BEGIN;

-- 1. 기존 데이터 확인 및 정리
DO $$ 
DECLARE
    existing_categories TEXT[];
BEGIN
    -- 기존 카테고리 조회
    SELECT ARRAY_AGG(DISTINCT category) INTO existing_categories
    FROM notifications 
    WHERE category IS NOT NULL;
    
    RAISE NOTICE '기존 카테고리: %', existing_categories;
    
    -- 기존 데이터를 새 카테고리 체계에 맞게 업데이트
    UPDATE notifications 
    SET category = CASE 
        WHEN category ILIKE '%quote%' OR category ILIKE '%견적%' THEN '견적'
        WHEN category ILIKE '%reservation%' OR category ILIKE '%예약%' THEN '예약'
        WHEN category ILIKE '%payment%' OR category ILIKE '%결제%' THEN '결제'
        WHEN category ILIKE '%customer%' OR category ILIKE '%고객%' THEN '고객문의'
        WHEN category ILIKE '%system%' OR category ILIKE '%시스템%' THEN '시스템'
        ELSE '기타'
    END
    WHERE category IS NOT NULL;
    
    RAISE NOTICE '기존 데이터 카테고리 정규화 완료';
END $$;

-- 2. notifications 테이블 구조 강화
-- subcategory 컬럼 추가
ALTER TABLE notifications 
ADD COLUMN IF NOT EXISTS subcategory TEXT DEFAULT '일반';

-- customer 정보 컬럼 추가 (없는 경우에만)
ALTER TABLE notifications 
ADD COLUMN IF NOT EXISTS customer_name TEXT;

ALTER TABLE notifications 
ADD COLUMN IF NOT EXISTS customer_email TEXT;

ALTER TABLE notifications 
ADD COLUMN IF NOT EXISTS customer_phone TEXT;

-- 기존 제약 조건 제거
ALTER TABLE notifications 
DROP CONSTRAINT IF EXISTS notifications_category_check;

-- 새로운 카테고리 제약 조건 추가
ALTER TABLE notifications 
ADD CONSTRAINT notifications_category_check 
CHECK (category IN ('견적', '예약', '결제', '고객문의', '시스템', '기타'));

-- 서브카테고리 제약 조건 추가
ALTER TABLE notifications 
ADD CONSTRAINT notifications_subcategory_check 
CHECK (subcategory IN ('승인요청', '신규신청', '변경요청', '취소요청', '결제확인', '연체알림', '일반'));

-- 3. 알림 생성 헬퍼 함수 (한글화)
CREATE OR REPLACE FUNCTION create_business_notification(
    p_category TEXT,
    p_subcategory TEXT DEFAULT '일반',
    p_title TEXT,
    p_message TEXT,
    p_priority TEXT DEFAULT 'normal',
    p_customer_name TEXT DEFAULT NULL,
    p_customer_email TEXT DEFAULT NULL,
    p_customer_phone TEXT DEFAULT NULL,
    p_target_table TEXT DEFAULT NULL,
    p_target_id TEXT DEFAULT NULL,
    p_metadata JSONB DEFAULT '{}'
) RETURNS UUID AS $$
DECLARE
    notification_id UUID;
BEGIN
    INSERT INTO notifications (
        type, category, subcategory, title, message, priority,
        customer_name, customer_email, customer_phone,
        target_table, target_id, metadata,
        created_at, updated_at
    ) VALUES (
        'business',
        p_category,
        p_subcategory,
        p_title,
        p_message,
        p_priority,
        p_customer_name,
        p_customer_email,
        p_customer_phone,
        p_target_table,
        p_target_id,
        p_metadata,
        NOW(),
        NOW()
    ) RETURNING id INTO notification_id;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. 견적 승인 요청 알림 생성 함수
CREATE OR REPLACE FUNCTION create_quote_approval_notification(
    p_quote_id UUID,
    p_user_id UUID
) RETURNS UUID AS $$
DECLARE
    quote_rec RECORD;
    user_rec RECORD;
    notification_id UUID;
    title_text TEXT;
    message_text TEXT;
BEGIN
    -- 견적 정보 조회
    SELECT id, quote_id, title, total_price, status
    INTO quote_rec
    FROM quote 
    WHERE id = p_quote_id OR quote_id = p_quote_id::text;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION '견적을 찾을 수 없습니다: %', p_quote_id;
    END IF;
    
    -- 사용자 정보 조회
    SELECT name, email, phone
    INTO user_rec
    FROM users 
    WHERE id = p_user_id;
    
    -- 제목과 메시지 생성
    title_text := '견적 승인 요청: ' || COALESCE(quote_rec.title, '제목없음');
    message_text := format(
        '고객명: %s
이메일: %s
연락처: %s
견적명: %s
총 금액: %s원
상태: %s

검토 후 승인 처리 부탁드립니다.',
        COALESCE(user_rec.name, '이름없음'),
        COALESCE(user_rec.email, '이메일없음'),
        COALESCE(user_rec.phone, '연락처없음'),
        COALESCE(quote_rec.title, '제목없음'),
        COALESCE(quote_rec.total_price::text, '0'),
        CASE quote_rec.status 
            WHEN 'draft' THEN '작성중'
            WHEN 'submitted' THEN '제출됨'
            WHEN 'pending' THEN '검토중'
            ELSE quote_rec.status
        END
    );
    
    -- 알림 생성
    SELECT create_business_notification(
        '견적',
        '승인요청',
        title_text,
        message_text,
        'high',
        user_rec.name,
        user_rec.email,
        user_rec.phone,
        'quote',
        quote_rec.id::text,
        jsonb_build_object(
            'quote_id', quote_rec.quote_id,
            'user_id', p_user_id,
            'total_price', quote_rec.total_price
        )
    ) INTO notification_id;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. 예약 신청 알림 생성 함수
CREATE OR REPLACE FUNCTION create_reservation_notification(
    p_reservation_id UUID,
    p_user_id UUID
) RETURNS UUID AS $$
DECLARE
    reservation_rec RECORD;
    user_rec RECORD;
    quote_rec RECORD;
    notification_id UUID;
    title_text TEXT;
    message_text TEXT;
    service_name TEXT;
BEGIN
    -- 예약 정보 조회
    SELECT re_id, re_user_id, re_quote_id, re_type, re_status, total_amount
    INTO reservation_rec
    FROM reservation 
    WHERE re_id = p_reservation_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION '예약을 찾을 수 없습니다: %', p_reservation_id;
    END IF;
    
    -- 사용자 정보 조회
    SELECT name, email, phone
    INTO user_rec
    FROM users 
    WHERE id = COALESCE(p_user_id, reservation_rec.re_user_id);
    
    -- 견적 정보 조회 (있는 경우)
    IF reservation_rec.re_quote_id IS NOT NULL THEN
        SELECT title INTO quote_rec
        FROM quote 
        WHERE id = reservation_rec.re_quote_id;
    END IF;
    
    -- 서비스 이름 변환
    service_name := CASE reservation_rec.re_type
        WHEN 'cruise' THEN '크루즈'
        WHEN 'airport' THEN '공항 서비스'
        WHEN 'hotel' THEN '호텔'
        WHEN 'tour' THEN '투어'
        WHEN 'rentcar' THEN '렌터카'
        ELSE reservation_rec.re_type
    END;
    
    -- 제목과 메시지 생성
    title_text := '신규 ' || service_name || ' 예약: ' || COALESCE(user_rec.name, '고객명없음');
    message_text := format(
        '고객명: %s
이메일: %s
연락처: %s
서비스: %s
견적명: %s
예약 금액: %s원
예약 상태: %s

확인 및 처리 부탁드립니다.',
        COALESCE(user_rec.name, '이름없음'),
        COALESCE(user_rec.email, '이메일없음'),
        COALESCE(user_rec.phone, '연락처없음'),
        service_name,
        COALESCE(quote_rec.title, '연결된 견적 없음'),
        COALESCE(reservation_rec.total_amount::text, '0'),
        CASE reservation_rec.re_status
            WHEN 'pending' THEN '대기중'
            WHEN 'confirmed' THEN '확정됨'
            WHEN 'processing' THEN '처리중'
            ELSE reservation_rec.re_status
        END
    );
    
    -- 알림 생성
    SELECT create_business_notification(
        '예약',
        '신규신청',
        title_text,
        message_text,
        'high',
        user_rec.name,
        user_rec.email,
        user_rec.phone,
        'reservation',
        reservation_rec.re_id::text,
        jsonb_build_object(
            'reservation_id', reservation_rec.re_id,
            'user_id', reservation_rec.re_user_id,
            'service_type', reservation_rec.re_type,
            'total_amount', reservation_rec.total_amount
        )
    ) INTO notification_id;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. 결제 신청 알림 생성 함수 (수정: 매개변수 순서 조정)
CREATE OR REPLACE FUNCTION create_payment_notification(
    p_reservation_id UUID,
    p_user_id UUID,
    p_amount NUMERIC,
    p_payment_method TEXT
) RETURNS UUID AS $$
DECLARE
    payment_rec RECORD;
    reservation_rec RECORD;
    user_rec RECORD;
    notification_id UUID;
    title_text TEXT;
    message_text TEXT;
    priority_level TEXT;
BEGIN
    -- 사용자 정보 조회
    SELECT name, email, phone
    INTO user_rec
    FROM users 
    WHERE id = p_user_id;
    
    -- 예약 정보 조회
    SELECT re_type, re_quote_id
    INTO reservation_rec
    FROM reservation 
    WHERE re_id = p_reservation_id;
    
    -- 우선순위 결정 (금액 기준)
    priority_level := CASE 
        WHEN p_amount >= 1000000 THEN 'urgent'
        WHEN p_amount >= 500000 THEN 'high'
        ELSE 'normal'
    END;
    
    -- 제목과 메시지 생성
    title_text := '결제 확인 필요: ' || COALESCE(user_rec.name, '고객명없음') || ' (' || p_amount::text || '원)';
    message_text := format(
        '고객명: %s
이메일: %s
연락처: %s
결제 금액: %s원
결제 방법: %s
서비스: %s

결제 확인 후 예약 승인 처리 부탁드립니다.',
        COALESCE(user_rec.name, '이름없음'),
        COALESCE(user_rec.email, '이메일없음'),
        COALESCE(user_rec.phone, '연락처없음'),
        p_amount::text,
        COALESCE(p_payment_method, '방법없음'),
        CASE reservation_rec.re_type
            WHEN 'cruise' THEN '크루즈'
            WHEN 'airport' THEN '공항 서비스'
            WHEN 'hotel' THEN '호텔'
            WHEN 'tour' THEN '투어'
            WHEN 'rentcar' THEN '렌터카'
            ELSE reservation_rec.re_type
        END
    );
    
    -- 알림 생성
    SELECT create_business_notification(
        '결제',
        '결제확인',
        title_text,
        message_text,
        priority_level,
        user_rec.name,
        user_rec.email,
        user_rec.phone,
        'reservation_payment',
        p_reservation_id::text,
        jsonb_build_object(
            'reservation_id', p_reservation_id,
            'user_id', p_user_id,
            'amount', p_amount,
            'payment_method', p_payment_method
        )
    ) INTO notification_id;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. 트리거 함수들
CREATE OR REPLACE FUNCTION trigger_quote_submission_notification()
RETURNS TRIGGER AS $$
BEGIN
    -- 견적이 submitted 상태로 변경될 때 알림 생성
    IF NEW.status = 'submitted' AND (OLD.status IS NULL OR OLD.status != 'submitted') THEN
        PERFORM create_quote_approval_notification(NEW.id, NEW.user_id::uuid);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION trigger_reservation_creation_notification()
RETURNS TRIGGER AS $$
BEGIN
    -- 새 예약이 생성될 때 알림 생성
    IF TG_OP = 'INSERT' THEN
        PERFORM create_reservation_notification(NEW.re_id, NEW.re_user_id);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION trigger_payment_creation_notification()
RETURNS TRIGGER AS $$
BEGIN
    -- 새 결제가 생성될 때 알림 생성
    IF TG_OP = 'INSERT' AND NEW.payment_status = 'pending' THEN
        PERFORM create_payment_notification(
            NEW.reservation_id, 
            NEW.user_id, 
            NEW.amount, 
            NEW.payment_method
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 8. 트리거 생성
DROP TRIGGER IF EXISTS trg_quote_submission_notification ON quote;
CREATE TRIGGER trg_quote_submission_notification
    AFTER UPDATE ON quote
    FOR EACH ROW
    EXECUTE FUNCTION trigger_quote_submission_notification();

DROP TRIGGER IF EXISTS trg_reservation_creation_notification ON reservation;
CREATE TRIGGER trg_reservation_creation_notification
    AFTER INSERT ON reservation
    FOR EACH ROW
    EXECUTE FUNCTION trigger_reservation_creation_notification();

DROP TRIGGER IF EXISTS trg_payment_creation_notification ON reservation_payment;
CREATE TRIGGER trg_payment_creation_notification
    AFTER INSERT ON reservation_payment
    FOR EACH ROW
    EXECUTE FUNCTION trigger_payment_creation_notification();

-- 9. 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_notifications_category_subcategory ON notifications(category, subcategory);
CREATE INDEX IF NOT EXISTS idx_notifications_customer_info ON notifications(customer_name, customer_email);
CREATE INDEX IF NOT EXISTS idx_notifications_target ON notifications(target_table, target_id);

COMMIT;

-- 사용법 안내
SELECT '✅ 알림 시스템 강화 완료!' as status;
SELECT '📋 카테고리: 견적(승인요청), 예약(신규신청), 결제(결제확인)' as categories;
SELECT '🔔 자동 알림: 견적 제출시, 예약 생성시, 결제 신청시' as auto_notifications;
SELECT '👤 고객 정보: 이름, 이메일, 연락처 포함' as customer_info;
