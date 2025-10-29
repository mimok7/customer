#!/usr/bin/env node

/**
 * SH_R 시트의 객실코드 점검 및 room_price 매칭 분석
 * 1. SH_R 시트에서 객실 관련 데이터 읽기
 * 2. Supabase room_price 테이블 구조 확인
 * 3. 매칭 가능 여부 분석 및 매핑 전략 제시
 */

const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const dotenv = require('dotenv');

// .env.local 파일 로드
dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SH_R_RANGE = 'SH_R!A2:AC'; // 전체 데이터 범위

// Supabase 클라이언트 초기화
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

// Google Sheets API 인증 설정
async function getGoogleSheetsClient() {
    const { GoogleAuth } = require('google-auth-library');

    const auth = new GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });

    const authClient = await auth.getClient();
    return google.sheets({ version: 'v4', auth: authClient });
}

async function main() {
    console.log('🔍 SH_R 객실코드 점검 시작...\n');

    try {
        // 1. SH_R 시트 헤더 확인
        console.log('📊 Step 1: SH_R 시트 구조 확인');
        const sheets = await getGoogleSheetsClient();

        // 헤더 읽기
        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_R!A1:AC1',
        });
        const headers = headerResponse.data.values[0];
        console.log('   - SH_R 컬럼 구조:');
        headers.forEach((header, idx) => {
            const colLetter = String.fromCharCode(65 + idx);
            console.log(`     ${colLetter}${idx + 1}: ${header}`);
        });

        // 데이터 읽기
        const dataResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: SH_R_RANGE,
        });
        const rows = dataResponse.data.values || [];
        console.log(`\n   - 총 ${rows.length}개 예약 데이터 발견\n`);

        // 2. 객실 관련 컬럼 분석
        console.log('📊 Step 2: 객실 관련 데이터 분석');

        // 컬럼 인덱스 찾기
        const cruiseIdx = headers.indexOf('크루즈');
        const categoryIdx = headers.indexOf('구분');
        const roomTypeIdx = headers.indexOf('객실종류');
        const roomCountIdx = headers.indexOf('객실수');
        const roomCodeIdx = headers.indexOf('객실코드');
        const checkinIdx = headers.indexOf('체크인');
        const adultIdx = headers.indexOf('ADULT');
        const childIdx = headers.indexOf('CHILD');
        const toddlerIdx = headers.indexOf('TODDLER');
        const guestCountIdx = headers.indexOf('인원수');
        const priceIdx = headers.indexOf('금액');

        console.log('   - 관련 컬럼 위치:');
        console.log(`     크루즈: ${cruiseIdx} (${String.fromCharCode(65 + cruiseIdx)})`);
        console.log(`     구분: ${categoryIdx} (${String.fromCharCode(65 + categoryIdx)})`);
        console.log(`     객실종류: ${roomTypeIdx} (${String.fromCharCode(65 + roomTypeIdx)})`);
        console.log(`     객실수: ${roomCountIdx} (${String.fromCharCode(65 + roomCountIdx)})`);
        console.log(`     객실코드: ${roomCodeIdx} (${String.fromCharCode(65 + roomCodeIdx)})`);
        console.log(`     체크인: ${checkinIdx} (${String.fromCharCode(65 + checkinIdx)})`);
        console.log(`     인원 정보: ADULT(${adultIdx}), CHILD(${childIdx}), TODDLER(${toddlerIdx})`);

        // 샘플 데이터 추출 (처음 10개)
        console.log('\n   - 샘플 데이터 (처음 10개):');
        const samples = rows.slice(0, 10).map((row, idx) => ({
            번호: idx + 1,
            주문ID: row[1],
            크루즈: row[cruiseIdx],
            구분: row[categoryIdx],
            객실종류: row[roomTypeIdx],
            객실수: row[roomCountIdx],
            객실코드: row[roomCodeIdx],
            체크인: row[checkinIdx],
            ADULT: row[adultIdx],
            CHILD: row[childIdx],
            TODDLER: row[toddlerIdx],
            인원수: row[guestCountIdx],
            금액: row[priceIdx],
        }));

        samples.forEach(sample => {
            console.log(`\n     ${sample.번호}. 주문ID: ${sample.주문ID}`);
            console.log(`        크루즈: ${sample.크루즈} | 구분: ${sample.구분}`);
            console.log(`        객실종류: ${sample.객실종류} | 객실수: ${sample.객실수}`);
            console.log(`        객실코드: ${sample.객실코드}`);
            console.log(`        체크인: ${sample.체크인}`);
            console.log(`        인원: A=${sample.ADULT} C=${sample.CHILD} T=${sample.TODDLER} (합:${sample.인원수})`);
            console.log(`        금액: ${sample.금액}`);
        });

        // 3. 객실코드 통계
        console.log('\n📊 Step 3: 객실코드 통계');
        const roomCodes = rows.map(row => row[roomCodeIdx]).filter(Boolean);
        const uniqueRoomCodes = [...new Set(roomCodes)];
        console.log(`   - 총 객실코드 개수: ${roomCodes.length}`);
        console.log(`   - 고유 객실코드 개수: ${uniqueRoomCodes.length}`);
        console.log(`   - 고유 객실코드 목록:`);
        uniqueRoomCodes.slice(0, 20).forEach(code => {
            const count = roomCodes.filter(c => c === code).length;
            console.log(`     ${code}: ${count}건`);
        });
        if (uniqueRoomCodes.length > 20) {
            console.log(`     ... 외 ${uniqueRoomCodes.length - 20}개`);
        }

        // 크루즈별 통계
        const cruiseNames = rows.map(row => row[cruiseIdx]).filter(Boolean);
        const uniqueCruises = [...new Set(cruiseNames)];
        console.log(`\n   - 크루즈 종류 (${uniqueCruises.length}개):`);
        uniqueCruises.forEach(cruise => {
            const count = cruiseNames.filter(c => c === cruise).length;
            console.log(`     ${cruise}: ${count}건`);
        });

        // 객실종류별 통계
        const roomTypes = rows.map(row => row[roomTypeIdx]).filter(Boolean);
        const uniqueRoomTypes = [...new Set(roomTypes)];
        console.log(`\n   - 객실종류 (${uniqueRoomTypes.length}개):`);
        uniqueRoomTypes.forEach(type => {
            const count = roomTypes.filter(t => t === type).length;
            console.log(`     ${type}: ${count}건`);
        });

        // 4. Supabase room_price 테이블 구조 확인
        console.log('\n📊 Step 4: Supabase room_price 테이블 구조');
        const { data: roomPrices, error: roomPriceError } = await supabase
            .from('room_price')
            .select('*')
            .limit(5);

        if (roomPriceError) {
            console.error('   ❌ room_price 테이블 조회 실패:', roomPriceError.message);
        } else if (roomPrices && roomPrices.length > 0) {
            console.log(`   - room_price 테이블 컬럼:`);
            const columns = Object.keys(roomPrices[0]);
            columns.forEach(col => {
                console.log(`     - ${col}: ${typeof roomPrices[0][col]} (예시: ${roomPrices[0][col]})`);
            });

            console.log(`\n   - room_price 샘플 데이터 (처음 5개):`);
            roomPrices.forEach((price, idx) => {
                console.log(`\n     ${idx + 1}. room_code: ${price.room_code}`);
                console.log(`        cruise_name: ${price.cruise_name}`);
                console.log(`        room_type: ${price.room_type}`);
                console.log(`        checkin_date: ${price.checkin_date}`);
                console.log(`        base_price: ${price.base_price}`);
                console.log(`        conditions: ${price.conditions}`);
            });

            // 전체 room_price 데이터 조회
            const { data: allRoomPrices, error: allError } = await supabase
                .from('room_price')
                .select('room_code, cruise_name, room_type, checkin_date');

            if (!allError && allRoomPrices) {
                console.log(`\n   - 전체 room_price 개수: ${allRoomPrices.length}개`);

                // room_code 목록
                const dbRoomCodes = [...new Set(allRoomPrices.map(p => p.room_code))];
                console.log(`   - DB room_code 개수: ${dbRoomCodes.length}개`);
                console.log(`   - DB room_code 샘플:`);
                dbRoomCodes.slice(0, 10).forEach(code => {
                    console.log(`     ${code}`);
                });

                // cruise_name 목록
                const dbCruiseNames = [...new Set(allRoomPrices.map(p => p.cruise_name))];
                console.log(`\n   - DB cruise_name (${dbCruiseNames.length}개):`);
                dbCruiseNames.forEach(name => {
                    const count = allRoomPrices.filter(p => p.cruise_name === name).length;
                    console.log(`     ${name}: ${count}개 가격 옵션`);
                });

                // room_type 목록
                const dbRoomTypes = [...new Set(allRoomPrices.map(p => p.room_type))];
                console.log(`\n   - DB room_type (${dbRoomTypes.length}개):`);
                dbRoomTypes.forEach(type => {
                    const count = allRoomPrices.filter(p => p.room_type === type).length;
                    console.log(`     ${type}: ${count}개 가격 옵션`);
                });
            }
        }

        // 5. 매칭 분석
        console.log('\n📊 Step 5: 매칭 가능성 분석');
        console.log('   매칭 기준:');
        console.log('   1. 크루즈명 (SH_R.크루즈 ↔ room_price.cruise_name)');
        console.log('   2. 객실종류 (SH_R.객실종류 ↔ room_price.room_type)');
        console.log('   3. 체크인 날짜 (SH_R.체크인 ↔ room_price.checkin_date)');
        console.log('   4. 인원 조건 (SH_R.ADULT/CHILD/TODDLER ↔ room_price.conditions)');

        // 6. 권장 사항
        console.log('\n💡 다음 단계 권장 사항:');
        console.log('   1. 크루즈명 매핑 테이블 생성 (SH_R → room_price)');
        console.log('   2. 객실종류 매핑 테이블 생성 (SH_R → room_price)');
        console.log('   3. 날짜 형식 통일 및 변환 로직');
        console.log('   4. 인원 조건 파싱 및 매칭 로직');
        console.log('   5. room_price 조회 및 room_code 매핑 스크립트');

        console.log('\n✅ SH_R 객실코드 점검 완료');

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
