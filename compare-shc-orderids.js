require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const fs = require('fs');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

// Auth ID 매핑 로드
const authIdMapping = JSON.parse(fs.readFileSync('./scripts/auth-id-mapping.json', 'utf8'));

async function compareSHCOrderIds() {
    console.log('🔍 SH_C 주문ID vs Auth Mapping 비교\n');

    // Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // SH_C 시트 데이터 로드
    console.log('1️⃣ SH_C 시트 주문ID 로드\n');

    const dataResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_C!B2:B', // B열: 주문ID만
    });

    const rows = dataResponse.data.values || [];
    const shcOrderIds = new Set(rows.map(row => row[0]).filter(id => id));

    console.log(`   SH_C 주문ID: ${shcOrderIds.size}개 (유니크)\n`);

    // 2. Auth Mapping 주문ID
    const authOrderIds = new Set(Object.keys(authIdMapping));
    console.log(`2️⃣ Auth Mapping 주문ID: ${authOrderIds.size}개\n`);

    // 3. 교집합
    const matchedIds = new Set([...shcOrderIds].filter(id => authOrderIds.has(id)));
    console.log(`3️⃣ 매칭되는 주문ID: ${matchedIds.size}개\n`);

    // 4. 차집합
    const shcOnlyIds = new Set([...shcOrderIds].filter(id => !authOrderIds.has(id)));
    console.log(`4️⃣ SH_C에만 있는 주문ID: ${shcOnlyIds.size}개\n`);

    if (shcOnlyIds.size > 0) {
        console.log('   샘플 (처음 20개):');
        Array.from(shcOnlyIds).slice(0, 20).forEach(id => {
            console.log(`     - ${id}`);
        });
    }

    // 5. 매칭률
    const matchRate = ((matchedIds.size / shcOrderIds.size) * 100).toFixed(2);
    console.log(`\n📊 매칭률: ${matchRate}%\n`);
}

compareSHCOrderIds().catch(console.error);
