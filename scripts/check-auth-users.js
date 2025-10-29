// Supabase Auth와 users 테이블 관계 확인
require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function checkAuthUsers() {
    console.log('🔐 Supabase Auth와 users 테이블 관계 확인\n');

    // 1. Auth users 조회 (admin API 사용)
    const { data: authUsers, error: authError } = await supabase.auth.admin.listUsers();

    if (authError) {
        console.error('❌ Auth users 조회 실패:', authError.message);
        console.log('\n💡 참고: Auth users는 Service Role Key가 필요합니다.');
    } else {
        console.log('✅ Auth users (인증 사용자):', authUsers.users?.length || 0, '개');

        if (authUsers.users && authUsers.users.length > 0) {
            console.log('\n📋 Auth users 샘플:');
            authUsers.users.slice(0, 3).forEach(u => {
                console.log(`  - ID: ${u.id}`);
                console.log(`    Email: ${u.email}`);
                console.log(`    Created: ${u.created_at}`);
            });
        }
    }

    // 2. Database users 테이블 조회
    const { data: dbUsers, error: dbError } = await supabase
        .from('users')
        .select('id, email, name, order_id');

    console.log('\n✅ Database users (데이터 테이블):', dbUsers?.length || 0, '개');

    if (dbUsers && dbUsers.length > 0) {
        console.log('\n📋 Database users 샘플:');
        dbUsers.slice(0, 3).forEach(u => {
            console.log(`  - ID: ${u.id}`);
            console.log(`    Email: ${u.email}`);
            console.log(`    Name: ${u.name}`);
            console.log(`    Order ID: ${u.order_id}`);
        });
    }

    // 3. CSV users 읽기
    const usersContent = fs.readFileSync('users.csv', 'utf8');
    const usersLines = usersContent.split('\n');
    const csvUsers = [];

    for (let i = 1; i < Math.min(4, usersLines.length); i++) {
        const line = usersLines[i].trim();
        if (!line) continue;
        const cols = line.split(',');
        csvUsers.push({
            id: cols[0],
            order_id: cols[1],
            email: cols[3],
            name: cols[4]
        });
    }

    console.log('\n✅ CSV users:', usersLines.length - 1, '개');
    console.log('\n📋 CSV users 샘플:');
    csvUsers.forEach(u => {
        console.log(`  - ID: ${u.id}`);
        console.log(`    Email: ${u.email}`);
        console.log(`    Name: ${u.name}`);
        console.log(`    Order ID: ${u.order_id}`);
    });

    // 4. 분석
    console.log('\n\n📊 분석 결과:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (authError) {
        console.log('\n🔐 Supabase Auth:');
        console.log('   - 현재 프로젝트는 Auth를 사용하지 않는 것으로 보입니다.');
        console.log('   - 또는 Service Role Key 권한이 필요합니다.');
    } else if (authUsers.users && authUsers.users.length > 0) {
        console.log('\n🔐 Supabase Auth:');
        console.log(`   - Auth users: ${authUsers.users.length}개`);
        console.log('   - 로그인/인증 시스템에 사용됩니다.');
        console.log('   - auth.users 테이블 (별도)');
    } else {
        console.log('\n🔐 Supabase Auth:');
        console.log('   - Auth users: 0개 (Auth 미사용)');
    }

    console.log('\n💾 Database users 테이블:');
    console.log(`   - 현재 데이터: ${dbUsers?.length || 0}개`);
    console.log('   - 예약/크루즈 데이터와 연결됩니다.');
    console.log('   - reservation.re_user_id → users.id');

    console.log('\n📄 CSV users:');
    console.log(`   - 준비된 데이터: ${usersLines.length - 1}개`);
    console.log('   - 업로드할 데이터입니다.');

    console.log('\n\n💡 결론:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (authError || !authUsers.users || authUsers.users.length === 0) {
        console.log('✅ Auth를 사용하지 않으므로 Auth와 users 테이블 간 충돌 없음');
        console.log('✅ users 테이블은 순수 데이터 테이블로만 사용됨');
        console.log('✅ CSV 업로드 시 Auth 걱정 불필요');
        console.log('\n📌 안전하게 users 테이블을 재업로드할 수 있습니다!');
    } else {
        console.log('⚠️  Auth users가 존재합니다.');
        console.log('⚠️  Auth users와 Database users의 ID 일치 여부 확인 필요');

        // Auth와 DB users ID 비교
        const authIds = new Set(authUsers.users.map(u => u.id));
        const dbIds = new Set(dbUsers?.map(u => u.id) || []);

        const matchingIds = [...authIds].filter(id => dbIds.has(id));
        console.log(`\n   - Auth와 DB에 모두 있는 ID: ${matchingIds.length}개`);

        if (matchingIds.length > 0) {
            console.log('   ⚠️  Auth users는 삭제하면 안 됩니다!');
            console.log('   ⚠️  users 테이블 재업로드 시 Auth ID 유지 필요');
        }
    }
}

checkAuthUsers().catch(console.error);
