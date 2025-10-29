#!/usr/bin/env node
/**
 * SHT 예약 import 결과 확인 스크립트
 */
const { createClient } = require('@supabase/supabase-js');
const dotenv = require('dotenv');
const path = require('path');

// Load environment variables
try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

async function checkImportResults() {
    console.log('🔍 SHT 예약 import 결과 확인\n');

    // 1. 총 건수
    const { count: totalCount } = await supabase
        .from('reservation')
        .select('*', { count: 'exact', head: true })
        .eq('re_type', 'sht');

    console.log(`✅ 총 SHT 예약 건수: ${totalCount}건\n`);

    // 2. 최근 10건 조회
    const { data: reservations, error: reservationError } = await supabase
        .from('reservation')
        .select(`
            re_id,
            re_user_id,
            re_type,
            re_status,
            payment_status,
            total_amount,
            re_created_at
        `)
        .eq('re_type', 'sht')
        .order('re_created_at', { ascending: false })
        .limit(10);

    if (reservationError) {
        console.error('❌ reservation 조회 오류:', reservationError);
        return;
    }

    console.log('📋 최근 SHT 예약 10건:');
    console.table(reservations.map(r => ({
        '예약ID': r.re_id.substring(0, 8) + '...',
        '상태': r.re_status,
        '결제': r.payment_status,
        '금액': r.total_amount,
        '생성일': r.re_created_at.substring(0, 10)
    })));

    // 3. reservation_car_sht 조회
    const { count: carShtCount } = await supabase
        .from('reservation_car_sht')
        .select('*', { count: 'exact', head: true });

    console.log(`\n✅ 차량 상세 데이터: ${carShtCount}건\n`);

    // 4. 샘플 상세 데이터
    const { data: carShtSample, error: carShtError } = await supabase
        .from('reservation_car_sht')
        .select('*')
        .limit(3);

    if (carShtError) {
        console.error('❌ reservation_car_sht 조회 오류:', carShtError);
        return;
    }

    console.log('📋 차량 상세 데이터 샘플 (3건):');
    carShtSample.forEach((car, idx) => {
        console.log(`\n[${idx + 1}] 예약ID: ${car.reservation_id.substring(0, 8)}...`);
        console.log(`   차량: ${car.vehicle_number} | 좌석: ${car.seat_number}`);
        console.log(`   분류: ${car.sht_category}`);
        console.log(`   픽업: ${car.pickup_location || 'N/A'} → 드롭: ${car.dropoff_location || 'N/A'}`);
        console.log(`   인원: ${car.passenger_count}명 | 금액: ${car.car_total_price}동`);
    });

    // 5. 사용자별 예약 통계
    const { data: userStats } = await supabase
        .from('reservation')
        .select('re_user_id')
        .eq('re_type', 'sht');

    const userCountMap = userStats.reduce((acc, r) => {
        acc[r.re_user_id] = (acc[r.re_user_id] || 0) + 1;
        return acc;
    }, {});

    const multipleBookings = Object.values(userCountMap).filter(count => count > 1).length;

    console.log(`\n📊 통계:`);
    console.log(`   - 총 예약자: ${Object.keys(userCountMap).length}명`);
    console.log(`   - 여러 예약한 사용자: ${multipleBookings}명`);
    console.log(`   - 최대 예약 수: ${Math.max(...Object.values(userCountMap))}건`);
}

checkImportResults().then(() => {
    console.log('\n✅ 확인 완료!');
    process.exit(0);
}).catch(err => {
    console.error('\n❌ 오류 발생:', err);
    process.exit(1);
});
