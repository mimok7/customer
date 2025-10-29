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

// ⚠️ 안전장치: true로 변경해야 실제 실행됩니다
const DRY_RUN = false; // false로 변경하여 실제 실행

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

function parseDate(dateStr) {
    if (!dateStr) return null;

    // YYYY-MM-DD 형식
    if (/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) {
        return dateStr;
    }

    // YYYYMMDD 형식
    if (/^\d{8}$/.test(dateStr)) {
        return `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}`;
    }

    // YYYY.MM.DD 또는 YYYY/MM/DD 형식
    const match = dateStr.match(/(\d{4})[\.\/-](\d{1,2})[\.\/-](\d{1,2})/);
    if (match) {
        const [, year, month, day] = match;
        return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    }

    return null;
}

async function main() {
    console.log('🔄 SH_M → users 테이블 동기화 스크립트\n');
    console.log('='.repeat(70));

    if (DRY_RUN) {
        console.log('\n⚠️  DRY RUN 모드: 실제 DB 변경 없음');
        console.log('   실제 실행하려면 스크립트에서 DRY_RUN = false로 변경하세요\n');
    } else {
        console.log('\n🚨 실제 실행 모드: DB에 데이터가 추가됩니다!\n');
    }

    console.log('='.repeat(70));

    // 1. SH_M 데이터 로드
    console.log('\n📥 SH_M 시트 데이터 로드 중...');
    const sheets = await getSheetsClient();
    const shmResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_M!A2:G',
    });
    const shmRows = shmResponse.data.values || [];

    const shmData = new Map();
    shmRows.forEach(row => {
        const orderId = row[0]?.trim();
        const reservationDate = parseDate(row[1]?.trim());
        const email = row[2]?.trim();
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
                memberGrade
            });
        }
    });

    console.log(`✅ SH_M: ${shmData.size}개 주문 로드`);

    // 2. users 테이블 기존 데이터 확인
    console.log('\n📥 users 테이블 기존 데이터 확인 중...');
    const { data: existingUsers } = await supabase
        .from('users')
        .select('order_id, email');

    const existingOrderIds = new Set(existingUsers?.map(u => u.order_id).filter(Boolean) || []);
    const existingEmails = new Set(existingUsers?.map(u => u.email?.toLowerCase()).filter(Boolean) || []);

    console.log(`✅ 기존 users: ${existingOrderIds.size}개 order_id`);

    // 3. 추가할 데이터 필터링
    console.log('\n🔍 추가할 데이터 필터링 중...');
    const toAdd = [];
    const skipped = {
        orderIdExists: 0,
        emailExists: 0,
        noEmail: 0,
        noName: 0
    };

    for (const [orderId, data] of shmData.entries()) {
        // order_id가 이미 존재하면 건너뜀
        if (existingOrderIds.has(orderId)) {
            skipped.orderIdExists++;
            continue;
        }

        // 이메일이 이미 존재하면 건너뜀 (중복 방지)
        if (existingEmails.has(data.email.toLowerCase())) {
            skipped.emailExists++;
            continue;
        }

        // 이메일이 없으면 건너뜀
        if (!data.email) {
            skipped.noEmail++;
            continue;
        }

        // 이름이 없으면 건너뜀
        if (!data.koreanName) {
            skipped.noName++;
            continue;
        }

        toAdd.push(data);
    }

    console.log(`\n✅ 추가할 사용자: ${toAdd.length}명`);
    console.log(`⏭️  건너뛰기:`);
    console.log(`   - order_id 이미 존재: ${skipped.orderIdExists}건`);
    console.log(`   - email 이미 존재: ${skipped.emailExists}건`);
    console.log(`   - email 없음: ${skipped.noEmail}건`);
    console.log(`   - 이름 없음: ${skipped.noName}건`);

    if (toAdd.length === 0) {
        console.log('\n✅ 추가할 데이터가 없습니다. 이미 동기화되어 있습니다.');
        return;
    }

    // 4. 샘플 데이터 표시
    console.log('\n' + '='.repeat(70));
    console.log('📝 추가할 데이터 샘플 (최대 10개)');
    console.log('='.repeat(70) + '\n');

    toAdd.slice(0, 10).forEach((data, index) => {
        console.log(`${index + 1}. ${data.orderId.padEnd(12)} | ${data.email.padEnd(30)} | ${data.koreanName}`);
    });

    if (toAdd.length > 10) {
        console.log(`\n... 외 ${toAdd.length - 10}명\n`);
    }

    // 5. 데이터 추가 실행
    if (DRY_RUN) {
        console.log('\n' + '='.repeat(70));
        console.log('⚠️  DRY RUN 모드: 실제 추가하지 않습니다');
        console.log('='.repeat(70));
        console.log(`\n실제 실행 시 ${toAdd.length}명의 사용자가 추가됩니다.\n`);
        return;
    }

    console.log('\n' + '='.repeat(70));
    console.log('🚀 users 테이블에 데이터 추가 중...');
    console.log('='.repeat(70));

    let successCount = 0;
    let errorCount = 0;
    const errors = [];

    // 배치로 처리 (한 번에 100개씩)
    const batchSize = 100;
    for (let i = 0; i < toAdd.length; i += batchSize) {
        const batch = toAdd.slice(i, i + batchSize);

        const usersToInsert = batch.map(data => ({
            order_id: data.orderId,
            email: data.email,
            name: data.koreanName,
            english_name: data.englishName,
            nickname: data.nickname,
            reservation_date: data.reservationDate,
            role: 'member',
            status: 'active',
            created_at: new Date().toISOString()
        }));

        const { data: inserted, error } = await supabase
            .from('users')
            .insert(usersToInsert)
            .select('id, order_id');

        if (error) {
            errorCount += batch.length;
            errors.push(`배치 ${Math.floor(i / batchSize) + 1} 오류: ${error.message}`);
            console.log(`❌ 배치 ${Math.floor(i / batchSize) + 1} 실패 (${batch.length}건)`);
        } else {
            successCount += inserted.length;
            console.log(`✅ 배치 ${Math.floor(i / batchSize) + 1} 성공 (${inserted.length}건)`);
        }
    }

    // 6. 결과 요약
    console.log('\n' + '='.repeat(70));
    console.log('📊 동기화 결과');
    console.log('='.repeat(70));

    console.log(`\n✅ 성공: ${successCount}명`);
    console.log(`❌ 실패: ${errorCount}명`);

    if (errors.length > 0) {
        console.log(`\n오류 내역:`);
        errors.forEach(err => console.log(`  - ${err}`));
    }

    // 7. 최종 확인
    console.log('\n' + '='.repeat(70));
    console.log('🔍 동기화 후 확인');
    console.log('='.repeat(70));

    const { data: finalUsers } = await supabase
        .from('users')
        .select('order_id')
        .not('order_id', 'is', null);

    console.log(`\n최종 users 테이블 order_id: ${finalUsers?.length || 0}개`);
    console.log(`SH_M 주문ID: ${shmData.size}개`);

    const finalMatchRate = ((finalUsers?.length || 0) / shmData.size) * 100;
    console.log(`\n매칭률: ${finalMatchRate.toFixed(1)}%`);

    if (finalMatchRate >= 95) {
        console.log('\n🎉 동기화 완료! 이제 SH_CC import를 다시 실행하세요.');
        console.log('   예상 이관 건수: 약 1,235건 (100%)');
    }

    console.log('\n' + '='.repeat(70));
}

main().catch(console.error);
