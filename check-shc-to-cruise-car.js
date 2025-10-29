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

    if (/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) {
        return dateStr;
    }

    if (/^\d{8}$/.test(dateStr)) {
        return `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}`;
    }

    const match = dateStr.match(/(\d{4})[\.\/-](\d{1,2})[\.\/-](\d{1,2})/);
    if (match) {
        const [, year, month, day] = match;
        return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    }

    return null;
}

async function main() {
    console.log('🔍 SH_C → reservation_cruise_car 이관 가능성 점검\n');
    console.log('='.repeat(80));

    // 1. reservation_cruise_car 테이블 구조 확인
    console.log('\n📋 Step 1: reservation_cruise_car 테이블 구조 확인');
    console.log('='.repeat(80));

    const { data: sampleReservations, error: reservationError } = await supabase
        .from('reservation_cruise_car')
        .select('*')
        .limit(1);

    if (reservationError) {
        console.log('❌ 테이블 조회 실패:', reservationError.message);
    } else if (sampleReservations && sampleReservations.length > 0) {
        console.log('\n✅ 테이블 컬럼 목록:');
        const columns = Object.keys(sampleReservations[0]);
        columns.forEach((col, idx) => {
            console.log(`   ${(idx + 1).toString().padStart(2)}. ${col.padEnd(30)} | 타입: ${typeof sampleReservations[0][col]}`);
        });
    } else {
        console.log('⚠️  테이블이 비어있어서 sql/db.csv에서 구조 확인 필요');
    }

    // 2. SH_C 시트 데이터 로드
    console.log('\n📋 Step 2: SH_C 시트 데이터 로드');
    console.log('='.repeat(80));

    const sheets = await getSheetsClient();
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_C!A1:Z',
    });

    const rows = response.data.values || [];
    const headers = rows[0] || [];
    const dataRows = rows.slice(1);

    console.log(`\n✅ SH_C 시트 로드 완료`);
    console.log(`   총 행 수: ${dataRows.length}행`);
    console.log(`   컬럼 수: ${headers.length}개\n`);

    console.log('컬럼 목록:');
    headers.forEach((header, idx) => {
        const colLetter = String.fromCharCode(65 + idx);
        console.log(`   ${colLetter}열. ${header}`);
    });

    // 3. users 테이블에서 order_id 로드
    console.log('\n📋 Step 3: users 테이블 order_id 로드');
    console.log('='.repeat(80));

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

    const orderToUserId = new Map(
        allUsers.map(u => [u.order_id?.trim(), u.id]).filter(([orderId]) => orderId)
    );

    console.log(`\n✅ users 테이블 로드 완료`);
    console.log(`   전체 사용자: ${allUsers.length}명`);
    console.log(`   order_id 매핑: ${orderToUserId.size}개\n`);

    // 4. 이관 가능성 분석
    console.log('📋 Step 4: 이관 가능성 분석 (샘플 20건)');
    console.log('='.repeat(80) + '\n');

    const analysis = {
        total: dataRows.length,
        hasOrderId: 0,
        userMappable: 0,
        hasRequiredFields: 0,
        fullyMappable: 0,
        samples: []
    };

    // 샘플 20건 분석
    const sampleSize = Math.min(20, dataRows.length);

    for (let i = 0; i < sampleSize; i++) {
        const row = dataRows[i];
        const orderId = row[1]?.trim(); // B열: 주문ID
        const userId = orderId ? orderToUserId.get(orderId) : null;

        // 필수 필드 확인
        const hasOrderId = !!orderId;
        const hasMappableUser = !!userId;

        // SH_C 주요 필드들
        const checkInDate = row[2]?.trim(); // C열
        const checkOutDate = row[3]?.trim(); // D열
        const cruiseName = row[4]?.trim(); // E열
        const roomType = row[5]?.trim(); // F열
        const carType = row[6]?.trim(); // G열
        const adultCount = row[7]?.trim(); // H열
        const childCount = row[8]?.trim(); // I열
        const infantCount = row[9]?.trim(); // J열
        const pickupLocation = row[10]?.trim(); // K열
        const dropoffLocation = row[11]?.trim(); // L열

        const hasRequiredFields = !!(orderId && (checkInDate || checkOutDate || cruiseName));

        if (hasOrderId) analysis.hasOrderId++;
        if (hasMappableUser) analysis.userMappable++;
        if (hasRequiredFields) analysis.hasRequiredFields++;
        if (hasMappableUser && hasRequiredFields) analysis.fullyMappable++;

        let status = '❌ 실패';
        let reason = [];

        if (!orderId) {
            reason.push('주문ID 없음');
        } else if (!userId) {
            reason.push('사용자 매핑 불가');
        } else if (!hasRequiredFields) {
            reason.push('필수 필드 부족');
        } else {
            status = '✅ 성공';
            reason.push('이관 가능');
        }

        analysis.samples.push({
            rowNum: i + 2,
            orderId: orderId || '(없음)',
            userId: userId ? userId.substring(0, 8) + '...' : '(없음)',
            checkInDate: checkInDate || '(없음)',
            cruiseName: cruiseName || '(없음)',
            roomType: roomType || '(없음)',
            carType: carType || '(없음)',
            pickupLocation: pickupLocation || '(없음)',
            status,
            reason: reason.join(', ')
        });
    }

    // 샘플 출력
    console.log('샘플 데이터 분석:\n');
    analysis.samples.forEach((sample, idx) => {
        console.log(`${(idx + 1).toString().padStart(2)}. [행 ${sample.rowNum}] ${sample.status}`);
        console.log(`    주문ID: ${sample.orderId.padEnd(15)} | 사용자ID: ${sample.userId}`);
        console.log(`    체크인: ${sample.checkInDate.padEnd(12)} | 크루즈: ${sample.cruiseName}`);
        console.log(`    객실: ${sample.roomType.padEnd(15)} | 차량: ${sample.carType}`);
        console.log(`    승차: ${sample.pickupLocation.padEnd(20)} | 이유: ${sample.reason}`);
        console.log('');
    });

    // 5. 전체 데이터 통계
    console.log('='.repeat(80));
    console.log('📊 전체 데이터 통계 분석');
    console.log('='.repeat(80) + '\n');

    let totalStats = {
        total: 0,
        hasOrderId: 0,
        userMappable: 0,
        hasRequiredFields: 0,
        fullyMappable: 0,
        failReasons: {
            noOrderId: 0,
            noUserMapping: 0,
            noRequiredFields: 0
        }
    };

    dataRows.forEach((row, index) => {
        totalStats.total++;

        const orderId = row[1]?.trim();
        const userId = orderId ? orderToUserId.get(orderId) : null;
        const checkInDate = row[2]?.trim();
        const checkOutDate = row[3]?.trim();
        const cruiseName = row[4]?.trim();

        const hasOrderId = !!orderId;
        const hasMappableUser = !!userId;
        const hasRequiredFields = !!(orderId && (checkInDate || checkOutDate || cruiseName));

        if (hasOrderId) totalStats.hasOrderId++;
        if (hasMappableUser) totalStats.userMappable++;
        if (hasRequiredFields) totalStats.hasRequiredFields++;
        if (hasMappableUser && hasRequiredFields) totalStats.fullyMappable++;

        // 실패 원인 분류
        if (!orderId) {
            totalStats.failReasons.noOrderId++;
        } else if (!userId) {
            totalStats.failReasons.noUserMapping++;
        } else if (!hasRequiredFields) {
            totalStats.failReasons.noRequiredFields++;
        }
    });

    console.log(`전체 데이터: ${totalStats.total}행\n`);

    console.log('✅ 성공 가능 데이터:');
    console.log(`   이관 가능: ${totalStats.fullyMappable}건 (${(totalStats.fullyMappable / totalStats.total * 100).toFixed(1)}%)\n`);

    console.log('⚠️  조건별 통과율:');
    console.log(`   주문ID 있음: ${totalStats.hasOrderId}건 (${(totalStats.hasOrderId / totalStats.total * 100).toFixed(1)}%)`);
    console.log(`   사용자 매핑 가능: ${totalStats.userMappable}건 (${(totalStats.userMappable / totalStats.total * 100).toFixed(1)}%)`);
    console.log(`   필수 필드 있음: ${totalStats.hasRequiredFields}건 (${(totalStats.hasRequiredFields / totalStats.total * 100).toFixed(1)}%)\n`);

    console.log('❌ 실패 원인 분석:');
    console.log(`   주문ID 없음: ${totalStats.failReasons.noOrderId}건`);
    console.log(`   사용자 매핑 불가: ${totalStats.failReasons.noUserMapping}건`);
    console.log(`   필수 필드 부족: ${totalStats.failReasons.noRequiredFields}건\n`);

    // 6. 이관 권장사항
    console.log('='.repeat(80));
    console.log('💡 이관 권장사항');
    console.log('='.repeat(80) + '\n');

    const successRate = (totalStats.fullyMappable / totalStats.total * 100).toFixed(1);

    if (successRate >= 90) {
        console.log(`✅ 이관 권장: ${successRate}% 성공 예상`);
        console.log(`   ${totalStats.fullyMappable}건의 데이터를 안전하게 이관할 수 있습니다.\n`);
    } else if (successRate >= 70) {
        console.log(`⚠️  조건부 권장: ${successRate}% 성공 예상`);
        console.log(`   ${totalStats.fullyMappable}건 이관 가능, ${totalStats.total - totalStats.fullyMappable}건 실패 예상\n`);
    } else {
        console.log(`❌ 이관 비권장: ${successRate}% 성공 예상`);
        console.log(`   데이터 정리 후 재시도 권장\n`);
    }

    // 7. 필요한 매핑 정보
    console.log('📋 reservation_cruise_car 테이블 필수 매핑:');
    console.log('   - reservation_id: reservation 테이블에서 생성 후 연결');
    console.log('   - user_id: users.order_id로 매핑 ✅');
    console.log('   - checkin: SH_C C열 (체크인일)');
    console.log('   - checkout: SH_C D열 (체크아웃일)');
    console.log('   - cruise_name: SH_C E열');
    console.log('   - room_type: SH_C F열');
    console.log('   - car_type: SH_C G열');
    console.log('   - guest_count: SH_C H+I+J열 합산');
    console.log('   - pickup_location: SH_C K열');
    console.log('   - dropoff_location: SH_C L열\n');

    console.log('='.repeat(80));
}

main().catch(console.error);
