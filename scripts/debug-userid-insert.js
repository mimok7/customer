require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function debugUserIdAndInsert() {
    console.log('🔍 User ID 및 INSERT 디버깅\n');

    // 1. 매핑 파일 로드
    const mappingPath = path.join(__dirname, 'mapping-order-user.json');
    const mapping = JSON.parse(fs.readFileSync(mappingPath, 'utf8'));
    const orderUserMap = mapping.orderUserMap || mapping;

    // 2. 첫 번째 실패 케이스 (행 6, Order ID: 0scpJclz)
    const testOrderId = '0scpJclz';
    const userId = orderUserMap[testOrderId];

    console.log('============================================================');
    console.log('📋 테스트 케이스');
    console.log('============================================================');
    console.log(`Order ID: ${testOrderId}`);
    console.log(`Mapped User ID: ${userId}\n`);

    if (!userId) {
        console.log('❌ 매핑된 User ID가 없습니다!');
        return;
    }

    // 3. User 정보 확인
    console.log('🔍 사용자 정보 조회...');
    const { data: user, error: userError } = await supabase
        .from('users')
        .select('*')
        .eq('id', userId)
        .single();

    if (userError) {
        console.log('❌ 사용자 조회 실패:', userError.message);
        return;
    }

    console.log('✅ 사용자 존재:');
    console.log(`   - Name: ${user.name}`);
    console.log(`   - Email: ${user.email}`);
    console.log(`   - Status: ${user.status}`);
    console.log(`   - Role: ${user.role}`);
    console.log(`   - ID: ${user.id}`);
    console.log('');

    // 4. 직접 INSERT 테스트
    console.log('🧪 직접 INSERT 테스트...');

    const testData = {
        re_user_id: userId,
        re_type: 'cruise',
        re_status: 'pending',
        total_amount: 0,
        paid_amount: 0,
        payment_status: 'pending'
    };

    console.log('   INSERT 데이터:', JSON.stringify(testData, null, 2));
    console.log('');

    const { data: insertResult, error: insertError } = await supabase
        .from('reservation')
        .insert(testData)
        .select()
        .single();

    if (insertError) {
        console.log('❌ INSERT 실패:');
        console.log('   Message:', insertError.message);
        console.log('   Code:', insertError.code);
        console.log('   Details:', insertError.details);
        console.log('   Hint:', insertError.hint);
        console.log('');

        // 5. FK 제약 조건의 실제 요구사항 확인
        console.log('============================================================');
        console.log('🔍 FK 제약 조건 분석');
        console.log('============================================================\n');

        // 5-1. reservation 테이블의 FK 정의 확인 (SQL)
        console.log('💡 Supabase Dashboard > SQL Editor에서 다음 쿼리 실행:\n');
        console.log(`SELECT 
  tc.constraint_name, 
  tc.table_name, 
  kcu.column_name, 
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name,
  pg_get_constraintdef(pgc.oid) AS constraint_definition
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
JOIN pg_constraint AS pgc
  ON pgc.conname = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_name='reservation'
  AND tc.constraint_name = 'reservation_re_user_id_fkey';`);
        console.log('');

        // 5-2. users 테이블에서 실제 존재 여부 재확인
        console.log('🔍 Users 테이블 재확인...');
        const { data: checkUser, error: checkError } = await supabase
            .from('users')
            .select('id')
            .eq('id', userId);

        if (checkError) {
            console.log('   ❌ 재확인 실패:', checkError.message);
        } else {
            console.log(`   ✅ 사용자 존재: ${checkUser.length}명`);
            console.log(`   User IDs:`, checkUser.map(u => u.id));
        }
        console.log('');

        // 5-3. RLS 정책 확인
        console.log('🔍 RLS 정책 확인 (SQL):');
        console.log('');
        console.log(`SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'reservation';`);
        console.log('');

    } else {
        console.log('✅ INSERT 성공!');
        console.log('   Reservation ID:', insertResult.re_id);
        console.log('');

        // 테스트 데이터 삭제
        const { error: deleteError } = await supabase
            .from('reservation')
            .delete()
            .eq('re_id', insertResult.re_id);

        if (deleteError) {
            console.log('   ⚠️  테스트 데이터 삭제 실패:', deleteError.message);
        } else {
            console.log('   🗑️  테스트 데이터 삭제 완료');
        }
    }

    // 6. 성공한 예약들의 user_id 패턴 확인
    console.log('============================================================');
    console.log('📊 성공한 예약들의 User ID 분석');
    console.log('============================================================\n');

    const { data: existingReservations, error: resError } = await supabase
        .from('reservation')
        .select('re_id, re_user_id, re_type, re_status, created_at')
        .eq('re_type', 'cruise')
        .order('created_at', { ascending: false })
        .limit(5);

    if (resError) {
        console.log('❌ 기존 예약 조회 실패:', resError.message);
    } else {
        console.log(`✅ 최근 예약 ${existingReservations.length}건:`);
        for (const res of existingReservations) {
            const { data: resUser } = await supabase
                .from('users')
                .select('name, email, status')
                .eq('id', res.re_user_id)
                .single();

            console.log(`   - ${res.re_id.substring(0, 8)}...: ${resUser?.name} (${resUser?.status}) - ${res.re_status}`);
        }
    }
}

debugUserIdAndInsert().catch(console.error);
