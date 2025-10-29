#!/usr/bin/env node

/**
 * 실패한 40건 재이관
 */

const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';

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

async function findRoomCode(cruise, roomType, checkinDate, category = '성인') {
    try {
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

        if (!error && data) return data.room_code;

        const keywords = roomType.replace(/\s+/g, ' ').split(' ').filter(word => word.length > 1);
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

            if (!similarError && similarData) return similarData.room_code;
        }

        const { data: noDateData, error: noDateError } = await supabase
            .from('room_price')
            .select('room_code')
            .eq('cruise', cruise)
            .eq('room_type', roomType)
            .eq('room_category', category)
            .limit(1)
            .single();

        if (!noDateError && noDateData) return noDateData.room_code;

        return null;
    } catch (error) {
        return null;
    }
}

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

async function main() {
    console.log('🔄 실패한 40건 재이관 시작\n');

    try {
        // Phase 3 결과 로드
        const resultPath = path.join(__dirname, 'phase3-full-migration-result.json');
        const migrationResult = JSON.parse(fs.readFileSync(resultPath, 'utf8'));
        const failedCases = migrationResult.results.failed;

        const foreignKeyFailures = failedCases.filter(f =>
            f.error.includes('foreign key constraint') &&
            f.error.includes('reservation_re_user_id_fkey')
        );

        console.log(`📊 재이관 대상: ${foreignKeyFailures.length}건\n`);

        // 매핑 테이블 로드
        const cruiseMappingPath = path.join(__dirname, 'mapping-cruise-names.json');
        const roomTypeMappingPath = path.join(__dirname, 'mapping-room-types.json');
        const orderUserMappingPath = path.join(__dirname, 'mapping-order-user.json');

        const cruiseMapping = JSON.parse(fs.readFileSync(cruiseMappingPath, 'utf8')).mapping;
        const roomTypeMapping = fs.existsSync(roomTypeMappingPath)
            ? JSON.parse(fs.readFileSync(roomTypeMappingPath, 'utf8')).mapping
            : {};
        const orderUserMap = JSON.parse(fs.readFileSync(orderUserMappingPath, 'utf8')).orderUserMap;

        // Google Sheets 데이터 읽기
        const sheets = await getGoogleSheetsClient();

        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_R!A1:AC1',
        });
        const headers = headerResponse.data.values[0];

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

        const results = { success: [], failed: [], skipped: [] };
        const completedRowNumbers = [];

        console.log('🔄 재이관 진행 중...\n');

        for (const failure of foreignKeyFailures) {
            const rowNum = failure.rowNum;

            try {
                // 해당 행 데이터 읽기
                const rowResponse = await sheets.spreadsheets.values.get({
                    spreadsheetId: SPREADSHEET_ID,
                    range: `SH_R!A${rowNum}:AC${rowNum}`,
                });

                const row = rowResponse.data.values[0];

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

                let boardingAssistBool = null;
                if (boardingAssist) {
                    const assistLower = boardingAssist.toString().toLowerCase();
                    if (assistLower === '필요' || assistLower === 'true' || assistLower === 'yes' || assistLower === 'o') {
                        boardingAssistBool = true;
                    } else if (assistLower === '불필요' || assistLower === 'false' || assistLower === 'no' || assistLower === 'x') {
                        boardingAssistBool = false;
                    }
                }

                const userId = orderUserMap[orderId];
                if (!userId) {
                    results.skipped.push({ rowNum, orderId, reason: '주문ID 매핑 실패' });
                    continue;
                }

                const dbCruise = cruiseMapping[shRCruise];
                if (!dbCruise) {
                    results.skipped.push({ rowNum, orderId, reason: '크루즈 매칭 실패' });
                    continue;
                }

                const dbRoomType = roomTypeMapping[shRRoomType] || shRRoomType;

                const checkinDate = parseDate(checkinStr);
                if (!checkinDate) {
                    results.skipped.push({ rowNum, orderId, reason: '날짜 파싱 실패' });
                    continue;
                }

                const roomCode = await findRoomCode(dbCruise, dbRoomType, checkinDate, category);
                if (!roomCode) {
                    results.skipped.push({ rowNum, orderId, reason: 'room_price_code 찾기 실패' });
                    continue;
                }

                // DB 저장
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
                    results.failed.push({ rowNum, orderId, error: reservationError.message });
                    continue;
                }

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
                    await supabase.from('reservation').delete().eq('re_id', reservationData.re_id);
                    results.failed.push({ rowNum, orderId, error: cruiseError.message });
                    continue;
                }

                results.success.push({ rowNum, orderId, reservationId: reservationData.re_id });
                completedRowNumbers.push(rowNum);

                console.log(`   ✅ 행 ${rowNum} (주문ID: ${orderId}): 이관 성공`);

            } catch (error) {
                results.failed.push({ rowNum, orderId: failure.orderId, error: error.message });
                console.log(`   ❌ 행 ${rowNum}: ${error.message}`);
            }
        }

        // 완료 표시
        if (completedRowNumbers.length > 0) {
            await markAsCompleted(sheets, completedRowNumbers);
        }

        console.log(`\n${'='.repeat(60)}`);
        console.log('📊 재이관 결과');
        console.log(`${'='.repeat(60)}`);
        console.log(`   - 성공: ${results.success.length}건`);
        console.log(`   - 실패: ${results.failed.length}건`);
        console.log(`   - 스킵: ${results.skipped.length}건`);

        if (results.failed.length > 0) {
            console.log('\n   ❌ 실패 케이스:');
            results.failed.forEach((fail, idx) => {
                console.log(`      ${idx + 1}. 행 ${fail.rowNum}: ${fail.error}`);
            });
        }

        if (results.skipped.length > 0) {
            console.log('\n   ⚠️  스킵 케이스:');
            results.skipped.forEach((skip, idx) => {
                console.log(`      ${idx + 1}. 행 ${skip.rowNum}: ${skip.reason}`);
            });
        }

        // 결과 저장
        const resultOutputPath = path.join(__dirname, 'retry-failed-40-result.json');
        fs.writeFileSync(resultOutputPath, JSON.stringify({
            retriedAt: new Date().toISOString(),
            totalRetried: foreignKeyFailures.length,
            successCount: results.success.length,
            failedCount: results.failed.length,
            skippedCount: results.skipped.length,
            results
        }, null, 2));

        console.log(`\n✅ 결과 저장: ${resultOutputPath}`);
        console.log(`\n🎉 재이관 완료! ${results.success.length}건이 추가로 이관되었습니다.`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
    }
}

main();
