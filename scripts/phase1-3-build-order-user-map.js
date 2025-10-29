#!/usr/bin/env node

/**
 * Phase 1-3: 주문ID-사용자 매핑 테이블 생성
 * SH_M의 주문ID와 Supabase users 테이블 매칭
 * 이관 작업에만 사용하며, Supabase에는 저장하지 않음
 */

const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SH_M_RANGE = 'SH_M!A2:W'; // 주문ID부터 모든 컬럼

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function getGoogleSheetsClient() {
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

// 전화번호 정규화
function normalizePhone(phone) {
    if (!phone) return '';
    return phone.replace(/[^0-9]/g, '').trim();
}

// 이름 정규화
function normalizeName(name) {
    if (!name) return '';
    return name.replace(/\s+/g, '').trim().toLowerCase();
}

async function main() {
    console.log('🔍 Phase 1-3: 주문ID-사용자 매핑 테이블 생성 시작\n');

    try {
        // 1. SH_M 시트에서 사용자 데이터 읽기
        console.log('📊 Step 1: SH_M 시트에서 사용자 데이터 읽기');
        const sheets = await getGoogleSheetsClient();

        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_M!A1:W1',
        });
        const headers = headerResponse.data.values[0];

        const dataResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: SH_M_RANGE,
        });
        const rows = dataResponse.data.values || [];

        console.log(`   - 총 ${rows.length}개 사용자 데이터 발견`);

        // 컬럼 인덱스 찾기
        const orderIdIdx = headers.indexOf('주문ID');
        const emailIdx = headers.indexOf('Email');
        const korNameIdx = headers.indexOf('한글이름');
        const engNameIdx = headers.indexOf('영문이름');
        const nameIdx = headers.indexOf('이름');
        const phoneIdx = headers.indexOf('전화번호');

        console.log(`   - 주문ID: ${orderIdIdx}, Email: ${emailIdx}, 이름: ${nameIdx}, 전화번호: ${phoneIdx}\n`);

        // 2. Supabase users 테이블 전체 조회
        console.log('📊 Step 2: Supabase users 테이블 조회');

        let allUsers = [];
        let page = 0;
        const pageSize = 1000;
        let hasMore = true;

        while (hasMore) {
            const { data, error } = await supabase
                .from('users')
                .select('id, email, name, phone_number')
                .range(page * pageSize, (page + 1) * pageSize - 1);

            if (error) {
                console.error('   ❌ users 조회 실패:', error.message);
                process.exit(1);
            }

            if (data && data.length > 0) {
                allUsers = allUsers.concat(data);
                page++;

                if (data.length < pageSize) {
                    hasMore = false;
                }
            } else {
                hasMore = false;
            }
        }

        console.log(`   - 총 ${allUsers.length}명 users 데이터 조회 완료\n`);

        // 3. 매칭 시도
        console.log('📊 Step 3: 주문ID → users.id 매칭 시작');
        console.log('   매칭 우선순위:');
        console.log('   1. Email 완전 일치');
        console.log('   2. 전화번호 일치');
        console.log('   3. 이름 일치\n');

        const orderUserMap = {}; // { orderId: userId }
        const matchDetails = {}; // { orderId: { userId, matchType, details } }
        const unmatchedOrders = [];

        let emailMatched = 0;
        let phoneMatched = 0;
        let nameMatched = 0;

        rows.forEach((row, idx) => {
            const orderId = row[orderIdIdx];
            if (!orderId) return;

            const email = row[emailIdx]?.trim().toLowerCase();
            const korName = row[korNameIdx]?.trim();
            const engName = row[engNameIdx]?.trim();
            const name = row[nameIdx]?.trim() || korName;
            const phone = normalizePhone(row[phoneIdx]);

            let matched = false;
            let matchType = null;
            let matchedUser = null;

            // 1순위: Email 매칭
            if (email) {
                const userByEmail = allUsers.find(u => u.email?.toLowerCase() === email);
                if (userByEmail) {
                    orderUserMap[orderId] = userByEmail.id;
                    matchedUser = userByEmail;
                    matchType = 'email';
                    emailMatched++;
                    matched = true;
                }
            }

            // 2순위: 전화번호 매칭
            if (!matched && phone) {
                const userByPhone = allUsers.find(u => normalizePhone(u.phone_number) === phone);
                if (userByPhone) {
                    orderUserMap[orderId] = userByPhone.id;
                    matchedUser = userByPhone;
                    matchType = 'phone';
                    phoneMatched++;
                    matched = true;
                }
            }

            // 3순위: 이름 매칭 (정규화)
            if (!matched && name) {
                const normalizedInputName = normalizeName(name);
                const userByName = allUsers.find(u => normalizeName(u.name) === normalizedInputName);
                if (userByName) {
                    orderUserMap[orderId] = userByName.id;
                    matchedUser = userByName;
                    matchType = 'name';
                    nameMatched++;
                    matched = true;
                }
            }

            // 매칭 결과 저장
            if (matched) {
                matchDetails[orderId] = {
                    userId: matchedUser.id,
                    matchType,
                    shM: {
                        orderId,
                        email,
                        name,
                        phone
                    },
                    user: {
                        id: matchedUser.id,
                        email: matchedUser.email,
                        name: matchedUser.name,
                        phone: matchedUser.phone_number
                    }
                };
            } else {
                unmatchedOrders.push({
                    orderId,
                    email,
                    name,
                    phone,
                    rowIndex: idx + 2 // Excel 행 번호 (헤더 포함)
                });
            }
        });

        // 4. 매칭 결과 통계
        const totalOrders = rows.filter(row => row[orderIdIdx]).length;
        const matchedCount = Object.keys(orderUserMap).length;
        const matchRate = (matchedCount / totalOrders * 100).toFixed(1);

        console.log('📊 매칭 통계:');
        console.log(`   - 총 주문ID: ${totalOrders}개`);
        console.log(`   - 매칭 성공: ${matchedCount}개 (${matchRate}%)`);
        console.log(`   - 매칭 실패: ${unmatchedOrders.length}개 (${(100 - matchRate).toFixed(1)}%)`);
        console.log(`\n   매칭 방법별 분류:`);
        console.log(`   - Email 매칭: ${emailMatched}개 (${(emailMatched / matchedCount * 100).toFixed(1)}%)`);
        console.log(`   - 전화번호 매칭: ${phoneMatched}개 (${(phoneMatched / matchedCount * 100).toFixed(1)}%)`);
        console.log(`   - 이름 매칭: ${nameMatched}개 (${(nameMatched / matchedCount * 100).toFixed(1)}%)`);

        // 5. 미매칭 케이스 샘플 출력
        if (unmatchedOrders.length > 0) {
            console.log(`\n⚠️  미매칭 주문ID (상위 10개):`);
            unmatchedOrders.slice(0, 10).forEach((order, idx) => {
                console.log(`   ${idx + 1}. 주문ID: ${order.orderId}`);
                console.log(`      Email: ${order.email || '(없음)'}`);
                console.log(`      이름: ${order.name || '(없음)'}`);
                console.log(`      전화번호: ${order.phone || '(없음)'}`);
                console.log(`      (SH_M 행: ${order.rowIndex})`);
            });

            if (unmatchedOrders.length > 10) {
                console.log(`   ... 외 ${unmatchedOrders.length - 10}개`);
            }
        }

        // 6. 매칭 테이블 저장
        const mappingData = {
            generatedAt: new Date().toISOString(),
            stats: {
                totalOrders,
                matchedCount,
                unmatchedCount: unmatchedOrders.length,
                matchRate: `${matchRate}%`,
                matchByEmail: emailMatched,
                matchByPhone: phoneMatched,
                matchByName: nameMatched
            },
            orderUserMap, // 이관 시 사용할 메인 맵
            matchDetails, // 디버깅용 상세 정보
            unmatchedOrders // 미매칭 목록
        };

        const mappingPath = path.join(__dirname, 'mapping-order-user.json');
        fs.writeFileSync(mappingPath, JSON.stringify(mappingData, null, 2));
        console.log(`\n✅ 매칭 테이블 저장: ${mappingPath}`);

        // 7. 다음 단계 안내
        console.log(`\n💡 다음 단계:`);
        if (unmatchedOrders.length > 0) {
            console.log(`   ⚠️  ${unmatchedOrders.length}개 주문ID 미매칭`);
            console.log(`   - 이관 시 해당 주문은 스킵됨`);
            console.log(`   - users 테이블에 사용자 추가 후 재매칭 가능`);
        }
        console.log(`   ✅ Phase 1 (기초 데이터 준비) 완료`);
        console.log(`   → Phase 2 (테스트 이관) 진행 가능`);

        console.log(`\n✅ Phase 1-3 완료`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
