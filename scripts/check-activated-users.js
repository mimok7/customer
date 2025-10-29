require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function checkActivatedUsers() {
    console.log('🔍 활성화된 사용자 상태 확인 중...\n');

    // 1. Phase 3 실패 결과 로드
    const fs = require('fs');
    const phase3Result = JSON.parse(fs.readFileSync('scripts/phase3-full-migration-result.json', 'utf-8'));

    // 실패한 케이스에서 사용자 ID 추출
    const failedUserIds = [...new Set(
        phase3Result.failed
            .filter(f => f.error.includes('foreign key'))
            .map(f => f.userId)
    )];

    console.log(`📊 확인할 사용자: ${failedUserIds.length}명\n`);

    // 2. 사용자 상태 확인
    const { data: users, error } = await supabase
        .from('users')
        .select('id, name, email, status, role')
        .in('id', failedUserIds);

    if (error) {
        console.error('❌ 사용자 조회 오류:', error);
        return;
    }

    console.log('============================================================');
    console.log('📋 사용자 상태 목록');
    console.log('============================================================\n');

    const statusCount = { active: 0, pending: 0, other: 0 };

    users.forEach(user => {
        const statusIcon = user.status === 'active' ? '✅' :
            user.status === 'pending' ? '⏳' : '❓';
        console.log(`${statusIcon} ${user.name} (${user.email})`);
        console.log(`   - ID: ${user.id}`);
        console.log(`   - Status: ${user.status}`);
        console.log(`   - Role: ${user.role || 'null'}`);
        console.log('');

        if (user.status === 'active') statusCount.active++;
        else if (user.status === 'pending') statusCount.pending++;
        else statusCount.other++;
    });

    console.log('============================================================');
    console.log('📊 상태 요약');
    console.log('============================================================');
    console.log(`   - Active: ${statusCount.active}명`);
    console.log(`   - Pending: ${statusCount.pending}명`);
    console.log(`   - Other: ${statusCount.other}명`);
    console.log('');

    // 3. RLS 정책 확인을 위한 샘플 INSERT 테스트
    console.log('============================================================');
    console.log('🧪 샘플 INSERT 테스트 (첫 번째 사용자)');
    console.log('============================================================\n');

    if (users.length > 0) {
        const testUser = users[0];
        console.log(`테스트 사용자: ${testUser.name} (${testUser.id})`);
        console.log(`Status: ${testUser.status}\n`);

        const { data, error: insertError } = await supabase
            .from('reservation')
            .insert({
                re_user_id: testUser.id,
                re_type: 'cruise',
                re_status: 'pending',
                total_amount: 0,
                paid_amount: 0,
                payment_status: 'pending'
            })
            .select()
            .single();

        if (insertError) {
            console.error('❌ INSERT 실패:', insertError.message);
            console.error('   Error Code:', insertError.code);
            console.error('   Details:', insertError.details);
            console.error('   Hint:', insertError.hint);
        } else {
            console.log('✅ INSERT 성공!');
            console.log('   Reservation ID:', data.re_id);

            // 테스트 데이터 삭제
            await supabase.from('reservation').delete().eq('re_id', data.re_id);
            console.log('   (테스트 데이터 삭제됨)');
        }
    }

    // 4. users 테이블 스키마 확인
    console.log('\n============================================================');
    console.log('📋 Users 테이블 샘플 데이터 (첫 5명)');
    console.log('============================================================\n');

    const { data: sampleUsers, error: sampleError } = await supabase
        .from('users')
        .select('*')
        .limit(5);

    if (sampleError) {
        console.error('❌ 샘플 데이터 조회 오류:', sampleError);
    } else {
        console.log('컬럼 목록:', Object.keys(sampleUsers[0] || {}));
        console.log('\n샘플 데이터:');
        sampleUsers.forEach(u => {
            console.log(`  - ${u.name}: status=${u.status}, role=${u.role}, created_at=${u.created_at}`);
        });
    }
}

checkActivatedUsers().catch(console.error);
