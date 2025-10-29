require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error('❌ 환경 변수 누락: NEXT_PUBLIC_SUPABASE_URL 또는 SUPABASE_SERVICE_ROLE_KEY');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkUsersReservationDate() {
    console.log('🔍 users 테이블의 reservation_date 확인 중...\n');

    // 전체 사용자 수
    const { count: totalUsers } = await supabase
        .from('users')
        .select('*', { count: 'exact', head: true });

    console.log(`📊 전체 사용자 수: ${totalUsers}명`);

    // reservation_date가 있는 사용자 수
    const { data: usersWithReservationDate, error } = await supabase
        .from('users')
        .select('id, email, reservation_date')
        .not('reservation_date', 'is', null);

    if (error) {
        console.error('❌ 조회 오류:', error);
        return;
    }

    console.log(`✅ reservation_date가 있는 사용자: ${usersWithReservationDate.length}명\n`);

    if (usersWithReservationDate.length > 0) {
        console.log('📋 샘플 데이터 (최대 10개):');
        console.table(usersWithReservationDate.slice(0, 10));
    } else {
        console.log('⚠️  reservation_date 필드에 데이터가 없습니다!');
        console.log('\n💡 해결 방법:');
        console.log('   1. users 테이블의 reservation_date 필드에 주문ID를 먼저 등록해야 합니다.');
        console.log('   2. 기존 데이터 마이그레이션 스크립트를 실행하세요.');
    }
}

checkUsersReservationDate().catch(console.error);
