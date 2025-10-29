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
    console.log('🔍 건너뛴 데이터 중 미래 승차일 확인\n');
    console.log('='.repeat(70));

    const today = '2025-10-27';
    console.log(`기준일: ${today}\n`);

    // 1. 전체 사용자 order_id 로드
    console.log('📥 users 테이블에서 order_id 로드 중...');
    let allUsers = [];
    const pageSize = 1000;
    let page = 0;
    let hasMore = true;

    while (hasMore) {
        const { data: users } = await supabase
            .from('users')
            .select('id, order_id')
            .range(page * pageSize, (page + 1) * pageSize - 1);

        if (users && users.length > 0) {
            allUsers = allUsers.concat(users);
            page++;
            hasMore = users.length === pageSize;
        } else {
            hasMore = false;
        }
    }

    const existingOrderIds = new Set(
        allUsers.map(u => u.order_id?.trim()).filter(Boolean)
    );
    console.log(`✅ users 테이블 order_id: ${existingOrderIds.size}개\n`);

    // 2. SH_CC 데이터 로드
    console.log('📥 SH_CC 시트 데이터 로드 중...');
    const sheets = await getSheetsClient();
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_CC!A2:L',
    });

    const rows = response.data.values || [];
    console.log(`✅ SH_CC 시트: ${rows.length}행 조회\n`);

    // 3. 건너뛴 데이터 중 미래 승차일 필터링
    console.log('='.repeat(70));
    console.log('🔍 건너뛴 데이터 중 미래 승차일 분석');
    console.log('='.repeat(70) + '\n');

    const skippedWithFutureDates = [];

    rows.forEach((row, index) => {
        const orderId = row[1]?.trim(); // B열: 주문ID
        const rideDateStr = row[4]?.trim(); // E열: 승차일
        const category = row[2]?.trim(); // C열: 분류
        const vehicleNum = row[5]?.trim(); // F열: 차량번호
        const seatNum = row[6]?.trim(); // G열: 좌석번호
        const riderName = row[7]?.trim(); // H열: 탑승자명
        const phone = row[8]?.trim(); // I열: 전화번호

        // 건너뛴 데이터 (users에 없는 order_id)
        if (orderId && !existingOrderIds.has(orderId)) {
            const rideDate = parseDate(rideDateStr);

            if (rideDate && rideDate > today) {
                skippedWithFutureDates.push({
                    rowNum: index + 2,
                    orderId,
                    rideDate,
                    rideDateStr,
                    category,
                    vehicleNum,
                    seatNum,
                    riderName,
                    phone
                });
            }
        }
    });

    // 4. 결과 출력
    if (skippedWithFutureDates.length === 0) {
        console.log('✅ 건너뛴 데이터 중 미래 승차일 데이터가 없습니다.\n');
    } else {
        console.log(`⚠️  건너뛴 데이터 중 미래 승차일: ${skippedWithFutureDates.length}건\n`);

        // 승차일 기준 정렬
        skippedWithFutureDates.sort((a, b) => a.rideDate.localeCompare(b.rideDate));

        console.log('상세 내역:\n');
        skippedWithFutureDates.forEach((item, idx) => {
            console.log(`${idx + 1}. [행 ${item.rowNum}] ${item.rideDate} (${item.rideDateStr})`);
            console.log(`   주문ID: ${item.orderId}`);
            console.log(`   분류: ${item.category} | 차량: ${item.vehicleNum} | 좌석: ${item.seatNum}`);
            console.log(`   탑승자: ${item.riderName} | 연락처: ${item.phone}`);
            console.log('');
        });

        // 날짜별 집계
        console.log('='.repeat(70));
        console.log('📊 날짜별 집계');
        console.log('='.repeat(70) + '\n');

        const dateCount = {};
        skippedWithFutureDates.forEach(item => {
            dateCount[item.rideDate] = (dateCount[item.rideDate] || 0) + 1;
        });

        Object.entries(dateCount)
            .sort(([a], [b]) => a.localeCompare(b))
            .forEach(([date, count]) => {
                console.log(`${date}: ${count}건`);
            });
    }

    console.log('\n' + '='.repeat(70));
    console.log('📊 최종 요약');
    console.log('='.repeat(70));
    console.log(`\n전체 SH_CC 데이터: ${rows.length}건`);
    console.log(`users 테이블에 있는 order_id: ${existingOrderIds.size}개`);

    const totalSkipped = rows.filter(row => {
        const orderId = row[1]?.trim();
        return orderId && !existingOrderIds.has(orderId);
    }).length;

    console.log(`건너뛴 데이터: ${totalSkipped}건`);
    console.log(`건너뛴 데이터 중 미래 승차일: ${skippedWithFutureDates.length}건`);

    if (skippedWithFutureDates.length > 0) {
        console.log(`\n⚠️  조치 필요: ${skippedWithFutureDates.length}건의 미래 예약이 이관되지 않았습니다!`);
    }

    console.log('\n' + '='.repeat(70));
}

main().catch(console.error);
