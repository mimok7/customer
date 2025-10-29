require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

// 승차일시 필터링 함수
function isAfter20250102(dateStr) {
    if (!dateStr) return false;

    // YYYY-MM-DD 형식 추출
    let dateOnly = dateStr;
    if (dateStr.includes(' ')) {
        dateOnly = dateStr.split(' ')[0];
    }

    // "YYYY. MM. DD" 형식 처리
    if (dateStr.includes('. ')) {
        const parts = dateStr.split('. ').filter(p => p);
        if (parts.length >= 3) {
            const [year, month, day] = parts;
            dateOnly = `${year}-${month.padStart(2, '0')}-${day.split(' ')[0].padStart(2, '0')}`;
        }
    }

    return dateOnly >= '2025-01-02';
} function formatDate(dateStr) {
    if (!dateStr) return null;

    // "2024. 2. 2" 형식 처리
    if (dateStr.includes('. ')) {
        const parts = dateStr.split('. ').map(p => p.trim());
        if (parts.length === 3) {
            const [year, month, day] = parts;
            return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
        }
    }

    // YYYY-MM-DD 형식은 그대로 반환
    if (/^\d{4}-\d{2}-\d{2}/.test(dateStr)) {
        return dateStr.split(' ')[0];
    }

    return dateStr;
}

function formatDateTime(dateStr) {
    if (!dateStr) return null;

    // "2024. 2. 2" 형식 처리
    if (dateStr.includes('. ')) {
        const parts = dateStr.split(' ');
        const dateParts = parts[0].split('. ').filter(p => p);
        if (dateParts.length === 3) {
            const [year, month, day] = dateParts;
            const time = parts[1] || '00:00:00';
            return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')} ${time}`;
        }
    }

    return dateStr;
}

async function generateCarReservationCSV() {
    console.log('🚀 SH_C → 독립 차량 예약 CSV 생성\n');

    // Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // SH_C 시트 데이터 로드
    console.log('1️⃣ SH_C 시트 데이터 로드\n');

    const dataResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_C!A2:U',
    });

    const rows = dataResponse.data.values || [];
    console.log(`   ✅ ${rows.length}개 행 로드\n`);

    // 2. CSV 데이터 생성
    console.log('2️⃣ CSV 데이터 생성\n');

    const reservationRows = [];
    const reservationCarRows = [];

    let matched = 0;
    let unmatched = 0;
    const reservationIdMap = new Map(); // order_id → reservation_id 매핑

    for (const row of rows) {
        const orderId = row[1]; // B열: 주문ID  
        const carCode = row[6]; // G열: 차량코드
        const carType = row[5] || ''; // F열: 차량종류
        const email = row[19]; // T열: Email

        // Email로 Auth ID 조회
        let authUserId = null;
        if (email) {
            // auth-id-mapping에서 email로 auth_id 찾기
            const mapping = Object.values(authIdMapping).find(m => m?.email === email);
            authUserId = mapping?.auth_id || authIdMapping[email];
        }

        if (!authUserId) {
            if (email || orderId) { // 빈 값들은 카운트 안함
                unmatched++;
                if (matched + unmatched <= 10) { // 처음 10개만 출력
                    console.log(`   ⚠️  Email ${email} (주문ID ${orderId}): Auth ID를 찾을 수 없음`);
                }
            }
            continue;
        }

        matched++;        // 주문ID별로 reservation_id 생성 (같은 주문ID는 같은 reservation_id 사용)
        let reservationId;
        if (reservationIdMap.has(orderId)) {
            reservationId = reservationIdMap.get(orderId);
        } else {
            reservationId = uuidv4();
            reservationIdMap.set(orderId, reservationId);

            // reservation 테이블 데이터 (주문ID당 한 번만)
            const reservationData = {
                re_id: reservationId,
                re_user_id: authUserId,
                re_quote_id: null, // 차량 단독 예약이므로 quote 없음
                re_type: 'car',
                re_status: 'completed',
                payment_status: 'completed',
                re_created_at: formatDateTime(row[13]) || new Date().toISOString(), // N열: 수정일시
                re_updated_at: formatDateTime(row[13]) || new Date().toISOString()
            };

            reservationRows.push(reservationData);
        }

        // reservation_cruise_car 데이터 (각 차량마다)
        const cruiseCarData = {
            id: uuidv4(),
            reservation_id: reservationId,
            car_price_code: carCode || '',
            pickup_datetime: formatDate(row[9]) || '', // J열: 승차일시
            pickup_location: row[10] || '', // K열: 승차위치
            dropoff_location: row[11] || '', // L열: 하차위치
            car_count: parseInt(row[7]) || 1, // H열: 차량수
            passenger_count: parseInt(row[8]) || 0, // I열: 승차인원
            car_total_price: parseInt(row[18]?.replace(/,/g, '')) || 0, // S열: 합계
            unit_price: parseInt(row[16]?.replace(/,/g, '')) || 0, // R열: 금액
            request_note: carType, // F열: 차량종류를 노트에 저장
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString()
        };

        reservationCarRows.push(cruiseCarData);
    }

    console.log(`   ✅ 매칭: ${matched}개`);
    console.log(`   ⚠️  미매칭: ${unmatched}개`);
    console.log(`   📦 생성된 reservation: ${reservationRows.length}개`);
    console.log(`   🚗 생성된 reservation_cruise_car: ${reservationCarRows.length}개\n`);

    // 3. reservation CSV 파일 작성
    console.log('3️⃣ reservation CSV 파일 작성\n');

    const reservationHeaders = [
        're_id',
        're_user_id',
        're_quote_id',
        're_type',
        're_status',
        'payment_status',
        're_created_at',
        're_updated_at'
    ];

    const reservationCSV = [
        reservationHeaders.join(','),
        ...reservationRows.map(row =>
            reservationHeaders.map(h => {
                const value = row[h];
                if (value === null || value === undefined) return '';
                if (typeof value === 'string' && (value.includes(',') || value.includes('\n'))) {
                    return `"${value.replace(/"/g, '""')}"`;
                }
                return value;
            }).join(',')
        )
    ].join('\n');

    fs.writeFileSync('./reservation-car-auth.csv', reservationCSV, 'utf8');
    console.log(`   ✅ reservation-car-auth.csv 생성 완료`);
    console.log(`   📊 총 ${reservationRows.length}개 행\n`);

    // 4. reservation_cruise_car CSV 파일 작성
    console.log('4️⃣ reservation_cruise_car CSV 파일 작성\n');

    const carHeaders = [
        'id',
        'reservation_id',
        'car_price_code',
        'pickup_datetime',
        'pickup_location',
        'dropoff_location',
        'car_count',
        'passenger_count',
        'car_total_price',
        'unit_price',
        'request_note',
        'created_at',
        'updated_at'
    ];

    const carCSV = [
        carHeaders.join(','),
        ...reservationCarRows.map(row =>
            carHeaders.map(h => {
                const value = row[h];
                if (value === null || value === undefined) return '';
                if (typeof value === 'string' && (value.includes(',') || value.includes('\n'))) {
                    return `"${value.replace(/"/g, '""')}"`;
                }
                return value;
            }).join(',')
        )
    ].join('\n');

    fs.writeFileSync('./reservation-cruise-car-auth.csv', carCSV, 'utf8');
    console.log(`   ✅ reservation-cruise-car-auth.csv 생성 완료`);
    console.log(`   📊 총 ${reservationCarRows.length}개 행\n`);

    // 5. 샘플 데이터 출력
    console.log('5️⃣ 샘플 데이터 (처음 3개):\n');

    console.log('   [reservation 샘플]');
    reservationRows.slice(0, 3).forEach((row, idx) => {
        console.log(`   [${idx + 1}]`);
        console.log(`     re_id: ${row.re_id}`);
        console.log(`     re_user_id: ${row.re_user_id}`);
        console.log(`     re_type: ${row.re_type}`);
        console.log(`     re_status: ${row.re_status}\n`);
    });

    console.log('   [reservation_cruise_car 샘플]');
    reservationCarRows.slice(0, 3).forEach((row, idx) => {
        console.log(`   [${idx + 1}]`);
        console.log(`     reservation_id: ${row.reservation_id}`);
        console.log(`     car_price_code: ${row.car_price_code}`);
        console.log(`     pickup_datetime: ${row.pickup_datetime}`);
        console.log(`     pickup_location: ${row.pickup_location}`);
        console.log(`     dropoff_location: ${row.dropoff_location}`);
        console.log(`     car_count: ${row.car_count}`);
        console.log(`     passenger_count: ${row.passenger_count}`);
        console.log(`     car_total_price: ${row.car_total_price?.toLocaleString()}동`);
        console.log(`     request_note: ${row.request_note}\n`);
    });

    // 6. 통계
    console.log('📊 최종 통계:\n');
    console.log(`   - SH_C 총 행: ${rows.length}개`);
    console.log(`   - 생성된 reservation: ${reservationRows.length}개`);
    console.log(`   - 생성된 reservation_cruise_car: ${reservationCarRows.length}개`);
    console.log(`   - 매칭 성공: ${matched}개`);
    console.log(`   - 매칭 실패: ${unmatched}개`);

    const totalPrice = reservationCarRows.reduce((sum, row) => sum + (row.car_total_price || 0), 0);
    console.log(`   - 총 금액: ${totalPrice.toLocaleString()}동\n`);
}

generateCarReservationCSV().catch(console.error);