require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY,
    {
        auth: {
            autoRefreshToken: false,
            persistSession: false
        }
    }
);

async function addMissingCarCodes() {
    console.log('🚀 누락된 차량코드 추가\n');

    const missingCodes = [
        {
            car_code: 'C626',
            cruise: '인도차이나 그랜드',
            car_category: '왕복',
            car_type: '9인승 리무진',
            schedule: '2박3일',
            passenger_count: '6~8인',
            price: 0 // 가격은 나중에 입력
        },
        {
            car_code: 'C630',
            cruise: '인도차이나 그랜드',
            car_category: '편도',
            car_type: '크루즈 셔틀 리무진',
            schedule: '2박3일',
            passenger_count: '2인',
            price: 0
        },
        {
            car_code: 'C632',
            cruise: '인도차이나 그랜드',
            car_category: '편도',
            car_type: '스테이하롱 셔틀 리무진 A',
            schedule: '2박3일',
            passenger_count: '3~4인',
            price: 0
        },
        {
            car_code: 'C636',
            cruise: '인도차이나 그랜드',
            car_category: '왕복',
            car_type: '16인승 리무진',
            schedule: '2박3일',
            passenger_count: '11~15인',
            price: 0
        }
    ];

    console.log('추가할 차량코드:\n');
    missingCodes.forEach(code => {
        console.log(`   ${code.car_code}: ${code.cruise} | ${code.car_type} | ${code.passenger_count}`);
    });

    console.log('\n⚠️  실제 가격은 수동으로 입력해야 합니다.\n');

    const { data, error } = await supabase
        .from('car_price')
        .insert(missingCodes)
        .select();

    if (error) {
        console.error('❌ 오류:', error.message);
    } else {
        console.log(`✅ ${data.length}개 차량코드 추가 완료\n`);

        data.forEach(item => {
            console.log(`   ${item.car_code}: ${item.car_type}`);
        });
    }
}

addMissingCarCodes().catch(console.error);
