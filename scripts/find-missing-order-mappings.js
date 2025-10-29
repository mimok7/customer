require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const fs = require('fs');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function findMissingOrderMappings() {
    console.log('🔍 누락된 Order ID 매핑 찾기 시작\n');

    // 1. Retry 실패 결과에서 Order ID 추출
    const retryResult = JSON.parse(fs.readFileSync('scripts/retry-failed-40-result.json', 'utf-8'));
    const failedOrderIds = [...new Set(retryResult.results.failed.map(f => f.orderId))];

    console.log(`📊 실패한 Order ID: ${failedOrderIds.length}개`);
    console.log('Order IDs:', failedOrderIds.join(', '));
    console.log('');

    // 2. 기존 매핑 파일 로드
    const existingMapping = JSON.parse(fs.readFileSync('scripts/mapping-order-user.json', 'utf-8'));

    const unmappedOrderIds = failedOrderIds.filter(orderId => !existingMapping[orderId]);
    console.log(`❌ 매핑되지 않은 Order ID: ${unmappedOrderIds.length}개`);
    console.log('Unmapped IDs:', unmappedOrderIds.join(', '));
    console.log('');

    // 3. Google Sheets API 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // 4. SH_M 시트에서 전체 데이터 로드
    console.log('📥 SH_M 시트에서 데이터 로딩...');
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_M!A:I',
    });

    const rows = response.data.values;
    const headers = rows[0];
    const dataRows = rows.slice(1);

    console.log(`✅ ${dataRows.length}개 레코드 로드됨\n`);

    // 5. 누락된 Order ID 찾기
    console.log('============================================================');
    console.log('🔍 SH_M에서 Order ID 검색 결과');
    console.log('============================================================\n');

    const newMappings = {};
    const notFoundIds = [];

    for (const orderId of unmappedOrderIds) {
        const foundRow = dataRows.find(row => row[0] === orderId); // A열: 주문ID

        if (foundRow) {
            const email = foundRow[2]; // C열: Email
            const nameKr = foundRow[3]; // D열: 한글이름
            const phone = foundRow[8]; // I열: 전화번호

            console.log(`✅ ${orderId} 발견:`);
            console.log(`   - 이름: ${nameKr}`);
            console.log(`   - Email: ${email || '(없음)'}`);
            console.log(`   - 전화: ${phone || '(없음)'}`);

            // SH_M에는 있지만 User ID 매핑은 불가능 (email/phone 없음)
            if (!email && !phone) {
                console.log(`   ⚠️  Email과 전화번호 모두 없어 매핑 불가`);
                notFoundIds.push({ orderId, nameKr, reason: 'no_contact_info' });
            } else {
                // 매핑 가능한 케이스는 별도 처리 필요
                newMappings[orderId] = { email, phone, nameKr };
            }
            console.log('');
        } else {
            console.log(`❌ ${orderId}: SH_M에 없음!`);
            notFoundIds.push({ orderId, reason: 'not_in_sh_m' });
            console.log('');
        }
    }

    // 6. 결과 요약
    console.log('============================================================');
    console.log('📊 검색 결과 요약');
    console.log('============================================================');
    console.log(`   - 총 누락 Order ID: ${unmappedOrderIds.length}개`);
    console.log(`   - SH_M에서 발견: ${Object.keys(newMappings).length}개`);
    console.log(`   - SH_M에 없음: ${notFoundIds.filter(n => n.reason === 'not_in_sh_m').length}개`);
    console.log(`   - 연락처 없음: ${notFoundIds.filter(n => n.reason === 'no_contact_info').length}개`);
    console.log('');

    // 7. 새로운 매핑 저장
    const resultPath = 'scripts/missing-order-mappings-result.json';
    fs.writeFileSync(resultPath, JSON.stringify({
        timestamp: new Date().toISOString(),
        unmappedCount: unmappedOrderIds.length,
        foundInShM: newMappings,
        notFound: notFoundIds
    }, null, 2));

    console.log(`✅ 결과 저장: ${resultPath}`);
    console.log('');

    if (Object.keys(newMappings).length > 0) {
        console.log('💡 다음 단계:');
        console.log('   1. 발견된 Order ID의 email/phone으로 users 테이블에서 User ID 찾기');
        console.log('   2. mapping-order-user.json에 추가');
        console.log('   3. retry 스크립트 재실행');
    }
}

findMissingOrderMappings().catch(console.error);
