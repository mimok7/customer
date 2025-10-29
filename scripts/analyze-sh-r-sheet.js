#!/usr/bin/env node
/**
 * SH_R 시트 분석 스크립트
 * - SH_R 시트의 구조와 데이터 확인
 * - 어떤 테이블로 이관해야 하는지 분석
 */

require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');

// Google Sheets API 설정
const SPREADSHEET_ID = process.env.GOOGLE_SHEETS_ID;
const SHEET_NAME = 'SH_R';
const GOOGLE_SERVICE_ACCOUNT = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const GOOGLE_SERVICE_KEY = process.env.GOOGLE_SERVICE_ACCOUNT_KEY;

/**
 * Google Sheets 클라이언트 생성
 */
async function getSheetsClient() {
    const auth = new google.auth.GoogleAuth({
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
 * SH_R 시트 데이터 분석
 */
async function analyzeSHRSheet() {
    console.log('╔════════════════════════════════════════════════════════════╗');
    console.log('║  SH_R 시트 구조 및 데이터 분석                            ║');
    console.log('╚════════════════════════════════════════════════════════════╝\n');

    try {
        // Google Sheets 연결
        console.log('🔌 Google Sheets 연결 중...');
        const sheets = await getSheetsClient();
        console.log('✅ 연결 성공\n');

        // 시트 데이터 읽기
        console.log('📋 SH_R 시트 데이터 읽는 중...');
        const response = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: `${SHEET_NAME}!A:AC`,
        });

        const rows = response.data.values;
        if (!rows || rows.length === 0) {
            console.log('❌ 시트에 데이터가 없습니다.');
            return;
        }

        // 헤더 분석
        const headers = rows[0];
        console.log(`✅ 데이터 읽기 완료: ${rows.length - 1}개 행\n`);

        console.log('📊 컬럼 구조 (총 %d개):', headers.length);
        console.log('═'.repeat(80));
        headers.forEach((header, idx) => {
            const col = String.fromCharCode(65 + (idx >= 26 ? Math.floor(idx / 26) - 1 + 65 : 0)) +
                String.fromCharCode(65 + (idx % 26));
            console.log(`  ${(idx + 1).toString().padStart(2, '0')}. ${col.padEnd(4)} ${header}`);
        });
        console.log('═'.repeat(80));

        // 샘플 데이터 분석 (처음 5개)
        console.log('\n📝 샘플 데이터 (처음 5개):');
        console.log('═'.repeat(80));
        for (let i = 1; i <= Math.min(5, rows.length - 1); i++) {
            const row = rows[i];
            console.log(`\n[${i}번째 예약]`);
            headers.forEach((header, idx) => {
                if (row[idx]) {
                    console.log(`  - ${header}: ${row[idx]}`);
                }
            });
        }
        console.log('═'.repeat(80));

        // 데이터 통계
        console.log('\n📈 데이터 통계:');
        console.log('═'.repeat(80));

        // 이메일별 카운트
        const emailIdx = headers.findIndex(h => h === 'Email' || h === 'email');
        const emails = new Set();
        const orderIds = new Set();

        for (let i = 1; i < rows.length; i++) {
            const row = rows[i];
            if (row[emailIdx]) emails.add(row[emailIdx]);
            if (row[1]) orderIds.add(row[1]); // 주문ID
        }

        console.log(`  총 예약 수: ${rows.length - 1}개`);
        console.log(`  고유 이메일 수: ${emails.size}명`);
        console.log(`  고유 주문ID 수: ${orderIds.size}개`);
        console.log('═'.repeat(80));

        // 이관 계획 안내
        console.log('\n🎯 데이터 이관 계획:');
        console.log('═'.repeat(80));
        console.log('\n1️⃣  SH_R → reservation_cruise 테이블');
        console.log('   [크루즈 객실 예약 정보]');
        console.log('   ┌────────────────────────────────────────┐');
        console.log('   │ SH_R 컬럼         → DB 컬럼            │');
        console.log('   ├────────────────────────────────────────┤');
        console.log('   │ 주문ID            → 연결용             │');
        console.log('   │ Email             → 사용자 매칭        │');
        console.log('   │ 객실코드          → room_price_code    │');
        console.log('   │ 체크인            → checkin            │');
        console.log('   │ 인원수            → guest_count        │');
        console.log('   │ 금액              → unit_price         │');
        console.log('   │ 합계              → room_total_price   │');
        console.log('   │ 승선도움          → boarding_assist    │');
        console.log('   │ 객실비고          → request_note       │');
        console.log('   └────────────────────────────────────────┘');

        console.log('\n2️⃣  연결 방식:');
        console.log('   • Email로 users 테이블에서 user_id 조회');
        console.log('   • 주문ID로 quote 테이블 생성 또는 조회');
        console.log('   • reservation 메인 테이블 생성');
        console.log('   • reservation_cruise 상세 정보 저장');

        console.log('\n3️⃣  필요한 전처리:');
        console.log('   ✓ 날짜 형식 변환 (체크인)');
        console.log('   ✓ 숫자 형식 변환 (금액, 인원수)');
        console.log('   ✓ 사용자 매칭 (Email → user_id)');
        console.log('   ✓ 객실 코드 검증 (room_price 테이블 참조)');

        console.log('\n4️⃣  실행 순서:');
        console.log('   1. users 테이블에 사용자 확인/등록');
        console.log('   2. quote 테이블에 주문 생성');
        console.log('   3. reservation 메인 예약 생성');
        console.log('   4. reservation_cruise 상세 예약 생성');
        console.log('═'.repeat(80));

        console.log('\n💡 다음 단계:');
        console.log('   node scripts/import-sh-r-to-reservations.js');
        console.log('   (아직 생성되지 않음 - 생성 필요)\n');

    } catch (error) {
        console.error('\n❌ 오류 발생:', error.message);
        console.error(error.stack);
        throw error;
    }
}

// 실행
analyzeSHRSheet().catch(error => {
    console.error('스크립트 실행 실패:', error);
    process.exit(1);
});
