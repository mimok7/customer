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

async function cleanupDatabase() {
    console.log('🧹 Supabase 데이터베이스 정리 시작\n');

    try {
        // 1. reservation_cruise 테이블 정리
        console.log('1️⃣ reservation_cruise 테이블 삭제 중...');
        const { error: cruiseError } = await supabase
            .from('reservation_cruise')
            .delete()
            .neq('id', '00000000-0000-0000-0000-000000000000'); // 모든 데이터 삭제

        if (cruiseError) {
            console.error('   ❌ 오류:', cruiseError.message);
        } else {
            console.log('   ✅ 완료\n');
        }

        // 2. reservation 테이블 정리
        console.log('2️⃣ reservation 테이블 삭제 중...');
        const { error: reservationError } = await supabase
            .from('reservation')
            .delete()
            .neq('re_id', '00000000-0000-0000-0000-000000000000');

        if (reservationError) {
            console.error('   ❌ 오류:', reservationError.message);
        } else {
            console.log('   ✅ 완료\n');
        }

        // 3. users 테이블 정리
        console.log('3️⃣ users 테이블 삭제 중...');
        const { error: usersError } = await supabase
            .from('users')
            .delete()
            .neq('id', '00000000-0000-0000-0000-000000000000');

        if (usersError) {
            console.error('   ❌ 오류:', usersError.message);
        } else {
            console.log('   ✅ 완료\n');
        }

        // 4. 결과 확인
        console.log('4️⃣ 정리 결과 확인 중...\n');

        const { count: usersCount } = await supabase
            .from('users')
            .select('*', { count: 'exact', head: true });

        const { count: reservationCount } = await supabase
            .from('reservation')
            .select('*', { count: 'exact', head: true });

        const { count: cruiseCount } = await supabase
            .from('reservation_cruise')
            .select('*', { count: 'exact', head: true });

        console.log('📊 현재 데이터:');
        console.log(`   - users: ${usersCount}개`);
        console.log(`   - reservation: ${reservationCount}개`);
        console.log(`   - reservation_cruise: ${cruiseCount}개\n`);

        console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        console.log('✅ 데이터베이스 정리 완료!\n');
        console.log('📝 다음 단계:');
        console.log('   - Supabase Dashboard → Table Editor로 이동');
        console.log('   - CSV 파일 수동 업로드:');
        console.log('     1. users 테이블 → users-auth.csv');
        console.log('     2. reservation 테이블 → reservations-auth.csv');
        console.log('     3. reservation_cruise 테이블 → reservation-cruise-auth.csv\n');

    } catch (error) {
        console.error('❌ 오류 발생:', error);
    }
}

cleanupDatabase().catch(console.error);
