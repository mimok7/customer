require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const { google } = require('googleapis');
const fs = require('fs');

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

async function createAuthFromSheets() {
    console.log('🔐 Google Sheets에서 Auth 계정 생성 시작\n');

    // Google Sheets API 초기화
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });

    const sheets = google.sheets({ version: 'v4', auth });
    const spreadsheetId = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';

    // SH_M 데이터 가져오기
    console.log('1️⃣ Google Sheets 데이터 로드 중...\n');

    const response = await sheets.spreadsheets.values.get({
        spreadsheetId,
        range: 'SH_M!A2:U',
    });

    const rows = response.data.values || [];
    console.log(`✅ ${rows.length}개 사용자 데이터 로드 완료\n`);

    // Auth 계정 생성
    console.log('2️⃣ Auth 계정 생성 중...\n');

    const authIdMapping = [];
    const errors = [];
    let successCount = 0;
    let skipCount = 0;
    let failCount = 0;

    for (let i = 0; i < rows.length; i++) {
        const row = rows[i];
        const orderId = row[0]; // 주문ID (Column A)
        const reservationDate = row[1]; // 예약일자
        const email = row[2]; // 이메일
        const name = row[3]; // 이름
        const phone = row[6]; // 휴대폰

        // 이메일이 없으면 스킵
        if (!email || email.trim() === '') {
            skipCount++;
            continue;
        }

        try {
            // 임시 비밀번호 생성 (주문ID 기반)
            const tempPassword = `SH${orderId}2025!`;

            // Auth 계정 생성
            const { data: authData, error: authError } = await supabase.auth.admin.createUser({
                email: email.trim(),
                password: tempPassword,
                email_confirm: true,
                user_metadata: {
                    name: name,
                    phone: phone,
                    order_id: orderId,
                    created_from: 'google_sheets_migration',
                    created_at: new Date().toISOString()
                }
            });

            if (authError) {
                // 이미 존재하는 이메일인 경우
                if (authError.message.includes('already registered')) {
                    console.log(`   ⚠️  이미 존재: ${email}`);
                    skipCount++;
                    continue;
                }

                console.error(`   ❌ 실패: ${email} (${authError.message})`);
                failCount++;
                errors.push({
                    order_id: orderId,
                    email: email,
                    error: authError.message
                });
                continue;
            }

            // 성공
            successCount++;
            authIdMapping.push({
                order_id: orderId,
                auth_id: authData.user.id,
                email: email,
                name: name,
                phone: phone,
                reservation_date: reservationDate
            });

            // 100명마다 진행상황 출력
            if (successCount % 100 === 0) {
                console.log(`   ✅ ${successCount}/${rows.length} 생성 완료...`);
            }

        } catch (err) {
            console.error(`   ❌ 오류: ${email}`, err.message);
            failCount++;
            errors.push({
                order_id: orderId,
                email: email,
                error: err.message
            });
        }

        // API rate limit 방지
        if (i % 10 === 0 && i > 0) {
            await new Promise(resolve => setTimeout(resolve, 100));
        }
    }

    console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    console.log('📊 생성 결과:');
    console.log(`   ✅ 성공: ${successCount}명`);
    console.log(`   ⚠️  스킵: ${skipCount}명 (이메일 없음 또는 중복)`);
    console.log(`   ❌ 실패: ${failCount}명`);

    // Auth ID 매핑 저장
    fs.writeFileSync(
        'auth-id-mapping.json',
        JSON.stringify(authIdMapping, null, 2)
    );
    console.log('\n✅ Auth ID 매핑 저장: auth-id-mapping.json');
    console.log(`   (${authIdMapping.length}개 매핑)`);

    if (errors.length > 0) {
        fs.writeFileSync(
            'auth-creation-errors.json',
            JSON.stringify(errors, null, 2)
        );
        console.log('\n❌ 실패 상세 정보 저장: auth-creation-errors.json');
        console.log(`   (${errors.length}개 오류)`);
    }

    // 최종 확인
    console.log('\n3️⃣ 생성 후 확인 중...\n');

    const { data: allUsers } = await supabase.auth.admin.listUsers({
        page: 1,
        perPage: 10
    });

    console.log(`✅ 현재 Auth 사용자: ${allUsers?.users?.length || 0}명 (샘플)\n`);

    if (allUsers?.users && allUsers.users.length > 0) {
        console.log('📋 생성된 사용자 샘플:');
        allUsers.users.slice(0, 5).forEach(u => {
            console.log(`   - ${u.email} (ID: ${u.id.substring(0, 8)}...)`);
        });
    }

    console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    console.log('✅ Auth 계정 생성 완료!\n');
    console.log('📝 다음 단계:');
    console.log('   1. auth-id-mapping.json 파일 확인');
    console.log('   2. export-to-csv-with-auth.js 실행 (Auth ID 기반 CSV 생성)');
    console.log('   3. CSV 파일 업로드\n');
}

createAuthFromSheets().catch(console.error);
