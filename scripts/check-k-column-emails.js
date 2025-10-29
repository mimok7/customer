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

async function checkKColumnEmails() {
    console.log('🔍 SH_CC K열(Email) 데이터 확인 중...\n');

    const sheets = await getSheetsClient();

    // K열 전체 조회
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_CC!K:K', // K열 전체
    });

    const rows = response.data.values || [];

    console.log(`📊 K열 총 행 수: ${rows.length}개`);

    // 비어있지 않은 이메일 찾기
    const emailRows = [];
    rows.forEach((row, index) => {
        const email = row[0]?.trim();
        if (email && email !== 'Email' && email !== '' && email !== '-') {
            emailRows.push({
                rowNumber: index + 1,
                email: email
            });
        }
    });

    console.log(`✅ 이메일이 있는 행: ${emailRows.length}개\n`);

    if (emailRows.length > 0) {
        console.log('📧 샘플 이메일 (최대 20개):');
        emailRows.slice(0, 20).forEach(item => {
            console.log(`  행 ${item.rowNumber}: ${item.email}`);
        });
    } else {
        console.log('⚠️  K열에 이메일 데이터가 없습니다!');
        console.log('💡 대신 SH_M 시트의 주문ID → 이메일 매핑을 사용해야 합니다.');
    }

    return emailRows.length;
}

checkKColumnEmails().catch(console.error);
