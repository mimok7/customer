#!/usr/bin/env node
/**
 * Google Sheets SH_CC → CSV 변환 스크립트
 * 
 * 목적:
 * - SH_CC 시트 데이터를 CSV 파일로 내보내기
 * - users 테이블에 있는 주문ID만 필터링
 * - import-sht-car-from-csv.js에서 사용할 수 있는 형식으로 변환
 * 
 * 실행 방법:
 * node scripts/export-sh-cc-to-csv-with-mapping.js
 * 
 * 출력 파일:
 * scripts/sh_cc_data.csv
 */

const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
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
if (!GOOGLE_SHEETS_ID || !GOOGLE_SERVICE_ACCOUNT || !GOOGLE_SERVICE_KEY) {
    console.error('❌ Missing Google Sheets env variables.');
    process.exit(1);
}

if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
    console.error('❌ Missing SUPABASE env variables.');
    process.exit(1);
}

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

/**
 * 이메일 유효성 확인 (users 테이블에 존재하는지)
 */
async function loadValidEmails() {
    console.log('\n📋 users 테이블에서 이메일 로드 중...');

    const { data: users, error: usersError } = await supabase
        .from('users')
        .select('id, email');

    if (usersError) {
        console.error('❌ 사용자 조회 실패:', usersError);
        return new Set();
    }

    // 이메일이 있는 사용자만 추출 (소문자로 정규화)
    const validEmails = new Set(
        users
            .filter(u => u.email)
            .map(u => u.email.trim().toLowerCase())
    );

    console.log(`👥 등록된 사용자: ${users.length}명`);
    console.log(`� 이메일이 있는 사용자: ${validEmails.size}명`);

    return validEmails;
}

/**
 * 날짜 파싱
 */
function parseDate(dateStr) {
    if (!dateStr) return '';

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

    // Excel 날짜 숫자
    if (/^\d+$/.test(dateStr)) {
        const days = parseInt(dateStr);
        const date = new Date(1900, 0, days - 1);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    return dateStr;
}

/**
 * CSV 이스케이프
 */
function escapeCSV(value) {
    if (!value) return '';
    const str = String(value);
    if (str.includes(',') || str.includes('"') || str.includes('\n')) {
        return `"${str.replace(/"/g, '""')}"`;
    }
    return str;
}

/**
 * SH_CC 시트 데이터를 CSV로 변환
 */
async function convertSHCCToCSV(validEmails) {
    console.log('\n📥 SH_CC 시트 데이터 로드 중...');

    const sheets = await getSheetsClient();

    // 먼저 헤더 확인
    const headerResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_CC!A1:Z1',
    });

    const headers = headerResponse.data.values?.[0] || [];
    console.log(`📋 헤더 확인: ${headers.length}개 컬럼`);
    console.log('컬럼:', headers.slice(0, 10).join(', '));

    // 데이터 조회
    const dataResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_CC!A2:Z', // 헤더 제외
    });

    const rows = dataResponse.data.values || [];
    console.log(`📊 SH_CC 시트: ${rows.length}행 조회`);

    // CSV 헤더 (import-sht-car-from-csv.js가 기대하는 형식)
    const csvHeaders = [
        'user_email',
        'reservation_date',
        'vehicle_number',
        'seat_number',
        'sht_category',
        'pickup_location',
        'dropoff_location',
        'pickup_datetime',
        'passenger_count',
        'request_note',
        'car_price_code',
        'unit_price',
        'total_price'
    ];

    const csvLines = [csvHeaders.join(',')];
    let convertedCount = 0;
    let skippedCount = 0;

    rows.forEach((row, index) => {
        // SH_CC 시트 구조 (실제 확인됨):
        // A: ID, B: 주문ID, C: 승차일, D: 구분, E: 분류, 
        // F: 차량번호, G: 좌석번호, H: 이름, I: 수정자, J: 수정일시, K: Email
        const userEmail = row[10]?.trim().toLowerCase(); // K열 = 인덱스 10

        if (!userEmail) {
            skippedCount++;
            return;
        }

        // users 테이블에 이메일이 있는지 확인
        if (!validEmails.has(userEmail)) {
            console.log(`⚠️  행 ${index + 2}: 이메일 '${userEmail}'이 users 테이블에 없음`);
            skippedCount++;
            return;
        }

        // SH_CC 시트 구조에 맞게 CSV 생성
        const csvRow = [
            escapeCSV(userEmail),                  // user_email (K열)
            escapeCSV(parseDate(row[2])),          // reservation_date (C열: 승차일)
            escapeCSV(row[5]),                     // vehicle_number (F열: 차량번호)
            escapeCSV(row[6]),                     // seat_number (G열: 좌석번호)
            escapeCSV(row[4]),                     // sht_category (E열: 분류)
            escapeCSV(''),                         // pickup_location (빈값)
            escapeCSV(''),                         // dropoff_location (빈값)
            escapeCSV(parseDate(row[2])),          // pickup_datetime (C열: 승차일 사용)
            escapeCSV('1'),                        // passenger_count (기본값 1)
            escapeCSV(row[7] || ''),               // request_note (H열: 이름)
            escapeCSV(''),                         // car_price_code (빈값)
            escapeCSV('0'),                        // unit_price (기본값 0)
            escapeCSV('0')                         // total_price (기본값 0)
        ];

        csvLines.push(csvRow.join(','));
        convertedCount++;
    });

    console.log(`✅ 변환 완료: ${convertedCount}건`);
    console.log(`⏭️  건너뜀: ${skippedCount}건`);

    return csvLines.join('\n');
}

/**
 * 메인 실행 함수
 */
async function main() {
    console.log('🚀 SH_CC 시트 → CSV 변환 시작');
    console.log('='.repeat(60));

    try {
        // 1. users 테이블에서 유효한 이메일 로드
        const validEmails = await loadValidEmails();

        if (validEmails.size === 0) {
            console.error('❌ users 테이블에 이메일이 없습니다.');
            process.exit(1);
        }

        // 2. SH_CC 시트 → CSV 변환
        const csvContent = await convertSHCCToCSV(validEmails);

        // 3. CSV 파일 저장
        const outputPath = path.join(process.cwd(), 'scripts', 'sh_cc_data.csv');
        fs.writeFileSync(outputPath, csvContent, 'utf-8');

        console.log('\n✅ CSV 파일 생성 완료!');
        console.log(`📄 파일 위치: ${outputPath}`);
        console.log('\n다음 단계:');
        console.log('  1. CSV 파일 확인: scripts/sh_cc_data.csv');
        console.log('  2. 필요시 데이터 수정');
        console.log('  3. 이관 실행: node scripts/import-sht-car-from-csv.js');

    } catch (error) {
        console.error('\n❌ 치명적 오류:', error);
        console.error(error.stack);
        process.exit(1);
    }
}

// 실행
main();
