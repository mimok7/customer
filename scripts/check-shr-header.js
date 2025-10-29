require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function checkSHRHeader() {
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // SH_R 헤더 확인
    const headerResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A1:V1',
    });

    const headers = headerResponse.data.values[0] || [];
    console.log('📋 SH_R 컬럼 구조:\n');
    headers.forEach((header, idx) => {
        const letter = String.fromCharCode(65 + idx);
        console.log(`   ${letter} (index ${idx}): ${header}`);
    });

    // 샘플 데이터 확인
    const dataResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A2:V2',
    });

    const sampleRow = dataResponse.data.values[0] || [];
    console.log('\n📋 샘플 데이터 (첫 번째 행):\n');
    sampleRow.forEach((value, idx) => {
        const letter = String.fromCharCode(65 + idx);
        const header = headers[idx] || '(no header)';
        console.log(`   ${letter} (index ${idx}) [${header}]: ${value}`);
    });
}

checkSHRHeader().catch(console.error);
