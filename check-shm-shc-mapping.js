require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const fs = require('fs');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

// Auth ID 매핑 로드
const authIdMapping = JSON.parse(fs.readFileSync('./scripts/auth-id-mapping.json', 'utf8'));

async function checkSHMSHCMapping() {
    console.log('🔍 SH_M과 SH_C 주문ID 매핑 확인\n');

    // Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // 1. SH_M 주문ID 로드 (B열)
    console.log('1️⃣ SH_M 주문ID 로드\n');

    const shmResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_M!B2:B',
    });

    const shmOrderIds = new Set(
        (shmResponse.data.values || [])
            .map(row => row[0])
            .filter(id => id)
    );

    console.log(`   SH_M 주문ID: ${shmOrderIds.size}개\n`);

    // 2. SH_C 주문ID 로드 (B열)
    console.log('2️⃣ SH_C 주문ID 로드\n');

    const shcResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_C!B2:B',
    });

    const shcOrderIds = new Set(
        (shcResponse.data.values || [])
            .map(row => row[0])
            .filter(id => id)
    );

    console.log(`   SH_C 주문ID: ${shcOrderIds.size}개\n`);

    // 3. Auth Mapping 주문ID
    const authOrderIds = new Set(Object.keys(authIdMapping));
    console.log(`3️⃣ Auth Mapping 주문ID: ${authOrderIds.size}개\n`);

    // 4. SH_M과 SH_C 교집합
    const shmShcIntersection = new Set(
        [...shmOrderIds].filter(id => shcOrderIds.has(id))
    );
    console.log(`4️⃣ SH_M ∩ SH_C: ${shmShcIntersection.size}개\n`);

    // 5. SH_C와 Auth Mapping 교집합
    const shcAuthIntersection = new Set(
        [...shcOrderIds].filter(id => authOrderIds.has(id))
    );
    console.log(`5️⃣ SH_C ∩ Auth Mapping: ${shcAuthIntersection.size}개\n`);

    // 6. SH_C에만 있는 주문ID
    const shcOnly = new Set(
        [...shcOrderIds].filter(id => !authOrderIds.has(id))
    );
    console.log(`6️⃣ SH_C에만 있는 주문ID: ${shcOnly.size}개\n`);

    if (shcOnly.size > 0) {
        console.log('   샘플 (처음 10개):');
        Array.from(shcOnly).slice(0, 10).forEach(id => {
            console.log(`     - ${id}`);
        });
    }

    // 7. 승차일시 확인
    console.log('\n7️⃣ SH_C 승차일시 분포 확인\n');

    const shcDataResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_C!B2:J',
    });

    const shcRows = shcDataResponse.data.values || [];
    const dates = shcRows
        .map(row => row[8]) // J열: 승차일시 (index 8)
        .filter(date => date)
        .map(date => {
            // 날짜 파싱
            if (date.includes('-')) {
                return date.split(' ')[0];
            }
            return date;
        });

    const dateCount = {};
    dates.forEach(date => {
        if (date >= '2025-01-02') {
            dateCount[date] = (dateCount[date] || 0) + 1;
        }
    });

    const sortedDates = Object.keys(dateCount).sort();
    console.log(`   2025-01-02 이후: ${sortedDates.length}개 날짜\n`);
    console.log(`   최소 날짜: ${sortedDates[0]}`);
    console.log(`   최대 날짜: ${sortedDates[sortedDates.length - 1]}`);

    const totalCount = Object.values(dateCount).reduce((sum, count) => sum + count, 0);
    console.log(`   총 행 수: ${totalCount}개\n`);
}

checkSHMSHCMapping().catch(console.error);
