require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function diagnoseRetryFailure() {
    console.log('🔍 Retry 실패 원인 진단 시작\n');

    // 1. Retry 결과 로드
    const retryResult = JSON.parse(fs.readFileSync('scripts/retry-failed-40-result.json', 'utf-8'));
    const failedCases = retryResult.results.failed.slice(0, 3); // 처음 3건만 분석

    console.log(`📊 분석할 실패 케이스: ${failedCases.length}건\n`);

    // 2. Order-User 매핑 로드
    const orderUserMapping = JSON.parse(fs.readFileSync('scripts/mapping-order-user.json', 'utf-8'));

    for (const failedCase of failedCases) {
        console.log('============================================================');
        console.log(`🔍 케이스 분석: 행 ${failedCase.rowNum}`);
        console.log('============================================================');
        console.log(`Order ID: ${failedCase.orderId}\n`);

        // 3. Order ID → User ID 매핑 확인
        const mappedUserId = orderUserMapping[failedCase.orderId];

        if (!mappedUserId) {
            console.log('❌ Order ID가 매핑되지 않음!');
            console.log('   → 이 케이스는 매핑 누락 문제\n');
            continue;
        }

        console.log(`✅ 매핑된 User ID: ${mappedUserId}\n`);

        // 4. 해당 User 정보 조회
        const { data: user, error: userError } = await supabase
            .from('users')
            .select('*')
            .eq('id', mappedUserId)
            .single();

        if (userError) {
            console.log('❌ User 조회 실패:', userError.message);
            console.log('   → 사용자가 DB에 없음!\n');
            continue;
        }

        console.log('📋 사용자 정보:');
        console.log(`   - Name: ${user.name}`);
        console.log(`   - Email: ${user.email}`);
        console.log(`   - Status: ${user.status}`);
        console.log(`   - Role: ${user.role || 'null'}`);
        console.log(`   - Created: ${user.created_at}`);
        console.log('');

        // 5. 실제 INSERT 테스트
        console.log('🧪 INSERT 테스트 시작...');

        const { data: insertData, error: insertError } = await supabase
            .from('reservation')
            .insert({
                re_user_id: mappedUserId,
                re_type: 'cruise',
                re_status: 'pending',
                total_amount: 0,
                paid_amount: 0,
                payment_status: 'pending'
            })
            .select()
            .single();

        if (insertError) {
            console.log('❌ INSERT 실패!');
            console.log('   Message:', insertError.message);
            console.log('   Code:', insertError.code);
            console.log('   Details:', insertError.details);
            console.log('   Hint:', insertError.hint);
            console.log('');

            // 6. RLS 정책 확인을 위한 service role 재테스트
            console.log('🔄 Service Role Key로 재시도...');
            const serviceRoleSupabase = createClient(supabaseUrl, supabaseKey, {
                auth: { persistSession: false }
            });

            const { data: serviceData, error: serviceError } = await serviceRoleSupabase
                .from('reservation')
                .insert({
                    re_user_id: mappedUserId,
                    re_type: 'cruise',
                    re_status: 'pending',
                    total_amount: 0,
                    paid_amount: 0,
                    payment_status: 'pending'
                })
                .select()
                .single();

            if (serviceError) {
                console.log('❌ Service Role도 실패!');
                console.log('   → FK 제약 조건 또는 트리거 문제');
                console.log('   Message:', serviceError.message);
            } else {
                console.log('✅ Service Role은 성공!');
                console.log('   → RLS 정책 문제일 가능성');
                // 테스트 데이터 삭제
                await serviceRoleSupabase.from('reservation').delete().eq('re_id', serviceData.re_id);
            }
        } else {
            console.log('✅ INSERT 성공!');
            console.log('   Reservation ID:', insertData.re_id);
            // 테스트 데이터 삭제
            await supabase.from('reservation').delete().eq('re_id', insertData.re_id);
            console.log('   (테스트 데이터 삭제됨)');
        }
        console.log('');
    }

    // 7. Users 테이블 전체 status 분포 확인
    console.log('============================================================');
    console.log('📊 Users 테이블 Status 분포');
    console.log('============================================================\n');

    const { data: statusDistribution, error: distError } = await supabase
        .from('users')
        .select('status')
        .then(result => {
            if (result.error) return result;
            const distribution = {};
            result.data.forEach(u => {
                distribution[u.status] = (distribution[u.status] || 0) + 1;
            });
            return { data: distribution, error: null };
        });

    if (!distError) {
        Object.entries(statusDistribution).forEach(([status, count]) => {
            console.log(`   - ${status}: ${count}명`);
        });
    }
    console.log('');

    // 8. Reservation 테이블의 FK 제약 조건 확인 (SQL 출력)
    console.log('============================================================');
    console.log('📋 FK 제약 조건 확인 SQL');
    console.log('============================================================\n');
    console.log('Supabase Dashboard > SQL Editor에서 실행:');
    console.log('');
    console.log(`SELECT 
  conname AS constraint_name,
  contype AS constraint_type,
  pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'reservation'::regclass
  AND contype = 'f';`);
    console.log('');
}

diagnoseRetryFailure().catch(console.error);
