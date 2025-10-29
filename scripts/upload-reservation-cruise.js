// reservation_cruise 테이블 업로드 스크립트
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

async function uploadReservationCruise() {
    console.log('📤 reservation_cruise 데이터 업로드 시작...\n');

    // CSV 파일 읽기
    const csvContent = fs.readFileSync('reservation_cruise.csv', 'utf8');
    const lines = csvContent.split('\n');

    console.log(' 총 행 수 (파일):', lines.length - 1, '\n');

    const cruises = [];
    let currentLine = '';
    let inQuotes = false;

    // CSV 파싱: 따옴표 안의 줄바꿈 처리
    for (let i = 1; i < lines.length; i++) {
        currentLine += (currentLine ? '\n' : '') + lines[i];

        // 따옴표 개수 세기
        const quoteCount = (currentLine.match(/"/g) || []).length;
        inQuotes = quoteCount % 2 !== 0;

        // 완전한 행이면 파싱
        if (!inQuotes && currentLine.trim()) {
            const cols = [];
            let current = '';
            let inFieldQuotes = false;

            for (let j = 0; j < currentLine.length; j++) {
                const char = currentLine[j];
                if (char === '"') {
                    inFieldQuotes = !inFieldQuotes;
                } else if (char === ',' && !inFieldQuotes) {
                    cols.push(current);
                    current = '';
                } else {
                    current += char;
                }
            }
            cols.push(current); // 마지막 컬럼

            if (cols.length >= 11) {  // 최소 컬럼 개수 확인
                const cruise = {
                    id: cols[0],
                    reservation_id: cols[1],
                    room_price_code: cols[2] || null,
                    checkin: cols[3] || null,
                    guest_count: cols[4] ? parseInt(cols[4]) : null,
                    unit_price: cols[5] ? parseInt(cols[5]) : null,
                    room_total_price: cols[6] ? parseInt(cols[6]) : null,
                    request_note: cols[7] || null,
                    boarding_code: cols[8] || null,
                    boarding_assist: cols[9] === 'true',
                    created_at: cols[10] || null
                };

                cruises.push(cruise);
            }

            currentLine = '';
        }
    }

    console.log(`✅ 파싱 완료: ${cruises.length}개 크루즈 예약\n`);
    console.log('🔍 샘플 데이터 (첫 2개):');
    console.log(JSON.stringify(cruises.slice(0, 2), null, 2));

    // 배치 업로드 (500개씩)
    const batchSize = 500;
    let successCount = 0;
    let errorCount = 0;

    for (let i = 0; i < cruises.length; i += batchSize) {
        const batch = cruises.slice(i, i + batchSize);

        console.log(`\n📤 배치 업로드 중... (${i + 1} ~ ${Math.min(i + batchSize, cruises.length)})`);

        const { data, error } = await supabase
            .from('reservation_cruise')
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
        .from('reservation_cruise')
        .select('*', { count: 'exact', head: true });

    console.log(`\n📊 최종 reservation_cruise 테이블 개수: ${count}개`);

    // 샘플 데이터 조회
    const { data: sampleData } = await supabase
        .from('reservation_cruise')
        .select('id, room_price_code, request_note, boarding_code, boarding_assist')
        .limit(3);

    console.log('\n🔍 업로드된 샘플 데이터:');
    sampleData?.forEach(d => {
        console.log(`\n  ID: ${d.id.substring(0, 8)}...`);
        console.log(`  room_price_code: ${d.room_price_code}`);
        console.log(`  boarding_code: ${d.boarding_code}`);
        console.log(`  boarding_assist: ${d.boarding_assist}`);
        console.log(`  request_note: ${d.request_note?.substring(0, 80)}...`);
    });
}

uploadReservationCruise().catch(console.error);
