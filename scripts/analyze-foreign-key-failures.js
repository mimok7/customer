#!/usr/bin/env node

/**
 * 실패한 40건의 외래 키 오류 상세 분석
 */

const { createClient } = require('@supabase/supabase-js');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function main() {
    console.log('🔍 외래 키 오류 상세 분석\n');

    try {
        // Phase 3 결과 로드
        const resultPath = path.join(__dirname, 'phase3-full-migration-result.json');
        const migrationResult = JSON.parse(fs.readFileSync(resultPath, 'utf8'));
        const failedCases = migrationResult.results.failed;

        // 외래 키 제약 조건 실패만 필터링
        const foreignKeyFailures = failedCases.filter(f =>
            f.error.includes('foreign key constraint') &&
            f.error.includes('reservation_re_user_id_fkey')
        );

        console.log(`📊 외래 키 실패 건수: ${foreignKeyFailures.length}건\n`);

        // 매핑 테이블 로드
        const orderUserMappingPath = path.join(__dirname, 'mapping-order-user.json');
        const orderUserData = JSON.parse(fs.readFileSync(orderUserMappingPath, 'utf8'));
        const orderUserMap = orderUserData.orderUserMap;

        console.log('🔍 각 실패 케이스 분석:\n');

        for (const failure of foreignKeyFailures.slice(0, 10)) { // 처음 10개만
            const orderId = failure.orderId;
            const userId = orderUserMap[orderId];

            console.log(`📋 행 ${failure.rowNum} (주문ID: ${orderId})`);
            console.log(`   - 매핑된 사용자 ID: ${userId}`);

            if (!userId) {
                console.log(`   ⚠️  매핑 테이블에 없음\n`);
                continue;
            }

            // users 테이블에서 확인
            const { data: userData, error: userError } = await supabase
                .from('users')
                .select('id, email, name, role, status')
                .eq('id', userId)
                .single();

            if (userError) {
                console.log(`   ❌ users 테이블 조회 오류: ${userError.message}`);
            } else if (!userData) {
                console.log(`   ❌ users 테이블에 없음`);
            } else {
                console.log(`   ✅ users 테이블에 존재:`);
                console.log(`      - 이메일: ${userData.email}`);
                console.log(`      - 이름: ${userData.name}`);
                console.log(`      - 역할: ${userData.role}`);
                console.log(`      - 상태: ${userData.status}`);

                // 직접 INSERT 시도
                console.log(`   🔄 직접 reservation INSERT 시도...`);
                const { data: testInsert, error: testError } = await supabase
                    .from('reservation')
                    .insert({
                        re_user_id: userId,
                        re_type: 'cruise',
                        re_status: 'pending',
                        total_amount: 1000000,
                        paid_amount: 0,
                        payment_status: 'pending'
                    })
                    .select();

                if (testError) {
                    console.log(`   ❌ INSERT 실패: ${testError.message}`);
                } else {
                    console.log(`   ✅ INSERT 성공!`);
                    // 테스트 데이터 삭제
                    await supabase.from('reservation').delete().eq('re_id', testInsert[0].re_id);
                    console.log(`   ✅ 테스트 데이터 삭제`);
                }
            }

            console.log('');
        }

        // RLS 정책 확인
        console.log('🔍 reservation 테이블 RLS 정책 확인:\n');
        console.log('   💡 힌트: RLS 정책이 INSERT를 막고 있을 수 있습니다.');
        console.log('   💡 Supabase에서 다음 SQL을 실행해보세요:');
        console.log('');
        console.log('   SELECT * FROM pg_policies WHERE tablename = \'reservation\';');
        console.log('');
        console.log('   또는 RLS를 임시로 비활성화:');
        console.log('   ALTER TABLE reservation DISABLE ROW LEVEL SECURITY;');

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
    }
}

main();
