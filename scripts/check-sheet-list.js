require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly'];

async function checkSheets() {
    console.log('📋 구글 스프레드시트 시트 목록 확인\n');

    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    try {
        const response = await sheets.spreadsheets.get({
            spreadsheetId: SPREADSHEET_ID,
        });

        console.log('============================================================');
        console.log('📊 스프레드시트 정보');
        console.log('============================================================');
        console.log(`제목: ${response.data.properties.title}`);
        console.log(`\n시트 목록 (총 ${response.data.sheets.length}개):\n`);

        response.data.sheets.forEach((sheet, idx) => {
            const props = sheet.properties;
            console.log(`${idx + 1}. ${props.title}`);
            console.log(`   - ID: ${props.sheetId}`);
            console.log(`   - 행: ${props.gridProperties.rowCount}, 열: ${props.gridProperties.columnCount}`);
        });

        console.log('\n============================================================');

        // room_price 관련 시트 찾기
        const roomPriceSheet = response.data.sheets.find(s =>
            s.properties.title.toLowerCase().includes('room') ||
            s.properties.title.toLowerCase().includes('price') ||
            s.properties.title.toLowerCase().includes('객실')
        );

        if (roomPriceSheet) {
            console.log(`\n✅ 객실/가격 관련 시트 발견: "${roomPriceSheet.properties.title}"`);
        } else {
            console.log('\n⚠️ room_price 관련 시트를 찾지 못했습니다.');
            console.log('   시트 이름을 확인해주세요.');
        }

    } catch (error) {
        console.error('❌ 오류:', error.message);
    }
}

checkSheets().catch(console.error);
