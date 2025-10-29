require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function checkRoomCodes() {
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // SH_R 데이터
    const shRResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A2:V10', // 처음 10개만
    });

    const shRRows = shRResponse.data.values || [];
    console.log('📋 SH_R 샘플 데이터 (처음 10개):\n');
    shRRows.forEach((row, idx) => {
        console.log(`Row ${idx + 1}:`);
        console.log(`  - 주문ID (Column B): ${row[1]}`);
        console.log(`  - room_code (Column J): ${row[9]}`);
        console.log(`  - 탑승일 (Column K): ${row[10]}`);
        console.log();
    });

    // room 시트 데이터
    const roomResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'room!A2:B10',
    });

    const roomRows = roomResponse.data.values || [];
    console.log('📋 room 시트 샘플 (처음 10개):\n');
    roomRows.forEach((row, idx) => {
        console.log(`Row ${idx + 1}:`);
        console.log(`  - room_code (Column A): ${row[0]}`);
        console.log(`  - name (Column B): ${row[1]}`);
        console.log();
    });
}

checkRoomCodes().catch(console.error);
