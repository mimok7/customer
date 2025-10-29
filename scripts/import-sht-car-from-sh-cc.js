#!/usr/bin/env node
/**
 * SH_CC 시트 → reservation + reservation_car_sht 이관 스크립트
 * 
 * 목적:
 * - SH_CC 시트에서 스하차량 데이터를 읽어 예약 시스템으로 이관
 * - reservation 테이블에 re_type='sht' 로 메인 예약 생성
 * - reservation_car_sht 테이블에 상세 데이터 저장
 * - 주문ID → 사용자ID 매핑 변환
 * 
 * 실행 방법:
 * node scripts/import-sht-car-from-sh-cc.js
 */

const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const dotenv = require('dotenv');

// Load environment variables
try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_SERVICE_KEY;
const GOOGLE_SHEETS_ID = process.env.GOOGLE_SHEETS_ID;
const GOOGLE_SERVICE_ACCOUNT = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const GOOGLE_SERVICE_KEY = process.env.GOOGLE_SERVICE_ACCOUNT_KEY;

// Validation
if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
    console.error('❌ Missing SUPABASE env variables.');
    process.exit(1);
}
if (!GOOGLE_SHEETS_ID || !GOOGLE_SERVICE_ACCOUNT || !GOOGLE_SERVICE_KEY) {
    console.error('❌ Missing Google Sheets env variables.');
    process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

/**
 * Google Sheets 클라이언트 생성
 */
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

/**
 * 날짜 파싱 (여러 형식 지원)
 */
function parseDate(dateStr) {
    if (!dateStr) return null;

    // 이미 YYYY-MM-DD 형식인 경우
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

    // Excel 날짜 숫자 (1900년 1월 1일부터의 일수)
    if (/^\d+$/.test(dateStr)) {
        const days = parseInt(dateStr);
        const date = new Date(1900, 0, days - 1);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    return null;
}

/**
 * 주문ID → 사용자ID 매핑 로드 (DB users.order_id에서 직접)
 */
async function loadOrderUserMapping() {
    console.log('\n📋 주문ID → 사용자ID 매핑 로드 중...');

    // DB에서 모든 사용자 조회 (order_id로 매핑)
    // ⚠️ 페이지네이션 제한 제거: count: infinity 사용
    let allUsers = [];
    const pageSize = 1000;
    let page = 0;
    let hasMore = true;

    while (hasMore) {
        const { data: users, error: usersError } = await supabase
            .from('users')
            .select('id, order_id, email')
            .range(page * pageSize, (page + 1) * pageSize - 1);

        if (usersError) {
            console.error('❌ 사용자 조회 실패:', usersError);
            break;
        }

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

    console.log(`👥 등록된 사용자: ${allUsers.length}명`);
    console.log(`✅ 주문ID 매핑 준비 완료: ${orderToUserId.size}개 (DB users.order_id 직접 사용)`);

    return orderToUserId;
}

/**
 * SH_CC 시트에서 데이터 로드
 */
async function loadSHCCData() {
    console.log('\n📥 SH_CC 시트 데이터 로드 중...');

    const sheets = await getSheetsClient();
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_CC!A2:Z', // 헤더 제외, 충분한 범위로 조회
    });

    const rows = response.data.values || [];
    console.log(`📊 SH_CC 시트: ${rows.length}행 조회`);

    return rows;
}

/**
 * SH_C 시트에서 pickup/dropoff 위치 정보 로드
 */
async function loadSHCLocations() {
    console.log('\n📥 SH_C 시트에서 위치 정보 로드 중...');

    const sheets = await getSheetsClient();
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_C!A2:U', // 헤더 제외, K열(승차위치), L열(하차위치) 포함
    });

    const rows = response.data.values || [];
    console.log(`📊 SH_C 시트: ${rows.length}행 조회`);

    // 주문ID → 위치 정보 매핑 (B열: 주문ID, K열: 승차위치, L열: 하차위치)
    const orderToLocation = new Map();
    rows.forEach(row => {
        const orderId = row[1]?.trim(); // B열: 주문ID
        const pickupLocation = row[10]?.trim() || null; // K열: 승차위치
        const dropoffLocation = row[11]?.trim() || null; // L열: 하차위치

        if (orderId) {
            if (!orderToLocation.has(orderId)) {
                orderToLocation.set(orderId, []);
            }
            orderToLocation.get(orderId).push({
                pickupLocation,
                dropoffLocation
            });
        }
    });

    console.log(`🗺️ 위치 정보 매핑: ${orderToLocation.size}개 주문`);
    return orderToLocation;
}

/**
 * 예약 데이터 생성 및 저장
 */
async function createReservations(shCCRows, orderUserMapping, orderLocationMapping) {
    console.log('\n🚀 예약 데이터 생성 시작...');

    let successCount = 0;
    let skipCount = 0;
    let errorCount = 0;
    const errors = [];

    for (let i = 0; i < shCCRows.length; i++) {
        const row = shCCRows[i];
        const rowNumber = i + 2; // 시트 행 번호 (헤더 제외)

        try {
            // SH_CC 시트 컬럼 매핑 (실제 시트 구조)
            // A: ID (시트 내부 ID)
            // B: 주문ID  
            // C: 승차일
            // D: 구분 (크루즈/렌트)
            // E: 분류 (Pickup/Drop-off)
            // F: 차량번호
            // G: 좌석번호
            // H: 이름
            // I: 수정자
            // J: 수정일시
            // K: Email

            const shccId = row[0]?.trim() || null;
            const orderId = row[1]?.trim(); // B열: 주문ID
            const usageDate = parseDate(row[2]) || null; // C열: 승차일
            const category = row[3]?.trim() || null; // D열: 구분
            const classification = row[4]?.trim() || null; // E열: 분류 (Pickup/Drop-off)
            const vehicleNumber = row[5]?.trim() || null; // F열: 차량번호
            const seatNumber = row[6]?.trim() || null; // G열: 좌석번호
            const customerName = row[7]?.trim() || null; // H열: 이름
            const modifier = row[8]?.trim() || null; // I열: 수정자
            const modifiedAt = row[9]?.trim() || null; // J열: 수정일시
            const email = row[10]?.trim() || null; // K열: Email

            // 가격 정보는 나중에 별도 계산 (기본값)
            const unitPrice = 0;
            const totalPrice = 0;
            const carPriceCode = null;

            if (!orderId) {
                console.log(`⏭️  행 ${rowNumber}: 주문ID 없음, 건너뜀`);
                skipCount++;
                continue;
            }

            // 주문ID → 사용자ID 직접 조회 (DB users.order_id)
            const userId = orderUserMapping.get(orderId);
            if (!userId) {
                console.log(`⚠️  행 ${rowNumber}: 주문ID '${orderId}'에 대한 사용자 없음`);
                skipCount++;
                continue;
            }

            // 주문ID → 위치 정보 조회 (SH_C 시트에서)
            const locations = orderLocationMapping.get(orderId) || [];
            let pickupLocation = null;
            let dropoffLocation = null;

            // 분류에 따라 적절한 위치 선택
            if (classification === 'Pickup' && locations.length > 0) {
                pickupLocation = locations[0].pickupLocation;
            } else if (classification === 'Drop-off' && locations.length > 0) {
                dropoffLocation = locations[0].dropoffLocation;
            } else if (locations.length > 0) {
                // 분류가 없으면 둘 다 저장
                pickupLocation = locations[0].pickupLocation;
                dropoffLocation = locations[0].dropoffLocation;
            }

            // 1. reservation 테이블에 메인 예약 생성
            const { data: reservation, error: reservationError } = await supabase
                .from('reservation')
                .insert({
                    re_user_id: userId,
                    re_quote_id: null, // 견적 없이 직접 예약
                    re_type: 'sht',
                    re_status: 'confirmed', // 기존 데이터는 확정 상태
                    re_created_at: usageDate ? new Date(usageDate).toISOString() : new Date().toISOString(),
                    total_amount: totalPrice,
                    paid_amount: 0,
                    payment_status: 'pending' // CHECK 제약 조건: 'pending', 'partial', 'completed', 'cancelled'
                })
                .select()
                .single();

            if (reservationError) {
                throw new Error(`reservation 테이블 삽입 실패: ${reservationError.message}`);
            }

            // 2. reservation_car_sht 테이블에 상세 데이터 저장
            const { error: carShtError } = await supabase
                .from('reservation_car_sht')
                .insert({
                    reservation_id: reservation.re_id,
                    vehicle_number: vehicleNumber,
                    seat_number: seatNumber,
                    sht_category: classification || category || null, // E열 (Pickup/Drop-off) 우선
                    usage_date: usageDate ? new Date(usageDate).toISOString() : null,
                    pickup_location: pickupLocation, // SH_C K열
                    dropoff_location: dropoffLocation, // SH_C L열
                    pickup_datetime: usageDate || null,
                    car_price_code: carPriceCode,
                    passenger_count: 0, // 시트에 정보 없음
                    car_count: 1,
                    unit_price: unitPrice,
                    car_total_price: totalPrice,
                    request_note: `이메일: ${email || '없음'}`,
                    created_at: new Date().toISOString()
                });

            if (carShtError) {
                throw new Error(`reservation_car_sht 테이블 삽입 실패: ${carShtError.message}`);
            }

            successCount++;
            if (successCount % 10 === 0) {
                console.log(`✅ ${successCount}건 처리 완료...`);
            }

        } catch (error) {
            errorCount++;
            const errorMsg = `행 ${rowNumber} (주문ID: ${row[0]}): ${error.message}`;
            errors.push(errorMsg);
            console.error(`❌ ${errorMsg}`);
        }
    }

    // 결과 요약
    console.log('\n' + '='.repeat(60));
    console.log('📊 이관 결과 요약');
    console.log('='.repeat(60));
    console.log(`✅ 성공: ${successCount}건`);
    console.log(`⏭️  건너뜀: ${skipCount}건`);
    console.log(`❌ 실패: ${errorCount}건`);
    console.log('='.repeat(60));

    if (errors.length > 0 && errors.length <= 20) {
        console.log('\n❌ 오류 상세:');
        errors.forEach(err => console.log(`  - ${err}`));
    } else if (errors.length > 20) {
        console.log(`\n❌ 오류가 너무 많습니다 (${errors.length}건). 처음 20개만 표시:`);
        errors.slice(0, 20).forEach(err => console.log(`  - ${err}`));
    }

    return { successCount, skipCount, errorCount };
}

/**
 * 메인 실행 함수
 */
async function main() {
    console.log('🚀 SH_CC 시트 → 예약 시스템 이관 시작');
    console.log('='.repeat(60));

    try {
        // 1. 주문ID → 사용자ID 매핑 로드 (DB users.order_id에서 직접)
        const orderUserMapping = await loadOrderUserMapping();

        if (orderUserMapping.size === 0) {
            console.error('❌ 사용자가 없습니다. users 테이블을 확인하세요.');
            process.exit(1);
        }

        // 2. SH_CC 시트 데이터 로드
        const shCCRows = await loadSHCCData();

        if (shCCRows.length === 0) {
            console.log('⚠️  SH_CC 시트에 데이터가 없습니다.');
            process.exit(0);
        }

        // 3. SH_C 시트에서 위치 정보 로드
        const orderLocationMapping = await loadSHCLocations();

        // 4. 예약 데이터 생성 및 저장 (주문ID로 직접 매핑)
        const result = await createReservations(shCCRows, orderUserMapping, orderLocationMapping);

        console.log('\n✅ 이관 작업 완료!');
        console.log(`\n📊 최종 결과:`);
        console.log(`  - 성공: ${result.successCount}건`);
        console.log(`  - 건너뜀: ${result.skipCount}건`);
        console.log(`  - 실패: ${result.errorCount}건`);

        process.exit(result.errorCount > 0 ? 1 : 0);

    } catch (error) {
        console.error('\n❌ 치명적 오류:', error);
        process.exit(1);
    }
}

// 실행
main();
