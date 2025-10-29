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

async function checkAllAuthUsers() {
    console.log('🔐 전체 Auth users 확인\n');

    // 모든 Auth users 조회 (페이지네이션)
    let allUsers = [];
    let page = 1;
    const perPage = 1000;

    while (true) {
        const { data: users, error } = await supabase.auth.admin.listUsers({
            page: page,
            perPage: perPage
        });

        if (error) {
            console.error('❌ Auth users 조회 실패:', error);
            break;
        }

        if (!users || users.users.length === 0) break;

        allUsers = allUsers.concat(users.users);
        console.log(`📄 Page ${page}: ${users.users.length}개 사용자 조회`);

        if (users.users.length < perPage) break;
        page++;
    }

    console.log(`\n✅ 총 Auth users: ${allUsers.length} 개\n`);

    // 도메인별 분류
    const domains = {};
    allUsers.forEach(user => {
        const domain = user.email.split('@')[1];
        if (!domains[domain]) domains[domain] = 0;
        domains[domain]++;
    });

    console.log('📊 도메인별 분포:');
    Object.entries(domains)
        .sort((a, b) => b[1] - a[1])
        .forEach(([domain, count]) => {
            console.log(`   - ${domain}: ${count}명`);
        });

    // 관리자 찾기
    const admins = allUsers.filter(u => u.email.includes('@hyojacho.es.kr'));
    console.log(`\n👨‍💼 관리자 계정: ${admins.length}개`);
    admins.forEach(admin => {
        console.log(`   - ${admin.email} (ID: ${admin.id})`);
    });

    // 일반 사용자
    const customers = allUsers.filter(u => !u.email.includes('@hyojacho.es.kr'));
    console.log(`\n👥 일반 사용자: ${customers.length}개`);
    console.log(`   샘플 (처음 10개):`);
    customers.slice(0, 10).forEach(user => {
        console.log(`   - ${user.email}`);
    });

    // Google Sheets 사용자 수 확인
    const { google } = require('googleapis');
    const auth = new google.auth.GoogleAuth({
        credentials: JSON.parse(process.env.GOOGLE_SERVICE_ACCOUNT_KEY),
        scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });

    const sheets = google.sheets({ version: 'v4', auth });
    const spreadsheetId = process.env.GOOGLE_SHEET_ID;

    const response = await sheets.spreadsheets.values.get({
        spreadsheetId,
        range: 'SH_M!A2:U',
    });

    const sheetUsers = response.data.values || [];
    console.log(`\n📄 Google Sheets 사용자: ${sheetUsers.length}개\n`);

    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    console.log('⚠️  확인사항:');
    console.log(`   - Auth users: ${allUsers.length}명`);
    console.log(`   - Google Sheets: ${sheetUsers.length}명`);
    console.log(`   - 차이: ${allUsers.length - sheetUsers.length}명`);
    console.log(`   - 관리자: ${admins.length}명 (보존 필요)`);
    console.log(`   - 삭제 대상: ${customers.length}명\n`);

    // 모든 사용자 ID 목록 저장
    const fs = require('fs');
    fs.writeFileSync(
        'all-auth-users.json',
        JSON.stringify(allUsers.map(u => ({
            id: u.id,
            email: u.email,
            created_at: u.created_at,
            is_admin: u.email.includes('@hyojacho.es.kr')
        })), null, 2)
    );

    console.log('✅ 전체 사용자 목록 저장: all-auth-users.json\n');
}

checkAllAuthUsers().catch(console.error);
