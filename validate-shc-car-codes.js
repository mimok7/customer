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

async function validateSHCCarCodes() {
    console.log('🔍 SH_C 차량코드 검증\n');

    // Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // 1. car_price 테이블의 모든 car_code 조회
    console.log('1️⃣ car_price 테이블의 차량코드 목록:\n');

    const { data: carPrices, error: carPriceError } = await supabase
        .from('car_price')
        .select('car_code, cruise, car_category, car_type, schedule, passenger_count, price')
        .order('car_code');

    if (carPriceError) {
        console.error('   ❌ 오류:', carPriceError.message);
        return;
    }

    console.log(`   ✅ 총 ${carPrices?.length || 0}개 차량코드\n`);

    const validCarCodes = new Set(carPrices.map(p => p.car_code));
    console.log('   유효한 차량코드:', Array.from(validCarCodes).join(', '));

    // car_code별 샘플 보기
    console.log('\n   차량코드 샘플:');
    const codeGroups = {};
    carPrices.forEach(price => {
        if (!codeGroups[price.car_code]) {
            codeGroups[price.car_code] = [];
        }
        codeGroups[price.car_code].push(price);
    });

    Object.keys(codeGroups).slice(0, 5).forEach(code => {
        const items = codeGroups[code];
        console.log(`\n   ${code}: ${items.length}개 옵션`);
        items.slice(0, 2).forEach((item, idx) => {
            console.log(`     [${idx + 1}] ${item.cruise} | ${item.car_category} | ${item.car_type} | ${item.schedule} | ${item.passenger_count} | ${item.price?.toLocaleString()}동`);
        });
    });

    // 2. SH_C 시트의 차량코드 확인
    console.log('\n\n2️⃣ SH_C 시트의 차량코드 확인:\n');

    const dataResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_C!A2:U',
    });

    const rows = dataResponse.data.values || [];
    console.log(`   ✅ 총 ${rows.length}개 행\n`);

    // 차량코드 분석
    const shcCarCodes = new Map();
    const missingCodes = new Set();
    const validCodes = new Set();

    rows.forEach((row, idx) => {
        const carCode = row[6]; // G열 (index 6)
        if (carCode) {
            if (!shcCarCodes.has(carCode)) {
                shcCarCodes.set(carCode, []);
            }
            shcCarCodes.get(carCode).push({
                rowNum: idx + 2,
                orderId: row[1],
                cruise: row[4],
                carType: row[5],
                carCode: carCode,
                passengerCount: row[8],
                amount: row[16]
            });

            if (validCarCodes.has(carCode)) {
                validCodes.add(carCode);
            } else {
                missingCodes.add(carCode);
            }
        }
    });

    console.log(`   SH_C에 사용된 차량코드: ${shcCarCodes.size}개`);
    console.log(`   ✅ 유효한 코드: ${validCodes.size}개`);
    console.log(`   ⚠️  누락된 코드: ${missingCodes.size}개\n`);

    if (missingCodes.size > 0) {
        console.log('   ❌ car_price 테이블에 없는 코드:');
        Array.from(missingCodes).forEach(code => {
            const samples = shcCarCodes.get(code).slice(0, 2);
            console.log(`\n   ${code}: ${shcCarCodes.get(code).length}개 사용`);
            samples.forEach(sample => {
                console.log(`     - 행${sample.rowNum}: ${sample.cruise} | ${sample.carType} | ${sample.passengerCount}명 | ${sample.amount}동`);
            });
        });
    }

    // 3. 차량코드별 매핑 상태
    console.log('\n\n3️⃣ 차량코드별 매핑 상태:\n');

    Array.from(shcCarCodes.entries()).slice(0, 10).forEach(([code, usages]) => {
        const status = validCarCodes.has(code) ? '✅' : '❌';
        console.log(`   ${status} ${code}: ${usages.length}회 사용`);

        if (validCarCodes.has(code)) {
            const priceOptions = codeGroups[code];
            console.log(`      → car_price에 ${priceOptions.length}개 옵션 존재`);
        }
    });

    // 4. 통계
    console.log('\n\n📊 최종 통계:\n');
    console.log(`   - SH_C 총 행: ${rows.length}개`);
    console.log(`   - 사용된 차량코드: ${shcCarCodes.size}개`);
    console.log(`   - 유효한 코드: ${validCodes.size}개`);
    console.log(`   - 누락된 코드: ${missingCodes.size}개`);
    console.log(`   - car_price 총 코드: ${validCarCodes.size}개`);
}

validateSHCCarCodes().catch(console.error);
