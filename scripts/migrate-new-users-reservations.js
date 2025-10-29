require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const { google } = require('googleapis');
const fs = require('fs');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SHEET_NAME_R = 'SH_R';
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function getGoogleSheetsClient() {
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: SCOPES,
    });
    return google.sheets({ version: 'v4', auth });
}

async function migrateNewUsersReservations() {
    console.log('🚀 신규 사용자 예약 이관 시작\n');

    // 1. 신규 사용자 목록 로드
    const resultPath = 'scripts/migrate-new-shm-users-result.json';
    if (!fs.existsSync(resultPath)) {
        console.error('❌ 신규 사용자 결과 파일이 없습니다.');
        return;
    }

    const migrationResult = JSON.parse(fs.readFileSync(resultPath, 'utf-8'));
    const newUsers = migrationResult.results.success;

    console.log('============================================================');
    console.log('📊 신규 사용자 정보');
    console.log('============================================================');
    console.log(`   총 신규 사용자: ${newUsers.length}명`);
    console.log('');

    // 2. Order ID 목록 생성
    const newOrderIds = new Set(newUsers.map(u => u.orderId).filter(Boolean));
    console.log(`   Order ID: ${newOrderIds.size}개`);
    console.log('');

    // 3. SH_R 시트에서 예약 데이터 로드
    console.log('============================================================');
    console.log('📥 SH_R 시트 데이터 로드');
    console.log('============================================================\n');

    const sheets = await getGoogleSheetsClient();
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: `${SHEET_NAME_R}!A:AZ`,
    });

    const rows = response.data.values;
    console.log(`✅ 총 ${rows.length}개 행 로드\n`);

    // 4. 헤더 파싱
    const headers = rows[0];
    const orderIdIndex = headers.findIndex(h => h === '주문ID');

    if (orderIdIndex === -1) {
        console.error('❌ 주문ID 컬럼을 찾을 수 없습니다.');
        return;
    }

    // 5. 신규 사용자의 예약만 필터링
    console.log('============================================================');
    console.log('🔍 신규 사용자 예약 필터링');
    console.log('============================================================\n');

    const newUserReservations = [];
    for (let i = 1; i < rows.length; i++) {
        const row = rows[i];
        const orderId = row[orderIdIndex];

        if (orderId && newOrderIds.has(orderId)) {
            const reservation = {};
            headers.forEach((header, index) => {
                reservation[header] = row[index] || '';
            });
            reservation._rowNum = i + 1;
            newUserReservations.push(reservation);
        }
    }

    console.log(`✅ 신규 사용자 예약: ${newUserReservations.length}개`);
    console.log('');

    // 6. 예약 데이터 검증
    console.log('============================================================');
    console.log('🔍 예약 데이터 검증');
    console.log('============================================================\n');

    const validation = {
        valid: [],
        incomplete: [],
        roomCodeMissing: [],
        carCodeMissing: [],
    };

    for (const res of newUserReservations) {
        // 필수 필드 체크 (실제 SH_R 컬럼명 사용)
        const hasRequiredFields = res['주문ID'] &&
            res['크루즈'] &&
            res['체크인'];

        if (!hasRequiredFields) {
            validation.incomplete.push({
                rowNum: res._rowNum,
                orderId: res['주문ID'],
                reason: '필수 필드 누락',
            });
            continue;
        }

        // Room Code 체크
        const roomCode = res['객실코드'];
        if (!roomCode) {
            validation.roomCodeMissing.push({
                rowNum: res._rowNum,
                orderId: res['주문ID'],
            });
        }

        // Car Code는 SH_R에 없는 것 같으므로 체크 제거

        validation.valid.push(res);
    } console.log(`   ✅ 유효한 예약: ${validation.valid.length}개`);
    console.log(`   ⚠️  필수 필드 누락: ${validation.incomplete.length}개`);
    console.log(`   ⚠️  Room Code 없음: ${validation.roomCodeMissing.length}개`);
    console.log(`   ⚠️  Car Code 없음: ${validation.carCodeMissing.length}개`);
    console.log('');

    // 7. Order-User 매핑 로드
    const mappingPath = 'scripts/mapping-order-user.json';
    const mapping = JSON.parse(fs.readFileSync(mappingPath, 'utf-8'));

    // 8. 예약 이관 (유효한 예약만)
    console.log('============================================================');
    console.log('🔄 예약 이관 시작');
    console.log('============================================================\n');

    const results = {
        success: [],
        failed: [],
        skipped: validation.incomplete.length,
    };

    for (const res of validation.valid) {
        const orderId = res['주문ID'];
        const userId = mapping.orderUserMap?.[orderId] || mapping[orderId];

        if (!userId) {
            console.log(`   ⚠️  행 ${res._rowNum}: User ID를 찾을 수 없음 (Order: ${orderId})`);
            results.failed.push({
                rowNum: res._rowNum,
                orderId: orderId,
                error: 'User ID 없음',
            });
            continue;
        }

        try {
            // Reservation 메인 테이블 삽입
            const { data: reservationData, error: reservationError } = await supabase
                .from('reservation')
                .insert({
                    re_user_id: userId,
                    re_quote_id: null, // 구글 시트 예약은 견적 없음
                    re_type: 'cruise',
                    re_status: 'confirmed',
                    re_created_at: new Date().toISOString(),
                })
                .select()
                .single();

            if (reservationError) {
                throw reservationError;
            }

            // Reservation Cruise 상세 테이블 삽입
            const cruiseData = {
                reservation_id: reservationData.re_id,
                cruise_code: null, // SH_R에는 크루즈 코드 없음
                cruise_name: res['크루즈'] || null,
                checkin: res['체크인'] || null,
                checkout: null, // SH_R에 하선일 없음
                room_code: res['객실코드'] || null,
                room_price_code: null, // 추후 업데이트
                car_code: null, // SH_R에 차량 정보 없음
                car_price_code: null,
                guest_count: parseInt(res['승선인원'] || res['인원수']) || 0,
                room_total_price: parseFloat(res['합계']) || 0,
                car_total_price: 0,
                request_note: res['객실비고'] || null,
            }; const { error: cruiseError } = await supabase
                .from('reservation_cruise')
                .insert(cruiseData);

            if (cruiseError) {
                // Cruise 실패시 Reservation도 삭제
                await supabase
                    .from('reservation')
                    .delete()
                    .eq('re_id', reservationData.re_id);
                throw cruiseError;
            }

            results.success.push({
                rowNum: res._rowNum,
                orderId: orderId,
                reservationId: reservationData.re_id,
            });

            // 100개마다 진행률 출력
            if (results.success.length % 100 === 0) {
                const progress = ((results.success.length / validation.valid.length) * 100).toFixed(1);
                console.log(`   진행: ${results.success.length}/${validation.valid.length} (${progress}%)`);
            }

        } catch (error) {
            console.error(`   ❌ 행 ${res._rowNum} 실패:`, error.message);
            results.failed.push({
                rowNum: res._rowNum,
                orderId: orderId,
                error: error.message,
            });
        }
    }

    // 9. 결과 요약
    console.log('\n============================================================');
    console.log('📊 이관 결과');
    console.log('============================================================');
    console.log(`   - 성공: ${results.success.length}개`);
    console.log(`   - 실패: ${results.failed.length}개`);
    console.log(`   - 스킵: ${results.skipped}개 (필수 필드 누락)`);
    console.log('');

    // 10. 실패 케이스 출력
    if (results.failed.length > 0) {
        console.log('============================================================');
        console.log('❌ 실패 케이스');
        console.log('============================================================\n');

        results.failed.slice(0, 10).forEach((f, idx) => {
            console.log(`   ${idx + 1}. 행 ${f.rowNum}: ${f.error}`);
            console.log(`      Order ID: ${f.orderId}`);
        });

        if (results.failed.length > 10) {
            console.log(`   ... 외 ${results.failed.length - 10}건\n`);
        }
    }

    // 11. 결과 저장
    const outputPath = 'scripts/migrate-new-users-reservations-result.json';
    fs.writeFileSync(outputPath, JSON.stringify({
        timestamp: new Date().toISOString(),
        totalNewUsers: newUsers.length,
        totalReservations: newUserReservations.length,
        validReservations: validation.valid.length,
        successCount: results.success.length,
        failedCount: results.failed.length,
        skippedCount: results.skipped,
        validation: validation,
        results: results,
    }, null, 2));

    console.log('============================================================');
    console.log('💾 결과 저장');
    console.log('============================================================');
    console.log(`✅ ${outputPath}\n`);

    console.log('============================================================');
    console.log('🎉 이관 완료!');
    console.log('============================================================');
    console.log(`   신규 사용자 예약 ${results.success.length}개가 이관되었습니다.`);
    console.log('');
}

migrateNewUsersReservations().catch(console.error);
