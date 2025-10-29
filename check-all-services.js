// 모든 서비스 시트 구조 확인 스크립트
require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

async function checkAllSheetsStructure() {
    try {
        console.log('🔍 모든 서비스 시트 구조 확인 중...\n');

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

        // 확인할 시트 목록
        const sheetList = [
            { name: 'SH_CC', displayName: '스하차량' },
            { name: 'SH_P', displayName: '공항' },
            { name: 'SH_H', displayName: '호텔' },
            { name: 'SH_T', displayName: '투어' },
            { name: 'SH_RC', displayName: '렌트카' }
        ];

        for (const sheet of sheetList) {
            console.log('\n' + '='.repeat(80));
            console.log(`📋 ${sheet.displayName} (${sheet.name}) 시트 구조`);
            console.log('='.repeat(80) + '\n');

            try {
                const response = await sheets.spreadsheets.values.get({
                    spreadsheetId,
                    range: `'${sheet.name}'!A1:Z6`, // 헤더 + 5개 데이터
                });

                const rows = response.data.values || [];

                if (rows.length === 0) {
                    console.log('❌ 데이터가 없습니다.\n');
                    continue;
                }

                const headers = rows[0];
                console.log('📊 컬럼 구조:\n');

                headers.forEach((header, index) => {
                    const colLetter = String.fromCharCode(65 + index); // A, B, C...
                    console.log(`  ${colLetter}열 (${index}): ${header}`);
                });

                console.log('\n📝 샘플 데이터 (첫 3개):\n');

                for (let i = 1; i < Math.min(4, rows.length); i++) {
                    console.log(`[${i}번째 데이터]`);
                    const sampleData = [];
                    rows[i].forEach((value, colIndex) => {
                        if (value && colIndex < 15) { // 앞의 15개 컬럼만 표시
                            const colLetter = String.fromCharCode(65 + colIndex);
                            sampleData.push(`  ${colLetter}(${headers[colIndex]}): ${value}`);
                        }
                    });
                    console.log(sampleData.slice(0, 10).join('\n')); // 최대 10개만
                    if (sampleData.length > 10) {
                        console.log(`  ... (${sampleData.length - 10}개 더 있음)`);
                    }
                    console.log('');
                }

            } catch (error) {
                console.error(`❌ ${sheet.name} 시트 조회 실패:`, error.message);
            }
        }

        console.log('\n' + '='.repeat(80));
        console.log('✅ 모든 시트 확인 완료');
        console.log('='.repeat(80));

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
    }
}

checkAllSheetsStructure();
