// users와 reservation CSV 파일 간 ID 매칭 확인
require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function checkUserMatching() {
    console.log('📋 users와 reservation CSV 매칭 확인\n');

    // 1. Supabase users 테이블의 ID 가져오기
    const { data: supabaseUsers } = await supabase
        .from('users')
        .select('id, order_id, name');

    const supabaseUserIds = new Set(supabaseUsers?.map(u => u.id) || []);
    console.log('✅ Supabase users 테이블:', supabaseUserIds.size, '개');

    // 2. users.csv의 ID 읽기
    const usersContent = fs.readFileSync('users.csv', 'utf8');
    const usersLines = usersContent.split('\n');
    const csvUserIds = new Set();

    for (let i = 1; i < usersLines.length; i++) {
        const line = usersLines[i].trim();
        if (!line) continue;
        const cols = line.split(',');
        if (cols[0]) csvUserIds.add(cols[0]);
    }

    console.log('✅ users.csv:', csvUserIds.size, '개');

    // 3. reservations.csv의 user_id 읽기
    const reservationsContent = fs.readFileSync('reservations.csv', 'utf8');
    const reservationsLines = reservationsContent.split('\n');
    const reservationUserIds = [];

    for (let i = 1; i < reservationsLines.length; i++) {
        const line = reservationsLines[i].trim();
        if (!line) continue;
        const cols = line.split(',');
        if (cols[1]) {  // re_user_id는 2번째 컬럼
            reservationUserIds.push(cols[1]);
        }
    }

    console.log('✅ reservations.csv의 re_user_id:', reservationUserIds.length, '개');

    // 4. 매칭 확인
    console.log('\n🔍 매칭 확인:');

    // CSV 간 매칭
    const missingInCsvUsers = reservationUserIds.filter(id => !csvUserIds.has(id));
    console.log('reservations.csv의 user_id 중 users.csv에 없는 것:', missingInCsvUsers.length, '개');

    // Supabase와 매칭
    const missingInSupabase = [...csvUserIds].filter(id => !supabaseUserIds.has(id));
    console.log('users.csv의 ID 중 Supabase에 없는 것:', missingInSupabase.length, '개');

    const missingFromCsv = [...supabaseUserIds].filter(id => !csvUserIds.has(id));
    console.log('Supabase의 ID 중 users.csv에 없는 것:', missingFromCsv.length, '개');

    // 5. 결론
    console.log('\n📊 결론:');
    if (missingInSupabase.length === 0) {
        console.log('✅ users.csv의 모든 ID가 Supabase에 존재합니다!');
    } else {
        console.log(`❌ users.csv와 Supabase의 ID가 ${missingInSupabase.length}개 불일치합니다.`);
        console.log('   → users 테이블을 재업로드해야 합니다!');
    }

    // 6. 샘플 비교
    console.log('\n📋 샘플 데이터:');
    console.log('users.csv 첫 3개 ID:');
    [...csvUserIds].slice(0, 3).forEach(id => console.log('  -', id));

    console.log('\nSupabase users 첫 3개 ID:');
    supabaseUsers?.slice(0, 3).forEach(u => console.log('  -', u.id, '(', u.name, ')'));

    console.log('\nreservations.csv 첫 3개 re_user_id:');
    reservationUserIds.slice(0, 3).forEach(id => console.log('  -', id));
}

checkUserMatching().catch(console.error);
