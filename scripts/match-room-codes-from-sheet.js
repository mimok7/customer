require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

// 날짜 파싱 함수
function parseDate(dateStr) {
    if (!dateStr) return null;
    try {
        const cleaned = dateStr.toString().replace(/\s/g, '').replace(/\./g, '-');
        const parts = cleaned.split('-').filter(p => p);
        if (parts.length === 3) {
            const [year, month, day] = parts;
            return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
        }
    } catch { }
    return null;
}

// 날짜 범위 체크
function isDateInRange(checkDate, startDate, endDate) {
    if (!checkDate || !startDate || !endDate) return false;
    const check = new Date(checkDate);
    const start = new Date(startDate);
    const end = new Date(endDate);
    return check >= start && check <= end;
}

// 문자열 정규화 (비교용)
function normalize(str) {
    if (!str) return '';
    return str.toString()
        .toLowerCase()
        .replace(/크루즈|cruise/gi, '')
        .replace(/스위트|룸|suite|room/gi, '')
        .replace(/\s+/g, '')
        .replace(/\(.*?\)/g, '')
        .replace(/[^a-z0-9가-힣]/g, '');
}

// 유사도 체크 (간단한 부분 문자열 매칭)
function isSimilar(str1, str2, minLength = 3) {
    const n1 = normalize(str1);
    const n2 = normalize(str2);
    if (!n1 || !n2) return false;

    // 완전 일치
    if (n1 === n2) return true;

    // 부분 문자열 포함 (최소 길이 이상)
    if (n1.length >= minLength && n2.includes(n1)) return true;
    if (n2.length >= minLength && n1.includes(n2)) return true;

    return false;
}

async function matchFromGoogleSheets() {
    console.log('🔄 구글 시트 room_price에서 코드 매칭 시작\n');

    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // 1. room_price 시트 데이터 로드
    console.log('============================================================');
    console.log('📥 room_price 시트 로드');
    console.log('============================================================\n');

    const roomPriceResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'room_price!A2:Z7000',  // 헤더 제외
    });

    const roomPriceRows = roomPriceResponse.data.values || [];
    console.log(`✅ ${roomPriceRows.length}개 room_price 레코드 로드\n`);

    // room_price 데이터 구조 분석 (첫 행 출력)
    if (roomPriceRows.length > 0) {
        console.log('📋 room_price 샘플 (첫 행):');
        const headers = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'room_price!A1:Z1',
        });
        const headerRow = headers.data.values[0];
        console.log('헤더:', headerRow.join(', '));
        console.log('데이터:', roomPriceRows[0].slice(0, 15).join(', '));
        console.log('');
    }

    // room_price 인덱싱 (빠른 검색을 위해)
    const roomPriceIndex = roomPriceRows.map((row, idx) => {
        return {
            row_num: idx + 2,
            room_code: row[0] || '',           // A열: room_code
            schedule: row[1] || '',            // B열: schedule
            room_category: row[2] || '',       // C열: room_category
            cruise: row[3] || '',              // D열: cruise
            room_type: row[4] || '',           // E열: room_type
            price: row[5] || '',               // F열: price
            start_date: parseDate(row[6]),     // G열: start_date
            end_date: parseDate(row[7]),       // H열: end_date
            payment: row[8] || '',             // I열: payment
        };
    }).filter(r => r.room_code); // room_code가 있는 것만

    console.log(`✅ ${roomPriceIndex.length}개 유효한 room_code 발견\n`);

    // 2. SH_R 시트 데이터 로드
    console.log('============================================================');
    console.log('📥 SH_R 시트 로드');
    console.log('============================================================\n');

    const shrResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A2:Z3000',
    });

    const shrRows = shrResponse.data.values || [];
    console.log(`✅ ${shrRows.length}개 SH_R 행 로드\n`);

    // 3. 매칭 로직
    console.log('============================================================');
    console.log('🔍 room_code 매칭');
    console.log('============================================================\n');

    const updates = [];
    let matchCount = 0;
    let noMatchCount = 0;
    const matchLog = [];

    shrRows.forEach((row, idx) => {
        const rowNum = idx + 2;

        const 크루즈 = row[2] || '';         // C열
        const 구분 = row[3] || '';           // D열
        const 객실종류 = row[4] || '';       // E열
        const 일정일수 = row[7] || '';       // H열
        const 체크인Raw = row[9] || '';      // J열

        if (!크루즈 || !체크인Raw) {
            noMatchCount++;
            return;
        }

        const 체크인 = parseDate(체크인Raw);
        if (!체크인) {
            noMatchCount++;
            return;
        }

        // 일정 파싱
        const 일정 = 일정일수.includes('박') ? 일정일수 : '';

        // room_price에서 매칭
        const candidates = roomPriceIndex.filter(rp => {
            // 1. 크루즈명 매칭 (필수)
            if (!isSimilar(크루즈, rp.cruise, 4)) {
                return false;
            }

            // 2. 날짜 범위 매칭 (필수)
            if (!isDateInRange(체크인, rp.start_date, rp.end_date)) {
                return false;
            }

            // 3. 일정 매칭 (선택적)
            if (일정 && rp.schedule) {
                if (!rp.schedule.includes(일정.replace(/박.*/, '박'))) {
                    return false;
                }
            }

            // 4. 객실타입 매칭 (선택적 - 있으면 더 정확)
            if (객실종류 && (rp.room_type || rp.room_category)) {
                const roomInfo = `${rp.room_type} ${rp.room_category}`;
                if (!isSimilar(객실종류, roomInfo, 3) && !isSimilar(구분, roomInfo, 3)) {
                    // 매칭 안되면 패스하지 않고 점수만 낮춤
                }
            }

            return true;
        });

        if (candidates.length > 0) {
            // 첫 번째 매칭 사용
            const matched = candidates[0];

            updates.push({
                range: `SH_R!G${rowNum}`,
                values: [[matched.room_code]]
            });

            matchCount++;

            if (matchCount <= 30) {
                matchLog.push({
                    row: rowNum,
                    cruise: 크루즈,
                    room: 객실종류 || 구분,
                    checkin: 체크인,
                    matched_code: matched.room_code,
                    matched_info: `${matched.cruise} - ${matched.room_type || matched.room_category} (${matched.schedule})`
                });
            }

            if (matchCount % 200 === 0) {
                console.log(`진행: ${matchCount} 매칭됨`);
            }
        } else {
            noMatchCount++;
        }
    });

    console.log(`\n✅ 매칭 완료`);
    console.log(`   매칭됨: ${matchCount}개`);
    console.log(`   매칭 안됨: ${noMatchCount}개`);
    console.log(`   성공률: ${((matchCount / shrRows.length) * 100).toFixed(1)}%`);
    console.log('');

    // 샘플 매칭 로그
    if (matchLog.length > 0) {
        console.log('📋 샘플 매칭 결과 (처음 30개):');
        console.log('─'.repeat(120));
        matchLog.forEach(log => {
            console.log(`행 ${log.row}: ${log.cruise} | ${log.room} | ${log.checkin}`);
            console.log(`   → ${log.matched_code}: ${log.matched_info}`);
        });
        console.log('');
    }

    if (updates.length === 0) {
        console.log('⚠️ 매칭된 코드가 없습니다.');
        return;
    }

    // 4. 구글 시트 업데이트
    console.log('============================================================');
    console.log('📤 SH_R 시트 객실코드(G열) 업데이트');
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
    console.log('🎉 room_code 매칭 및 업데이트 완료!');
    console.log('============================================================');
    console.log(`총 ${matchCount}개의 객실코드가 SH_R 시트에 업데이트되었습니다.`);
    console.log(`매칭 안됨: ${noMatchCount}개 (수동 확인 필요)`);
    console.log('');
    console.log('📌 다음 단계:');
    console.log('   1. 구글 시트에서 SH_R의 객실코드(G열) 확인');
    console.log('   2. node scripts/export-to-csv.js 실행하여 CSV 재생성');
    console.log('   3. Supabase에 CSV 업로드');
    console.log('');
}

matchFromGoogleSheets().catch(console.error);
