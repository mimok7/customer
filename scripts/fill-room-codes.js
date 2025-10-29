require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function fillRoomCodes() {
    console.log('🔄 SH_R 시트 객실코드 자동 생성 시작\n');

    // 1. Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // 2. SH_R 데이터 로드
    console.log('============================================================');
    console.log('📥 SH_R 시트 데이터 로드');
    console.log('============================================================\n');

    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A2:Z3000',  // 헤더 제외하고 데이터만
    });

    const rows = response.data.values || [];
    console.log(`✅ 총 ${rows.length}개 행 로드\n`);

    // 3. 객실코드 생성
    console.log('============================================================');
    console.log('🔧 객실코드 생성');
    console.log('============================================================\n');

    const updates = [];
    let emptyCount = 0;
    let generatedCount = 0;

    rows.forEach((row, idx) => {
        const rowNum = idx + 2;  // 시트 행 번호 (헤더 제외)

        // 컬럼 인덱스
        const 크루즈 = row[2] || '';       // C열
        const 구분 = row[3] || '';         // D열
        const 객실종류 = row[4] || '';     // E열
        const 객실코드 = row[6] || '';     // G열 (현재 객실코드)
        const 일정일수 = row[7] || '';     // H열
        const 체크인 = row[9] || '';       // J열

        // 객실코드가 비어있는 경우만 생성
        if (!객실코드) {
            emptyCount++;

            // 객실코드 생성 로직
            let newRoomCode = '';

            if (크루즈 && 체크인) {
                // 1. 크루즈명 약어 (10자)
                const cruiseShort = 크루즈
                    .replace(/크루즈/g, '')
                    .replace(/\s+/g, '')
                    .replace(/CRUISE/gi, '')
                    .replace(/\(.*?\)/g, '')  // 괄호 제거
                    .substring(0, 10);

                // 2. 객실종류 약어 (10자)
                let roomTypeShort = '';
                if (객실종류) {
                    roomTypeShort = 객실종류
                        .replace(/스위트|룸|Room|Suite/gi, '')
                        .replace(/\([^)]*\)/g, '')  // 괄호 제거
                        .replace(/\s+/g, '')
                        .substring(0, 10);
                } else if (구분) {
                    // 객실종류가 없으면 구분 사용
                    roomTypeShort = 구분
                        .replace(/\s+/g, '')
                        .substring(0, 10);
                } else {
                    roomTypeShort = 'STANDARD';
                }

                // 3. 날짜 포맷 (20240601)
                let dateStr = '';
                try {
                    const cleaned = 체크인.replace(/\s/g, '').replace(/\./g, '-');
                    const parts = cleaned.split('-').filter(p => p);
                    if (parts.length === 3) {
                        const [year, month, day] = parts;
                        dateStr = `${year}${month.padStart(2, '0')}${day.padStart(2, '0')}`;
                    } else {
                        dateStr = cleaned.replace(/[-]/g, '').substring(0, 8);
                    }
                } catch {
                    dateStr = '00000000';
                }

                // 4. 일정일수 추가 (선택적)
                const daysStr = 일정일수.toString().replace(/[^0-9]/g, '').substring(0, 1) || '2';

                // 최종 객실코드 생성
                newRoomCode = `${cruiseShort}_${roomTypeShort}_${dateStr}_${daysStr}D`
                    .toUpperCase()
                    .substring(0, 50);

                // 업데이트 배열에 추가 (G열, 인덱스 6)
                updates.push({
                    range: `SH_R!G${rowNum}`,
                    values: [[newRoomCode]]
                });

                generatedCount++;

                // 진행 상황 표시 (100개마다)
                if (generatedCount % 100 === 0) {
                    console.log(`진행: ${generatedCount}/${emptyCount} 생성됨`);
                }
            }
        }
    });

    console.log(`\n✅ 생성 완료: ${generatedCount}개`);
    console.log(`   빈 객실코드: ${emptyCount}개`);
    console.log('');

    if (updates.length === 0) {
        console.log('✅ 생성할 객실코드가 없습니다.');
        return;
    }

    // 4. 구글 시트에 업데이트
    console.log('============================================================');
    console.log('📤 구글 시트 업데이트');
    console.log('============================================================\n');

    // 배치 업데이트 (100개씩)
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

        // API 제한 방지를 위한 딜레이
        if (i < totalBatches - 1) {
            await new Promise(resolve => setTimeout(resolve, 500));
        }
    }

    console.log('\n============================================================');
    console.log('🎉 객실코드 생성 완료!');
    console.log('============================================================');
    console.log(`총 ${generatedCount}개의 객실코드가 SH_R 시트에 추가되었습니다.`);
    console.log('');
    console.log('📋 샘플 생성된 코드 (처음 10개):');
    updates.slice(0, 10).forEach((update, idx) => {
        console.log(`   ${idx + 1}. ${update.range}: ${update.values[0][0]}`);
    });
    console.log('');
    console.log('📌 다음 단계:');
    console.log('   1. 구글 시트에서 객실코드(G열) 확인');
    console.log('   2. node scripts/export-to-csv.js 실행하여 CSV 재생성');
    console.log('   3. Supabase에 CSV 업로드');
    console.log('');
}

fillRoomCodes().catch(console.error);
