require('dotenv').config({ path: '.env.local' });
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');

const GOOGLE_SHEETS_ID = process.env.GOOGLE_SHEETS_ID;
const GOOGLE_SERVICE_ACCOUNT = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const GOOGLE_SERVICE_KEY = process.env.GOOGLE_SERVICE_ACCOUNT_KEY;

async function getSheetsClient() {
    const auth = new GoogleAuth({
        credentials: {
            client_email: GOOGLE_SERVICE_ACCOUNT,
            private_key: GOOGLE_SERVICE_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });
    const authClient = await auth.getClient();
    return google.sheets({ version: 'v4', auth: authClient });
}

async function checkSHMStructure() {
    console.log('🔍 SH_M 시트 구조 확인 중...\n');

    const sheets = await getSheetsClient();

    // 헤더 및 첫 5행 조회
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_M!A1:Z6', // 헤더 + 첫 5행
    });

    const rows = response.data.values || [];

    if (rows.length === 0) {
        console.log('⚠️  SH_M 시트가 비어있습니다.');
        return;
    }

    const headers = rows[0];
    console.log('📋 헤더 (컬럼명):');
    headers.forEach((header, index) => {
        console.log(`  ${String.fromCharCode(65 + index)}. ${header}`);
    });

    console.log('\n📊 첫 5행 샘플 데이터:');
    rows.slice(1, 6).forEach((row, rowIndex) => {
        console.log(`\n행 ${rowIndex + 2}:`);
        row.forEach((cell, cellIndex) => {
            if (cellIndex < headers.length) {
                console.log(`  ${headers[cellIndex]}: ${cell}`);
            }
        });
    });

    console.log('\n============================================================');
    console.log('📝 주문ID → 이메일 매핑 정보:');
    console.log('============================================================');
    console.log('이 시트를 통해 SH_CC의 주문ID로 사용자 이메일을 찾을 수 있습니다.');
}

checkSHMStructure().catch(console.error);
