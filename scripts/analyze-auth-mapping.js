// Auth ID 기반 데이터 매핑 및 CSV 재생성 전략
require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function analyzeAuthMapping() {
    console.log('🔄 Auth ID 기반 데이터 매핑 전략 수립\n');

    // 1. Auth users 가져오기
    const { data: authUsers } = await supabase.auth.admin.listUsers();
    console.log('✅ Auth users:', authUsers.users?.length || 0, '개\n');

    // 2. 현재 DB users 가져오기
    const { data: dbUsers } = await supabase
        .from('users')
        .select('id, email, name, order_id, role');

    console.log('✅ Database users:', dbUsers?.length || 0, '개\n');

    // 3. Email 기반 매핑 생성
    const emailToAuthId = new Map();
    const emailToDbUser = new Map();

    authUsers.users?.forEach(u => {
        emailToAuthId.set(u.email, u.id);
    });

    dbUsers?.forEach(u => {
        emailToDbUser.set(u.email, u);
    });

    // 4. 매칭 가능한 사용자 확인
    const matchableUsers = [];
    const unmatchableUsers = [];
    const adminUsers = [];

    authUsers.users?.forEach(authUser => {
        const dbUser = emailToDbUser.get(authUser.email);

        // 관리자 식별 (hyojacho.es.kr 도메인)
        if (authUser.email?.includes('@hyojacho.es.kr')) {
            adminUsers.push({
                auth_id: authUser.id,
                email: authUser.email,
                type: 'admin'
            });
        } else if (dbUser) {
            matchableUsers.push({
                auth_id: authUser.id,
                email: authUser.email,
                old_db_id: dbUser.id,
                name: dbUser.name,
                order_id: dbUser.order_id,
                role: dbUser.role
            });
        } else {
            unmatchableUsers.push({
                auth_id: authUser.id,
                email: authUser.email
            });
        }
    });

    console.log('📊 Auth users 분류:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    console.log(`👥 관리자/매니저: ${adminUsers.length}개`);
    adminUsers.forEach(u => {
        console.log(`   - ${u.email} (ID: ${u.auth_id.substring(0, 8)}...)`);
    });

    console.log(`\n✅ DB와 매칭 가능: ${matchableUsers.length}개 (고객)`);
    console.log('   샘플:');
    matchableUsers.slice(0, 5).forEach(u => {
        console.log(`   - ${u.email}`);
        console.log(`     Auth ID: ${u.auth_id.substring(0, 8)}...`);
        console.log(`     Old DB ID: ${u.old_db_id.substring(0, 8)}...`);
        console.log(`     Name: ${u.name}`);
        console.log(`     Order ID: ${u.order_id}`);
    });

    console.log(`\n❓ 매칭 불가: ${unmatchableUsers.length}개`);
    if (unmatchableUsers.length > 0) {
        console.log('   (DB에 없는 Auth 계정):');
        unmatchableUsers.forEach(u => {
            console.log(`   - ${u.email} (ID: ${u.auth_id.substring(0, 8)}...)`);
        });
    }

    // 5. CSV users.csv 읽기
    const usersContent = fs.readFileSync('users.csv', 'utf8');
    const usersLines = usersContent.split('\n');
    const csvUsers = [];

    for (let i = 1; i < usersLines.length; i++) {
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

    console.log(`\n📄 CSV users: ${csvUsers.length}개\n`);

    // 6. 전략 수립
    console.log('\n🎯 Auth ID 기반 재구성 전략:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    console.log('1️⃣ Auth users와 Email로 매칭 (40개)');
    console.log('   - Auth ID를 users.id로 사용');
    console.log('   - 로그인 후 자신의 데이터 조회 가능 ✅\n');

    console.log('2️⃣ Auth 없는 고객 (CSV의 나머지 ~2,100개)');
    console.log('   - 새 UUID 생성 (CSV 그대로)');
    console.log('   - order_id로만 조회 가능 (로그인 불가)\n');

    console.log('3️⃣ 관리자 (2개)');
    console.log('   - users 테이블에 등록');
    console.log('   - role = "admin" 설정\n');

    // 7. ID 매핑 생성
    const idMapping = {};

    // Auth와 매칭되는 사용자: Auth ID 사용
    matchableUsers.forEach(u => {
        idMapping[u.old_db_id] = u.auth_id;
    });

    console.log('\n📋 생성할 ID 매핑:');
    console.log(`   - Auth 매칭: ${Object.keys(idMapping).length}개`);
    console.log('   - 샘플:');
    Object.entries(idMapping).slice(0, 3).forEach(([oldId, newId]) => {
        console.log(`     Old: ${oldId.substring(0, 8)}... → New (Auth): ${newId.substring(0, 8)}...`);
    });

    // 8. 매핑 파일 저장
    fs.writeFileSync(
        'auth-id-mapping.json',
        JSON.stringify({
            adminUsers,
            matchableUsers,
            unmatchableUsers,
            idMapping
        }, null, 2)
    );

    console.log('\n\n✅ 분석 완료!');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    console.log('📁 저장된 파일: auth-id-mapping.json');
    console.log('\n다음 단계:');
    console.log('   1. auth-id-mapping.json 확인');
    console.log('   2. Auth ID 기반으로 CSV 재생성');
    console.log('   3. Supabase에 업로드');
}

analyzeAuthMapping().catch(console.error);
