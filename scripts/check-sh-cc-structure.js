#!/usr/bin/env node
/**
 * SH_CC 시트 구조 확인 스크립트
 * - 헤더 확인
 * - 샘플 데이터 확인 (첫 5개 행)
 * - 컬럼 매핑 가이드 생성
 */

const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const dotenv = require('dotenv');

// Load environment variables
try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

const GOOGLE_SHEETS_ID = process.env.GOOGLE_SHEETS_ID;
const GOOGLE_SERVICE_ACCOUNT = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const GOOGLE_SERVICE_KEY = process.env.GOOGLE_SERVICE_ACCOUNT_KEY;

if (!GOOGLE_SHEETS_ID || !GOOGLE_SERVICE_ACCOUNT || !GOOGLE_SERVICE_KEY) {
    console.error('❌ Missing Google Sheets env variables.');
    process.exit(1);
}

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

async function main() {
    console.log('🔍 SH_CC 시트 구조 확인\n');

    try {
        const sheets = await getSheetsClient();

        // 헤더 조회
        console.log('📋 헤더 조회 중...');
        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range: 'SH_CC!A1:Z1',
        });

        const headers = headerResponse.data.values?.[0] || [];
        console.log(`\n✅ 총 ${headers.length}개 컬럼 발견:\n`);

        headers.forEach((header, index) => {
            const columnLetter = String.fromCharCode(65 + index); // A, B, C, ...
            console.log(`  ${columnLetter}열: ${header}`);
        });

        // 샘플 데이터 조회 (처음 5개 행)
        console.log('\n📊 샘플 데이터 조회 중 (첫 5개 행)...\n');
        const dataResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range: 'SH_CC!A2:Z6', // 헤더 제외 5개 행
        });

        const rows = dataResponse.data.values || [];

        rows.forEach((row, rowIndex) => {
            console.log(`\n📌 행 ${rowIndex + 2}:`);
            headers.forEach((header, colIndex) => {
                const value = row[colIndex] || '(비어있음)';
                const columnLetter = String.fromCharCode(65 + colIndex);
                console.log(`  ${columnLetter}. ${header}: ${value}`);
            });
        });

        // 컬럼 매핑 가이드
        console.log('\n' + '='.repeat(60));
        console.log('📝 컬럼 매핑 가이드 (reservation_car_sht 테이블용)');
        console.log('='.repeat(60));
        console.log('\n아래 매핑을 import-sht-car-from-sh-cc.js에 적용하세요:\n');

        console.log('주요 필드 매핑:');
        console.log('  - reservation_id: UUID (자동 생성)');
        console.log('  - vehicle_number: 차량번호');
        console.log('  - seat_number: 좌석번호');
        console.log('  - sht_category: 카테고리');
        console.log('  - usage_date: 사용 일시');
        console.log('  - pickup_location: 픽업 위치');
        console.log('  - dropoff_location: 드롭오프 위치');
        console.log('  - pickup_datetime: 픽업 날짜');
        console.log('  - car_price_code: 가격 코드');
        console.log('  - passenger_count: 승객 수');
        console.log('  - car_count: 차량 수 (기본값: 1)');
        console.log('  - unit_price: 단가');
        console.log('  - car_total_price: 총 금액');
        console.log('  - request_note: 요청사항');

        console.log('\n✅ 구조 확인 완료!');

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        process.exit(1);
    }
}

main();
