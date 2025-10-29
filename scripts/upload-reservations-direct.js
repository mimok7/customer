// reservation 테이블 직접 업로드 스크립트
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

async function uploadReservations() {
    console.log('📤 reservation 데이터 업로드 시작...\n');

    // CSV 파일 읽기
    const csvContent = fs.readFileSync('reservations.csv', 'utf8');
    const lines = csvContent.split('\n');
    const header = lines[0].split(',');

    console.log('📋 CSV 헤더:', header.join(', '));
    console.log('📊 총 행 수:', lines.length - 1, '\n');

    const reservations = [];

    for (let i = 1; i < lines.length; i++) {
        const line = lines[i].trim();
        if (!line) continue;

        const cols = line.split(',');

        // 컬럼 매핑 확인
        const reservation = {
            re_id: cols[0],
            re_user_id: cols[1],
            order_id: cols[2],
            re_quote_id: cols[3] || null,
            re_type: cols[4],
            re_status: cols[5],
            re_created_at: cols[6],
            re_update_at: cols[7],
            total_amount: cols[8] ? parseInt(cols[8]) : null,
            paid_amount: cols[9] ? parseInt(cols[9]) : null,
            payment_status: cols[10]
        };

        reservations.push(reservation);
    }

    console.log(`✅ 파싱 완료: ${reservations.length}개 예약\n`);
    console.log('🔍 샘플 데이터 (첫 2개):');
    console.log(JSON.stringify(reservations.slice(0, 2), null, 2));

    // 배치 업로드 (500개씩)
    const batchSize = 500;
    let successCount = 0;
    let errorCount = 0;

    for (let i = 0; i < reservations.length; i += batchSize) {
        const batch = reservations.slice(i, i + batchSize);

        console.log(`\n📤 배치 업로드 중... (${i + 1} ~ ${Math.min(i + batchSize, reservations.length)})`);

        const { data, error } = await supabase
            .from('reservation')
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

    // 최종 확인
    const { count } = await supabase
        .from('reservation')
        .select('*', { count: 'exact', head: true });

    console.log(`\n📊 최종 reservation 테이블 개수: ${count}개`);
}

uploadReservations().catch(console.error);
