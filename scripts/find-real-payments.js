const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

async function findRealPayments() {
    console.log('🔍 실제 금액이 있는 결제/예약 찾기...\n');

    try {
        // 1. 0이 아닌 금액의 결제 찾기
        const { data: nonZeroPayments } = await supabase
            .from('reservation_payment')
            .select('*')
            .gt('amount', 0);

        console.log('💰 0이 아닌 금액의 결제:', nonZeroPayments?.length || 0, '건');
        if (nonZeroPayments && nonZeroPayments.length > 0) {
            nonZeroPayments.forEach(p => {
                console.log(`  - ${p.id}: ${p.amount.toLocaleString()}동 (예약: ${p.reservation_id})`);
            });
        }

        // 2. 각 서비스 테이블에서 데이터가 있는지 확인
        const tables = [
            'reservation_cruise',
            'reservation_cruise_car',
            'reservation_airport',
            'reservation_hotel',
            'reservation_rentcar',
            'reservation_tour'
        ];

        console.log('\n📋 서비스 테이블별 데이터 확인:');
        for (const table of tables) {
            const { data, count } = await supabase
                .from(table)
                .select('*', { count: 'exact' })
                .limit(3);

            console.log(`\n${table}: ${count || 0}건`);
            if (data && data.length > 0) {
                console.log('  샘플 데이터:');
                data.forEach((row, idx) => {
                    const keys = Object.keys(row).slice(0, 5); // 처음 5개 컬럼만 표시
                    console.log(`    [${idx + 1}] ${keys.map(k => `${k}=${row[k]}`).join(', ')}`);
                });
            }
        }

        // 3. 실제 금액이 있는 서비스 데이터 찾기
        console.log('\n🔍 금액이 있는 서비스 데이터 검색...');

        const cruiseWithAmount = await supabase
            .from('reservation_cruise')
            .select('*')
            .or('room_total_price.gt.0,unit_price.gt.0')
            .limit(5);

        const cruiseCarWithAmount = await supabase
            .from('reservation_cruise_car')
            .select('*')
            .or('car_total_price.gt.0,unit_price.gt.0')
            .limit(5);

        const airportWithAmount = await supabase
            .from('reservation_airport')
            .select('*')
            .gt('total_price', 0)
            .limit(5);

        console.log('\n💰 금액이 있는 서비스:');
        console.log(`- 크루즈 객실 (금액 있음): ${cruiseWithAmount.data?.length || 0}건`);
        console.log(`- 크루즈 차량 (금액 있음): ${cruiseCarWithAmount.data?.length || 0}건`);
        console.log(`- 공항 서비스 (금액 있음): ${airportWithAmount.data?.length || 0}건`);

        // 4. 샘플 데이터 상세 표시
        if (cruiseWithAmount.data && cruiseWithAmount.data.length > 0) {
            console.log('\n✅ 크루즈 객실 샘플:');
            cruiseWithAmount.data.forEach((c, idx) => {
                console.log(`  [${idx + 1}] 예약: ${c.reservation_id}`);
                console.log(`      room_total_price: ${c.room_total_price}`);
                console.log(`      unit_price: ${c.unit_price}, guest_count: ${c.guest_count}`);
                console.log(`      계산 금액: ${(c.unit_price || 0) * (c.guest_count || 0)}`);
            });
        }

        if (cruiseCarWithAmount.data && cruiseCarWithAmount.data.length > 0) {
            console.log('\n🚗 크루즈 차량 샘플:');
            cruiseCarWithAmount.data.forEach((c, idx) => {
                console.log(`  [${idx + 1}] 예약: ${c.reservation_id}`);
                console.log(`      car_total_price: ${c.car_total_price}`);
                console.log(`      unit_price: ${c.unit_price}, passenger_count: ${c.passenger_count}`);
                console.log(`      계산 금액: ${(c.unit_price || 0) * (c.passenger_count || 0)}`);
            });
        }

        if (airportWithAmount.data && airportWithAmount.data.length > 0) {
            console.log('\n✈️  공항 서비스 샘플:');
            airportWithAmount.data.forEach((a, idx) => {
                console.log(`  [${idx + 1}] 예약: ${a.reservation_id}, 금액: ${a.total_price}`);
            });
        }

    } catch (error) {
        console.error('❌ 오류 발생:', error);
    }
}

findRealPayments();
