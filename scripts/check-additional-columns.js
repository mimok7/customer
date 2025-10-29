// SH_R, SH_M 시트의 추가 컬럼 확인
require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

async function checkColumns() {
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly']
    });

    const sheets = google.sheets({ version: 'v4', auth: await auth.getClient() });
    const sheetId = process.env.GOOGLE_SHEETS_ID;

    // SH_R 시트 컬럼 확인
    console.log('📋 SH_R 시트 컬럼:');
    const resR = await sheets.spreadsheets.values.get({
        spreadsheetId: sheetId,
        range: 'SH_R!1:1'
    });

    const headersR = resR.data.values[0];
    headersR.forEach((header, index) => {
        if (header.includes('처리') || header.includes('승선') || header.includes('도움')) {
            console.log(`  ${String.fromCharCode(65 + index)} (${index}): ${header}`);
        }
    });

    // SH_M 시트 컬럼 확인
    console.log('\n📋 SH_M 시트 컬럼:');
    const resM = await sheets.spreadsheets.values.get({
        spreadsheetId: sheetId,
        range: 'SH_M!1:1'
    });

    const headersM = resM.data.values[0];
    headersM.forEach((header, index) => {
        if (header.includes('요청') || header.includes('특이') || header.includes('메모')) {
            console.log(`  ${String.fromCharCode(65 + index)} (${index}): ${header}`);
        }
    });

    // 샘플 데이터 확인
    console.log('\n🔍 SH_R 샘플 데이터 (첫 3행):');
    const sampleR = await sheets.spreadsheets.values.get({
        spreadsheetId: sheetId,
        range: 'SH_R!A2:AZ4'
    });

    console.log('주문ID (B열):', sampleR.data.values?.map(row => row[1]).join(', '));

    const processIndex = headersR.findIndex(h => h.includes('처리'));
    const boardingHelpIndex = headersR.findIndex(h => h.includes('승선') && h.includes('도움'));

    console.log(`\n처리 (${String.fromCharCode(65 + processIndex)}열):`,
        sampleR.data.values?.map(row => row[processIndex]).join(', '));
    console.log(`승선 도움 (${String.fromCharCode(65 + boardingHelpIndex)}열):`,
        sampleR.data.values?.map(row => row[boardingHelpIndex]).join(', '));

    // SH_M 샘플 데이터
    console.log('\n🔍 SH_M 샘플 데이터 (첫 3행):');
    const sampleM = await sheets.spreadsheets.values.get({
        spreadsheetId: sheetId,
        range: 'SH_M!A2:AZ4'
    });

    const requestIndex = headersM.findIndex(h => h.includes('요청사항'));
    const specialIndex = headersM.findIndex(h => h.includes('특이사항'));
    const memoIndex = headersM.findIndex(h => h.includes('메모'));

    console.log(`요청사항 (${String.fromCharCode(65 + requestIndex)}열):`,
        sampleM.data.values?.map(row => row[requestIndex]).join(' / '));
    console.log(`특이사항 (${String.fromCharCode(65 + specialIndex)}열):`,
        sampleM.data.values?.map(row => row[specialIndex]).join(' / '));
    console.log(`메모 (${String.fromCharCode(65 + memoIndex)}열):`,
        sampleM.data.values?.map(row => row[memoIndex]).join(' / '));
}

checkColumns().catch(console.error);
