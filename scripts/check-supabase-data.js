// Supabase 데이터 확인 스크립트
require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

// 환경변수에서 Supabase 설정 로드
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error('❌ 환경변수가 설정되지 않았습니다.');
    console.log('NEXT_PUBLIC_SUPABASE_URL:', supabaseUrl ? '✅' : '❌');
    console.log('SUPABASE_SERVICE_ROLE_KEY:', supabaseKey ? '✅' : '❌');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkData() {
    console.log('🔍 Supabase 데이터 확인 중...\n');

    // 1. users 테이블 개수
    const { count: usersCount, error: usersError } = await supabase
        .from('users')
        .select('*', { count: 'exact', head: true });

    if (usersError) {
        console.error('❌ users 조회 오류:', usersError.message);
    } else {
        console.log(`✅ users 테이블: ${usersCount}개`);
    }

    // 2. users의 실제 ID 샘플
    const { data: sampleUsers, error: sampleError } = await supabase
        .from('users')
        .select('id, order_id, name')
        .limit(5);

    if (sampleError) {
        console.error('❌ users 샘플 조회 오류:', sampleError.message);
    } else {
        console.log('\n📋 users 샘플 데이터:');
        sampleUsers?.forEach(u => {
            console.log(`  - ID: ${u.id.substring(0, 8)}..., order_id: ${u.order_id}, name: ${u.name}`);
        });
    }

    // 3. reservation 테이블 개수
    const { count: reservationCount, error: reservationError } = await supabase
        .from('reservation')
        .select('*', { count: 'exact', head: true });

    if (reservationError) {
        console.error('\n❌ reservation 조회 오류:', reservationError.message);
    } else {
        console.log(`\n✅ reservation 테이블: ${reservationCount}개`);
    }

    // 4. CSV의 첫 몇 개 user_id 확인
    const fs = require('fs');
    const reservationsCsv = fs.readFileSync('reservations.csv', 'utf8');
    const lines = reservationsCsv.split('\n').slice(1, 6);

    console.log('\n📄 reservations.csv의 처음 5개 user_id:');
    for (const line of lines) {
        if (!line.trim()) continue;
        const cols = line.split(',');
        const userId = cols[1];

        // Supabase에 존재하는지 확인
        const { data, error } = await supabase
            .from('users')
            .select('id, name')
            .eq('id', userId)
            .single();

        if (error || !data) {
            console.log(`  ❌ ${userId.substring(0, 8)}... - Supabase에 없음!`);
        } else {
            console.log(`  ✅ ${userId.substring(0, 8)}... - ${data.name}`);
        }
    }

    console.log('\n✅ 확인 완료!');
}

checkData().catch(console.error);
