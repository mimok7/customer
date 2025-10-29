// 주문ID 매핑 문제 점검 스크립트
const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const dotenv = require('dotenv');

// Load environment variables
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

async function checkMapping() {
    console.log('🔍 주문ID 매핑 문제 점검\n');

    try {
        // 1. SH_M 시트 데이터 확인
        console.log('📋 1단계: SH_M 시트 데이터 확인');
        const sheets = await getSheetsClient();

        // 헤더 먼저 확인
        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range: 'SH_M!A1:G1',
        });
        const headers = headerResponse.data.values?.[0] || [];
        console.log('   SH_M 헤더:', headers.join(' | '));

        // 데이터 확인
        const response = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range: 'SH_M!A2:G',
        });

        const rows = response.data.values || [];
        console.log(`   ✅ SH_M 시트: ${rows.length}행 조회\n`);

        // 샘플 5개 출력
        console.log('   📊 샘플 데이터 (첫 5개):');
        rows.slice(0, 5).forEach((row, idx) => {
            console.log(`   ${idx + 1}. A열(주문ID): ${row[0] || '없음'}, C열(이메일): ${row[2] || '없음'}`);
        });

        // 이메일 통계
        const emails = rows.map(r => r[2]?.trim()?.toLowerCase()).filter(Boolean);
        const uniqueEmails = new Set(emails);
        console.log(`\n   📧 총 이메일: ${emails.length}개, 유니크: ${uniqueEmails.size}개`);

        // 2. users 테이블 확인
        console.log('\n📋 2단계: users 테이블 확인');
        const { data: users, error: usersError } = await supabase
            .from('users')
            .select('id, email');

        if (usersError) {
            console.error('   ❌ users 테이블 조회 오류:', usersError);
            return;
        }

        console.log(`   ✅ users 테이블: ${users.length}명\n`);

        // 샘플 5개 출력
        console.log('   📊 샘플 사용자 (첫 5개):');
        users.slice(0, 5).forEach((user, idx) => {
            console.log(`   ${idx + 1}. ${user.email}`);
        });

        // 3. 이메일 매핑 테스트
        console.log('\n📋 3단계: 이메일 매칭 테스트');

        const emailToUserId = new Map(
            users.map(u => [u.email?.toLowerCase(), u.id])
        );

        const shMEmails = [...uniqueEmails];
        const usersEmails = new Set(users.map(u => u.email?.toLowerCase()));

        // 매칭되는 이메일
        const matchedEmails = shMEmails.filter(email => usersEmails.has(email));
        // 매칭 안되는 이메일
        const unmatchedEmails = shMEmails.filter(email => !usersEmails.has(email));

        console.log(`   ✅ 매칭 성공: ${matchedEmails.length}개`);
        console.log(`   ❌ 매칭 실패: ${unmatchedEmails.length}개`);

        if (unmatchedEmails.length > 0) {
            console.log('\n   ⚠️ 매칭 실패 이메일 (첫 10개):');
            unmatchedEmails.slice(0, 10).forEach((email, idx) => {
                console.log(`   ${idx + 1}. ${email}`);
            });
        }

        // 4. 주문ID → 사용자ID 매핑 생성
        console.log('\n📋 4단계: 주문ID → 사용자ID 매핑 생성');

        const orderToUserId = new Map();
        let mappedCount = 0;
        let unmappedCount = 0;

        rows.forEach(row => {
            const orderId = row[0]?.trim();
            const email = row[2]?.trim()?.toLowerCase(); // C열: Email

            if (orderId && email) {
                const userId = emailToUserId.get(email);
                if (userId) {
                    orderToUserId.set(orderId, userId);
                    mappedCount++;
                } else {
                    unmappedCount++;
                }
            }
        });

        console.log(`   ✅ 매핑 성공: ${mappedCount}개 주문`);
        console.log(`   ❌ 매핑 실패: ${unmappedCount}개 주문`);

        if (orderToUserId.size === 0) {
            console.log('\n❌ 주문ID 매핑이 0개입니다!');
            console.log('   문제: SH_M의 이메일과 users 테이블의 이메일이 일치하지 않습니다.');
            console.log('\n   해결 방법:');
            console.log('   1. users 테이블에 사용자 추가');
            console.log('   2. SH_M 시트의 이메일 형식 확인');
        } else {
            console.log(`\n✅ 총 ${orderToUserId.size}개 주문이 매핑되었습니다!`);

            // 매핑 샘플 출력
            console.log('\n   📊 매핑 샘플 (첫 5개):');
            let count = 0;
            for (const [orderId, userId] of orderToUserId.entries()) {
                if (count >= 5) break;
                const email = rows.find(r => r[0] === orderId)?.[2]; // C열
                console.log(`   ${count + 1}. 주문ID: ${orderId} → 사용자ID: ${userId.substring(0, 8)}... (${email})`);
                count++;
            }
        }

        // 5. SH_CC 주문ID와 비교
        console.log('\n📋 5단계: SH_CC 주문ID 확인');
        const shCCResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range: 'SH_CC!B2:B', // B열: 주문ID
        });

        const shCCOrderIds = (shCCResponse.data.values || [])
            .map(row => row[0]?.trim())
            .filter(Boolean);

        const uniqueShCCOrderIds = new Set(shCCOrderIds);
        console.log(`   SH_CC 주문ID: ${shCCOrderIds.length}건 (유니크: ${uniqueShCCOrderIds.size}개)`);

        // SH_CC의 주문ID 중 매핑 가능한 개수
        const mappableOrderIds = [...uniqueShCCOrderIds].filter(orderId =>
            orderToUserId.has(orderId)
        );

        console.log(`   ✅ 매핑 가능: ${mappableOrderIds.length}개`);
        console.log(`   ❌ 매핑 불가: ${uniqueShCCOrderIds.size - mappableOrderIds.length}개`);

        if (uniqueShCCOrderIds.size - mappableOrderIds.length > 0) {
            const unmappableOrderIds = [...uniqueShCCOrderIds].filter(orderId =>
                !orderToUserId.has(orderId)
            );
            console.log('\n   ⚠️ 매핑 불가 주문ID (첫 10개):');
            unmappableOrderIds.slice(0, 10).forEach((orderId, idx) => {
                console.log(`   ${idx + 1}. ${orderId}`);
            });
        }

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
    }
}

checkMapping();
