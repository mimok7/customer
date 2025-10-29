require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function verifyRLSPolicy() {
    console.log('🔍 RLS 정책 확인 및 검증\n');

    // 1. users 테이블 RLS 상태 확인
    console.log('============================================================');
    console.log('📋 Users 테이블 RLS 상태');
    console.log('============================================================\n');

    // RLS 상태는 Supabase Dashboard에서 확인 필요
    console.log('⚠️  RLS 상태는 Supabase Dashboard에서 직접 확인하세요\n');

    // 2. 테스트 사용자로 직접 INSERT 테스트
    const testUserId = 'bab42fdc-a57a-4391-85f7-0e6831ab03ec'; // 방정철

    console.log('============================================================');
    console.log('🧪 INSERT 테스트 (Service Role)');
    console.log('============================================================');
    console.log(`Test User ID: ${testUserId}\n`);

    // 2-1. 사용자 존재 확인
    const { data: user, error: userError } = await supabase
        .from('users')
        .select('id, name, email, status, role')
        .eq('id', testUserId)
        .single();

    if (userError) {
        console.log('❌ 사용자 조회 실패:', userError.message);
        return;
    }

    console.log('✅ 사용자 확인:');
    console.log(`   - Name: ${user.name}`);
    console.log(`   - Status: ${user.status}`);
    console.log(`   - Role: ${user.role}\n`);

    // 2-2. Reservation INSERT 시도
    console.log('🔄 Reservation INSERT 시도...\n');

    const { data: insertResult, error: insertError } = await supabase
        .from('reservation')
        .insert({
            re_user_id: testUserId,
            re_type: 'cruise',
            re_status: 'pending',
            total_amount: 0,
            paid_amount: 0,
            payment_status: 'pending'
        })
        .select();

    if (insertError) {
        console.log('❌ INSERT 여전히 실패:');
        console.log('   Error:', insertError.message);
        console.log('   Code:', insertError.code);
        console.log('   Details:', insertError.details);
        console.log('');

        // 3. RLS를 완전히 비활성화하는 방법 제시
        console.log('============================================================');
        console.log('💡 해결 방법: RLS 완전 비활성화 (임시)');
        console.log('============================================================\n');
        console.log('Supabase Dashboard > SQL Editor에서 실행:\n');
        console.log('-- 1. users 테이블 RLS 비활성화');
        console.log('ALTER TABLE users DISABLE ROW LEVEL SECURITY;\n');
        console.log('-- 2. 이관 완료 후 다시 활성화');
        console.log('-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;\n');

    } else {
        console.log('✅ INSERT 성공!');
        console.log(`   Reservation ID: ${insertResult[0].re_id}\n`);

        // 테스트 데이터 삭제
        await supabase
            .from('reservation')
            .delete()
            .eq('re_id', insertResult[0].re_id);

        console.log('   (테스트 데이터 삭제 완료)\n');

        console.log('============================================================');
        console.log('✅ 준비 완료! Retry 스크립트 실행 가능');
        console.log('============================================================');
        console.log('\n명령어: node scripts/retry-failed-40.js\n');
    }

    // 4. 현재 RLS 정책 목록 조회 시도
    console.log('============================================================');
    console.log('📋 현재 적용된 RLS 정책 (직접 확인 필요)');
    console.log('============================================================\n');
    console.log('Supabase Dashboard > Authentication > Policies에서 확인하거나\n');
    console.log('SQL Editor에서 실행:\n');
    console.log(`SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies 
WHERE tablename IN ('users', 'reservation')
ORDER BY tablename, policyname;`);
    console.log('');
}

verifyRLSPolicy().catch(console.error);
