-- ========================================
-- 🎯 결제 금액 자동 동기화 시스템 추가
-- ========================================
-- 예약 총금액 변경시 결제 테이블의 금액도 자동 업데이트

-- 🔄 1단계: 예약 총금액 변경시 결제 금액 자동 업데이트 함수
CREATE OR REPLACE FUNCTION sync_payment_amount_with_reservation()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- reservation.total_amount가 변경되었을 때만 실행
  IF OLD.total_amount IS DISTINCT FROM NEW.total_amount THEN
    -- 해당 예약의 결제 정보가 있으면 금액 동기화
    UPDATE reservation_payment 
    SET amount = NEW.total_amount,
        updated_at = NOW()
    WHERE reservation_id = NEW.re_id 
      AND payment_status IN ('pending', 'processing'); -- 완료된 결제는 변경하지 않음
    
    -- 로그 출력 (개발환경에서 확인용)
    IF FOUND THEN
      RAISE NOTICE '💰 예약 % 결제 금액이 %동으로 동기화됨', NEW.re_id, NEW.total_amount;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;

-- 🔗 2단계: reservation 테이블에 트리거 연결
DROP TRIGGER IF EXISTS trg_sync_payment_amount ON reservation;
CREATE TRIGGER trg_sync_payment_amount
AFTER UPDATE ON reservation
FOR EACH ROW 
WHEN (OLD.total_amount IS DISTINCT FROM NEW.total_amount)
EXECUTE FUNCTION sync_payment_amount_with_reservation();

-- 🔧 3단계: 기존 결제 데이터 동기화
DO $$
DECLARE
  r RECORD;
  v_updated INTEGER := 0;
BEGIN
  -- 예약 총금액과 결제 금액이 다른 경우 동기화
  FOR r IN 
    SELECT 
      rp.id as payment_id,
      rp.reservation_id,
      rp.amount as current_payment_amount,
      res.total_amount as reservation_total_amount
    FROM reservation_payment rp
    JOIN reservation res ON rp.reservation_id = res.re_id
    WHERE rp.amount != res.total_amount
      AND rp.payment_status IN ('pending', 'processing')
  LOOP
    UPDATE reservation_payment 
    SET amount = r.reservation_total_amount,
        updated_at = NOW()
    WHERE id = r.payment_id;
    
    v_updated := v_updated + 1;
    
    RAISE NOTICE '🔄 결제 % 금액을 %동에서 %동으로 동기화', 
      r.payment_id, r.current_payment_amount, r.reservation_total_amount;
  END LOOP;
  
  RAISE NOTICE '✅ 총 %개 결제의 금액이 동기화되었습니다.', v_updated;
END;
$$;

-- 📊 4단계: 동기화 상태 확인 함수
CREATE OR REPLACE FUNCTION check_payment_amount_sync()
RETURNS TABLE(
  reservation_id UUID,
  reservation_total NUMERIC(14,2),
  payment_amount NUMERIC(12,0),
  is_synced BOOLEAN,
  difference NUMERIC(14,2)
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    res.re_id as reservation_id,
    res.total_amount as reservation_total,
    rp.amount as payment_amount,
    (res.total_amount = rp.amount) as is_synced,
    (res.total_amount - rp.amount) as difference
  FROM reservation res
  JOIN reservation_payment rp ON res.re_id = rp.reservation_id
  WHERE rp.payment_status IN ('pending', 'processing')
  ORDER BY ABS(res.total_amount - rp.amount) DESC;
END;
$$;

-- 🎯 5단계: 수동 동기화 함수 (필요시 사용)
CREATE OR REPLACE FUNCTION sync_all_payment_amounts()
RETURNS TABLE(
  reservation_id UUID,
  old_amount NUMERIC(12,0),
  new_amount NUMERIC(14,2),
  updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_updated INTEGER := 0;
BEGIN
  -- 모든 미완료 결제의 금액을 예약 총금액으로 동기화
  UPDATE reservation_payment 
  SET amount = reservation.total_amount,
      updated_at = NOW()
  FROM reservation
  WHERE reservation_payment.reservation_id = reservation.re_id
    AND reservation_payment.payment_status IN ('pending', 'processing')
    AND reservation_payment.amount != reservation.total_amount;
  
  GET DIAGNOSTICS v_updated = ROW_COUNT;
  
  RAISE NOTICE '✅ 총 %개 결제의 금액이 동기화되었습니다.', v_updated;
  
  -- 동기화된 결과 반환
  RETURN QUERY
  SELECT 
    res.re_id as reservation_id,
    rp.amount as old_amount,
    res.total_amount as new_amount,
    rp.updated_at
  FROM reservation res
  JOIN reservation_payment rp ON res.re_id = rp.reservation_id
  WHERE rp.updated_at >= NOW() - INTERVAL '1 minute'
  ORDER BY rp.updated_at DESC;
END;
$$;

-- ✅ 6단계: 설치 완료 확인
DO $$
DECLARE
  v_total_payments INTEGER;
  v_synced_payments INTEGER;
  v_unsynced_payments INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_total_payments 
  FROM reservation_payment 
  WHERE payment_status IN ('pending', 'processing');
  
  SELECT COUNT(*) INTO v_synced_payments 
  FROM reservation_payment rp
  JOIN reservation res ON rp.reservation_id = res.re_id
  WHERE rp.payment_status IN ('pending', 'processing')
    AND rp.amount = res.total_amount;
  
  v_unsynced_payments := v_total_payments - v_synced_payments;
  
  RAISE NOTICE '';
  RAISE NOTICE '🎉 결제 금액 자동 동기화 시스템 설치 완료!';
  RAISE NOTICE '📊 결제 동기화 현황:';
  RAISE NOTICE '   - 총 활성 결제: %개', v_total_payments;
  RAISE NOTICE '   - 동기화됨: %개', v_synced_payments;
  RAISE NOTICE '   - 동기화 필요: %개', v_unsynced_payments;
  RAISE NOTICE '';
  RAISE NOTICE '✨ 이제 예약 총금액이 변경되면 결제 금액도 자동으로 동기화됩니다!';
  RAISE NOTICE '';
  RAISE NOTICE '🔍 동기화 상태 확인: SELECT * FROM check_payment_amount_sync();';
  RAISE NOTICE '🔄 수동 동기화 실행: SELECT * FROM sync_all_payment_amounts();';
END;
$$;
