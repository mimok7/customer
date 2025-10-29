// SH_M의 요청사항/특이사항/메모 데이터 확인
require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

async function checkSHMData() {
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly']
    });

    const sheets = google.sheets({ version: 'v4', auth: await auth.getClient() });
    const sheetId = process.env.GOOGLE_SHEETS_ID;

    // 헤더 확인
    const headerRes = await sheets.spreadsheets.values.get({
        spreadsheetId: sheetId,
        range: 'SH_M!1:1'
    });

    const headers = headerRes.data.values[0];
    console.log('📋 SH_M 헤더:');
    console.log('  주문ID (A):', headers[0]);
    console.log('  요청사항 (Q):', headers[16]);
    console.log('  특이사항 (S):', headers[18]);
    console.log('  메모 (U):', headers[20]);

    // 데이터 샘플
    const dataRes = await sheets.spreadsheets.values.get({
        spreadsheetId: sheetId,
        range: 'SH_M!A2:U10'
    });

    console.log('\n🔍 SH_M 샘플 데이터:');
    dataRes.data.values?.forEach((row, i) => {
        if (row[16] || row[18] || row[20]) {  // 요청사항, 특이사항, 메모 중 하나라도 있으면
            console.log(`\nRow ${i + 2}:`);
            console.log('  주문ID:', row[0]);
            console.log('  요청사항:', row[16]?.substring(0, 80) || '(없음)');
            console.log('  특이사항:', row[18]?.substring(0, 80) || '(없음)');
            console.log('  메모:', row[20]?.substring(0, 80) || '(없음)');
        }
    });
}

checkSHMData().catch(console.error);
