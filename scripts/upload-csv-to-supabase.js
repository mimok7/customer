require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const csvParser = require('csv-parser');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function uploadCSV() {
    console.log('🚀 CSV 파일을 Supabase에 자동 업로드\n');

    // 1. Users 업로드
    console.log('============================================================');
    console.log('📤 STEP 1: users.csv 업로드');
    console.log('============================================================\n');

    const users = [];
    await new Promise((resolve, reject) => {
        fs.createReadStream('users.csv')
            .pipe(csvParser())
            .on('data', (row) => {
                users.push({
                    id: row.id,
                    order_id: row.order_id || null,  // order_id 추가
                    reservation_date: row.reservation_date || null,
                    email: row.email || null,
                    name: row.name || null,
                    english_name: row.english_name || null,
                    nickname: row.nickname || null,
                    phone_number: row.phone_number || null,
                    role: row.role,
                    birth_date: row.birth_date || null,
                    passport_number: row.passport_number || null,
                    passport_expiry: row.passport_expiry || null,
                    status: row.status,
                    created_at: row.created_at,
                    updated_at: row.updated_at,
                    kakao_id: row.kakao_id || null
                });
            })
            .on('end', resolve)
            .on('error', reject);
    });

    console.log(`✅ users.csv 파싱 완료: ${users.length}명\n`);

    const BATCH_SIZE = 100;
    let userInsertCount = 0;

    for (let i = 0; i < users.length; i += BATCH_SIZE) {
        const batch = users.slice(i, i + BATCH_SIZE);

        const { error } = await supabase
            .from('users')
            .insert(batch);

        if (error) {
            console.error(`❌ Users Batch ${Math.floor(i / BATCH_SIZE) + 1} 실패:`, error.message);
        } else {
            userInsertCount += batch.length;
            const progress = Math.min(i + BATCH_SIZE, users.length);
            console.log(`✅ Users Batch ${Math.floor(i / BATCH_SIZE) + 1} 완료 (${progress}/${users.length})`);
        }

        await new Promise(resolve => setTimeout(resolve, 500));
    }

    console.log(`\n✅ Users 업로드 완료: ${userInsertCount}명\n`);

    // 2. Reservations 업로드
    console.log('============================================================');
    console.log('📤 STEP 2: reservations.csv 업로드');
    console.log('============================================================\n');

    const reservations = [];
    await new Promise((resolve, reject) => {
        fs.createReadStream('reservations.csv')
            .pipe(csvParser())
            .on('data', (row) => {
                reservations.push({
                    re_id: row.re_id,
                    re_user_id: row.re_user_id,
                    order_id: row.order_id || null,  // order_id 추가
                    re_quote_id: row.re_quote_id || null,
                    re_type: row.re_type,
                    re_status: row.re_status,
                    re_created_at: row.re_created_at,
                    re_update_at: row.re_update_at,
                    total_amount: parseFloat(row.total_amount) || 0,
                    paid_amount: parseFloat(row.paid_amount) || 0,
                    payment_status: row.payment_status
                });
            })
            .on('end', resolve)
            .on('error', reject);
    });

    console.log(`✅ reservations.csv 파싱 완료: ${reservations.length}개\n`);

    let reservationInsertCount = 0;

    for (let i = 0; i < reservations.length; i += BATCH_SIZE) {
        const batch = reservations.slice(i, i + BATCH_SIZE);

        const { error } = await supabase
            .from('reservation')
            .insert(batch);

        if (error) {
            console.error(`❌ Reservation Batch ${Math.floor(i / BATCH_SIZE) + 1} 실패:`, error.message);
        } else {
            reservationInsertCount += batch.length;
            const progress = Math.min(i + BATCH_SIZE, reservations.length);
            console.log(`✅ Reservation Batch ${Math.floor(i / BATCH_SIZE) + 1} 완료 (${progress}/${reservations.length})`);
        }

        await new Promise(resolve => setTimeout(resolve, 500));
    }

    console.log(`\n✅ Reservations 업로드 완료: ${reservationInsertCount}개\n`);

    // 3. Reservation Cruise 업로드
    console.log('============================================================');
    console.log('📤 STEP 3: reservation_cruise.csv 업로드');
    console.log('============================================================\n');

    const cruises = [];
    await new Promise((resolve, reject) => {
        fs.createReadStream('reservation_cruise.csv')
            .pipe(csvParser())
            .on('data', (row) => {
                cruises.push({
                    id: row.id,
                    reservation_id: row.reservation_id,
                    room_price_code: row.room_price_code || null,
                    checkin: row.checkin || null,
                    guest_count: parseInt(row.guest_count) || 0,
                    unit_price: parseFloat(row.unit_price) || 0,
                    room_total_price: parseFloat(row.room_total_price) || 0,
                    request_note: row.request_note || null,
                    boarding_code: row.boarding_code || null,
                    boarding_assist: row.boarding_assist === 'true',
                    created_at: row.created_at
                });
            })
            .on('end', resolve)
            .on('error', reject);
    });

    console.log(`✅ reservation_cruise.csv 파싱 완료: ${cruises.length}개\n`);

    let cruiseInsertCount = 0;

    for (let i = 0; i < cruises.length; i += BATCH_SIZE) {
        const batch = cruises.slice(i, i + BATCH_SIZE);

        const { error } = await supabase
            .from('reservation_cruise')
            .insert(batch);

        if (error) {
            console.error(`❌ Cruise Batch ${Math.floor(i / BATCH_SIZE) + 1} 실패:`, error.message);
        } else {
            cruiseInsertCount += batch.length;
            const progress = Math.min(i + BATCH_SIZE, cruises.length);
            console.log(`✅ Cruise Batch ${Math.floor(i / BATCH_SIZE) + 1} 완료 (${progress}/${cruises.length})`);
        }

        await new Promise(resolve => setTimeout(resolve, 500));
    }

    console.log(`\n✅ Reservation Cruise 업로드 완료: ${cruiseInsertCount}개\n`);

    // 4. 최종 결과
    console.log('============================================================');
    console.log('🎉 자동 업로드 완료!');
    console.log('============================================================');
    console.log(`✅ Users: ${userInsertCount}명`);
    console.log(`✅ Reservations: ${reservationInsertCount}개`);
    console.log(`✅ Reservation Cruise: ${cruiseInsertCount}개`);
    console.log('');
    console.log('📊 모든 데이터는 객실코드(room_price_code)를 포함합니다.');
    console.log('');
}

uploadCSV().catch(error => {
    console.error('❌ 오류 발생:', error);
    process.exit(1);
});
