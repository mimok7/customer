#!/usr/bin/env node

/**
 * 주문ID 상태 확인 스크립트
 * 1. SH_M 시트에서 주문ID 읽기
 * 2. users 테이블에 주문ID 컬럼 확인
 * 3. 주문ID 매핑 상태 점검
 */

const { google } = require('googleapis');
const { createClient } = require('@supabase/supabase-js');
const dotenv = require('dotenv');
const path = require('path');

// .env.local 파일 로드
dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SH_M_RANGE = 'SH_M!A2:W'; // 주문ID는 A컬럼

// Supabase 클라이언트 초기화
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

// Google Sheets API 인증 설정
async function getGoogleSheetsClient() {
    const { GoogleAuth } = require('google-auth-library');

    const auth = new GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });

    const authClient = await auth.getClient();
    return google.sheets({ version: 'v4', auth: authClient });
}

async function main() {
    console.log('🔍 주문ID 상태 확인 시작...\n');

    let orderIdColumns = []; // 함수 최상위에 선언

    try {
        // 1. SH_M에서 주문ID 읽기
        console.log('📊 Step 1: SH_M 시트에서 주문ID 샘플 읽기');
        const sheets = await getGoogleSheetsClient();
        const response = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: SH_M_RANGE,
        });

        const rows = response.data.values || [];
        console.log(`   - 총 ${rows.length}개 행 발견`);

        // 주문ID 샘플 (A컬럼)
        const orderIds = rows.slice(0, 10).map(row => row[0]).filter(Boolean);
        console.log(`   - 샘플 주문ID (처음 10개):`);
        orderIds.forEach((id, idx) => {
            console.log(`     ${idx + 1}. ${id}`);
        });

        // 주문ID 통계
        const allOrderIds = rows.map(row => row[0]).filter(Boolean);
        const uniqueOrderIds = new Set(allOrderIds);
        console.log(`   - 총 주문ID 개수: ${allOrderIds.length}`);
        console.log(`   - 고유 주문ID 개수: ${uniqueOrderIds.size}`);
        console.log(`   - 중복 주문ID: ${allOrderIds.length - uniqueOrderIds.size}개\n`);

        // 2. users 테이블 구조 확인
        console.log('📊 Step 2: users 테이블 구조 확인');
        const { data: users, error: usersError } = await supabase
            .from('users')
            .select('*')
            .limit(1);

        if (usersError) {
            console.error('   ❌ users 테이블 조회 실패:', usersError.message);
        } else if (users && users.length > 0) {
            const columns = Object.keys(users[0]);
            console.log(`   - users 테이블 컬럼 (${columns.length}개):`);
            columns.forEach(col => {
                console.log(`     - ${col}`);
            });

            // 주문ID 관련 컬럼 확인
            orderIdColumns = columns.filter(col =>
                col.toLowerCase().includes('order') ||
                col.includes('주문') ||
                col.toLowerCase().includes('quote_id')
            );

            if (orderIdColumns.length > 0) {
                console.log(`\n   ✅ 주문 관련 컬럼 발견: ${orderIdColumns.join(', ')}`);
            } else {
                console.log(`\n   ⚠️  주문ID 관련 컬럼 없음`);
            }
        }

        // 3. Email과 주문ID 매핑 샘플
        console.log('\n📊 Step 3: Email-주문ID 매핑 샘플 (SH_M 기준)');
        const mappingSamples = rows.slice(0, 5).map(row => ({
            주문ID: row[0],
            Email: row[2],
            한글이름: row[3],
            영문이름: row[4],
        }));

        console.log('   샘플 데이터:');
        mappingSamples.forEach((sample, idx) => {
            console.log(`   ${idx + 1}. 주문ID: ${sample.주문ID} | Email: ${sample.Email} | 이름: ${sample.한글이름}`);
        });

        // 4. users 테이블에서 동일 Email 확인
        console.log('\n📊 Step 4: users 테이블에서 매칭 확인');
        for (const sample of mappingSamples.slice(0, 3)) {
            if (sample.Email) {
                const { data: matchedUsers, error } = await supabase
                    .from('users')
                    .select('id, email, name')
                    .eq('email', sample.Email)
                    .limit(1);

                if (matchedUsers && matchedUsers.length > 0) {
                    console.log(`   ✅ ${sample.Email}: users 테이블에 존재`);
                    console.log(`      - user_id: ${matchedUsers[0].id}`);
                    console.log(`      - 이름: ${matchedUsers[0].name}`);
                    console.log(`      - 주문ID (SH_M): ${sample.주문ID}`);
                } else {
                    console.log(`   ❌ ${sample.Email}: users 테이블에 없음`);
                }
            }
        }

        // 5. 권장 사항
        console.log('\n💡 분석 결과 및 권장 사항:');
        console.log('   1. SH_M의 주문ID는 A컬럼에 정상적으로 존재');
        console.log(`   2. 총 ${uniqueOrderIds.size}개의 고유 주문ID 확인`);

        if (orderIdColumns.length === 0) {
            console.log('   3. ⚠️  users 테이블에 주문ID 컬럼 없음');
            console.log('   4. 📋 다음 작업 필요:');
            console.log('      - users 테이블에 order_id 컬럼 추가');
            console.log('      - SH_M 주문ID를 users.order_id에 업데이트');
            console.log('      - SH_R 이관시 주문ID로 users 매칭');
        } else {
            console.log(`   3. ✅ users 테이블에 주문 관련 컬럼 존재: ${orderIdColumns.join(', ')}`);
            console.log('   4. 해당 컬럼에 주문ID 데이터가 저장되어 있는지 확인 필요');
        }

        console.log('\n✅ 주문ID 상태 확인 완료');

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
