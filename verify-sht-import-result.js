const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });
require('dotenv').config();

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function main() {
    console.log('📊 이관 결과 상세 확인\n');

    // 1. reservation (re_type='sht') 개수
    const { data: reservations, error: resError } = await supabase
        .from('reservation')
        .select('re_id, re_user_id, re_status, payment_status, re_created_at')
        .eq('re_type', 'sht');

    if (resError) {
        console.error('❌ reservation 조회 오류:', resError);
        return;
    }

    console.log(`✅ reservation (sht): ${reservations.length}건`);
    console.log(`  - 샘플 5건:`);
    reservations.slice(0, 5).forEach((r, i) => {
        console.log(`    ${i + 1}. ${r.re_id} | status: ${r.re_status} | payment: ${r.payment_status}`);
    });

    // 2. reservation_car_sht 개수
    const { data: carSht, error: carShtError } = await supabase
        .from('reservation_car_sht')
        .select('reservation_id, vehicle_number, seat_number, sht_category, usage_date');

    if (carShtError) {
        console.error('\n❌ reservation_car_sht 조회 오류:', carShtError);
        return;
    }

    console.log(`\n✅ reservation_car_sht: ${carSht.length}건`);
    console.log(`  - 샘플 5건:`);
    carSht.slice(0, 5).forEach((c, i) => {
        console.log(`    ${i + 1}. 차량: ${c.vehicle_number} | 좌석: ${c.seat_number} | 분류: ${c.sht_category}`);
    });

    // 3. 통계
    console.log('\n\n============================================================');
    console.log('📊 이관 통계');
    console.log('============================================================');
    console.log(`총 SH_CC 데이터: 1,235건`);
    console.log(`이관 성공: ${reservations.length}건 (${((reservations.length / 1235) * 100).toFixed(1)}%)`);
    console.log(`건너뜀 (매핑 없음): ${1235 - reservations.length}건`);
    console.log(`\nreservation ↔ reservation_car_sht 매칭: ${reservations.length === carSht.length ? '✅ 일치' : '❌ 불일치'}`);
    console.log('============================================================');
}

main().catch(console.error);
