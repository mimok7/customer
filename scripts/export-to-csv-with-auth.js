require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const fs = require('fs');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function exportToCSVWithAuth() {
    console.log('📥 Auth ID 기반 CSV 생성 시작\n');

    // Auth ID 매핑 로드
    const authMapping = JSON.parse(fs.readFileSync('auth-id-mapping.json', 'utf-8'));
    const orderIdToAuthId = {};
    authMapping.forEach(item => {
        orderIdToAuthId[item.order_id] = item.auth_id;
    });

    console.log(`✅ ${authMapping.length}개 Auth ID 매핑 로드\n`);

    // Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // SH_M 데이터 로드
    console.log('1️⃣ SH_M 데이터 로드\n');
    const shMResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_M!A:U',
    });

    const shMRows = shMResponse.data.values || [];
    console.log(`✅ SH_M: ${shMRows.length}개 행\n`);

    // SH_R 데이터 로드
    console.log('2️⃣ SH_R 데이터 로드\n');
    const shRResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A:V',
    });

    const shRRows = shRResponse.data.values || [];
    console.log(`✅ SH_R: ${shRRows.length}개 행\n`);

    // Room codes 로드 (필터링용)
    const roomCodesResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'room!A2:B',
    });
    const validRoomCodes = new Set(
        (roomCodesResponse.data.values || []).map(row => row[0])
    );
    console.log(`✅ 유효한 room_code: ${validRoomCodes.size}개\n`);

    // SH_M 데이터로 주문ID별 요청사항 매핑 생성
    const orderNotesMapping = {};
    shMRows.slice(1).forEach(row => {
        const orderId = row[0];
        const notes = [
            row[16] || '', // Q (index 16): 요청사항
            row[18] || '', // S (index 18): 특이사항
            row[20] || ''  // U (index 20): 메모
        ].filter(n => n.trim()).join('\n');

        if (notes) {
            orderNotesMapping[orderId] = notes;
        }
    });

    // users.csv 생성
    // 날짜 포맷 변환 함수
    const formatDate = (dateStr) => {
        if (!dateStr) return '';
        try {
            // "2024. 2. 2" 형식을 "2024-02-02"로 변환
            const cleaned = dateStr.replace(/\s/g, '').replace(/\./g, '-');
            const parts = cleaned.split('-').filter(p => p);
            if (parts.length === 3) {
                const [year, month, day] = parts;
                return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
            }
            return '';
        } catch {
            return '';
        }
    };

    console.log('3️⃣ users.csv 생성\n');
    const usersCSV = [];
    usersCSV.push([
        'id',
        'order_id',
        'reservation_date',
        'email',
        'name',
        'english_name',
        'nickname',
        'phone_number',
        'role',
        'birth_date',
        'passport_number',
        'passport_expiry',
        'status',
        'created_at',
        'updated_at',
        'kakao_id'
    ].join(','));

    let usersCount = 0;
    let usersSkipped = 0;

    shMRows.slice(1).forEach(row => {
        const orderId = row[0];
        const authId = orderIdToAuthId[orderId];

        // Auth ID가 없으면 스킵
        if (!authId) {
            usersSkipped++;
            return;
        }

        const reservationDate = formatDate(row[1] || '');  // B: 예약일
        const email = row[2] || '';  // C: Email
        const name = row[3] || '';  // D: 한글이름
        const englishName = row[4] || '';  // E: 영문이름
        const nickname = row[5] || '';  // F: 닉네임
        const phoneNumber = row[8] || '';  // I: 전화번호
        const birthDate = formatDate(row[19] || '');  // T: 생년월일
        const kakaoId = row[17] || '';  // R: 카톡ID

        usersCSV.push([
            authId, // Auth ID 사용!
            orderId,
            reservationDate,
            `"${email.replace(/"/g, '""')}"`,
            `"${name.replace(/"/g, '""')}"`,
            `"${englishName.replace(/"/g, '""')}"`,
            `"${nickname.replace(/"/g, '""')}"`,
            `"${phoneNumber.replace(/"/g, '""')}"`,
            'member',
            birthDate,
            `""`,  // passport_number (데이터 없음)
            ``,    // passport_expiry (데이터 없음)
            'active',
            new Date().toISOString(),
            new Date().toISOString(),
            `"${kakaoId.replace(/"/g, '""')}"`
        ].join(','));

        usersCount++;
    });

    fs.writeFileSync('users-auth.csv', usersCSV.join('\n'));
    console.log(`✅ users-auth.csv: ${usersCount}개 (스킵: ${usersSkipped}개)\n`);

    // reservations.csv 및 reservation_cruise.csv 생성
    console.log('4️⃣ reservations.csv & reservation_cruise.csv 생성\n');

    const reservationsCSV = [];
    reservationsCSV.push([
        're_id',
        're_user_id',
        'order_id',
        're_quote_id',
        're_type',
        're_status',
        're_created_at',
        're_update_at',
        'total_amount',
        'paid_amount',
        'payment_status'
    ].join(','));

    const cruiseCSV = [];
    cruiseCSV.push([
        'id',
        'reservation_id',
        'room_price_code',
        'checkin',
        'guest_count',
        'unit_price',
        'room_total_price',
        'request_note',
        'boarding_code',
        'boarding_assist',
        'created_at'
    ].join(','));

    const { v4: uuidv4 } = require('uuid');
    let reservationsCount = 0;
    let cruiseCount = 0;
    let reservationsSkipped = 0;

    shRRows.slice(1).forEach(row => {
        const orderId = row[1];  // Column B
        const roomCode = row[6];  // Column G: 객실코드

        // R로 시작하는 유효한 room_code만 처리
        if (!roomCode || !roomCode.startsWith('R')) {
            reservationsSkipped++;
            return;
        }

        const authId = orderIdToAuthId[orderId];

        // Auth ID가 없으면 스킵
        if (!authId) {
            reservationsSkipped++;
            return;
        }

        const reId = uuidv4();
        const cruiseId = uuidv4();
        const checkin = formatDate(row[9] || '');  // Column J: 체크인
        const guestCount = row[15] || '0';  // Column P: 인원수
        const boardingAssistText = row[18] || '';  // Column S: 승선도움 (TRUE/FALSE 문자열)
        const boardingCode = row[21] || '';  // Column V: 처리

        // boarding_assist를 boolean으로 변환 (TRUE/FALSE 문자열 → true/false)
        const boardingAssist = boardingAssistText.toUpperCase() === 'TRUE' ? 'true' : 'false';

        // SH_M의 요청사항, 특이사항, 메모만 가져오기
        const shMNotes = orderNotesMapping[orderId] || '';

        // 요청사항은 SH_M 데이터만 포함
        const requestNotes = shMNotes;        // reservation 레코드
        reservationsCSV.push([
            reId,
            authId, // Auth ID 사용!
            orderId,
            '', // re_quote_id (나중에 매핑)
            'cruise',
            'completed',  // ✅ 예약 상태: completed
            new Date().toISOString(),
            new Date().toISOString(),
            '0',
            '0',
            'completed'  // ✅ 결제 상태: completed
        ].join(','));
        reservationsCount++;

        // reservation_cruise 레코드
        cruiseCSV.push([
            cruiseId,
            reId,
            roomCode,
            checkin,
            guestCount,
            '0',
            '0',
            `"${requestNotes.replace(/"/g, '""').replace(/\n/g, '\\n')}"`,
            `"${boardingCode.replace(/"/g, '""')}"`,
            boardingAssist,  // ✅ boolean 값 (true/false)
            new Date().toISOString()
        ].join(','));
        cruiseCount++;
    });

    fs.writeFileSync('reservations-auth.csv', reservationsCSV.join('\n'));
    fs.writeFileSync('reservation-cruise-auth.csv', cruiseCSV.join('\n'));

    console.log(`✅ reservations-auth.csv: ${reservationsCount}개 (스킵: ${reservationsSkipped}개)`);
    console.log(`✅ reservation-cruise-auth.csv: ${cruiseCount}개\n`);

    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    console.log('✅ Auth ID 기반 CSV 생성 완료!\n');
    console.log('📄 생성된 파일:');
    console.log('   - users-auth.csv');
    console.log('   - reservations-auth.csv');
    console.log('   - reservation-cruise-auth.csv\n');
    console.log('📝 다음 단계:');
    console.log('   1. Supabase에서 기존 데이터 삭제');
    console.log('   2. CSV 파일 업로드\n');
}

exportToCSVWithAuth().catch(console.error);
