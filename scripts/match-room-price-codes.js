require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const { createClient } = require('@supabase/supabase-js');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

// 날짜 매칭 함수 (범위 체크)
function isDateInRange(checkDate, startDate, endDate) {
    const check = new Date(checkDate);
    const start = new Date(startDate);
    const end = new Date(endDate);
    return check >= start && check <= end;
}

// 크루즈명 정규화
function normalizeCruiseName(name) {
    return name
        .replace(/크루즈/g, '')
        .replace(/CRUISE/gi, '')
        .replace(/\s+/g, '')
        .replace(/\(.*?\)/g, '')
        .toLowerCase();
}

// 객실종류/구분 정규화
function normalizeRoomType(type) {
    return type
        .replace(/스위트|룸|Room|Suite/gi, '')
        .replace(/\s+/g, '')
        .toLowerCase();
}

async function matchRoomPriceCodes() {
    console.log('🔄 SH_R 데이터와 room_price 매칭 시작\n');

    // 1. room_price 데이터 로드
    console.log('============================================================');
    console.log('📥 Supabase room_price 데이터 로드');
    console.log('============================================================\n');

    const { data: roomPrices, error: rpError } = await supabase
        .from('room_price')
        .select('*');

    if (rpError) {
        console.error('❌ room_price 조회 실패:', rpError.message);
        return;
    }

    console.log(`✅ ${roomPrices.length}개 room_price 레코드 로드\n`);

    // 2. Google Sheets 인증 및 SH_R 데이터 로드
    console.log('============================================================');
    console.log('📥 SH_R 시트 데이터 로드');
    console.log('============================================================\n');

    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A2:Z3000',
    });

    const rows = response.data.values || [];
    console.log(`✅ ${rows.length}개 SH_R 행 로드\n`);

    // 3. 매칭 로직
    console.log('============================================================');
    console.log('🔍 room_price 코드 매칭');
    console.log('============================================================\n');

    const updates = [];
    let matchCount = 0;
    let noMatchCount = 0;
    const matchLog = [];

    rows.forEach((row, idx) => {
        const rowNum = idx + 2;

        const 크루즈 = row[2] || '';
        const 구분 = row[3] || '';
        const 객실종류 = row[4] || '';
        const 일정일수 = row[7] || '';
        const 체크인Raw = row[9] || '';

        if (!크루즈 || !체크인Raw) {
            return; // 필수 정보 없으면 스킵
        }

        // 체크인 날짜 파싱
        let 체크인 = '';
        try {
            const cleaned = 체크인Raw.replace(/\s/g, '').replace(/\./g, '-');
            const parts = cleaned.split('-').filter(p => p);
            if (parts.length === 3) {
                const [year, month, day] = parts;
                체크인 = `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
            }
        } catch {
            return; // 날짜 파싱 실패하면 스킵
        }

        // 일정일수 파싱
        const 일정 = 일정일수.includes('박')
            ? 일정일수
            : (일정일수.replace(/[^0-9]/g, '') ? `${일정일수.replace(/[^0-9]/g, '')}박` : '');

        // room_price 테이블에서 매칭
        const normalizedCruise = normalizeCruiseName(크루즈);
        const normalizedRoom = normalizeRoomType(객실종류 || 구분);

        const candidates = roomPrices.filter(rp => {
            // 1. 크루즈명 매칭
            const rpCruise = normalizeCruiseName(rp.cruise || '');
            if (!rpCruise || !normalizedCruise.includes(rpCruise.substring(0, 5))) {
                return false;
            }

            // 2. 일정 매칭 (선택적)
            if (일정 && rp.schedule && !rp.schedule.includes(일정.replace(/박.*/, '박'))) {
                return false;
            }

            // 3. 날짜 범위 매칭
            if (rp.start_date && rp.end_date) {
                if (!isDateInRange(체크인, rp.start_date, rp.end_date)) {
                    return false;
                }
            }

            // 4. 객실타입/카테고리 매칭 (선택적)
            if (normalizedRoom) {
                const rpRoom = normalizeRoomType(rp.room_type || rp.room_category || '');
                if (rpRoom && !normalizedRoom.includes(rpRoom.substring(0, 3))) {
                    return false;
                }
            }

            return true;
        });

        if (candidates.length > 0) {
            // 첫 번째 매칭 결과 사용 (가장 근접한 것)
            const matched = candidates[0];

            updates.push({
                range: `SH_R!G${rowNum}`,
                values: [[matched.room_code]]
            });

            matchCount++;

            if (matchCount <= 20) {
                matchLog.push({
                    row: rowNum,
                    cruise: 크루즈,
                    room: 객실종류 || 구분,
                    checkin: 체크인,
                    matched_code: matched.room_code,
                    matched_info: `${matched.cruise} - ${matched.room_type || matched.room_category} (${matched.schedule})`
                });
            }

            if (matchCount % 100 === 0) {
                console.log(`진행: ${matchCount} 매칭됨`);
            }
        } else {
            noMatchCount++;
        }
    });

    console.log(`\n✅ 매칭 완료`);
    console.log(`   매칭됨: ${matchCount}개`);
    console.log(`   매칭 안됨: ${noMatchCount}개`);
    console.log('');

    // 샘플 매칭 로그 출력
    console.log('📋 샘플 매칭 결과 (처음 20개):');
    console.log('─'.repeat(120));
    matchLog.forEach(log => {
        console.log(`행 ${log.row}: ${log.cruise} | ${log.room} | ${log.checkin}`);
        console.log(`   → ${log.matched_code}: ${log.matched_info}`);
    });
    console.log('');

    if (updates.length === 0) {
        console.log('⚠️ 매칭된 코드가 없습니다.');
        return;
    }

    // 4. 구글 시트 업데이트
    console.log('============================================================');
    console.log('📤 구글 시트 업데이트');
    console.log('============================================================\n');

    const BATCH_SIZE = 100;
    const totalBatches = Math.ceil(updates.length / BATCH_SIZE);

    for (let i = 0; i < totalBatches; i++) {
        const batchStart = i * BATCH_SIZE;
        const batchEnd = Math.min(batchStart + BATCH_SIZE, updates.length);
        const batch = updates.slice(batchStart, batchEnd);

        try {
            await sheets.spreadsheets.values.batchUpdate({
                spreadsheetId: SPREADSHEET_ID,
                resource: {
                    valueInputOption: 'RAW',
                    data: batch
                }
            });

            const progress = ((batchEnd / updates.length) * 100).toFixed(1);
            console.log(`✅ Batch ${i + 1}/${totalBatches} 완료 (${batchEnd}/${updates.length}, ${progress}%)`);
        } catch (error) {
            console.error(`❌ Batch ${i + 1} 실패:`, error.message);
        }

        if (i < totalBatches - 1) {
            await new Promise(resolve => setTimeout(resolve, 500));
        }
    }

    console.log('\n============================================================');
    console.log('🎉 room_price 코드 매칭 완료!');
    console.log('============================================================');
    console.log(`총 ${matchCount}개의 객실코드가 매칭되어 업데이트되었습니다.`);
    console.log(`매칭 안됨: ${noMatchCount}개 (수동 확인 필요)`);
    console.log('');
    console.log('📌 다음 단계:');
    console.log('   1. 구글 시트에서 객실코드(G열) 확인');
    console.log('   2. 매칭 안된 행 수동 확인 및 수정');
    console.log('   3. node scripts/export-to-csv.js 실행하여 CSV 재생성');
    console.log('   4. Supabase에 CSV 업로드');
    console.log('');
}

matchRoomPriceCodes().catch(console.error);
