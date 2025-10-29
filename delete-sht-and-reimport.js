const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });
require('dotenv').config();

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function main() {
    console.log('🗑️  기존 SHT 예약 데이터 삭제 중...\n');

    // 1. reservation_car_sht 삭제 (외래키 제약)
    const { error: carShtError, data: carShtData } = await supabase
        .from('reservation_car_sht')
        .delete()
        .neq('reservation_id', '00000000-0000-0000-0000-000000000000'); // 모든 데이터

    if (carShtError) {
        console.error('❌ reservation_car_sht 삭제 오류:', carShtError);
    } else {
        console.log('✅ reservation_car_sht 삭제 완료');
    }

    // 2. reservation (re_type='sht') 삭제
    const { error: resError, data: resData } = await supabase
        .from('reservation')
        .delete()
        .eq('re_type', 'sht');

    if (resError) {
        console.error('❌ reservation 삭제 오류:', resError);
    } else {
        console.log('✅ reservation (sht) 삭제 완료');
    }

    // 3. 삭제 확인
    const { data: checkReservations } = await supabase
        .from('reservation')
        .select('re_id')
        .eq('re_type', 'sht');

    const { data: checkCarSht } = await supabase
        .from('reservation_car_sht')
        .select('reservation_id');

    console.log(`\n📊 삭제 후 확인:`);
    console.log(`  - reservation (sht): ${checkReservations?.length || 0}건`);
    console.log(`  - reservation_car_sht: ${checkCarSht?.length || 0}건`);

    if ((checkReservations?.length || 0) === 0 && (checkCarSht?.length || 0) === 0) {
        console.log('\n✅ 모든 SHT 데이터 삭제 완료!\n');
        console.log('이제 import 스크립트를 실행하세요:');
        console.log('  node scripts/import-sht-car-from-sh-cc.js');
    }
}

main().catch(console.error);
