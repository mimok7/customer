require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function exportToCSV() {
    console.log('📥 구글 시트 데이터를 CSV로 변환 시작\n');

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
    console.log('📊 SH_M 데이터 로드');
    console.log('============================================================\n');

    const shMResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_M!A:U',  // U열까지 확장 (메모 컬럼 포함)
    });

    const shMRows = shMResponse.data.values;
    const shMHeaders = shMRows[0];
    const shMData = shMRows.slice(1);

    console.log(`✅ SH_M: ${shMData.length}개 행\n`);

    // 3. Users CSV 생성
    console.log('============================================================');
    console.log('📝 users.csv 생성');
    console.log('============================================================\n');

    // Supabase users 테이블 구조에 맞춤 (order_id 컬럼 추가)
    const usersCsvHeader = 'id,order_id,reservation_date,email,name,english_name,nickname,phone_number,role,birth_date,passport_number,passport_expiry,status,created_at,updated_at,kakao_id\n';
    let usersCsvContent = usersCsvHeader;
    const orderUserMapping = {};

    let validCount = 0;
    let invalidCount = 0;

    shMData.forEach((row) => {
        // 구글 시트 SH_M 컬럼 (A~I)
        const orderId = row[0];           // A: 주문ID
        const reservationDate = row[1];   // B: 예약일
        const email = row[2]?.trim();     // C: Email
        const nameKr = row[3]?.trim();    // D: 한글이름
        const nameEn = row[4]?.trim();    // E: 영문이름
        const nickname = row[5]?.trim();  // F: 닉네임
        const memberLevel = row[6];       // G: 회원등급
        const name2 = row[7]?.trim();     // H: 이름 (중복?)
        const phone = row[8]?.trim();     // I: 전화번호

        // 유효성 검사
        if (!email && !phone) {
            invalidCount++;
            return;
        }

        const userId = uuidv4();
        const now = new Date().toISOString();

        // CSV 행 생성 (쉼표와 줄바꿈 이스케이프)
        const escapeCsv = (str) => {
            if (!str) return '';
            if (str.includes(',') || str.includes('"') || str.includes('\n')) {
                return `"${str.replace(/"/g, '""')}"`;
            }
            return str;
        };

        // 날짜 포맷 변환 (구글 시트 날짜 → ISO 8601)
        const formatDate = (dateStr) => {
            if (!dateStr) return '';
            try {
                // "2024. 5. 2" 형식을 "2024-05-02"로 변환
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

        usersCsvContent += [
            userId,
            escapeCsv(orderId || ''),  // order_id 추가
            escapeCsv(formatDate(reservationDate)),
            escapeCsv(email || ''),
            escapeCsv(nameKr || name2 || ''),  // 한글이름 우선, 없으면 이름(H) 사용
            escapeCsv(nameEn || ''),
            escapeCsv(nickname || ''),
            escapeCsv(phone || ''),
            'member',
            '',  // birth_date (구글 시트에 없음)
            '',  // passport_number (구글 시트에 없음)
            '',  // passport_expiry (구글 시트에 없음)
            'active',
            now,
            now,
            ''   // kakao_id
        ].join(',') + '\n';

        // Order-User 매핑 저장
        if (orderId) {
            orderUserMapping[orderId] = userId;
        }

        validCount++;
    });

    fs.writeFileSync('users.csv', usersCsvContent, 'utf-8');
    console.log(`✅ users.csv 생성 완료: ${validCount}명 (무효: ${invalidCount}명)\n`);

    // 4. Order-User 매핑 저장
    fs.writeFileSync('order-user-mapping.json', JSON.stringify(orderUserMapping, null, 2), 'utf-8');
    console.log(`✅ order-user-mapping.json 저장: ${Object.keys(orderUserMapping).length}개\n`);

    // 5. SH_R 데이터 로드
    console.log('============================================================');
    console.log('📊 SH_R 데이터 로드');
    console.log('============================================================\n');

    const shRResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A:AZ',
    });

    const shRRows = shRResponse.data.values;
    const shRHeaders = shRRows[0];
    const shRData = shRRows.slice(1);

    console.log(`✅ SH_R: ${shRData.length}개 행\n`);

    // 6. Reservations CSV 생성
    console.log('============================================================');
    console.log('📝 reservations.csv 생성');
    console.log('============================================================\n');

    // Supabase reservation 테이블 구조에 맞춤 (order_id 추가)
    const reservationsCsvHeader = 're_id,re_user_id,order_id,re_quote_id,re_type,re_status,re_created_at,re_update_at,total_amount,paid_amount,payment_status\n';
    let reservationsCsvContent = reservationsCsvHeader;

    // Supabase reservation_cruise 테이블 구조에 맞춤
    const cruiseCsvHeader = 'id,reservation_id,room_price_code,checkin,guest_count,unit_price,room_total_price,request_note,boarding_code,boarding_assist,created_at\n';
    let cruiseCsvContent = cruiseCsvHeader;

    const orderIdIndex = shRHeaders.findIndex(h => h === '주문ID');
    const 크루즈Index = shRHeaders.findIndex(h => h === '크루즈');
    const 체크인Index = shRHeaders.findIndex(h => h === '체크인');
    const 객실코드Index = shRHeaders.findIndex(h => h === '객실코드');
    const 승선인원Index = shRHeaders.findIndex(h => h === '승선인원');
    const 인원수Index = shRHeaders.findIndex(h => h === '인원수');
    const 합계Index = shRHeaders.findIndex(h => h === '합계');
    const 금액Index = shRHeaders.findIndex(h => h === '금액');
    const 객실비고Index = shRHeaders.findIndex(h => h === '객실비고');
    const 승선도움Index = shRHeaders.findIndex(h => h === '승선도움');
    const 처리Index = shRHeaders.findIndex(h => h === '처리');  // V열: 승선코드

    // SH_M 시트에서 요청사항/특이사항/메모 가져오기 위한 매핑 생성
    const shMOrderIdIndex = shMHeaders.findIndex(h => h === '주문ID');
    const 요청사항Index = shMHeaders.findIndex(h => h === '요청사항');
    const 특이사항Index = shMHeaders.findIndex(h => h === '특이사항');
    const 메모Index = shMHeaders.findIndex(h => h === '메모');

    // 주문ID로 SH_M 데이터 매핑
    const orderNotesMapping = {};
    shMData.forEach((row) => {
        const orderId = row[shMOrderIdIndex];
        if (orderId) {
            const notes = [];
            if (row[요청사항Index]) notes.push(`요청사항: ${row[요청사항Index]}`);
            if (row[특이사항Index]) notes.push(`특이사항: ${row[특이사항Index]}`);
            if (row[메모Index]) notes.push(`메모: ${row[메모Index]}`);
            orderNotesMapping[orderId] = notes.join('\n');
        }
    });

    console.log(`✅ orderNotesMapping 생성: ${Object.keys(orderNotesMapping).length}개`);
    console.log('🔍 샘플 주문 노트:');
    Object.entries(orderNotesMapping).slice(0, 3).forEach(([orderId, notes]) => {
        console.log(`  ${orderId}: ${notes.substring(0, 60)}...`);
    });
    console.log('');

    let reservationCount = 0;
    let skippedCount = 0;
    let noRoomCodeCount = 0;  // 객실코드 없어서 스킵된 개수

    // 날짜 포맷 변환 함수
    const formatDate = (dateStr) => {
        if (!dateStr) return '';
        try {
            // "2024. 5. 2" 형식을 "2024-05-02"로 변환
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

    const escapeCsv = (str) => {
        if (!str) return '';
        if (str.includes(',') || str.includes('"') || str.includes('\n')) {
            return `"${str.replace(/"/g, '""')}"`;
        }
        return str;
    };

    shRData.forEach((row) => {
        const orderId = row[orderIdIndex];
        const 객실코드 = row[객실코드Index] || '';  // G열: 객실코드

        // ✅ 객실코드가 있는 데이터만 처리 (R로 시작하는 코드)
        if (!객실코드 || !객실코드.startsWith('R')) {
            noRoomCodeCount++;
            return;  // 객실코드 없으면 스킵
        }

        const userId = orderUserMapping[orderId];

        if (!userId) {
            skippedCount++;
            return;
        }

        const 크루즈 = row[크루즈Index] || '';
        const 체크인 = row[체크인Index] || '';
        // 객실코드는 이미 위에서 검증됨
        const 객실종류 = row[객실코드Index - 2] || '';  // E열: 객실종류
        const 승선인원 = row[승선인원Index] || row[인원수Index] || '0';
        const 합계 = row[합계Index] || '0';
        const 금액 = row[금액Index] || '0';
        const 객실비고 = row[객실비고Index] || '';
        const 승선도움 = row[승선도움Index] || '';
        const 처리 = row[처리Index] || '';  // V열: 승선코드

        // SH_M에서 요청사항/특이사항/메모 가져오기
        const shMNotes = orderNotesMapping[orderId] || '';

        // request_note 통합: 객실비고 + SH_M의 노트들
        const requestNotes = [객실비고, shMNotes].filter(Boolean).join('\n');

        // 필수 필드 체크
        if (!크루즈 || !체크인) {
            skippedCount++;
            return;
        }

        // room_price_code는 이미 검증된 객실코드 사용
        let roomPriceCode = 객실코드;

        const reservationId = uuidv4();
        const cruiseDetailId = uuidv4();
        const now = new Date().toISOString();

        // 금액 파싱 (쉼표 제거)
        const parseAmount = (amountStr) => {
            if (!amountStr) return '0';
            return amountStr.toString().replace(/,/g, '').replace(/[^\d.-]/g, '') || '0';
        };

        const totalAmount = parseAmount(합계);
        const unitPrice = parseAmount(금액);

        // Reservation CSV (메인 예약 - order_id 포함)
        reservationsCsvContent += [
            reservationId,
            userId,
            escapeCsv(orderId || ''),  // order_id 추가
            '',  // re_quote_id (null)
            'cruise',
            'confirmed',
            now,
            now,
            totalAmount,
            '0',  // paid_amount
            'pending'  // payment_status
        ].join(',') + '\n';

        // Reservation Cruise CSV (크루즈 상세)
        cruiseCsvContent += [
            cruiseDetailId,
            reservationId,
            escapeCsv(roomPriceCode),  // 자동 생성된 코드 또는 빈 문자열
            escapeCsv(formatDate(체크인)),
            parseInt(승선인원) || 0,
            unitPrice,
            totalAmount,
            escapeCsv(requestNotes),  // 통합된 요청사항 (객실비고 + SH_M 노트)
            escapeCsv(처리 || ''),  // boarding_code: SH_R의 처리 컬럼 (V열)
            승선도움 === 'Y' || 승선도움 === 'O' ? 'true' : 'false',  // boarding_assist: SH_R의 승선도움 (S열)
            now
        ].join(',') + '\n';

        reservationCount++;
    });

    fs.writeFileSync('reservations.csv', reservationsCsvContent, 'utf-8');
    fs.writeFileSync('reservation_cruise.csv', cruiseCsvContent, 'utf-8');

    console.log(`✅ reservations.csv 생성 완료: ${reservationCount}개`);
    console.log(`✅ reservation_cruise.csv 생성 완료: ${reservationCount}개`);
    console.log(`   스킵: ${skippedCount}개 (User ID 없거나 필수 필드 누락)`);
    console.log(`   ⚠️  객실코드 없음: ${noRoomCodeCount}개 (제외됨)\n`);

    // 7. 최종 요약
    console.log('============================================================');
    console.log('🎉 CSV 변환 완료!');
    console.log('============================================================');
    console.log('생성된 파일:');
    console.log('  1. users.csv - Supabase users 테이블용');
    console.log('  2. order-user-mapping.json - Order ID → User ID 매핑');
    console.log('  3. reservations.csv - Supabase reservation 테이블용');
    console.log('  4. reservation_cruise.csv - Supabase reservation_cruise 테이블용');
    console.log('');
    console.log('📌 다음 단계:');
    console.log('  Supabase Table Editor에서 CSV Import:');
    console.log('');
    console.log('  1. users 테이블');
    console.log('     - Table Editor → users → ... → Import data from CSV');
    console.log('     - 파일: users.csv');
    console.log('     - ✅ First row is header 체크');
    console.log('     - 컬럼 자동 매핑 확인 후 Import');
    console.log('');
    console.log('  2. reservation 테이블');
    console.log('     - Table Editor → reservation → ... → Import data from CSV');
    console.log('     - 파일: reservations.csv');
    console.log('     - ✅ First row is header 체크');
    console.log('');
    console.log('  3. reservation_cruise 테이블');
    console.log('     - Table Editor → reservation_cruise → ... → Import data from CSV');
    console.log('     - 파일: reservation_cruise.csv');
    console.log('     - ✅ First row is header 체크');
    console.log('');
    console.log('⚠️  중요: users → reservation → reservation_cruise 순서로 임포트!');
    console.log('   (FK 제약조건 때문에 순서가 중요합니다)');
    console.log('');
}

exportToCSV().catch(console.error);
