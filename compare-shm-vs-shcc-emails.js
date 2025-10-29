const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const dotenv = require('dotenv');

try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const GOOGLE_SHEETS_ID = process.env.GOOGLE_SHEETS_ID;
const GOOGLE_SERVICE_ACCOUNT = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const GOOGLE_SERVICE_KEY = process.env.GOOGLE_SERVICE_ACCOUNT_KEY;

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

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

async function main() {
    console.log('🔍 SH_M vs SH_CC 이메일 비교 분석\n');

    // 1. DB users 테이블 이메일 로드
    const { data: users } = await supabase.from('users').select('email');
    const dbEmails = new Set(users.map(u => u.email?.toLowerCase()?.trim()).filter(Boolean));
    console.log(`📊 DB users 테이블: ${dbEmails.size}개 유니크 이메일\n`);

    // 2. SH_CC K열 이메일 로드
    const sheets = await getSheetsClient();
    const shccResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_CC!A2:K',
    });
    const shccRows = shccResponse.data.values || [];
    const shccEmails = new Set();
    const shccEmailCounts = new Map();

    shccRows.forEach(row => {
        const email = row[10]?.trim()?.toLowerCase();
        if (email) {
            shccEmails.add(email);
            shccEmailCounts.set(email, (shccEmailCounts.get(email) || 0) + 1);
        }
    });

    console.log(`📊 SH_CC K열: ${shccEmails.size}개 유니크 이메일 (총 ${shccRows.length}행)`);
    console.log(`   - 이메일 있는 행: ${Array.from(shccEmailCounts.values()).reduce((a, b) => a + b, 0)}건`);
    console.log(`   - 이메일 없는 행: ${shccRows.length - Array.from(shccEmailCounts.values()).reduce((a, b) => a + b, 0)}건\n`);

    // 3. SH_M C열 이메일 로드
    const shmResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_M!A2:C',
    });
    const shmRows = shmResponse.data.values || [];
    const shmOrderEmails = new Map(); // orderId → email

    shmRows.forEach(row => {
        const orderId = row[0]?.trim();
        const email = row[2]?.trim()?.toLowerCase();
        if (orderId && email) {
            shmOrderEmails.set(orderId, email);
        }
    });

    const shmEmails = new Set(shmOrderEmails.values());
    console.log(`📊 SH_M C열: ${shmEmails.size}개 유니크 이메일 (총 ${shmOrderEmails.size}개 주문)\n`);

    // 4. 교집합 분석
    const shccInDb = Array.from(shccEmails).filter(e => dbEmails.has(e));
    const shmInDb = Array.from(shmEmails).filter(e => dbEmails.has(e));
    const shccNotInDb = Array.from(shccEmails).filter(e => !dbEmails.has(e));

    console.log('🎯 매칭 분석:');
    console.log(`   ✅ SH_CC 이메일 중 DB 매칭: ${shccInDb.length}개 (${((shccInDb.length / shccEmails.size) * 100).toFixed(1)}%)`);
    console.log(`   ✅ SH_M 이메일 중 DB 매칭: ${shmInDb.length}개 (${((shmInDb.length / shmEmails.size) * 100).toFixed(1)}%)`);
    console.log(`   ❌ SH_CC 이메일 중 DB 미매칭: ${shccNotInDb.length}개\n`);

    // 5. SH_CC의 주문ID → SH_M 비교
    const shccOrderIds = new Set(shccRows.map(r => r[1]?.trim()).filter(Boolean));
    const shmOrderIds = new Set(shmOrderEmails.keys());
    const orderIntersection = Array.from(shccOrderIds).filter(id => shmOrderIds.has(id));

    console.log('📋 주문ID 비교:');
    console.log(`   - SH_CC 유니크 주문ID: ${shccOrderIds.size}개`);
    console.log(`   - SH_M 주문ID: ${shmOrderIds.size}개`);
    console.log(`   - 교집합: ${orderIntersection.length}개 (${((orderIntersection.length / shccOrderIds.size) * 100).toFixed(1)}%)\n`);

    // 6. 이메일 형식 분석
    console.log('📝 이메일 형식 분석:');
    const shccEmailSamples = Array.from(shccEmails).slice(0, 10);
    console.log('   SH_CC 샘플:');
    shccEmailSamples.forEach(email => {
        const inDb = dbEmails.has(email) ? '✅' : '❌';
        console.log(`     ${inDb} ${email}`);
    });

    console.log('\n   SH_CC 미매칭 샘플:');
    shccNotInDb.slice(0, 10).forEach(email => {
        console.log(`     ❌ ${email}`);
    });

    // 7. 결론
    console.log('\n\n============================================================');
    console.log('💡 결론');
    console.log('============================================================');

    if (shmInDb.length > shccInDb.length) {
        const expectedMatchedRecords = orderIntersection.length;
        console.log(`✅ SH_M 방식이 더 효율적입니다!`);
        console.log(`   - SH_M 통한 매칭: ${shmInDb.length}개 이메일 → 예상 ${expectedMatchedRecords}건 레코드`);
        console.log(`   - SH_CC 직접 매칭: ${shccInDb.length}개 이메일 → 실제 299건 레코드`);
        console.log(`\n   이유: SH_CC의 K열 이메일이 불완전하거나 DB와 형식이 다름`);
    } else {
        console.log(`✅ SH_CC 직접 매칭이 더 효율적입니다!`);
    }
    console.log('============================================================');
}

main().catch(console.error);
