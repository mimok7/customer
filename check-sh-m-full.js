// SH_M 시트 전체 구조 확인
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const dotenv = require('dotenv');

try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

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

async function checkSHM() {
    console.log('🔍 SH_M 시트 전체 구조 확인\n');

    const sheets = await getSheetsClient();

    // 헤더 확인
    const headerResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_M!A1:Z1',
    });
    const headers = headerResponse.data.values?.[0] || [];

    console.log('📋 헤더 (컬럼명):');
    headers.forEach((header, idx) => {
        const col = String.fromCharCode(65 + idx);
        console.log(`   ${col}열: ${header}`);
    });

    // 샘플 데이터 5개
    const dataResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_M!A2:Z6',
    });
    const rows = dataResponse.data.values || [];

    console.log('\n📊 샘플 데이터 (첫 5개):');
    rows.forEach((row, rowIdx) => {
        console.log(`\n행 ${rowIdx + 2}:`);
        headers.forEach((header, colIdx) => {
            const col = String.fromCharCode(65 + colIdx);
            const value = row[colIdx] || '(비어있음)';
            console.log(`   ${col}. ${header}: ${value}`);
        });
    });
}

checkSHM();
