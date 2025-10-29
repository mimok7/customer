#!/usr/bin/env node

/**
 * Phase 2-2: 중규모 테스트 이관 (100건)
 * SH_R → reservation + reservation_cruise 이관 + 완료 표시
 * 성공한 데이터는 SH_R 시트 "단위" 컬럼에 "완료" 표시
 */

const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SH_R_RANGE = 'SH_R!A2:AC101'; // 100개 (헤더 제외 2-101행)

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function getGoogleSheetsClient() {
    const auth = new GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets'],
    });

    const authClient = await auth.getClient();
    return google.sheets({ version: 'v4', auth: authClient });
}

// 날짜 파싱 함수
function parseDate(dateStr) {
    if (!dateStr) return null;

    const dotFormat = dateStr.match(/(\d{4})\.\s*(\d{1,2})\.\s*(\d{1,2})/);
    if (dotFormat) {
        const [, year, month, day] = dotFormat;
        return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    }

    const dashFormat = dateStr.match(/(\d{4})-(\d{1,2})-(\d{1,2})/);
    if (dashFormat) {
        const [, year, month, day] = dashFormat;
        return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    }

    return null;
}

// room_price에서 room_code 찾기 (유사한 객실명 다수 적용)
async function findRoomCode(cruise, roomType, checkinDate, category = '성인') {
    try {
        // 1차 시도: 정확한 매칭
        const { data, error } = await supabase
            .from('room_price')
            .select('room_code')
            .eq('cruise', cruise)
            .eq('room_type', roomType)
            .eq('room_category', category)
            .lte('start_date', checkinDate)
            .gte('end_date', checkinDate)
            .limit(1)
            .single();

        if (!error && data) {
            return data.room_code;
        }

        // 2차 시도: 유사한 객실명으로 검색 (LIKE 패턴)
        // roomType에서 핵심 키워드 추출
        const keywords = roomType
            .replace(/\s+/g, ' ')
            .split(' ')
            .filter(word => word.length > 1); // 1글자 제외

        // 각 키워드로 검색 시도
        for (const keyword of keywords) {
            const { data: similarData, error: similarError } = await supabase
                .from('room_price')
                .select('room_code, room_type')
                .eq('cruise', cruise)
                .ilike('room_type', `%${keyword}%`)
                .eq('room_category', category)
                .lte('start_date', checkinDate)
                .gte('end_date', checkinDate)
                .limit(1)
                .single();

            if (!similarError && similarData) {
                console.log(`      ✅ 유사 객실 매칭: "${roomType}" → "${similarData.room_type}"`);
                return similarData.room_code;
            }
        }

        // 3차 시도: 날짜 범위 무시하고 검색
        const { data: noDateData, error: noDateError } = await supabase
            .from('room_price')
            .select('room_code')
            .eq('cruise', cruise)
            .eq('room_type', roomType)
            .eq('room_category', category)
            .limit(1)
            .single();

        if (!noDateError && noDateData) {
            console.log(`      ⚠️  날짜 범위 외 매칭: "${roomType}"`);
            return noDateData.room_code;
        }

        return null;
    } catch (error) {
        return null;
    }
}

// SH_R 시트 "단위" 컬럼에 "완료" 표시
async function markAsCompleted(sheets, rowNumbers) {
    if (rowNumbers.length === 0) return;

    try {
        // 단위 컬럼은 27번째 (AA 컬럼)
        const updates = rowNumbers.map(rowNum => ({
            range: `SH_R!AA${rowNum}`,
            values: [['완료']]
        }));

        await sheets.spreadsheets.values.batchUpdate({
            spreadsheetId: SPREADSHEET_ID,
            requestBody: {
                valueInputOption: 'RAW',
                data: updates
            }
        });

        console.log(`   ✅ ${rowNumbers.length}건 "완료" 표시 완료`);
    } catch (error) {
        console.error(`   ⚠️  완료 표시 실패: ${error.message}`);
    }
}

async function main() {
    console.log('🔍 Phase 2-2: 중규모 테스트 이관 (100건) 시작\n');

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
        console.log('📊 Step 2: SH_R 테스트 데이터 읽기 (100건)');
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
        console.log('📊 Step 3: 예약 데이터 이관 시작 (실제 DB 저장)\n');

        const results = {
            success: [],
            failed: [],
            skipped: []
        };

        const completedRowNumbers = []; // 완료 표시할 행 번호들

        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            const rowNum = i + 2; // Excel 행 번호 (헤더 제외)

            if ((i + 1) % 10 === 0 || i === 0) {
                console.log(`   [${i + 1}/${rows.length}] 처리 중...`);
            }

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

                // boarding_assist를 boolean으로 변환
                let boardingAssistBool = null;
                if (boardingAssist) {
                    const assistLower = boardingAssist.toString().toLowerCase();
                    if (assistLower === '필요' || assistLower === 'true' || assistLower === 'yes' || assistLower === 'o') {
                        boardingAssistBool = true;
                    } else if (assistLower === '불필요' || assistLower === 'false' || assistLower === 'no' || assistLower === 'x') {
                        boardingAssistBool = false;
                    }
                    // "미정" 등은 null로 유지
                }

                // 검증 1: 주문ID → userId 매칭
                const userId = orderUserMap[orderId];
                if (!userId) {
                    results.skipped.push({ rowNum, orderId, reason: '주문ID 매칭 실패' });
                    continue;
                }

                // 검증 2: 크루즈명 매칭
                const dbCruise = cruiseMapping[shRCruise];
                if (!dbCruise) {
                    results.skipped.push({ rowNum, orderId, reason: '크루즈 매칭 실패' });
                    continue;
                }

                // 검증 3: 객실종류 매칭
                const dbRoomType = roomTypeMapping[shRRoomType] || shRRoomType;

                // 검증 4: 체크인 날짜 파싱
                const checkinDate = parseDate(checkinStr);
                if (!checkinDate) {
                    results.skipped.push({ rowNum, orderId, reason: '날짜 파싱 실패' });
                    continue;
                }

                // 검증 5: room_code 찾기 (없으면 스킵)
                const roomCode = await findRoomCode(dbCruise, dbRoomType, checkinDate, category);
                if (!roomCode) {
                    results.skipped.push({ rowNum, orderId, reason: 'room_price_code 찾기 실패' });
                    continue;
                }

                // 실제 DB 저장
                // 1. reservation 테이블에 메인 예약 생성
                const { data: reservationData, error: reservationError } = await supabase
                    .from('reservation')
                    .insert({
                        re_user_id: userId,
                        re_quote_id: null,
                        re_type: 'cruise',
                        re_status: 'pending',
                        total_amount: price,
                        paid_amount: 0,
                        payment_status: 'pending'
                    })
                    .select()
                    .single();

                if (reservationError) {
                    throw new Error(`reservation 저장 실패: ${reservationError.message}`);
                }

                // 2. reservation_cruise 테이블에 크루즈 상세 저장
                const { error: cruiseError } = await supabase
                    .from('reservation_cruise')
                    .insert({
                        reservation_id: reservationData.re_id,
                        room_price_code: roomCode,
                        checkin: checkinDate,
                        guest_count: guestCount,
                        unit_price: price,
                        room_total_price: price,
                        boarding_assist: boardingAssistBool,
                        request_note: requestNote || null
                    });

                if (cruiseError) {
                    // reservation도 롤백 필요
                    await supabase.from('reservation').delete().eq('re_id', reservationData.re_id);
                    throw new Error(`reservation_cruise 저장 실패: ${cruiseError.message}`);
                }

                results.success.push({
                    rowNum,
                    orderId,
                    reservationId: reservationData.re_id,
                    userId,
                    cruise: dbCruise,
                    roomType: dbRoomType,
                    roomCode,
                    checkinDate,
                    guestCount,
                    price
                });

                completedRowNumbers.push(rowNum);

            } catch (error) {
                results.failed.push({
                    rowNum,
                    orderId: row[orderIdIdx],
                    error: error.message
                });
            }
        }

        // 4. 완료 표시
        console.log(`\n📊 Step 4: SH_R 시트에 완료 표시`);
        await markAsCompleted(sheets, completedRowNumbers);

        // 5. 결과 요약
        console.log(`\n📊 테스트 이관 결과:`);
        console.log(`   - 총 처리: ${rows.length}건`);
        console.log(`   - 성공: ${results.success.length}건 (${(results.success.length / rows.length * 100).toFixed(1)}%)`);
        console.log(`   - 실패: ${results.failed.length}건`);
        console.log(`   - 스킵: ${results.skipped.length}건`);

        if (results.failed.length > 0) {
            console.log(`\n   ❌ 실패 케이스 (상위 10개):`);
            results.failed.slice(0, 10).forEach((fail, idx) => {
                console.log(`      ${idx + 1}. 행 ${fail.rowNum}: ${fail.error}`);
            });
        }

        if (results.skipped.length > 0) {
            console.log(`\n   ⚠️  스킵 케이스 (상위 10개):`);
            results.skipped.slice(0, 10).forEach((skip, idx) => {
                console.log(`      ${idx + 1}. 행 ${skip.rowNum}: ${skip.reason} (주문ID: ${skip.orderId})`);
            });
        }

        // 6. 결과 저장
        const resultPath = path.join(__dirname, 'phase2-2-test-result.json');
        fs.writeFileSync(resultPath, JSON.stringify({
            migratedAt: new Date().toISOString(),
            totalRecords: rows.length,
            successCount: results.success.length,
            failedCount: results.failed.length,
            skippedCount: results.skipped.length,
            successRate: `${(results.success.length / rows.length * 100).toFixed(1)}%`,
            results
        }, null, 2));

        console.log(`\n✅ 결과 저장: ${resultPath}`);

        // 7. 다음 단계 안내
        console.log(`\n💡 다음 단계:`);
        const successRate = results.success.length / rows.length * 100;
        if (successRate >= 90) {
            console.log(`   ✅ 테스트 성공률 높음 (${results.success.length}/${rows.length})`);
            console.log(`   → Phase 3 (전체 데이터 이관) 진행 가능`);
        } else if (successRate >= 80) {
            console.log(`   ⚠️  성공률 양호 (${results.success.length}/${rows.length})`);
            console.log(`   → 실패/스킵 케이스 검토 후 전체 이관 진행`);
        } else {
            console.log(`   ❌ 성공률이 낮습니다 (${results.success.length}/${rows.length})`);
            console.log(`   → 매핑 테이블 보완 필요`);
        }

        console.log(`\n✅ Phase 2-2 완료`);
        console.log(`✅ ${results.success.length}건이 실제 DB에 저장되었습니다.`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
