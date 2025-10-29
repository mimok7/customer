-- create_reservation_notification 함수 수정
-- phone → phone_number로 변경

CREATE OR REPLACE FUNCTION public.create_reservation_notification(p_reservation_id uuid, p_user_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    reservation_rec RECORD;
    user_rec RECORD;
    notification_id UUID;
    title_text TEXT;
    message_text TEXT;
    service_name TEXT;
    quote_title TEXT;
BEGIN
    -- 예약 정보 조회
    SELECT re_id, re_user_id, re_quote_id, re_type, re_status, total_amount
    INTO reservation_rec
    FROM reservation 
    WHERE re_id = p_reservation_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION '예약을 찾을 수 없습니다: %', p_reservation_id;
    END IF;
    
    -- 사용자 정보 조회 (phone → phone_number로 수정)
    SELECT name, email, phone_number as phone
    INTO user_rec
    FROM users 
    WHERE id = COALESCE(p_user_id, reservation_rec.re_user_id);
    
    -- 견적 제목 조회 (있는 경우)
    quote_title := '연결된 견적 없음';
    IF reservation_rec.re_quote_id IS NOT NULL THEN
        SELECT title INTO quote_title
        FROM quote 
        WHERE id = reservation_rec.re_quote_id;
        
        IF quote_title IS NULL THEN
            quote_title := '연결된 견적 없음';
        END IF;
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
        quote_title,
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
        title_text,
        message_text,
        '신규신청',
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
$function$;
