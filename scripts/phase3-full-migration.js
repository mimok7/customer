#!/usr/bin/env node

/**
 * Phase 3: 전체 데이터 이관 (2,932건)
 * SH_R → reservation + reservation_cruise 이관 + 완료 표시
 * 100건씩 배치 처리
 */

const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const BATCH_SIZE = 100; // 100건씩 배치 처리

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
        const keywords = roomType
            .replace(/\s+/g, ' ')
            .split(' ')
            .filter(word => word.length > 1);

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

async function processBatch(sheets, headers, rows, startRow, orderUserMap, cruiseMapping, roomTypeMapping) {
    const results = {
        success: [],
        failed: [],
        skipped: []
    };

    const completedRowNumbers = [];

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

    for (let i = 0; i < rows.length; i++) {
        const row = rows[i];
        const rowNum = startRow + i;

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
                results.failed.push({
                    rowNum,
                    orderId,
                    error: `reservation 저장 실패: ${reservationError.message}`
                });
                continue;
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
                results.failed.push({
                    rowNum,
                    orderId,
                    error: `reservation_cruise 저장 실패: ${cruiseError.message}`
                });
                continue;
            }

            results.success.push({
                rowNum,
                orderId,
                reservationId: reservationData.re_id
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

    // 완료 표시
    if (completedRowNumbers.length > 0) {
        await markAsCompleted(sheets, completedRowNumbers);
    }

    return results;
}

async function main() {
    console.log('🚀 Phase 3: 전체 데이터 이관 시작 (배치 처리)\n');
    console.log(`⏰ 시작 시간: ${new Date().toLocaleString('ko-KR')}\n`);

    const startTime = Date.now();

    try {
        // 1. 매핑 테이블 로드
        console.log('📋 Step 1: 매핑 테이블 로드');

        const cruiseMappingPath = path.join(__dirname, 'mapping-cruise-names.json');
        const roomTypeMappingPath = path.join(__dirname, 'mapping-room-types.json');
        const orderUserMappingPath = path.join(__dirname, 'mapping-order-user.json');

        const cruiseMapping = JSON.parse(fs.readFileSync(cruiseMappingPath, 'utf8')).mapping;
        const roomTypeMapping = fs.existsSync(roomTypeMappingPath)
            ? JSON.parse(fs.readFileSync(roomTypeMappingPath, 'utf8')).mapping
            : {};
        const orderUserMap = JSON.parse(fs.readFileSync(orderUserMappingPath, 'utf8')).orderUserMap;

        console.log(`   ✅ 크루즈 매핑: ${Object.keys(cruiseMapping).length}개`);
        console.log(`   ✅ 객실종류 매핑: ${Object.keys(roomTypeMapping).length}개`);
        console.log(`   ✅ 주문ID-사용자 매핑: ${Object.keys(orderUserMap).length}개\n`);

        // 2. Google Sheets 클라이언트 초기화
        console.log('📊 Step 2: Google Sheets 연결');
        const sheets = await getGoogleSheetsClient();

        // 헤더 읽기
        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_R!A1:AC1',
        });
        const headers = headerResponse.data.values[0];

        // 전체 데이터 건수 확인
        const countResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_R!A:A',
        });
        const totalRows = countResponse.data.values.length - 1; // 헤더 제외

        console.log(`   ✅ 총 ${totalRows}건의 데이터 발견\n`);

        // 3. 배치 처리
        console.log(`📊 Step 3: 배치 처리 시작 (${BATCH_SIZE}건씩)\n`);

        const allResults = {
            success: [],
            failed: [],
            skipped: []
        };

        let processedCount = 0;
        let batchNumber = 1;

        while (processedCount < totalRows) {
            const startRow = processedCount + 2; // +2 = 헤더 제외 + 1-based index
            const endRow = Math.min(startRow + BATCH_SIZE - 1, totalRows + 1);
            const batchRange = `SH_R!A${startRow}:AC${endRow}`;

            console.log(`\n🔄 Batch ${batchNumber}: 행 ${startRow}-${endRow} (${endRow - startRow + 1}건)`);

            const batchResponse = await sheets.spreadsheets.values.get({
                spreadsheetId: SPREADSHEET_ID,
                range: batchRange,
            });

            const batchRows = batchResponse.data.values || [];

            if (batchRows.length === 0) {
                console.log('   ⚠️  빈 배치, 건너뜀');
                processedCount += BATCH_SIZE;
                batchNumber++;
                continue;
            }

            const batchResults = await processBatch(
                sheets,
                headers,
                batchRows,
                startRow,
                orderUserMap,
                cruiseMapping,
                roomTypeMapping
            );

            // 결과 집계
            allResults.success.push(...batchResults.success);
            allResults.failed.push(...batchResults.failed);
            allResults.skipped.push(...batchResults.skipped);

            console.log(`   ✅ 성공: ${batchResults.success.length}건`);
            console.log(`   ❌ 실패: ${batchResults.failed.length}건`);
            console.log(`   ⚠️  스킵: ${batchResults.skipped.length}건`);

            processedCount += batchRows.length;
            batchNumber++;

            // 진행률 표시
            const progress = ((processedCount / totalRows) * 100).toFixed(1);
            console.log(`   📊 진행률: ${processedCount}/${totalRows} (${progress}%)`);
        }

        // 4. 최종 결과 요약
        const endTime = Date.now();
        const duration = ((endTime - startTime) / 1000).toFixed(1);

        console.log(`\n${'='.repeat(60)}`);
        console.log(`📊 최종 이관 결과`);
        console.log(`${'='.repeat(60)}`);
        console.log(`⏰ 종료 시간: ${new Date().toLocaleString('ko-KR')}`);
        console.log(`⏱️  소요 시간: ${duration}초`);
        console.log(`\n📈 통계:`);
        console.log(`   - 총 처리: ${totalRows}건`);
        console.log(`   - 성공: ${allResults.success.length}건 (${(allResults.success.length / totalRows * 100).toFixed(1)}%)`);
        console.log(`   - 실패: ${allResults.failed.length}건 (${(allResults.failed.length / totalRows * 100).toFixed(1)}%)`);
        console.log(`   - 스킵: ${allResults.skipped.length}건 (${(allResults.skipped.length / totalRows * 100).toFixed(1)}%)`);

        if (allResults.failed.length > 0) {
            console.log(`\n   ❌ 실패 케이스 (상위 20개):`);
            allResults.failed.slice(0, 20).forEach((fail, idx) => {
                console.log(`      ${idx + 1}. 행 ${fail.rowNum}: ${fail.error}`);
            });
        }

        if (allResults.skipped.length > 0) {
            console.log(`\n   ⚠️  스킵 케이스 (상위 20개):`);
            allResults.skipped.slice(0, 20).forEach((skip, idx) => {
                console.log(`      ${idx + 1}. 행 ${skip.rowNum}: ${skip.reason} (주문ID: ${skip.orderId})`);
            });
        }

        // 5. 결과 저장
        const resultPath = path.join(__dirname, 'phase3-full-migration-result.json');
        fs.writeFileSync(resultPath, JSON.stringify({
            migratedAt: new Date().toISOString(),
            duration: `${duration}초`,
            totalRecords: totalRows,
            successCount: allResults.success.length,
            failedCount: allResults.failed.length,
            skippedCount: allResults.skipped.length,
            successRate: `${(allResults.success.length / totalRows * 100).toFixed(1)}%`,
            results: allResults
        }, null, 2));

        console.log(`\n✅ 결과 저장: ${resultPath}`);
        console.log(`\n✅ Phase 3 완료!`);
        console.log(`✅ ${allResults.success.length}건이 성공적으로 이관되었습니다.`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
