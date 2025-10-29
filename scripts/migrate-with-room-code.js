require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const { createClient } = require('@supabase/supabase-js');
const { v4: uuidv4 } = require('uuid');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly'];

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

// 날짜 파싱
function parseDate(dateStr) {
    if (!dateStr) return null;
    try {
        const cleaned = dateStr.toString().replace(/\s/g, '').replace(/\./g, '-');
        const parts = cleaned.split('-').filter(p => p);
        if (parts.length === 3) {
            const [year, month, day] = parts;
            return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
        }
    } catch { }
    return null;
}

// 금액 파싱
function parseAmount(amountStr) {
    if (!amountStr) return 0;
    const cleaned = amountStr.toString().replace(/,/g, '').replace(/[^\d.-]/g, '');
    const num = parseFloat(cleaned);
    return isNaN(num) ? 0 : num;
}

async function migrateWithRoomCode() {
    console.log('🚀 객실코드가 있는 데이터만 Supabase로 이관 시작\n');

    // Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // 1. SH_M 데이터 로드 (사용자)
    console.log('============================================================');
    console.log('📥 STEP 1: SH_M (사용자) 데이터 로드');
    console.log('============================================================\n');

    const shMResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_M!A2:I2200',
    });

    const shMRows = shMResponse.data.values || [];
    console.log(`✅ SH_M: ${shMRows.length}개 행 로드\n`);

    // Order ID → User 매핑
    const orderUserMap = {};
    const usersToInsert = [];

    shMRows.forEach(row => {
        const 주문ID = row[0] || '';
        const 예약일Raw = row[1] || '';
        const Email = row[2] || '';
        const 한글이름 = row[3] || '';
        const 영문이름 = row[4] || '';
        const 닉네임 = row[5] || '';
        const 전화번호 = row[8] || '';

        if (!주문ID) return;

        const userId = uuidv4();
        orderUserMap[주문ID] = userId;

        const 예약일 = parseDate(예약일Raw);

        usersToInsert.push({
            id: userId,
            reservation_date: 예약일,
            email: Email || null,
            name: 한글이름 || null,
            english_name: 영문이름 || null,
            nickname: 닉네임 || null,
            phone_number: 전화번호 || null,
            role: 'member',
            birth_date: null,
            passport_number: null,
            passport_expiry: null,
            status: 'active',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            kakao_id: null
        });
    });

    console.log(`✅ 사용자 ${usersToInsert.length}명 준비 완료\n`);

    // 2. SH_R 데이터 로드 (예약)
    console.log('============================================================');
    console.log('📥 STEP 2: SH_R (예약) 데이터 로드');
    console.log('============================================================\n');

    const shRResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A2:Z3000',
    });

    const shRRows = shRResponse.data.values || [];
    console.log(`✅ SH_R: ${shRRows.length}개 행 로드\n`);

    // 3. 객실코드가 있는 예약만 필터링
    console.log('============================================================');
    console.log('🔍 STEP 3: 객실코드 필터링');
    console.log('============================================================\n');

    const validReservations = [];
    let skipCount = 0;

    shRRows.forEach((row, idx) => {
        const 주문ID = row[1] || '';
        const 객실코드 = row[6] || '';  // G열: 객실코드

        // 객실코드가 없으면 스킵
        if (!객실코드 || !객실코드.startsWith('R')) {
            skipCount++;
            return;
        }

        // User ID 확인
        const userId = orderUserMap[주문ID];
        if (!userId) {
            skipCount++;
            return;
        }

        const 크루즈 = row[2] || '';
        const 구분 = row[3] || '';
        const 객실종류 = row[4] || '';
        const 객실수 = row[5] || '';
        const 일정일수 = row[7] || '';
        const 체크인Raw = row[9] || '';
        const ADULT = parseInt(row[11]) || 0;
        const CHILD = parseInt(row[12]) || 0;
        const 승선인원 = parseInt(row[14]) || 0;
        const 승선도움 = row[18] || '';
        const 객실비고 = row[20] || '';
        const 금액 = parseAmount(row[24]);
        const 합계 = parseAmount(row[25]);

        const 체크인 = parseDate(체크인Raw);
        if (!체크인) {
            skipCount++;
            return;
        }

        validReservations.push({
            userId,
            주문ID,
            객실코드,
            크루즈,
            구분,
            객실종류,
            객실수,
            일정일수,
            체크인,
            ADULT,
            CHILD,
            승선인원,
            승선도움,
            객실비고,
            금액,
            합계
        });
    });

    console.log(`✅ 유효한 예약 (객실코드 있음): ${validReservations.length}개`);
    console.log(`⚠️  스킵됨 (객실코드 없음): ${skipCount}개\n`);

    if (validReservations.length === 0) {
        console.log('❌ 이관할 데이터가 없습니다.');
        return;
    }

    // 4. 사용되는 User만 필터링
    const usedUserIds = new Set(validReservations.map(r => r.userId));
    const filteredUsers = usersToInsert.filter(u => usedUserIds.has(u.id));

    console.log(`✅ 실제 사용되는 사용자: ${filteredUsers.length}명\n`);

    // 5. Supabase에 삽입 - Users
    console.log('============================================================');
    console.log('📤 STEP 4: Supabase users 테이블에 삽입');
    console.log('============================================================\n');

    const BATCH_SIZE = 100;
    let userInsertCount = 0;
    const insertedUserIds = new Map(); // 원래 ID → 실제 삽입된 ID

    for (let i = 0; i < filteredUsers.length; i += BATCH_SIZE) {
        const batch = filteredUsers.slice(i, i + BATCH_SIZE);

        const { data, error } = await supabase
            .from('users')
            .insert(batch);

        if (error) {
            console.error(`❌ Users Batch ${Math.floor(i / BATCH_SIZE) + 1} 실패:`, error.message);
        } else {
            userInsertCount += batch.length;
            batch.forEach(u => insertedUserIds.set(u.id, u.id));
            const progress = Math.min(i + BATCH_SIZE, filteredUsers.length);
            console.log(`✅ Users Batch ${Math.floor(i / BATCH_SIZE) + 1} 완료 (${progress}/${filteredUsers.length})`);
        }

        await new Promise(resolve => setTimeout(resolve, 500));
    }

    console.log(`\n✅ Users 삽입 완료: ${userInsertCount}명\n`);

    // 삽입된 User ID 검증
    console.log('🔍 삽입된 User 검증 중...');
    const { data: verifyUsers, error: verifyError } = await supabase
        .from('users')
        .select('id')
        .in('id', Array.from(insertedUserIds.keys()));

    if (verifyError) {
        console.error('❌ User 검증 실패:', verifyError.message);
    } else {
        console.log(`✅ 검증 완료: ${verifyUsers.length}명이 실제로 존재함\n`);

        // 존재하는 user ID만 사용하도록 필터링
        const existingUserIds = new Set(verifyUsers.map(u => u.id));
        const validReservationsFiltered = validReservations.filter(r =>
            existingUserIds.has(r.userId)
        );

        console.log(`✅ FK 검증 통과한 예약: ${validReservationsFiltered.length}개\n`);

        // 유효한 예약만 사용
        validReservations.length = 0;
        validReservations.push(...validReservationsFiltered);
    }

    // 6. Supabase에 삽입 - Reservations
    console.log('============================================================');
    console.log('📤 STEP 5: Supabase reservation 테이블에 삽입');
    console.log('============================================================\n');

    const reservationMap = {};
    let reservationInsertCount = 0;

    for (let i = 0; i < validReservations.length; i += BATCH_SIZE) {
        const batch = validReservations.slice(i, i + BATCH_SIZE);

        const reservationsToInsert = batch.map(r => ({
            re_id: uuidv4(),
            re_user_id: r.userId,
            re_quote_id: null,
            re_type: 'cruise',
            re_status: 'confirmed',
            re_created_at: new Date().toISOString(),
            re_update_at: new Date().toISOString(),
            total_amount: r.합계,
            paid_amount: 0,
            payment_status: 'pending'
        }));

        const { data, error } = await supabase
            .from('reservation')
            .insert(reservationsToInsert)
            .select();

        if (error) {
            console.error(`❌ Reservation Batch ${Math.floor(i / BATCH_SIZE) + 1} 실패:`, error.message);
        } else {
            reservationInsertCount += data.length;

            // reservation_id 매핑 저장
            data.forEach((res, idx) => {
                const original = batch[idx];
                reservationMap[`${original.userId}_${original.주문ID}_${original.체크인}`] = res.re_id;
            });

            const progress = Math.min(i + BATCH_SIZE, validReservations.length);
            console.log(`✅ Reservation Batch ${Math.floor(i / BATCH_SIZE) + 1} 완료 (${progress}/${validReservations.length})`);
        }

        await new Promise(resolve => setTimeout(resolve, 300));
    }

    console.log(`\n✅ Reservation 삽입 완료: ${reservationInsertCount}개\n`);

    // 7. Supabase에 삽입 - Reservation Cruise
    console.log('============================================================');
    console.log('📤 STEP 6: Supabase reservation_cruise 테이블에 삽입');
    console.log('============================================================\n');

    let cruiseInsertCount = 0;

    for (let i = 0; i < validReservations.length; i += BATCH_SIZE) {
        const batch = validReservations.slice(i, i + BATCH_SIZE);

        const cruisesToInsert = batch.map(r => {
            const reservationId = reservationMap[`${r.userId}_${r.주문ID}_${r.체크인}`];

            if (!reservationId) {
                return null;
            }

            return {
                id: uuidv4(),
                reservation_id: reservationId,
                room_price_code: r.객실코드,  // 객실코드 (필수)
                checkin: r.체크인,
                guest_count: r.승선인원 || (r.ADULT + r.CHILD),
                unit_price: r.금액,
                room_total_price: r.합계,
                request_note: [
                    r.객실비고,
                    r.구분 ? `구분: ${r.구분}` : '',
                    r.객실종류 ? `객실종류: ${r.객실종류}` : '',
                    r.일정일수 ? `일정: ${r.일정일수}` : ''
                ].filter(Boolean).join('\n'),
                boarding_code: null,
                boarding_assist: r.승선도움 === 'Y' || r.승선도움 === 'O',
                created_at: new Date().toISOString()
            };
        }).filter(Boolean);

        if (cruisesToInsert.length === 0) continue;

        const { data, error } = await supabase
            .from('reservation_cruise')
            .insert(cruisesToInsert)
            .select();

        if (error) {
            console.error(`❌ Cruise Batch ${Math.floor(i / BATCH_SIZE) + 1} 실패:`, error.message);
        } else {
            cruiseInsertCount += data.length;
            const progress = Math.min(i + BATCH_SIZE, validReservations.length);
            console.log(`✅ Cruise Batch ${Math.floor(i / BATCH_SIZE) + 1} 완료 (${progress}/${validReservations.length})`);
        }

        await new Promise(resolve => setTimeout(resolve, 300));
    }

    console.log(`\n✅ Reservation Cruise 삽입 완료: ${cruiseInsertCount}개\n`);

    // 8. 최종 결과
    console.log('============================================================');
    console.log('🎉 이관 완료!');
    console.log('============================================================');
    console.log(`✅ Users: ${userInsertCount}명`);
    console.log(`✅ Reservations: ${reservationInsertCount}개`);
    console.log(`✅ Reservation Cruise: ${cruiseInsertCount}개`);
    console.log(`⚠️  스킵됨 (객실코드 없음): ${skipCount}개`);
    console.log('');
    console.log('📊 이관된 데이터는 모두 객실코드(room_price_code)를 포함합니다.');
    console.log('');
}

migrateWithRoomCode().catch(error => {
    console.error('❌ 오류 발생:', error);
    process.exit(1);
});
