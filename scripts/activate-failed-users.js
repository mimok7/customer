#!/usr/bin/env node

/**
 * 실패한 40건의 사용자 status를 'active'로 변경
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
    console.log('🔧 실패한 40건의 사용자 status 활성화\n');

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

        // 매핑 테이블 로드
        const orderUserMappingPath = path.join(__dirname, 'mapping-order-user.json');
        const orderUserData = JSON.parse(fs.readFileSync(orderUserMappingPath, 'utf8'));
        const orderUserMap = orderUserData.orderUserMap;

        // 사용자 ID 수집 (중복 제거)
        const userIds = new Set();
        foreignKeyFailures.forEach(f => {
            const userId = orderUserMap[f.orderId];
            if (userId) {
                userIds.add(userId);
            }
        });

        console.log(`📊 활성화할 사용자: ${userIds.size}명\n`);

        let updated = 0;
        let failed = 0;

        for (const userId of userIds) {
            // 현재 상태 확인
            const { data: userData } = await supabase
                .from('users')
                .select('id, name, email, status')
                .eq('id', userId)
                .single();

            if (!userData) {
                console.log(`   ⚠️  ${userId}: 사용자 없음`);
                failed++;
                continue;
            }

            if (userData.status === 'active') {
                console.log(`   ✓ ${userData.name || userData.email}: 이미 active`);
                continue;
            }

            // status를 'active'로 변경
            const { error } = await supabase
                .from('users')
                .update({ status: 'active' })
                .eq('id', userId);

            if (error) {
                console.log(`   ❌ ${userData.name || userData.email}: 업데이트 실패 - ${error.message}`);
                failed++;
            } else {
                console.log(`   ✅ ${userData.name || userData.email}: pending → active`);
                updated++;
            }
        }

        console.log(`\n${'='.repeat(60)}`);
        console.log('📊 업데이트 결과');
        console.log(`${'='.repeat(60)}`);
        console.log(`   - 업데이트 성공: ${updated}명`);
        console.log(`   - 이미 active: ${userIds.size - updated - failed}명`);
        console.log(`   - 실패: ${failed}명`);

        if (updated > 0) {
            console.log('\n✅ 사용자 status가 활성화되었습니다!');
            console.log('\n💡 다음 단계:');
            console.log('   1. 실패한 40건을 다시 이관해보세요.');
            console.log('   2. 명령어: node scripts/retry-failed-40.js');
        }

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
    }
}

main();
