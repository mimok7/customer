require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function checkSHRHeaders() {
    console.log('🔍 SH_R 시트 헤더 확인\n');

    // Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // SH_R 데이터 로드 (첫 2행만)
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A1:AZ2',
    });

    const rows = response.data.values;

    console.log('============================================================');
    console.log('📋 SH_R 시트 헤더 (첫 번째 행)');
    console.log('============================================================\n');

    const headers = rows[0];
    headers.forEach((header, index) => {
        const column = String.fromCharCode(65 + index); // A, B, C...
        console.log(`   ${column}: ${header}`);
    });

    console.log('\n============================================================');
    console.log('📋 샘플 데이터 (두 번째 행)');
    console.log('============================================================\n');

    if (rows.length > 1) {
        const sampleData = rows[1];
        headers.forEach((header, index) => {
            const value = sampleData[index] || '(비어있음)';
            console.log(`   ${header}: ${value}`);
        });
    }
}

checkSHRHeaders().catch(console.error);
