// Google Sheets 시트 목록 확인 스크립트
require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

async function checkSheets() {
    try {
        console.log('🔍 Google Sheets 연결 중...\n');

        const spreadsheetId = process.env.GOOGLE_SHEETS_ID;

        if (!spreadsheetId) {
            console.error('❌ GOOGLE_SHEETS_ID가 설정되지 않았습니다.');
            return;
        }

        const auth = new google.auth.GoogleAuth({
            credentials: {
                type: 'service_account',
                client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
                private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY?.replace(/\\n/g, '\n'),
            },
            scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
        });

        const sheets = google.sheets({ version: 'v4', auth });

        const response = await sheets.spreadsheets.get({
            spreadsheetId,
        });

        const sheetList = response.data.sheets || [];

        console.log('📊 전체 시트 목록:\n');
        console.log('='.repeat(50));

        sheetList.forEach((sheet, index) => {
            const title = sheet.properties?.title || '';
            const sheetId = sheet.properties?.sheetId || '';
            const rowCount = sheet.properties?.gridProperties?.rowCount || 0;
            const colCount = sheet.properties?.gridProperties?.columnCount || 0;

            console.log(`${index + 1}. ${title}`);
            console.log(`   - ID: ${sheetId}`);
            console.log(`   - 크기: ${rowCount}행 x ${colCount}열\n`);
        });

        console.log('='.repeat(50));
        console.log(`\n총 ${sheetList.length}개의 시트가 있습니다.\n`);

        // 특정 시트 찾기
        const sheetNames = sheetList.map(s => s.properties?.title);

        console.log('🔍 스테이하롱 시트 확인:\n');

        const sheetMapping = {
            'SH_C': '차량',
            'SH_R': '크루즈',
            'SH_CC': '스하차량',
            'SH_P': '공항',
            'SH_H': '호텔',
            'SH_T': '투어',
            'SH_RC': '렌트카',
            'SH_M': '사용자',
            'SH_SP': '특별'
        };

        Object.entries(sheetMapping).forEach(([code, name]) => {
            const found = sheetNames.includes(code);
            if (found) {
                console.log(`✅ ${code} (${name}) 시트 발견`);
            } else {
                console.log(`❌ ${code} (${name}) 시트를 찾을 수 없습니다.`);
            }
        });
    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        if (error.response) {
            console.error('   응답 상세:', error.response.data);
        }
    }
}

checkSheets();
