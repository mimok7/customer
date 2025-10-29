require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const { createClient } = require('@supabase/supabase-js');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY,
    {
        auth: {
            autoRefreshToken: false,
            persistSession: false
        }
    }
);

async function checkSHCStructure() {
    console.log('🔍 SH_C 시트 구조 확인\n');

    // Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // 1. SH_C 헤더 확인
    const headerResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_C!A1:Z1',
    });

    const headers = headerResponse.data.values?.[0] || [];
    console.log('1️⃣ SH_C 컬럼 구조:\n');
    headers.forEach((header, idx) => {
        const letter = String.fromCharCode(65 + idx);
        console.log(`   ${letter} (index ${idx}): ${header}`);
    });

    // 2. SH_C 샘플 데이터
    const dataResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_C!A2:Z10',
    });

    const rows = dataResponse.data.values || [];
    console.log(`\n2️⃣ SH_C 데이터: ${rows.length}개 샘플\n`);

    if (rows.length > 0) {
        console.log('첫 번째 행 샘플:');
        rows[0].forEach((value, idx) => {
            const letter = String.fromCharCode(65 + idx);
            const header = headers[idx] || '(no header)';
            console.log(`   ${letter} [${header}]: ${value}`);
        });
    }

    // 3. car_price 테이블 구조 확인
    console.log('\n3️⃣ car_price 테이블 구조:\n');

    const { data: carPrices, error } = await supabase
        .from('car_price')
        .select('*')
        .limit(5);

    if (error) {
        console.error('   ❌ 오류:', error.message);
    } else {
        console.log(`   ✅ ${carPrices?.length || 0}개 샘플`);
        if (carPrices && carPrices.length > 0) {
            console.log('\n   컬럼 목록:');
            Object.keys(carPrices[0]).forEach(key => {
                console.log(`     - ${key}`);
            });

            console.log('\n   샘플 데이터:');
            carPrices.slice(0, 2).forEach((price, idx) => {
                console.log(`\n   [${idx + 1}]`);
                console.log(`     car_code: ${price.car_code}`);
                console.log(`     cruise: ${price.cruise}`);
                console.log(`     route: ${price.route}`);
                console.log(`     vehicle_type: ${price.vehicle_type}`);
                console.log(`     passenger_count: ${price.passenger_count}`);
                console.log(`     base_price: ${price.base_price}`);
            });
        }
    }

    // 4. SH_C 전체 데이터 개수
    const allDataResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_C!A2:A',
    });

    const allRows = allDataResponse.data.values || [];
    console.log(`\n4️⃣ SH_C 전체 데이터: ${allRows.length}개 행\n`);
}

checkSHCStructure().catch(console.error);
