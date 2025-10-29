// users 테이블 전체 업로드 스크립트 (누락된 데이터 보완)
require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error('❌ 환경변수가 설정되지 않았습니다.');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function uploadUsers() {
    console.log('📤 users 데이터 업로드 시작...\n');

    // 1. 현재 Supabase에 있는 user IDs 가져오기
    console.log('🔍 Supabase의 기존 users 확인 중...');
    const { data: existingUsers } = await supabase
        .from('users')
        .select('id');

    const existingIds = new Set(existingUsers?.map(u => u.id) || []);
    console.log(`✅ 기존 users: ${existingIds.size}개\n`);

    // 2. CSV 파일 읽기
    const csvContent = fs.readFileSync('users.csv', 'utf8');
    const lines = csvContent.split('\n');
    const header = lines[0].split(',');

    console.log('📋 CSV 헤더:', header.join(', '));
    console.log('📊 CSV 총 행 수:', lines.length - 1, '\n');

    const users = [];

    for (let i = 1; i < lines.length; i++) {
        const line = lines[i].trim();
        if (!line) continue;

        const cols = line.split(',');

        // 이미 존재하는 ID는 스킵
        if (existingIds.has(cols[0])) {
            continue;
        }

        const user = {
            id: cols[0],
            order_id: cols[1] || null,
            reservation_date: cols[2] || null,
            email: cols[3] || null,
            name: cols[4] || null,
            english_name: cols[5] || null,
            nickname: cols[6] || null,
            phone_number: cols[7] || null,
            role: cols[8] || 'member',
            birth_date: cols[9] || null,
            passport_number: cols[10] || null,
            passport_expiry: cols[11] || null,
            status: cols[12] || 'active',
            created_at: cols[13] || new Date().toISOString(),
            updated_at: cols[14] || new Date().toISOString(),
            kakao_id: cols[15] || null
        };

        users.push(user);
    }

    console.log(`✅ 업로드할 새로운 users: ${users.length}개\n`);

    if (users.length === 0) {
        console.log('✅ 모든 users가 이미 업로드되어 있습니다!');
        return;
    }

    console.log('🔍 샘플 데이터 (첫 2개):');
    console.log(JSON.stringify(users.slice(0, 2), null, 2));

    // 3. 배치 업로드 (500개씩)
    const batchSize = 500;
    let successCount = 0;
    let errorCount = 0;

    for (let i = 0; i < users.length; i += batchSize) {
        const batch = users.slice(i, i + batchSize);

        console.log(`\n📤 배치 업로드 중... (${i + 1} ~ ${Math.min(i + batchSize, users.length)})`);

        const { data, error } = await supabase
            .from('users')
            .insert(batch);

        if (error) {
            console.error(`❌ 배치 ${Math.floor(i / batchSize) + 1} 업로드 실패:`, error.message);
            console.error('상세:', error);
            errorCount += batch.length;

            // 첫 실패한 데이터 출력
            console.log('\n🔍 실패한 첫 번째 데이터:');
            console.log(JSON.stringify(batch[0], null, 2));
            break;
        } else {
            successCount += batch.length;
            console.log(`✅ ${batch.length}개 업로드 완료`);
        }
    }

    console.log(`\n✅ 업로드 완료: ${successCount}개 성공, ${errorCount}개 실패`);

    // 4. 최종 확인
    const { count } = await supabase
        .from('users')
        .select('*', { count: 'exact', head: true });

    console.log(`\n📊 최종 users 테이블 개수: ${count}개 (목표: 2151개)`);
}

uploadUsers().catch(console.error);
