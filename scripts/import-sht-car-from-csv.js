#!/usr/bin/env node
/**
 * SH_CC CSV 파일 → reservation + reservation_car_sht 이관 스크립트
 * 
 * 목적:
 * - CSV 파일에서 스하차량 데이터를 읽어 예약 시스템으로 이관
 * - reservation 테이블에 re_type='sht' 로 메인 예약 생성
 * - reservation_car_sht 테이블에 상세 데이터 저장
 * - 주문ID → 사용자ID 매핑 변환
 * 
 * 사용 방법:
 * 1. SH_CC 데이터를 CSV로 내보내기 (scripts/sh_cc_data.csv)
 * 2. node scripts/import-sht-car-from-csv.js
 * 
 * CSV 형식:
 * user_email,reservation_date,vehicle_number,seat_number,sht_category,pickup_location,dropoff_location,pickup_datetime,passenger_count,request_note,car_price_code,unit_price,total_price
 * 
 * 주의: 한 사람이 여러 예약을 할 수 있으므로 동일 이메일에 대해 여러 행 처리 가능
 */

const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

// Load environment variables
try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_SERVICE_KEY;

// Validation
if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
    console.error('❌ Missing SUPABASE env variables.');
    console.error('Required: NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY');
    process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

// CSV 파일 경로
const CSV_FILE_PATH = path.join(process.cwd(), 'scripts', 'sh_cc_data.csv');

/**
 * CSV 파싱 함수 (RFC 4180 호환)
 * - 따옴표로 묶인 필드 내부의 콤마를 구분자로 처리하지 않음
 */
function parseCSV(csvContent) {
    const lines = csvContent.split('\n').filter(line => line.trim());
    if (lines.length === 0) return [];

    // CSV 라인 파싱 (따옴표 처리)
    function parseCSVLine(line) {
        const result = [];
        let current = '';
        let inQuotes = false;

        for (let i = 0; i < line.length; i++) {
            const char = line[i];
            const nextChar = line[i + 1];

            if (char === '"') {
                if (inQuotes && nextChar === '"') {
                    // 이스케이프된 따옴표 (""  -> ")
                    current += '"';
                    i++; // 다음 따옴표 건너뛰기
                } else {
                    // 따옴표 시작/끝
                    inQuotes = !inQuotes;
                }
            } else if (char === ',' && !inQuotes) {
                // 필드 구분자 (따옴표 밖에서만)
                result.push(current.trim());
                current = '';
            } else {
                current += char;
            }
        }

        // 마지막 필드 추가
        result.push(current.trim());

        // 따옴표 제거
        return result.map(field => {
            // 양쪽 따옴표 제거
            if (field.startsWith('"') && field.endsWith('"')) {
                return field.slice(1, -1);
            }
            return field;
        });
    }

    const headers = parseCSVLine(lines[0]);
    const rows = [];

    for (let i = 1; i < lines.length; i++) {
        const values = parseCSVLine(lines[i]);
        const row = {};
        headers.forEach((header, index) => {
            row[header] = values[index] || '';
        });
        rows.push(row);
    }

    return rows;
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
 * 이메일 → 사용자ID 매핑 로드
 */
async function loadEmailUserMapping() {
    console.log('\n📋 이메일 → 사용자ID 매핑 로드 중...');

    // users 테이블에서 email과 id 매핑 (이메일 소문자 정규화)
    const { data: users, error: usersError } = await supabase
        .from('users')
        .select('id, email');

    if (usersError) {
        console.error('❌ 사용자 조회 실패:', usersError);
        return new Map();
    }

    // 이메일은 중복 가능하므로 이메일 → [사용자ID 배열] 매핑
    const emailToUserIds = new Map();

    users.forEach(u => {
        if (u.email) {
            const email = u.email.trim().toLowerCase();
            if (!emailToUserIds.has(email)) {
                emailToUserIds.set(email, []);
            }
            emailToUserIds.get(email).push(u.id);
        }
    });

    console.log(`👥 등록된 사용자: ${users.length}명`);
    console.log(`� 이메일 매핑: ${emailToUserIds.size}개 (중복 허용)`);

    return emailToUserIds;
}

/**
 * CSV 파일에서 데이터 로드
 */
function loadCSVData() {
    console.log('\n📥 CSV 파일 로드 중...');
    console.log(`📄 파일: ${CSV_FILE_PATH}`);

    if (!fs.existsSync(CSV_FILE_PATH)) {
        throw new Error(`CSV 파일을 찾을 수 없습니다: ${CSV_FILE_PATH}`);
    }

    const csvContent = fs.readFileSync(CSV_FILE_PATH, 'utf-8');
    const rows = parseCSV(csvContent);

    console.log(`📊 CSV 파일: ${rows.length}행 로드`);

    return rows;
}

/**
 * 예약 데이터 생성 및 저장
 */
async function createReservations(csvRows, emailToUserIds) {
    console.log('\n🚀 예약 데이터 생성 시작...');

    let successCount = 0;
    let skipCount = 0;
    let errorCount = 0;
    const errors = [];

    for (let i = 0; i < csvRows.length; i++) {
        const row = csvRows[i];
        const rowNumber = i + 2; // CSV 행 번호 (헤더 제외)

        try {
            // 이메일로 사용자ID 조회
            const userEmail = row.user_email?.trim().toLowerCase();
            if (!userEmail) {
                console.log(`⏭️  행 ${rowNumber}: 이메일 없음, 건너뜀`);
                skipCount++;
                continue;
            }

            const userIds = emailToUserIds.get(userEmail);
            if (!userIds || userIds.length === 0) {
                console.log(`⚠️  행 ${rowNumber}: 이메일 '${userEmail}'에 대한 사용자 없음`);
                skipCount++;
                continue;
            }

            // 첫 번째 사용자 ID 사용 (같은 이메일이면 모두 같은 사람)
            const userId = userIds[0];

            // CSV 데이터 추출
            const reservationDate = parseDate(row.reservation_date) || new Date().toISOString().split('T')[0];
            const vehicleNumber = row.vehicle_number?.trim() || null;
            const seatNumber = row.seat_number?.trim() || null;
            const shtCategory = row.sht_category?.trim() || null;
            const pickupLocation = row.pickup_location?.trim() || null;
            const dropoffLocation = row.dropoff_location?.trim() || null;
            const pickupDatetime = parseDate(row.pickup_datetime) || null;
            const passengerCount = parseInt(row.passenger_count) || 0;
            const requestNote = row.request_note?.trim() || null;
            const carPriceCode = row.car_price_code?.trim() || null;
            const unitPrice = parseFloat(row.unit_price) || 0;
            const totalPrice = parseFloat(row.total_price) || 0;

            // 1. reservation 테이블에 메인 예약 생성
            const { data: reservation, error: reservationError } = await supabase
                .from('reservation')
                .insert({
                    re_user_id: userId,
                    re_quote_id: null, // 견적 없이 직접 예약
                    re_type: 'sht',
                    re_status: 'confirmed', // 기존 데이터는 확정 상태
                    re_created_at: new Date(reservationDate).toISOString(),
                    total_amount: totalPrice,
                    paid_amount: 0,
                    payment_status: 'pending' // DB constraint: pending, completed, cancelled, overdue
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
                    sht_category: shtCategory,
                    usage_date: pickupDatetime ? new Date(pickupDatetime).toISOString() : null,
                    pickup_location: pickupLocation,
                    dropoff_location: dropoffLocation,
                    pickup_datetime: pickupDatetime,
                    car_price_code: carPriceCode,
                    passenger_count: passengerCount,
                    car_count: 1,
                    unit_price: unitPrice,
                    car_total_price: totalPrice,
                    request_note: requestNote,
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
            const errorMsg = `행 ${rowNumber} (주문ID: ${row.order_id}): ${error.message}`;
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
    console.log('🚀 CSV 파일 → 예약 시스템 이관 시작');
    console.log('='.repeat(60));

    try {
        // 1. 이메일 → 사용자ID 매핑 로드
        const emailToUserIds = await loadEmailUserMapping();

        if (emailToUserIds.size === 0) {
            console.error('❌ 이메일 매핑이 없습니다. users 테이블의 email을 확인하세요.');
            process.exit(1);
        }

        // 2. CSV 파일 데이터 로드
        const csvRows = loadCSVData();

        if (csvRows.length === 0) {
            console.log('⚠️  CSV 파일에 데이터가 없습니다.');
            process.exit(0);
        }

        // 3. 예약 데이터 생성 및 저장
        const result = await createReservations(csvRows, emailToUserIds);

        console.log('\n✅ 이관 작업 완료!');
        console.log(`\n📊 최종 결과:`);
        console.log(`  - 성공: ${result.successCount}건`);
        console.log(`  - 건너뜀: ${result.skipCount}건`);
        console.log(`  - 실패: ${result.errorCount}건`);

        process.exit(result.errorCount > 0 ? 1 : 0);

    } catch (error) {
        console.error('\n❌ 치명적 오류:', error);
        console.error(error.stack);
        process.exit(1);
    }
}

// 실행
main();
