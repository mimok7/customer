-- ========================================
-- 🧪 예약 총금액 자동계산 시스템 테스트
-- ========================================

-- 🔍 1. 시스템 상태 확인
SELECT 
    '시스템 상태 확인' as test_step,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reservation' AND column_name = 'total_amount')
        THEN '✅ total_amount 컬럼 존재'
        ELSE '❌ total_amount 컬럼 없음'
    END as total_amount_column,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.routines WHERE routine_name = 'recompute_reservation_total')
        THEN '✅ 자동계산 함수 존재'
        ELSE '❌ 자동계산 함수 없음'
    END as calculation_function,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.triggers WHERE trigger_name = 'trg_reservation_cruise_total')
        THEN '✅ 트리거 설정됨'
        ELSE '❌ 트리거 없음'
    END as triggers_setup;

-- 🧮 2. 예약별 금액 계산 확인 (샘플 5개)
SELECT 
    '예약별 금액 확인' as test_step,
    r.re_id,
    r.total_amount as calculated_total,
    -- 수동 계산
    (
        COALESCE((SELECT SUM(COALESCE(room_total_price, unit_price * guest_count)) FROM reservation_cruise WHERE reservation_id = r.re_id), 0) +
        COALESCE((SELECT SUM(COALESCE(car_total_price, 0)) FROM reservation_cruise_car WHERE reservation_id = r.re_id), 0) +
        COALESCE((SELECT SUM(COALESCE(total_price, unit_price * ra_car_count)) FROM reservation_airport WHERE reservation_id = r.re_id), 0) +
        COALESCE((SELECT SUM(COALESCE(total_price, 0)) FROM reservation_hotel WHERE reservation_id = r.re_id), 0) +
        COALESCE((SELECT SUM(COALESCE(total_price, 0)) FROM reservation_tour WHERE reservation_id = r.re_id), 0) +
        COALESCE((SELECT SUM(COALESCE(total_price, unit_price * car_count)) FROM reservation_rentcar WHERE reservation_id = r.re_id), 0)
    ) as manual_total,
    CASE 
        WHEN r.total_amount = (
            COALESCE((SELECT SUM(COALESCE(room_total_price, unit_price * guest_count)) FROM reservation_cruise WHERE reservation_id = r.re_id), 0) +
            COALESCE((SELECT SUM(COALESCE(car_total_price, 0)) FROM reservation_cruise_car WHERE reservation_id = r.re_id), 0) +
            COALESCE((SELECT SUM(COALESCE(total_price, unit_price * ra_car_count)) FROM reservation_airport WHERE reservation_id = r.re_id), 0) +
            COALESCE((SELECT SUM(COALESCE(total_price, 0)) FROM reservation_hotel WHERE reservation_id = r.re_id), 0) +
            COALESCE((SELECT SUM(COALESCE(total_price, 0)) FROM reservation_tour WHERE reservation_id = r.re_id), 0) +
            COALESCE((SELECT SUM(COALESCE(total_price, unit_price * car_count)) FROM reservation_rentcar WHERE reservation_id = r.re_id), 0)
        )
        THEN '✅ 정확'
        ELSE '❌ 불일치'
    END as accuracy_check
FROM reservation r
WHERE r.re_status = 'confirmed'
LIMIT 5;

-- 💳 3. 결제 금액 동기화 확인
SELECT 
    '결제 동기화 확인' as test_step,
    res.re_id as reservation_id,
    res.total_amount as reservation_total,
    rp.amount as payment_amount,
    rp.payment_status,
    CASE 
        WHEN res.total_amount = rp.amount THEN '✅ 동기화됨'
        ELSE '❌ 동기화 필요'
    END as sync_status,
    (res.total_amount - rp.amount) as difference
FROM reservation res
JOIN reservation_payment rp ON res.re_id = rp.reservation_id
WHERE rp.payment_status IN ('pending', 'processing')
ORDER BY ABS(res.total_amount - rp.amount) DESC
LIMIT 5;

-- 📊 4. 전체 통계
SELECT 
    '전체 통계' as test_step,
    (SELECT COUNT(*) FROM reservation) as total_reservations,
    (SELECT COUNT(*) FROM reservation WHERE total_amount > 0) as reservations_with_amount,
    (SELECT COUNT(*) FROM reservation WHERE total_amount = 0) as reservations_without_amount,
    (SELECT COUNT(*) FROM reservation_payment WHERE payment_status IN ('pending', 'processing')) as active_payments,
    (SELECT COUNT(*) 
     FROM reservation_payment rp
     JOIN reservation res ON rp.reservation_id = res.re_id
     WHERE rp.payment_status IN ('pending', 'processing')
       AND rp.amount = res.total_amount) as synced_payments;

-- 🔄 5. 수동 테스트 함수들
-- 특정 예약 재계산 테스트 (실제 reservation_id로 변경 필요)
-- SELECT recompute_reservation_total('실제-UUID-여기에-입력');

-- 모든 결제 동기화 테스트
-- SELECT sync_all_payment_amounts() as synchronized_payments_count;

-- 동기화 상태 상세 확인
-- SELECT * FROM check_payment_amount_sync() LIMIT 10;
