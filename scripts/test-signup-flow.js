require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

// Anon key로 클라이언트 생성 (실제 브라우저와 동일)
const supabase = createClient(supabaseUrl, anonKey);

async function testSignupFlow() {
    console.log('🔍 실제 회원가입 흐름 테스트\n');

    const testEmail = `test${Date.now()}@example.com`;
    const testPassword = 'test123456';
    const testName = '테스트사용자';

    console.log('============================================================');
    console.log('📝 테스트 정보');
    console.log('============================================================');
    console.log('Email:', testEmail);
    console.log('Password:', testPassword);
    console.log('Name:', testName);
    console.log('');

    try {
        // Step 1: Auth 회원가입
        console.log('============================================================');
        console.log('🔄 Step 1: Supabase Auth 회원가입');
        console.log('============================================================\n');

        const { data: authData, error: authError } = await supabase.auth.signUp({
            email: testEmail,
            password: testPassword,
            options: {
                data: {
                    display_name: testName,
                },
            },
        });

        if (authError) {
            console.log('❌ Auth 회원가입 실패:', authError.message);
            throw authError;
        }

        if (!authData.user) {
            console.log('❌ 사용자 생성 실패: user가 null');
            return;
        }

        console.log('✅ Auth 회원가입 성공');
        console.log('   User ID:', authData.user.id);
        console.log('   Email:', authData.user.email);
        console.log('   Email Confirmed:', authData.user.email_confirmed_at ? 'Yes' : 'No');
        console.log('');

        // Step 2: Users 테이블에 프로필 저장
        console.log('============================================================');
        console.log('🔄 Step 2: Users 테이블에 프로필 저장');
        console.log('============================================================\n');

        const userId = authData.user.id;

        // 2-1. 기존 사용자 확인
        const { data: existingUser, error: fetchError } = await supabase
            .from('users')
            .select('role')
            .eq('id', userId)
            .single();

        if (fetchError && fetchError.code !== 'PGRST116') {
            console.log('❌ 기존 사용자 확인 실패:', fetchError.message);
        } else if (existingUser) {
            console.log('ℹ️  이미 존재하는 사용자 (기존 role:', existingUser.role, ')');
        } else {
            console.log('✅ 신규 사용자');
        }
        console.log('');

        // 2-2. Upsert 시도
        const upsertData = {
            id: userId,
            email: testEmail,
            name: testName,
            role: existingUser?.role || 'guest',
            status: 'active',
            created_at: existingUser ? undefined : new Date().toISOString(),
            updated_at: new Date().toISOString(),
        };

        console.log('Upsert 데이터:', JSON.stringify(upsertData, null, 2));
        console.log('');

        const { data: insertData, error: insertError } = await supabase
            .from('users')
            .upsert(upsertData, { onConflict: 'id' })
            .select()
            .single();

        if (insertError) {
            console.log('❌ Users 테이블 저장 실패:');
            console.log('   Message:', insertError.message);
            console.log('   Code:', insertError.code);
            console.log('   Details:', insertError.details);
            console.log('   Hint:', insertError.hint);
            console.log('');

            console.log('============================================================');
            console.log('💡 해결 방법');
            console.log('============================================================\n');
            console.log('Supabase Dashboard > SQL Editor에서 다음 SQL 실행:\n');
            console.log('sql/fix-users-rls-for-signup.sql 파일의 내용을 복사하여 실행\n');
            console.log('핵심 정책:');
            console.log(`CREATE POLICY "Users can insert their own profile" 
ON users 
FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = id);`);
            console.log('');

            // 정리: Auth 사용자 삭제 시도
            console.log('🗑️  테스트 Auth 사용자 삭제 시도...');
            const serviceRoleSupabase = createClient(
                supabaseUrl,
                process.env.SUPABASE_SERVICE_ROLE_KEY
            );
            await serviceRoleSupabase.auth.admin.deleteUser(userId);
            console.log('   (Auth 사용자 삭제됨)\n');

            return;
        }

        console.log('✅ Users 테이블 저장 성공!');
        console.log('   User ID:', insertData.id);
        console.log('   Name:', insertData.name);
        console.log('   Role:', insertData.role);
        console.log('   Status:', insertData.status);
        console.log('');

        // Step 3: 정리 (테스트 사용자 삭제)
        console.log('============================================================');
        console.log('🗑️  테스트 데이터 정리');
        console.log('============================================================\n');

        // Service Role로 삭제
        const serviceRoleSupabase = createClient(
            supabaseUrl,
            process.env.SUPABASE_SERVICE_ROLE_KEY
        );

        // Users 테이블 삭제
        await serviceRoleSupabase.from('users').delete().eq('id', userId);
        console.log('✅ Users 테이블 레코드 삭제');

        // Auth 사용자 삭제
        await serviceRoleSupabase.auth.admin.deleteUser(userId);
        console.log('✅ Auth 사용자 삭제');
        console.log('');

        console.log('============================================================');
        console.log('🎉 회원가입 흐름 테스트 성공!');
        console.log('============================================================\n');
        console.log('실제 회원가입이 정상적으로 작동합니다.');
        console.log('');

    } catch (error) {
        console.error('❌ 테스트 실패:', error);
    }
}

testSignupFlow().catch(console.error);
