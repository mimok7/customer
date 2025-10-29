#!/usr/bin/env node

/**
 * 실패한 40건 분석 및 사용자 추가
 * 외래 키 제약 조건으로 실패한 예약의 사용자를 users 테이블에 추가
 */

const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function getGoogleSheetsClient() {
    const auth = new GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets'],
    });

    const authClient = await auth.getClient();
    return google.sheets({ version: 'v4', auth: authClient });
}

async function main() {
    console.log('🔍 실패한 40건 분석 및 사용자 추가\n');

    try {
        // 1. Phase 3 결과 로드
        const resultPath = path.join(__dirname, 'phase3-full-migration-result.json');
        if (!fs.existsSync(resultPath)) {
            console.error('❌ phase3-full-migration-result.json 파일이 없습니다.');
            return;
        }

        const migrationResult = JSON.parse(fs.readFileSync(resultPath, 'utf8'));
        const failedCases = migrationResult.results.failed;

        console.log(`📊 실패 건수: ${failedCases.length}건\n`);

        // 외래 키 제약 조건 실패만 필터링
        const foreignKeyFailures = failedCases.filter(f =>
            f.error.includes('foreign key constraint') &&
            f.error.includes('reservation_re_user_id_fkey')
        );

        console.log(`🎯 외래 키 실패 건수: ${foreignKeyFailures.length}건\n`);

        if (foreignKeyFailures.length === 0) {
            console.log('✅ 외래 키 제약 조건 실패 건이 없습니다.');
            return;
        }

        // 2. 매핑 테이블 로드
        const orderUserMappingPath = path.join(__dirname, 'mapping-order-user.json');
        const orderUserData = JSON.parse(fs.readFileSync(orderUserMappingPath, 'utf8'));
        const orderUserMap = orderUserData.orderUserMap;

        // 3. Google Sheets에서 SH_M 데이터 읽기
        console.log('📊 SH_M 사용자 데이터 읽기...');
        const sheets = await getGoogleSheetsClient();

        const shMResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_M!A:I',
        });

        const shMRows = shMResponse.data.values || [];
        const shMHeaders = shMRows[0];
        const shMData = shMRows.slice(1);

        const orderIdIdx = shMHeaders.indexOf('주문ID');
        const emailIdx = shMHeaders.indexOf('Email');
        const nameIdx = shMHeaders.indexOf('한글이름');
        const engNameIdx = shMHeaders.indexOf('영문이름');
        const phoneIdx = shMHeaders.indexOf('전화번호');

        console.log(`   ✅ ${shMData.length}개 사용자 데이터 읽기 완료\n`);

        // 4. 실패한 주문ID들의 사용자 정보 수집
        const missingUsers = [];

        for (const failure of foreignKeyFailures) {
            const orderId = failure.orderId;
            const userId = orderUserMap[orderId];

            if (!userId) {
                console.log(`   ⚠️  행 ${failure.rowNum}: 주문ID ${orderId}가 매핑되지 않음`);
                continue;
            }

            // SH_M에서 사용자 정보 찾기
            const userRow = shMData.find(row => row[orderIdIdx] === orderId);

            if (!userRow) {
                console.log(`   ⚠️  행 ${failure.rowNum}: SH_M에서 주문ID ${orderId}를 찾을 수 없음`);
                continue;
            }

            const email = userRow[emailIdx] || null;
            const name = userRow[nameIdx] || null;
            const engName = userRow[engNameIdx] || null;
            const phone = userRow[phoneIdx] || null;

            // users 테이블에 이미 있는지 확인
            const { data: existingUser } = await supabase
                .from('users')
                .select('id')
                .eq('id', userId)
                .single();

            if (existingUser) {
                console.log(`   ✅ 행 ${failure.rowNum}: 사용자 ${userId}는 이미 존재함`);
                continue;
            }

            missingUsers.push({
                rowNum: failure.rowNum,
                orderId,
                userId,
                email,
                name,
                engName,
                phone
            });
        }

        console.log(`\n📊 추가할 사용자: ${missingUsers.length}명\n`);

        if (missingUsers.length === 0) {
            console.log('✅ 추가할 사용자가 없습니다.');
            return;
        }

        // 5. 사용자 추가 (확인 후)
        console.log('📋 추가할 사용자 목록:');
        missingUsers.forEach((user, idx) => {
            console.log(`\n   [${idx + 1}] 행 ${user.rowNum}:`);
            console.log(`      - 주문ID: ${user.orderId}`);
            console.log(`      - 사용자 ID: ${user.userId}`);
            console.log(`      - 이메일: ${user.email || '(없음)'}`);
            console.log(`      - 이름: ${user.name || '(없음)'}`);
            console.log(`      - 영문이름: ${user.engName || '(없음)'}`);
            console.log(`      - 전화번호: ${user.phone || '(없음)'}`);
        });

        console.log('\n⚠️  위 사용자들을 users 테이블에 추가합니다...\n');

        // 6. 실제 사용자 추가
        const addedUsers = [];
        const failedUsers = [];

        for (const user of missingUsers) {
            try {
                const { data, error } = await supabase
                    .from('users')
                    .insert({
                        id: user.userId,
                        email: user.email,
                        name: user.name,
                        english_name: user.engName,
                        phone_number: user.phone,
                        role: 'member',
                        status: 'active',
                        created_at: new Date().toISOString()
                    })
                    .select();

                if (error) {
                    throw error;
                }

                addedUsers.push({
                    ...user,
                    success: true
                });

                console.log(`   ✅ 행 ${user.rowNum}: ${user.name || user.email || user.userId} 추가 완료`);

            } catch (error) {
                failedUsers.push({
                    ...user,
                    error: error.message
                });

                console.log(`   ❌ 행 ${user.rowNum}: ${user.name || user.email || user.userId} 추가 실패 - ${error.message}`);
            }
        }

        // 7. 결과 요약
        console.log(`\n${'='.repeat(60)}`);
        console.log('📊 사용자 추가 결과');
        console.log(`${'='.repeat(60)}`);
        console.log(`   - 추가 성공: ${addedUsers.length}명`);
        console.log(`   - 추가 실패: ${failedUsers.length}명`);

        if (failedUsers.length > 0) {
            console.log('\n   ❌ 실패한 사용자:');
            failedUsers.forEach((user, idx) => {
                console.log(`      ${idx + 1}. ${user.name || user.email}: ${user.error}`);
            });
        }

        // 8. 결과 저장
        const resultOutputPath = path.join(__dirname, 'add-missing-users-result.json');
        fs.writeFileSync(resultOutputPath, JSON.stringify({
            processedAt: new Date().toISOString(),
            totalMissingUsers: missingUsers.length,
            addedCount: addedUsers.length,
            failedCount: failedUsers.length,
            addedUsers,
            failedUsers
        }, null, 2));

        console.log(`\n✅ 결과 저장: ${resultOutputPath}`);

        if (addedUsers.length > 0) {
            console.log('\n💡 다음 단계:');
            console.log('   1. 실패한 40건을 다시 이관해보세요.');
            console.log('   2. 이제 사용자가 존재하므로 성공할 것입니다.');
            console.log(`   3. 명령어: node scripts/retry-failed-reservations.js`);
        }

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
    }
}

main();
