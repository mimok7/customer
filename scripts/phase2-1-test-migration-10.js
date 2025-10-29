#!/usr/bin/env node

/**
 * Phase 2-1: 소규모 테스트 이관 (10건)
 * SH_R → reservation + reservation_cruise 이관 테스트
 * 전체 프로세스 검증
 */

const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SH_R_RANGE = 'SH_R!A2:AC12'; // 처음 10개만 (헤더 제외 2-11행)

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function getGoogleSheetsClient() {
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

// 날짜 파싱 함수
function parseDate(dateStr) {
    if (!dateStr) return null;

    // "2025. 9. 22" 형식
    const dotFormat = dateStr.match(/(\d{4})\.\s*(\d{1,2})\.\s*(\d{1,2})/);
    if (dotFormat) {
        const [, year, month, day] = dotFormat;
        return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    }

    // "2025-09-22" 형식
    const dashFormat = dateStr.match(/(\d{4})-(\d{1,2})-(\d{1,2})/);
    if (dashFormat) {
        const [, year, month, day] = dashFormat;
        return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    }

    return null;
}

// room_price에서 room_code 찾기
async function findRoomCode(cruise, roomType, checkinDate, category = '성인') {
    try {
        const { data, error } = await supabase
            .from('room_price')
            .select('room_code, cruise, room_type, start_date, end_date, room_category')
            .eq('cruise', cruise)
            .eq('room_type', roomType)
            .eq('room_category', category)
            .lte('start_date', checkinDate)
            .gte('end_date', checkinDate)
            .limit(1)
            .single();

        if (error || !data) {
            return null;
        }

        return data.room_code;
    } catch (error) {
        return null;
    }
}

async function main() {
    console.log('🔍 Phase 2-1: 소규모 테스트 이관 (10건) 시작\n');

    try {
        // 1. 매핑 테이블 로드
        console.log('📋 Step 1: 매핑 테이블 로드');

        const cruiseMappingPath = path.join(__dirname, 'mapping-cruise-names.json');
        const roomTypeMappingPath = path.join(__dirname, 'mapping-room-types.json');
        const orderUserMappingPath = path.join(__dirname, 'mapping-order-user.json');

        if (!fs.existsSync(cruiseMappingPath) || !fs.existsSync(orderUserMappingPath)) {
            console.error('❌ 필수 매핑 테이블 파일이 없습니다.');
            process.exit(1);
        }

        const cruiseMapping = JSON.parse(fs.readFileSync(cruiseMappingPath, 'utf8')).mapping;
        const roomTypeMapping = fs.existsSync(roomTypeMappingPath)
            ? JSON.parse(fs.readFileSync(roomTypeMappingPath, 'utf8')).mapping
            : {};
        const orderUserMap = JSON.parse(fs.readFileSync(orderUserMappingPath, 'utf8')).orderUserMap;

        console.log(`   ✅ 크루즈 매핑: ${Object.keys(cruiseMapping).length}개`);
        console.log(`   ✅ 객실종류 매핑: ${Object.keys(roomTypeMapping).length}개`);
        console.log(`   ✅ 주문ID-사용자 매핑: ${Object.keys(orderUserMap).length}개\n`);

        // 2. SH_R 데이터 읽기
        console.log('📊 Step 2: SH_R 테스트 데이터 읽기 (10건)');
        const sheets = await getGoogleSheetsClient();

        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_R!A1:AC1',
        });
        const headers = headerResponse.data.values[0];

        const dataResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: SH_R_RANGE,
        });
        const rows = dataResponse.data.values || [];

        console.log(`   - 총 ${rows.length}개 예약 데이터 읽기 완료\n`);

        // 컬럼 인덱스
        const orderIdIdx = headers.indexOf('주문ID');
        const cruiseIdx = headers.indexOf('크루즈');
        const categoryIdx = headers.indexOf('구분');
        const roomTypeIdx = headers.indexOf('객실종류');
        const checkinIdx = headers.indexOf('체크인');
        const adultIdx = headers.indexOf('ADULT');
        const childIdx = headers.indexOf('CHILD');
        const toddlerIdx = headers.indexOf('TODDLER');
        const guestCountIdx = headers.indexOf('인원수');
        const priceIdx = headers.indexOf('금액');
        const requestIdx = headers.indexOf('객실비고');
        const assistIdx = headers.indexOf('승선도움');

        // 3. 이관 프로세스
        console.log('📊 Step 3: 예약 데이터 이관 시작\n');

        const results = {
            success: [],
            failed: []
        };

        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            const rowNum = i + 2; // Excel 행 번호 (헤더 제외)

            console.log(`   [${i + 1}/10] 처리 중... (SH_R 행 ${rowNum})`);

            try {
                const orderId = row[orderIdIdx];
                const shRCruise = row[cruiseIdx];
                const shRRoomType = row[roomTypeIdx];
                const checkinStr = row[checkinIdx];
                const adult = parseInt(row[adultIdx]) || 0;
                const child = parseInt(row[childIdx]) || 0;
                const toddler = parseInt(row[toddlerIdx]) || 0;
                const guestCount = parseInt(row[guestCountIdx]) || (adult + child + toddler);
                const price = parseInt(row[priceIdx]?.replace(/[^0-9]/g, '')) || 0;
                const category = row[categoryIdx];
                const requestNote = row[requestIdx];
                const boardingAssist = row[assistIdx];

                // 검증 1: 주문ID → userId 매칭
                const userId = orderUserMap[orderId];
                if (!userId) {
                    throw new Error(`주문ID 매칭 실패: ${orderId}`);
                }

                // 검증 2: 크루즈명 매칭
                const dbCruise = cruiseMapping[shRCruise];
                if (!dbCruise) {
                    throw new Error(`크루즈 매칭 실패: ${shRCruise}`);
                }

                // 검증 3: 객실종류 매칭
                const dbRoomType = roomTypeMapping[shRRoomType] || shRRoomType;

                // 검증 4: 체크인 날짜 파싱
                const checkinDate = parseDate(checkinStr);
                if (!checkinDate) {
                    throw new Error(`날짜 파싱 실패: ${checkinStr}`);
                }

                // 검증 5: room_code 찾기
                const roomCode = await findRoomCode(dbCruise, dbRoomType, checkinDate, category);
                if (!roomCode) {
                    console.log(`      ⚠️  room_code 찾기 실패 (크루즈: ${dbCruise}, 객실: ${dbRoomType})`);
                    // room_code 없이도 진행 (NULL 허용)
                }

                // 이관 데이터 생성 (실제 저장은 하지 않음 - 테스트)
                const reservationData = {
                    re_user_id: userId,
                    re_quote_id: null, // quote 테이블과 연결 필요시
                    re_type: 'cruise',
                    re_status: 'pending'
                };

                const cruiseReservationData = {
                    // reservation_id는 reservation 생성 후 받음
                    room_price_code: roomCode,
                    checkin: checkinDate,
                    guest_count: guestCount,
                    unit_price: price,
                    room_total_price: price,
                    boarding_assist: boardingAssist || null,
                    request_note: requestNote || null
                };

                console.log(`      ✅ 검증 완료`);
                console.log(`         - 사용자: ${userId.substring(0, 8)}...`);
                console.log(`         - 크루즈: ${dbCruise}`);
                console.log(`         - 객실: ${dbRoomType}`);
                console.log(`         - room_code: ${roomCode || 'NULL'}`);
                console.log(`         - 체크인: ${checkinDate}`);
                console.log(`         - 인원: ${guestCount}명 (성인:${adult}, 아동:${child}, 유아:${toddler})`);
                console.log(`         - 금액: ${price.toLocaleString()}동`);

                results.success.push({
                    rowNum,
                    orderId,
                    userId,
                    cruise: dbCruise,
                    roomType: dbRoomType,
                    roomCode,
                    reservationData,
                    cruiseReservationData
                });

            } catch (error) {
                console.log(`      ❌ 실패: ${error.message}`);
                results.failed.push({
                    rowNum,
                    orderId: row[orderIdIdx],
                    error: error.message,
                    data: {
                        cruise: row[cruiseIdx],
                        roomType: row[roomTypeIdx],
                        checkin: row[checkinIdx]
                    }
                });
            }
        }

        // 4. 결과 요약
        console.log(`\n📊 테스트 이관 결과:`);
        console.log(`   - 총 처리: ${rows.length}건`);
        console.log(`   - 성공: ${results.success.length}건 (${(results.success.length / rows.length * 100).toFixed(1)}%)`);
        console.log(`   - 실패: ${results.failed.length}건 (${(results.failed.length / rows.length * 100).toFixed(1)}%)`);

        if (results.failed.length > 0) {
            console.log(`\n   ❌ 실패 케이스:`);
            results.failed.forEach((fail, idx) => {
                console.log(`      ${idx + 1}. 행 ${fail.rowNum}: ${fail.error}`);
                console.log(`         주문ID: ${fail.orderId}`);
                console.log(`         크루즈: ${fail.data.cruise}`);
                console.log(`         객실: ${fail.data.roomType}`);
            });
        }

        // 5. 결과 저장
        const resultPath = path.join(__dirname, 'phase2-1-test-result.json');
        fs.writeFileSync(resultPath, JSON.stringify({
            testedAt: new Date().toISOString(),
            totalRecords: rows.length,
            successCount: results.success.length,
            failedCount: results.failed.length,
            successRate: `${(results.success.length / rows.length * 100).toFixed(1)}%`,
            results
        }, null, 2));

        console.log(`\n✅ 결과 저장: ${resultPath}`);

        // 6. 다음 단계 안내
        console.log(`\n💡 다음 단계:`);
        if (results.success.length >= 9) { // 90% 이상 성공
            console.log(`   ✅ 테스트 성공률 높음 (${results.success.length}/10)`);
            console.log(`   → Phase 2-2 (중규모 테스트 100건) 진행 가능`);
        } else {
            console.log(`   ⚠️  성공률이 낮습니다 (${results.success.length}/10)`);
            console.log(`   → 매핑 테이블 보완 후 재시도 권장`);
        }

        console.log(`\n✅ Phase 2-1 완료`);
        console.log(`\n⚠️  주의: 이 테스트는 실제 DB에 저장하지 않았습니다.`);
        console.log(`   실제 이관을 원하시면 별도로 알려주세요.`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
