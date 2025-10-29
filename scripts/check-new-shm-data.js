require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function checkNewShMData() {
    console.log('🔍 SH_M 신규 데이터 확인\n');

    // 1. Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // 2. SH_M 데이터 로드
    console.log('============================================================');
    console.log('📥 SH_M 시트 데이터 로딩');
    console.log('============================================================\n');

    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_M!A:I',
    });

    const rows = response.data.values;
    const headers = rows[0];
    const dataRows = rows.slice(1);

    console.log('컬럼:', headers.join(', '));
    console.log(`총 레코드: ${dataRows.length}개\n`);

    // 3. 기존 users 테이블 데이터
    console.log('============================================================');
    console.log('📊 기존 Users 테이블 확인');
    console.log('============================================================\n');

    const { data: existingUsers, error: usersError } = await supabase
        .from('users')
        .select('email');

    if (usersError) {
        console.error('❌ Users 조회 실패:', usersError.message);
        return;
    }

    const existingEmails = new Set(existingUsers.map(u => u.email?.toLowerCase().trim()));
    console.log(`기존 사용자: ${existingUsers.length}명\n`);

    // 4. 신규 데이터 확인
    console.log('============================================================');
    console.log('🔍 신규 데이터 분석');
    console.log('============================================================\n');

    const newUsers = [];
    const duplicateUsers = [];
    const invalidUsers = [];

    dataRows.forEach((row, idx) => {
        const orderId = row[0];
        const reservationDate = row[1];
        const email = row[2]?.toLowerCase().trim();
        const nameKr = row[3];
        const nameEn = row[4];
        const gender = row[5];
        const birthDate = row[6];
        const passport = row[7];
        const phone = row[8];

        // 유효성 검사
        if (!email && !phone) {
            invalidUsers.push({ rowNum: idx + 2, orderId, nameKr, reason: '이메일과 전화번호 모두 없음' });
            return;
        }

        if (email && existingEmails.has(email)) {
            duplicateUsers.push({ rowNum: idx + 2, orderId, email, nameKr });
            return;
        }

        newUsers.push({
            rowNum: idx + 2,
            orderId,
            email,
            nameKr,
            nameEn,
            gender,
            birthDate,
            passport,
            phone,
        });
    });

    console.log(`✅ 신규 사용자: ${newUsers.length}명`);
    console.log(`⚠️  중복 이메일: ${duplicateUsers.length}명`);
    console.log(`❌ 유효하지 않음: ${invalidUsers.length}명`);
    console.log('');

    // 5. 신규 사용자 샘플 (처음 10명)
    if (newUsers.length > 0) {
        console.log('============================================================');
        console.log('📋 신규 사용자 샘플 (처음 10명)');
        console.log('============================================================\n');

        newUsers.slice(0, 10).forEach(u => {
            console.log(`${u.rowNum}. ${u.nameKr || '(이름없음)'} (${u.email || u.phone || '연락처없음'})`);
            console.log(`   Order ID: ${u.orderId || '(없음)'}`);
            console.log('');
        });

        if (newUsers.length > 10) {
            console.log(`... 외 ${newUsers.length - 10}명\n`);
        }
    }

    // 6. 중복 사용자 샘플 (처음 10명)
    if (duplicateUsers.length > 0) {
        console.log('============================================================');
        console.log('⚠️  중복 이메일 샘플 (처음 10명)');
        console.log('============================================================\n');

        duplicateUsers.slice(0, 10).forEach(u => {
            console.log(`${u.rowNum}. ${u.nameKr} - ${u.email}`);
            console.log(`   Order ID: ${u.orderId}`);
            console.log('');
        });

        if (duplicateUsers.length > 10) {
            console.log(`... 외 ${duplicateUsers.length - 10}명\n`);
        }
    }

    // 7. 결과 저장
    const resultPath = 'scripts/new-shm-data-analysis.json';
    fs.writeFileSync(resultPath, JSON.stringify({
        timestamp: new Date().toISOString(),
        totalRows: dataRows.length,
        newUsersCount: newUsers.length,
        duplicatesCount: duplicateUsers.length,
        invalidCount: invalidUsers.length,
        newUsers: newUsers,
        duplicates: duplicateUsers,
        invalid: invalidUsers,
    }, null, 2));

    console.log('============================================================');
    console.log('💾 결과 저장');
    console.log('============================================================');
    console.log(`✅ ${resultPath}\n`);

    // 8. 다음 단계 안내
    console.log('============================================================');
    console.log('📝 다음 단계');
    console.log('============================================================\n');

    if (newUsers.length > 0) {
        console.log(`1. 신규 ${newUsers.length}명을 users 테이블에 이관`);
        console.log('   명령어: node scripts/migrate-new-shm-users.js\n');
    }

    if (duplicateUsers.length > 0) {
        console.log(`2. 중복 ${duplicateUsers.length}명 처리 방법:`);
        console.log('   - 옵션 A: 무시 (이미 등록된 사용자)');
        console.log('   - 옵션 B: 추가 정보 업데이트 (전화번호, 이름 등)\n');
    }

    if (invalidUsers.length > 0) {
        console.log(`3. 유효하지 않은 ${invalidUsers.length}명:`);
        console.log('   - 이메일과 전화번호가 모두 없는 사용자');
        console.log('   - 수동으로 정보 보완 필요\n');
    }

    console.log('============================================================');
    console.log('📊 최종 통계');
    console.log('============================================================');
    console.log(`   SH_M 전체: ${dataRows.length}명`);
    console.log(`   기존 Users: ${existingUsers.length}명`);
    console.log(`   신규 추가 가능: ${newUsers.length}명`);
    console.log(`   중복 (스킵): ${duplicateUsers.length}명`);
    console.log(`   유효하지 않음: ${invalidUsers.length}명`);
    console.log('');
}

checkNewShMData().catch(console.error);
