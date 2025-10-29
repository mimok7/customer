require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function cleanDatabase() {
    console.log('🗑️  데이터베이스 초기화 시작\n');
    console.log('⚠️  WARNING: 모든 예약 및 사용자 데이터가 삭제됩니다!\n');

    try {
        // 1. reservation_cruise 삭제
        console.log('1️⃣  reservation_cruise 테이블 삭제 중...');
        const { error: cruiseError } = await supabase
            .from('reservation_cruise')
            .delete()
            .neq('id', '00000000-0000-0000-0000-000000000000');

        if (cruiseError && cruiseError.code !== 'PGRST116') {
            console.error('❌ reservation_cruise 삭제 실패:', cruiseError.message);
        } else {
            console.log('✅ reservation_cruise 삭제 완료\n');
        }

        // 2. reservation 삭제
        console.log('2️⃣  reservation 테이블 삭제 중...');
        const { error: resError } = await supabase
            .from('reservation')
            .delete()
            .neq('re_id', '00000000-0000-0000-0000-000000000000');

        if (resError && resError.code !== 'PGRST116') {
            console.error('❌ reservation 삭제 실패:', resError.message);
        } else {
            console.log('✅ reservation 삭제 완료\n');
        }

        // 3. users 삭제
        console.log('3️⃣  users 테이블 삭제 중...');
        const { error: userError } = await supabase
            .from('users')
            .delete()
            .neq('id', '00000000-0000-0000-0000-000000000000');

        if (userError && userError.code !== 'PGRST116') {
            console.error('❌ users 삭제 실패:', userError.message);
        } else {
            console.log('✅ users 삭제 완료\n');
        }

        // 4. 검증
        console.log('============================================================');
        console.log('🔍 삭제 결과 확인');
        console.log('============================================================\n');

        const { count: userCount } = await supabase
            .from('users')
            .select('*', { count: 'exact', head: true });

        const { count: resCount } = await supabase
            .from('reservation')
            .select('*', { count: 'exact', head: true });

        const { count: cruiseCount } = await supabase
            .from('reservation_cruise')
            .select('*', { count: 'exact', head: true });

        console.log(`users: ${userCount}개`);
        console.log(`reservation: ${resCount}개`);
        console.log(`reservation_cruise: ${cruiseCount}개`);
        console.log('');

        if (userCount === 0 && resCount === 0 && cruiseCount === 0) {
            console.log('✅ 데이터베이스 초기화 완료!\n');
            console.log('📌 이제 migrate-with-room-code.js를 실행하세요.');
        } else {
            console.log('⚠️  일부 데이터가 남아있습니다. SQL에서 TRUNCATE 실행이 필요할 수 있습니다.');
        }

    } catch (error) {
        console.error('❌ 오류 발생:', error);
    }
}

cleanDatabase();
