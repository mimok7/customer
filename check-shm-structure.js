// SH_M (사용자) 시트 구조 확인 스크립트
require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

async function checkSHMStructure() {
    try {
        console.log('🔍 SH_M 시트 구조 확인 중...\n');

        const spreadsheetId = process.env.GOOGLE_SHEETS_ID;

        const auth = new google.auth.GoogleAuth({
            credentials: {
                type: 'service_account',
                client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
                private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY?.replace(/\\n/g, '\n'),
            },
            scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
        });

        const sheets = google.sheets({ version: 'v4', auth });

        // SH_M 시트의 헤더와 첫 5개 데이터 가져오기
        const response = await sheets.spreadsheets.values.get({
            spreadsheetId,
            range: "'SH_M'!A1:Z6", // 헤더 + 5개 데이터
        });

        const rows = response.data.values || [];

        if (rows.length === 0) {
            console.log('❌ 데이터가 없습니다.');
            return;
        }

        console.log('📋 SH_M 시트 헤더 (컬럼 구조):\n');
        console.log('='.repeat(80));

        const headers = rows[0];
        headers.forEach((header, index) => {
            const colLetter = String.fromCharCode(65 + index); // A, B, C...
            console.log(`${colLetter}열 (${index}): ${header}`);
        });

        console.log('\n' + '='.repeat(80));
        console.log('\n📊 샘플 데이터 (첫 5개):\n');

        for (let i = 1; i < Math.min(6, rows.length); i++) {
            console.log(`\n[${i}번째 데이터]`);
            rows[i].forEach((value, colIndex) => {
                if (value) { // 값이 있는 컬럼만 표시
                    const colLetter = String.fromCharCode(65 + colIndex);
                    console.log(`  ${colLetter}(${headers[colIndex]}): ${value}`);
                }
            });
        }

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
    }
}

checkSHMStructure();
