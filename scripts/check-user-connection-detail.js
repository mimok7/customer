// Auth users와 Database users의 연결 구조 확인
require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function checkUserConnection() {
    console.log('🔗 Auth와 Database users 연결 구조 분석\n');

    // 1. Auth users 가져오기
    const { data: authUsers } = await supabase.auth.admin.listUsers();
    console.log('✅ Auth users:', authUsers.users?.length || 0, '개');

    // 2. Database users 가져오기  
    const { data: dbUsers } = await supabase
        .from('users')
        .select('id, email, name, order_id, role');

    console.log('✅ Database users:', dbUsers?.length || 0, '개');

    // 3. ID 매칭 확인
    const authIds = new Set(authUsers.users?.map(u => u.id) || []);
    const dbIds = new Set(dbUsers?.map(u => u.id) || []);

    const matchingIds = [...authIds].filter(id => dbIds.has(id));
    console.log('✅ Auth와 DB에 모두 있는 ID:', matchingIds.length, '개\n');

    // 4. 현재 연결 상태 분석
    console.log('📊 현재 구조 분석:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    if (matchingIds.length === 0) {
        console.log('❌ 문제 발견!');
        console.log('   Auth users와 Database users의 ID가 전혀 연결되어 있지 않습니다.\n');

        console.log('🔍 Auth users 샘플 (로그인 계정):');
        authUsers.users?.slice(0, 3).forEach(u => {
            console.log(`   - ID: ${u.id}`);
            console.log(`     Email: ${u.email}`);
        });

        console.log('\n🔍 Database users 샘플 (예약 데이터):');
        dbUsers?.slice(0, 3).forEach(u => {
            console.log(`   - ID: ${u.id}`);
            console.log(`     Email: ${u.email}`);
            console.log(`     Name: ${u.name}`);
            console.log(`     Order ID: ${u.order_id}`);
        });

        console.log('\n\n💡 현재 시나리오 추측:');
        console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

        // Email로 매칭 가능한지 확인
        const authEmails = new Set(authUsers.users?.map(u => u.email) || []);
        const dbEmails = new Set(dbUsers?.map(u => u.email) || []);
        const matchingEmails = [...authEmails].filter(email => dbEmails.has(email));

        console.log('📧 Email 기준 매칭:', matchingEmails.length, '개');

        if (matchingEmails.length > 0) {
            console.log('\n✅ Email로는 일부 매칭됩니다!');
            console.log('   예시:');
            matchingEmails.slice(0, 3).forEach(email => {
                const authUser = authUsers.users?.find(u => u.email === email);
                const dbUser = dbUsers?.find(u => u.email === email);
                console.log(`   - Email: ${email}`);
                console.log(`     Auth ID: ${authUser?.id}`);
                console.log(`     DB ID: ${dbUser?.id}`);
                console.log(`     DB Name: ${dbUser?.name}`);
            });
        }

        console.log('\n\n🎯 결론:');
        console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

        console.log('현재 구조는 두 가지 시나리오 중 하나입니다:\n');

        console.log('📌 시나리오 1: 완전 분리 시스템');
        console.log('   - Auth users: 관리자/매니저만 (50개)');
        console.log('   - DB users: Google Sheets 고객 데이터만 (2,151개)');
        console.log('   - 고객은 로그인 없이 견적/예약 조회 (주문ID 기반)');
        console.log('   - 이 경우: CSV 재업로드 안전 ✅\n');

        console.log('📌 시나리오 2: 통합 시스템 (문제 있음)');
        console.log('   - Auth users: 일부 고객도 로그인 가능해야 함');
        console.log('   - DB users: Auth users.id와 일치해야 함');
        console.log('   - 현재: ID 불일치로 로그인해도 데이터 못 봄 ❌');
        console.log('   - 이 경우: CSV 재업로드하면 더 악화됨 ⚠️\n');

        console.log('\n🔍 copilot-instructions.md 확인 필요:');
        console.log('   - 사용자 구분: 견적자(Guest) vs 예약자(Member)');
        console.log('   - 견적자는 Supabase 인증만, users 테이블 등록 없음');
        console.log('   - 예약자는 예약 시점에 users 테이블 등록');
        console.log('   - 따라서 Auth.id = users.id 여야 함!');

    } else {
        console.log('✅ 정상 연결됨');
        console.log('   Auth users와 Database users가 ID로 연결되어 있습니다.\n');

        console.log('🔗 연결된 사용자 샘플:');
        matchingIds.slice(0, 5).forEach(id => {
            const authUser = authUsers.users?.find(u => u.id === id);
            const dbUser = dbUsers?.find(u => u.id === id);
            console.log(`   - ID: ${id}`);
            console.log(`     Auth Email: ${authUser?.email}`);
            console.log(`     DB Name: ${dbUser?.name}`);
            console.log(`     DB Role: ${dbUser?.role}`);
        });

        console.log('\n⚠️  이 경우 CSV 재업로드 시 주의 필요!');
    }

    // 5. 예약 데이터 확인
    console.log('\n\n📦 예약 데이터 확인:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    const { data: reservations } = await supabase
        .from('reservation')
        .select('re_id, re_user_id, order_id')
        .limit(5);

    console.log('예약 샘플:');
    reservations?.forEach(r => {
        const dbUser = dbUsers?.find(u => u.id === r.re_user_id);
        const isAuthUser = authIds.has(r.re_user_id);
        console.log(`   - Reservation ID: ${r.re_id}`);
        console.log(`     User ID: ${r.re_user_id}`);
        console.log(`     Order ID: ${r.order_id}`);
        console.log(`     DB Name: ${dbUser?.name || '(없음)'}`);
        console.log(`     Auth 계정 여부: ${isAuthUser ? 'YES (로그인 가능)' : 'NO (로그인 불가)'}`);
    });
}

checkUserConnection().catch(console.error);
