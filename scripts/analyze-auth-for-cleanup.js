// Auth users 분석 및 관리자 식별
require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function analyzeAuthUsers() {
    console.log('🔐 Auth users 분석 및 관리자 식별\n');

    // 1. Auth users 조회
    const { data: authData } = await supabase.auth.admin.listUsers();
    const authUsers = authData.users || [];

    console.log('✅ 총 Auth users:', authUsers.length, '개\n');

    // 2. 관리자 식별 (이메일 도메인 또는 role 기반)
    const adminEmails = ['kys@hyojacho.es.kr', 'kjh@hyojacho.es.kr'];
    const admins = [];
    const customers = [];

    authUsers.forEach(u => {
        if (adminEmails.includes(u.email) || u.email?.includes('@hyojacho.es.kr')) {
            admins.push(u);
        } else {
            customers.push(u);
        }
    });

    console.log('👨‍💼 관리자 계정:', admins.length, '개');
    admins.forEach(u => {
        console.log(`   - ${u.email} (ID: ${u.id})`);
        console.log(`     Created: ${u.created_at}`);
    });

    console.log('\n👥 고객 계정 (삭제 대상):', customers.length, '개');
    console.log('   샘플:');
    customers.slice(0, 5).forEach(u => {
        console.log(`   - ${u.email} (ID: ${u.id.substring(0, 8)}...)`);
    });

    // 3. Google Sheets에서 가져올 사용자 확인
    const usersContent = fs.readFileSync('users.csv', 'utf8');
    const usersLines = usersContent.split('\n');
    const csvCount = usersLines.length - 1;

    console.log('\n📄 Google Sheets 사용자:', csvCount, '개');

    // 4. 삭제 스크립트 생성
    console.log('\n\n📋 실행 계획:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    console.log('1️⃣ Auth에서 고객 계정 삭제');
    console.log(`   - 삭제 대상: ${customers.length}개`);
    console.log(`   - 유지: 관리자 ${admins.length}개\n`);

    console.log('2️⃣ Google Sheets 데이터로 Auth 계정 생성');
    console.log(`   - 생성 대상: ${csvCount}개`);
    console.log('   - Auth ID를 users.id로 사용\n');

    console.log('3️⃣ users 테이블에 Auth ID로 데이터 저장');
    console.log('   - auth.uid() = users.id = reservation.re_user_id\n');

    // 5. 삭제할 사용자 ID 저장
    const deleteUserIds = customers.map(u => ({
        id: u.id,
        email: u.email,
        created_at: u.created_at
    }));

    fs.writeFileSync(
        'auth-users-to-delete.json',
        JSON.stringify(deleteUserIds, null, 2)
    );

    console.log('✅ 삭제 대상 목록 저장: auth-users-to-delete.json');
    console.log(`   (${deleteUserIds.length}개 계정)\n`);

    // 6. 관리자 목록 저장
    const adminList = admins.map(u => ({
        id: u.id,
        email: u.email,
        created_at: u.created_at
    }));

    fs.writeFileSync(
        'auth-admins-keep.json',
        JSON.stringify(adminList, null, 2)
    );

    console.log('✅ 관리자 목록 저장: auth-admins-keep.json');
    console.log(`   (${adminList.length}개 계정)\n`);

    console.log('\n⚠️  다음 단계:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    console.log('1. auth-users-to-delete.json 확인');
    console.log('2. delete-auth-customers.js 실행 (고객 계정 삭제)');
    console.log('3. create-auth-from-sheets.js 실행 (새 Auth 계정 생성)');
    console.log('4. export-to-csv-with-auth.js 실행 (Auth ID 기반 CSV 생성)');
    console.log('5. CSV 업로드');
}

analyzeAuthUsers().catch(console.error);
