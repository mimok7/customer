require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly'];

async function analyzeCruises() {
    console.log('🔍 SH_R 시트의 크루즈 분석\n');

    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A2:Z3000',
    });

    const rows = response.data.values || [];

    const cruiseCounts = {};
    rows.forEach(row => {
        const 크루즈 = row[2] || '';
        if (크루즈) {
            cruiseCounts[크루즈] = (cruiseCounts[크루즈] || 0) + 1;
        }
    });

    console.log('============================================================');
    console.log('📊 SH_R 시트의 크루즈 현황');
    console.log('============================================================\n');

    const sorted = Object.entries(cruiseCounts).sort((a, b) => b[1] - a[1]);
    sorted.forEach(([cruise, count], idx) => {
        console.log(`${idx + 1}. ${cruise}: ${count}건`);
    });

    console.log('\n============================================================');
    console.log(`총 ${sorted.length}개 크루즈, ${rows.length}건의 예약`);
    console.log('============================================================\n');

    console.log('⚠️ room_price 테이블에는 "그랜드 파이어니스"만 있습니다.');
    console.log('   다른 크루즈들의 room_price 데이터가 필요합니다.\n');
}

analyzeCruises().catch(console.error);
