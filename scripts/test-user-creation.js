require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function testUserCreation() {
    console.log('🔍 회원가입 프로필 생성 테스트\n');

    // 1. 테스트 사용자 생성 시도
    const testUserId = 'test-user-' + Date.now();
    const testEmail = `test${Date.now()}@example.com`;

    console.log('============================================================');
    console.log('🧪 테스트 1: Service Role로 users INSERT');
    console.log('============================================================\n');
    console.log('Test User ID:', testUserId);
    console.log('Test Email:', testEmail);
    console.log('');

    const { data: insertData, error: insertError } = await supabase
        .from('users')
        .insert({
            id: testUserId,
            email: testEmail,
            name: '테스트사용자',
            role: 'guest',
            status: 'active',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString()
        })
        .select()
        .single();

    if (insertError) {
        console.log('❌ Service Role INSERT 실패:');
        console.log('   Message:', insertError.message);
        console.log('   Code:', insertError.code);
        console.log('   Details:', insertError.details);
        console.log('');

        console.log('============================================================');
        console.log('💡 해결 방법');
        console.log('============================================================\n');
        console.log('Supabase Dashboard > SQL Editor에서 실행:\n');
        console.log('-- users 테이블 RLS 확인');
        console.log(`SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual
FROM pg_policies 
WHERE tablename = 'users';`);
        console.log('');
        console.log('-- 만약 INSERT를 막는 정책이 있다면 Service Role에 대한 예외 추가:');
        console.log(`CREATE POLICY "Service role can insert users" 
ON users 
FOR INSERT 
TO service_role
WITH CHECK (true);`);
        console.log('');
        console.log('-- 또는 회원가입을 위한 authenticated role INSERT 허용:');
        console.log(`CREATE POLICY "Allow authenticated users to insert their own profile" 
ON users 
FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = id);`);
        console.log('');

    } else {
        console.log('✅ Service Role INSERT 성공!');
        console.log('   User ID:', insertData.id);
        console.log('');

        // 테스트 데이터 삭제
        await supabase.from('users').delete().eq('id', testUserId);
        console.log('   (테스트 데이터 삭제됨)\n');
    }

    // 2. RLS 상태 확인
    console.log('============================================================');
    console.log('📋 Users 테이블 RLS 상태');
    console.log('============================================================\n');

    const { data: tableInfo, error: tableError } = await supabase
        .from('users')
        .select('id')
        .limit(1);

    if (tableError) {
        console.log('⚠️  테이블 접근 오류:', tableError.message);
    } else {
        console.log('✅ 테이블 접근 가능 (Service Role)\n');
    }

    // 3. 기존 사용자 샘플 확인
    console.log('============================================================');
    console.log('📊 기존 사용자 샘플 (5명)');
    console.log('============================================================\n');

    const { data: sampleUsers, error: sampleError } = await supabase
        .from('users')
        .select('id, email, name, role, status, created_at')
        .order('created_at', { ascending: false })
        .limit(5);

    if (sampleError) {
        console.log('❌ 샘플 조회 실패:', sampleError.message);
    } else {
        sampleUsers.forEach(u => {
            console.log(`   - ${u.name || u.email}: role=${u.role}, status=${u.status}`);
        });
        console.log('');
    }

    // 4. 실제 Auth User로 테스트 (anon key)
    console.log('============================================================');
    console.log('🧪 테스트 2: Anon Key로 users INSERT (회원가입 시뮬레이션)');
    console.log('============================================================\n');

    const anonSupabase = createClient(supabaseUrl, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);

    const testUserId2 = 'test-anon-' + Date.now();
    const testEmail2 = `testanon${Date.now()}@example.com`;

    const { data: anonInsertData, error: anonInsertError } = await anonSupabase
        .from('users')
        .insert({
            id: testUserId2,
            email: testEmail2,
            name: '익명테스트',
            role: 'guest',
            status: 'active',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString()
        })
        .select()
        .single();

    if (anonInsertError) {
        console.log('❌ Anon Key INSERT 실패 (예상됨):');
        console.log('   Message:', anonInsertError.message);
        console.log('   Code:', anonInsertError.code);
        console.log('');
        console.log('💡 이것이 정상입니다. 회원가입 시에는:');
        console.log('   1. Auth signUp으로 인증 사용자 생성');
        console.log('   2. 생성된 auth.uid()로 users 테이블에 INSERT');
        console.log('   3. RLS 정책: auth.uid() = id 조건으로 자신의 프로필만 INSERT 허용\n');

    } else {
        console.log('⚠️  Anon Key INSERT 성공 (보안 문제!)');
        console.log('   → RLS 정책이 너무 느슨합니다.\n');

        // 테스트 데이터 삭제
        await supabase.from('users').delete().eq('id', testUserId2);
    }

    console.log('============================================================');
    console.log('📝 권장 RLS 정책');
    console.log('============================================================\n');
    console.log('1. SELECT: 모든 인증된 사용자가 users 읽기 가능');
    console.log('2. INSERT: 인증된 사용자가 자신의 프로필만 생성 가능 (auth.uid() = id)');
    console.log('3. UPDATE: 사용자가 자신의 프로필만 수정 가능 (auth.uid() = id)');
    console.log('4. DELETE: admin만 가능 (role = \'admin\')\n');
}

testUserCreation().catch(console.error);
