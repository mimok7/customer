require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function analyzeSHRData() {
    console.log('🔍 SH_R 데이터 분석\n');

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
        range: 'SH_R!A2:AZ50',  // 처음 50개 행만
    });

    const rows = response.data.values;
    const headers = ['ID', '주문ID', '크루즈', '구분', '객실종류', '객실수', '객실코드', '일정일수', '객실할인', '체크인', '시간', 'ADULT', 'CHILD', 'TODDLER', '승선인원', '인원수'];

    console.log('============================================================');
    console.log('📊 SH_R 데이터 샘플 (처음 20개)');
    console.log('============================================================\n');

    let emptyRoomCodeCount = 0;
    let filledRoomCodeCount = 0;

    rows.slice(0, 20).forEach((row, idx) => {
        const rowNum = idx + 2;
        const 주문ID = row[1] || '';
        const 크루즈 = row[2] || '';
        const 구분 = row[3] || '';
        const 객실종류 = row[4] || '';
        const 객실코드 = row[6] || '';
        const 일정일수 = row[7] || '';
        const 체크인 = row[9] || '';
        const ADULT = row[11] || '';
        const CHILD = row[12] || '';

        if (객실코드) {
            filledRoomCodeCount++;
        } else {
            emptyRoomCodeCount++;
        }

        console.log(`행 ${rowNum}:`);
        console.log(`  주문ID: ${주문ID}`);
        console.log(`  크루즈: ${크루즈}`);
        console.log(`  구분: ${구분 || '(없음)'}`);
        console.log(`  객실종류: ${객실종류 || '(없음)'}`);
        console.log(`  객실코드: ${객실코드 || '❌ 비어있음'}`);
        console.log(`  일정일수: ${일정일수}`);
        console.log(`  체크인: ${체크인}`);
        console.log(`  인원: ADULT=${ADULT}, CHILD=${CHILD}`);
        console.log('');
    });

    console.log('============================================================');
    console.log('📊 통계 (전체 데이터)');
    console.log('============================================================\n');

    const allRows = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A2:G3000',
    });

    const allData = allRows.data.values || [];
    let totalEmpty = 0;
    let totalFilled = 0;
    const cruiseSet = new Set();
    const 구분Set = new Set();
    const 객실종류Set = new Set();

    allData.forEach((row) => {
        const 객실코드 = row[6] || '';
        const 크루즈 = row[2] || '';
        const 구분 = row[3] || '';
        const 객실종류 = row[4] || '';

        if (객실코드) {
            totalFilled++;
        } else {
            totalEmpty++;
        }

        if (크루즈) cruiseSet.add(크루즈);
        if (구분) 구분Set.add(구분);
        if (객실종류) 객실종류Set.add(객실종류);
    });

    console.log(`총 레코드: ${allData.length}개`);
    console.log(`객실코드 있음: ${totalFilled}개`);
    console.log(`객실코드 없음: ${totalEmpty}개 ❌`);
    console.log('');

    console.log('크루즈 종류:');
    Array.from(cruiseSet).forEach(c => console.log(`  - ${c}`));
    console.log('');

    console.log('구분 종류:');
    Array.from(구분Set).forEach(c => console.log(`  - ${c || '(비어있음)'}`));
    console.log('');

    console.log('객실종류:');
    Array.from(객실종류Set).forEach(c => console.log(`  - ${c || '(비어있음)'}`));
    console.log('');
}

analyzeSHRData().catch(console.error);
