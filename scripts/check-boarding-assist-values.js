require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function checkBoardingAssist() {
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // SH_R 샘플 데이터 확인
    const shRResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A2:V20',
    });

    const rows = shRResponse.data.values || [];
    console.log('📋 SH_R 승선도움 데이터 샘플 (처음 20개):\n');

    const uniqueValues = new Set();

    rows.forEach((row, idx) => {
        const boardingAssist = row[17] || '';  // Column R: 승선도움
        uniqueValues.add(boardingAssist);

        if (idx < 10) {
            console.log(`Row ${idx + 2}:`);
            console.log(`  주문ID: ${row[1]}`);
            console.log(`  승선도움 (Column R, index 17): "${boardingAssist}"`);
            console.log(`  타입: ${typeof boardingAssist}`);
            console.log();
        }
    });

    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    console.log('📊 승선도움 고유 값 목록:\n');
    Array.from(uniqueValues).sort().forEach(value => {
        console.log(`  "${value}"`);
    });
}

checkBoardingAssist().catch(console.error);
