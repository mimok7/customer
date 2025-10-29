// 현재 데이터베이스 SHT 예약 상태 확인
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

async function checkCurrentData() {
    console.log('📊 현재 데이터베이스 SHT 예약 상태 확인\n');

    try {
        // reservation 테이블 확인
        const { data: reservations, error: resError } = await supabase
            .from('reservation')
            .select('re_id, re_type, re_user_id, re_quote_id, re_created_at')
            .eq('re_type', 'sht');

        if (resError) {
            console.error('❌ reservation 조회 오류:', resError);
            return;
        }

        console.log(`✅ reservation 테이블 (re_type='sht'): ${reservations?.length || 0}건\n`);

        if (reservations && reservations.length > 0) {
            const reservationIds = reservations.map(r => r.re_id);

            // reservation_car_sht 확인
            const { data: carShtData, error: carShtError } = await supabase
                .from('reservation_car_sht')
                .select('id, reservation_id, vehicle_number, seat_number, usage_date, sht_category')
                .in('reservation_id', reservationIds);

            if (carShtError) {
                console.error('❌ reservation_car_sht 조회 오류:', carShtError);
            } else {
                console.log(`✅ reservation_car_sht 테이블: ${carShtData?.length || 0}건\n`);

                // 카테고리별 통계
                const categoryStats = {};
                carShtData?.forEach(item => {
                    const cat = item.sht_category || '미분류';
                    categoryStats[cat] = (categoryStats[cat] || 0) + 1;
                });

                console.log('📋 카테고리별 통계:');
                Object.entries(categoryStats).forEach(([cat, count]) => {
                    console.log(`  - ${cat}: ${count}건`);
                });

                // 날짜 범위 확인
                if (carShtData && carShtData.length > 0) {
                    const dates = carShtData
                        .map(d => d.usage_date)
                        .filter(Boolean)
                        .sort();

                    if (dates.length > 0) {
                        console.log('\n📅 사용일 범위:');
                        console.log(`  - 최소: ${dates[0]}`);
                        console.log(`  - 최대: ${dates[dates.length - 1]}`);
                    }
                }
            }
        } else {
            console.log('ℹ️ 현재 데이터베이스에 SHT 예약 데이터가 없습니다.\n');
        }

        console.log('\n' + '='.repeat(60));
        console.log('📌 요약');
        console.log('='.repeat(60));
        console.log(`구글시트 SH_CC: 1235건`);
        console.log(`DB reservation(sht): ${reservations?.length || 0}건`);
        console.log(`차이: ${1235 - (reservations?.length || 0)}건`);
        console.log('='.repeat(60));

    } catch (error) {
        console.error('❌ 예상치 못한 오류:', error);
    }
}

checkCurrentData();
