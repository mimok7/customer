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
    console.log('🔍 SH_M 시트 ↔ users 테이블 데이터 일치 점검\n');
    console.log('='.repeat(70));

    // 1. SH_M 시트 데이터 로드
    console.log('\n📥 SH_M 시트 데이터 로드 중...');
    const sheets = await getSheetsClient();
    const shmResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_M!A2:G', // A:주문ID, B:예약일, C:Email, D:한글이름, E:영문이름, F:닉네임, G:회원등급
    });
    const shmRows = shmResponse.data.values || [];

    console.log(`✅ SH_M 시트: ${shmRows.length}행 조회`);

    // SH_M 데이터 구조화
    const shmData = new Map();
    const shmOrderIds = new Set();
    const shmEmails = new Set();

    shmRows.forEach((row, index) => {
        const orderId = row[0]?.trim();
        const reservationDate = row[1]?.trim();
        const email = row[2]?.trim()?.toLowerCase();
        const koreanName = row[3]?.trim();
        const englishName = row[4]?.trim();
        const nickname = row[5]?.trim();
        const memberGrade = row[6]?.trim();

        if (orderId && email) {
            shmData.set(orderId, {
                orderId,
                reservationDate,
                email,
                koreanName,
                englishName,
                nickname,
                memberGrade,
                rowNumber: index + 2
            });
            shmOrderIds.add(orderId);
            shmEmails.add(email);
        }
    });

    console.log(`   - 유효한 데이터: ${shmData.size}건`);
    console.log(`   - 유니크 주문ID: ${shmOrderIds.size}개`);
    console.log(`   - 유니크 이메일: ${shmEmails.size}개`);

    // 2. users 테이블 데이터 로드
    console.log('\n📥 users 테이블 데이터 로드 중...');
    const { data: users, error: usersError } = await supabase
        .from('users')
        .select('id, order_id, email, name, english_name, nickname, reservation_date');

    if (usersError) {
        console.error('❌ users 조회 오류:', usersError);
        return;
    }

    console.log(`✅ users 테이블: ${users.length}명 조회`);

    // users 데이터 구조화
    const usersData = new Map();
    const usersOrderIds = new Set();
    const usersEmails = new Set();

    users.forEach(user => {
        if (user.order_id) {
            usersData.set(user.order_id, user);
            usersOrderIds.add(user.order_id);
            if (user.email) {
                usersEmails.add(user.email.toLowerCase());
            }
        }
    });

    console.log(`   - order_id 있는 사용자: ${usersOrderIds.size}명`);
    console.log(`   - 유니크 이메일: ${usersEmails.size}개`);

    // 3. 주문ID 기준 매칭 분석
    console.log('\n' + '='.repeat(70));
    console.log('📊 주문ID 기준 매칭 분석');
    console.log('='.repeat(70));

    const orderIdMatches = {
        both: [], // 양쪽 모두 존재
        shmOnly: [], // SH_M에만 존재
        usersOnly: [] // users에만 존재
    };

    // SH_M 기준 체크
    for (const orderId of shmOrderIds) {
        if (usersOrderIds.has(orderId)) {
            const shmItem = shmData.get(orderId);
            const userItem = usersData.get(orderId);
            orderIdMatches.both.push({ orderId, shm: shmItem, user: userItem });
        } else {
            orderIdMatches.shmOnly.push({ orderId, shm: shmData.get(orderId) });
        }
    }

    // users 기준 체크 (SH_M에 없는 것)
    for (const orderId of usersOrderIds) {
        if (!shmOrderIds.has(orderId)) {
            orderIdMatches.usersOnly.push({ orderId, user: usersData.get(orderId) });
        }
    }

    console.log(`\n✅ 양쪽 모두 존재: ${orderIdMatches.both.length}개 (${((orderIdMatches.both.length / shmOrderIds.size) * 100).toFixed(1)}%)`);
    console.log(`❌ SH_M에만 존재: ${orderIdMatches.shmOnly.length}개 (${((orderIdMatches.shmOnly.length / shmOrderIds.size) * 100).toFixed(1)}%)`);
    console.log(`⚠️  users에만 존재: ${orderIdMatches.usersOnly.length}개`);

    // 4. 이메일 기준 매칭 분석
    console.log('\n' + '='.repeat(70));
    console.log('📧 이메일 기준 매칭 분석');
    console.log('='.repeat(70));

    const emailMatches = {
        both: 0,
        shmOnly: 0,
        usersOnly: 0
    };

    for (const email of shmEmails) {
        if (usersEmails.has(email)) {
            emailMatches.both++;
        } else {
            emailMatches.shmOnly++;
        }
    }

    for (const email of usersEmails) {
        if (!shmEmails.has(email)) {
            emailMatches.usersOnly++;
        }
    }

    console.log(`\n✅ 양쪽 모두 존재: ${emailMatches.both}개 (${((emailMatches.both / shmEmails.size) * 100).toFixed(1)}%)`);
    console.log(`❌ SH_M에만 존재: ${emailMatches.shmOnly}개 (${((emailMatches.shmOnly / shmEmails.size) * 100).toFixed(1)}%)`);
    console.log(`⚠️  users에만 존재: ${emailMatches.usersOnly}개`);

    // 5. 데이터 일치성 검증 (양쪽 모두 존재하는 경우)
    console.log('\n' + '='.repeat(70));
    console.log('🔍 데이터 일치성 검증 (주문ID 매칭된 경우)');
    console.log('='.repeat(70));

    const discrepancies = {
        email: [],
        name: [],
        englishName: [],
        nickname: [],
        reservationDate: []
    };

    orderIdMatches.both.forEach(match => {
        const { orderId, shm, user } = match;

        // 이메일 비교
        if (shm.email?.toLowerCase() !== user.email?.toLowerCase()) {
            discrepancies.email.push({
                orderId,
                shm: shm.email,
                user: user.email
            });
        }

        // 이름 비교 (한글 이름)
        if (shm.koreanName && user.name && shm.koreanName !== user.name) {
            discrepancies.name.push({
                orderId,
                shm: shm.koreanName,
                user: user.name
            });
        }

        // 영문 이름 비교
        if (shm.englishName && user.english_name && shm.englishName !== user.english_name) {
            discrepancies.englishName.push({
                orderId,
                shm: shm.englishName,
                user: user.english_name
            });
        }

        // 닉네임 비교
        if (shm.nickname && user.nickname && shm.nickname !== user.nickname) {
            discrepancies.nickname.push({
                orderId,
                shm: shm.nickname,
                user: user.nickname
            });
        }

        // 예약일 비교
        if (shm.reservationDate && user.reservation_date && shm.reservationDate !== user.reservation_date) {
            discrepancies.reservationDate.push({
                orderId,
                shm: shm.reservationDate,
                user: user.reservation_date
            });
        }
    });

    console.log(`\n검증 대상: ${orderIdMatches.both.length}개 주문ID\n`);

    console.log(`📧 이메일 불일치: ${discrepancies.email.length}건`);
    if (discrepancies.email.length > 0) {
        console.log(`   샘플 (최대 5건):`);
        discrepancies.email.slice(0, 5).forEach(d => {
            console.log(`   - ${d.orderId}: SH_M="${d.shm}" vs users="${d.user}"`);
        });
    }

    console.log(`\n👤 한글이름 불일치: ${discrepancies.name.length}건`);
    if (discrepancies.name.length > 0) {
        console.log(`   샘플 (최대 5건):`);
        discrepancies.name.slice(0, 5).forEach(d => {
            console.log(`   - ${d.orderId}: SH_M="${d.shm}" vs users="${d.user}"`);
        });
    }

    console.log(`\n🔤 영문이름 불일치: ${discrepancies.englishName.length}건`);
    if (discrepancies.englishName.length > 0) {
        console.log(`   샘플 (최대 5건):`);
        discrepancies.englishName.slice(0, 5).forEach(d => {
            console.log(`   - ${d.orderId}: SH_M="${d.shm}" vs users="${d.user}"`);
        });
    }

    console.log(`\n📝 닉네임 불일치: ${discrepancies.nickname.length}건`);
    console.log(`📅 예약일 불일치: ${discrepancies.reservationDate.length}건`);

    // 6. SH_M에만 있는 데이터 상세 (users에 추가해야 할 데이터)
    console.log('\n' + '='.repeat(70));
    console.log('📋 SH_M에만 존재하는 주문ID (users 테이블에 추가 필요)');
    console.log('='.repeat(70));

    console.log(`\n총 ${orderIdMatches.shmOnly.length}개 주문ID\n`);

    if (orderIdMatches.shmOnly.length > 0) {
        console.log(`상위 20개 샘플:\n`);
        orderIdMatches.shmOnly.slice(0, 20).forEach((item, index) => {
            const { orderId, shm } = item;
            console.log(`${(index + 1).toString().padStart(3)}. ${orderId.padEnd(12)} | ${shm.email.padEnd(30)} | ${shm.koreanName || 'N/A'}`);
        });

        if (orderIdMatches.shmOnly.length > 20) {
            console.log(`\n... 외 ${orderIdMatches.shmOnly.length - 20}개\n`);
        }
    }

    // 7. 최종 요약
    console.log('\n' + '='.repeat(70));
    console.log('📊 최종 요약');
    console.log('='.repeat(70));

    console.log(`\n🎯 주문ID 매칭:`);
    console.log(`   ✅ 일치: ${orderIdMatches.both.length}개 (${((orderIdMatches.both.length / shmOrderIds.size) * 100).toFixed(1)}%)`);
    console.log(`   ❌ SH_M에만: ${orderIdMatches.shmOnly.length}개 (${((orderIdMatches.shmOnly / shmOrderIds.size) * 100).toFixed(1)}%)`);
    console.log(`   ⚠️  users에만: ${orderIdMatches.usersOnly.length}개`);

    console.log(`\n📧 이메일 매칭:`);
    console.log(`   ✅ 일치: ${emailMatches.both}개 (${((emailMatches.both / shmEmails.size) * 100).toFixed(1)}%)`);
    console.log(`   ❌ SH_M에만: ${emailMatches.shmOnly}개 (${((emailMatches.shmOnly / shmEmails.size) * 100).toFixed(1)}%)`);
    console.log(`   ⚠️  users에만: ${emailMatches.usersOnly}개`);

    console.log(`\n🔍 데이터 불일치 (양쪽 모두 존재하는 경우):`);
    console.log(`   📧 이메일: ${discrepancies.email.length}건`);
    console.log(`   👤 한글이름: ${discrepancies.name.length}건`);
    console.log(`   🔤 영문이름: ${discrepancies.englishName.length}건`);
    console.log(`   📝 닉네임: ${discrepancies.nickname.length}건`);
    console.log(`   📅 예약일: ${discrepancies.reservationDate.length}건`);

    // 8. 액션 아이템
    console.log('\n' + '='.repeat(70));
    console.log('💡 필요한 조치');
    console.log('='.repeat(70));

    console.log(`\n1️⃣ users 테이블에 추가 필요:`);
    console.log(`   - ${orderIdMatches.shmOnly.length}개 주문ID (SH_M에만 존재)`);
    console.log(`   - 이들을 추가하면 매칭률이 ${((orderIdMatches.both.length / shmOrderIds.size) * 100).toFixed(1)}% → 100%로 향상`);

    if (discrepancies.email.length > 0) {
        console.log(`\n2️⃣ 이메일 불일치 해결:`);
        console.log(`   - ${discrepancies.email.length}건의 이메일이 SH_M과 users에서 다름`);
        console.log(`   - 어느 쪽이 정확한지 확인 필요`);
    }

    if (discrepancies.name.length > 0 || discrepancies.englishName.length > 0) {
        console.log(`\n3️⃣ 이름 정보 불일치 확인:`);
        console.log(`   - 한글이름: ${discrepancies.name.length}건`);
        console.log(`   - 영문이름: ${discrepancies.englishName.length}건`);
    }

    console.log(`\n4️⃣ 데이터 동기화 스크립트 실행 권장:`);
    console.log(`   - SH_M의 ${orderIdMatches.shmOnly.length}개 주문을 users 테이블에 추가`);
    console.log(`   - 이후 SH_CC import 재실행 시 매칭률 향상 예상`);

    console.log('\n' + '='.repeat(70));
}

main().catch(console.error);
