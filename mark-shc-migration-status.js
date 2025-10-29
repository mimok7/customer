const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const dotenv = require('dotenv');

try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const GOOGLE_SHEETS_ID = process.env.GOOGLE_SHEETS_ID;
const GOOGLE_SERVICE_ACCOUNT = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const GOOGLE_SERVICE_KEY = process.env.GOOGLE_SERVICE_ACCOUNT_KEY;

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

// ⚠️ 안전장치: true면 시뮬레이션만, false면 실제 시트 업데이트
const DRY_RUN = false;

async function getSheetsClient() {
    const auth = new GoogleAuth({
        credentials: {
            client_email: GOOGLE_SERVICE_ACCOUNT,
            private_key: GOOGLE_SERVICE_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets'],
    });
    const authClient = await auth.getClient();
    return google.sheets({ version: 'v4', auth: authClient });
}

async function main() {
    console.log('🔍 SH_C → reservation_cruise_car 이관 가능성 점검 + V열 표시\n');
    console.log('='.repeat(80));

    if (DRY_RUN) {
        console.log('\n⚠️  DRY RUN 모드: 시트 업데이트 없음');
        console.log('   실제 실행하려면 DRY_RUN = false로 변경하세요\n');
    } else {
        console.log('\n🚨 실제 실행 모드: 시트가 업데이트됩니다!\n');
    }

    console.log('='.repeat(80));

    // 1. users 테이블에서 order_id 로드
    console.log('\n📋 Step 1: users 테이블 order_id 로드');
    console.log('='.repeat(80));

    let allUsers = [];
    const pageSize = 1000;
    let page = 0;
    let hasMore = true;

    while (hasMore) {
        const { data: users } = await supabase
            .from('users')
            .select('id, order_id')
            .range(page * pageSize, (page + 1) * pageSize - 1);

        if (users && users.length > 0) {
            allUsers = allUsers.concat(users);
            page++;
            hasMore = users.length === pageSize;
        } else {
            hasMore = false;
        }
    }

    const orderToUserId = new Map(
        allUsers.map(u => [u.order_id?.trim(), u.id]).filter(([orderId]) => orderId)
    );

    console.log(`✅ 전체 사용자: ${allUsers.length}명`);
    console.log(`✅ order_id 매핑: ${orderToUserId.size}개\n`);

    // 2. SH_C 시트 데이터 로드
    console.log('📋 Step 2: SH_C 시트 데이터 로드');
    console.log('='.repeat(80));

    const sheets = await getSheetsClient();
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_C!A2:V',
    });

    const dataRows = response.data.values || [];
    console.log(`✅ SH_C 시트: ${dataRows.length}행 로드\n`);

    // 3. 이관 가능성 분석
    console.log('📋 Step 3: 이관 가능성 분석');
    console.log('='.repeat(80) + '\n');

    const updateData = [];
    const stats = {
        total: dataRows.length,
        success: 0,
        failNoOrderId: 0,
        failNoUser: 0,
        failNoFields: 0
    };

    dataRows.forEach((row, index) => {
        const orderId = row[1]?.trim(); // B열
        const category = row[2]?.trim(); // C열 (구분)
        const classification = row[3]?.trim(); // D열 (분류)
        const cruiseName = row[4]?.trim(); // E열
        const carType = row[5]?.trim(); // F열
        const pickupLocation = row[10]?.trim(); // K열

        let status = '';
        let reason = '';

        // 이관 가능 조건 체크
        if (!orderId) {
            status = '❌ 실패';
            reason = '주문ID 없음';
            stats.failNoOrderId++;
        } else {
            const userId = orderToUserId.get(orderId);

            if (!userId) {
                status = '❌ 실패';
                reason = '사용자 매핑 불가';
                stats.failNoUser++;
            } else if (!category && !classification && !cruiseName) {
                status = '❌ 실패';
                reason = '필수 필드 부족';
                stats.failNoFields++;
            } else {
                status = '✅ 성공';
                reason = '이관 가능';
                stats.success++;
            }
        }

        // V열(22번째, 인덱스 21)에 상태 업데이트
        updateData.push({
            rowNum: index + 2,
            orderId: orderId || '(없음)',
            status,
            reason,
            updateValue: `${status} | ${reason}`
        });
    });

    // 4. 통계 출력
    console.log('통계 요약:\n');
    console.log(`전체: ${stats.total}건`);
    console.log(`✅ 이관 가능: ${stats.success}건 (${(stats.success / stats.total * 100).toFixed(1)}%)`);
    console.log(`❌ 실패: ${stats.total - stats.success}건\n`);

    console.log('실패 원인:');
    console.log(`   주문ID 없음: ${stats.failNoOrderId}건`);
    console.log(`   사용자 매핑 불가: ${stats.failNoUser}건`);
    console.log(`   필수 필드 부족: ${stats.failNoFields}건\n`);

    // 5. 샘플 출력
    console.log('='.repeat(80));
    console.log('📝 업데이트 데이터 샘플 (최대 30건)');
    console.log('='.repeat(80) + '\n');

    updateData.slice(0, 30).forEach((item, idx) => {
        console.log(`${(idx + 1).toString().padStart(2)}. [행 ${item.rowNum}] ${item.status}`);
        console.log(`    주문ID: ${item.orderId.padEnd(15)} | V열: "${item.updateValue}"`);
    });

    if (updateData.length > 30) {
        console.log(`\n... 외 ${updateData.length - 30}건\n`);
    }

    // 6. 시트 업데이트
    if (DRY_RUN) {
        console.log('\n='.repeat(80));
        console.log('⚠️  DRY RUN 모드: 실제 업데이트 없음');
        console.log('='.repeat(80));
        console.log(`\n실제 실행 시 ${updateData.length}행의 V열이 업데이트됩니다.\n`);
    } else {
        console.log('\n='.repeat(80));
        console.log('🚀 SH_C 시트 V열 업데이트 시작');
        console.log('='.repeat(80) + '\n');

        // 배치로 업데이트 (100개씩)
        const batchSize = 100;
        let successCount = 0;
        let errorCount = 0;

        for (let i = 0; i < updateData.length; i += batchSize) {
            const batch = updateData.slice(i, i + batchSize);

            const batchUpdates = batch.map(item => ({
                range: `SH_C!V${item.rowNum}`,
                values: [[item.updateValue]]
            }));

            try {
                await sheets.spreadsheets.values.batchUpdate({
                    spreadsheetId: GOOGLE_SHEETS_ID,
                    requestBody: {
                        data: batchUpdates,
                        valueInputOption: 'RAW'
                    }
                });

                successCount += batch.length;
                console.log(`✅ 배치 ${Math.floor(i / batchSize) + 1} 완료 (${batch.length}건)`);
            } catch (error) {
                errorCount += batch.length;
                console.log(`❌ 배치 ${Math.floor(i / batchSize) + 1} 실패: ${error.message}`);
            }
        }

        console.log('\n='.repeat(80));
        console.log('📊 업데이트 결과');
        console.log('='.repeat(80));
        console.log(`\n✅ 성공: ${successCount}건`);
        console.log(`❌ 실패: ${errorCount}건\n`);
    }

    // 7. 최종 권장사항
    console.log('='.repeat(80));
    console.log('💡 이관 권장사항');
    console.log('='.repeat(80) + '\n');

    const successRate = (stats.success / stats.total * 100).toFixed(1);

    if (successRate >= 90) {
        console.log(`✅ 이관 강력 권장: ${successRate}% 성공 예상`);
    } else if (successRate >= 70) {
        console.log(`⚠️  조건부 권장: ${successRate}% 성공 예상`);
    } else {
        console.log(`❌ 이관 비권장: ${successRate}% 성공 예상`);
    }

    console.log(`\n예상 결과:`);
    console.log(`   ✅ 이관 성공: ${stats.success}건`);
    console.log(`   ❌ 이관 실패: ${stats.total - stats.success}건\n`);

    console.log('다음 단계:');
    console.log('   1. V열의 "✅ 성공" 데이터만 필터링');
    console.log('   2. import 스크립트 실행');
    console.log('   3. reservation + reservation_cruise_car 테이블에 저장\n');

    console.log('='.repeat(80));
}

main().catch(console.error);
