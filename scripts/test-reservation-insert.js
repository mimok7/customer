#!/usr/bin/env node

/**
 * reservation 테이블 직접 INSERT 테스트
 */

const { createClient } = require('@supabase/supabase-js');
const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function main() {
    console.log('🔍 reservation 테이블 INSERT 테스트\n');

    try {
        // 실제 사용자 ID 하나 가져오기
        const { data: users, error: userError } = await supabase
            .from('users')
            .select('id')
            .limit(1)
            .single();

        if (userError || !users) {
            console.error('❌ 사용자 조회 실패:', userError?.message);
            return;
        }

        console.log('✅ 테스트용 사용자 ID:', users.id);

        // INSERT 테스트 1: 기본 필드만
        console.log('\n🔍 Test 1: 기본 필드만 (re_user_id, re_type, re_status)');
        const { data: test1, error: error1 } = await supabase
            .from('reservation')
            .insert({
                re_user_id: users.id,
                re_type: 'cruise',
                re_status: 'pending'
            })
            .select();

        if (error1) {
            console.error('❌ Test 1 실패:', error1.message);
            console.error('상세:', JSON.stringify(error1, null, 2));
        } else {
            console.log('✅ Test 1 성공!');
            console.log('생성된 데이터:', test1[0]);

            // 삭제
            await supabase.from('reservation').delete().eq('re_id', test1[0].re_id);
            console.log('✅ 테스트 데이터 삭제');
        }

        // INSERT 테스트 2: 모든 필드
        console.log('\n🔍 Test 2: 모든 필드 포함');
        const { data: test2, error: error2 } = await supabase
            .from('reservation')
            .insert({
                re_user_id: users.id,
                re_quote_id: null,
                re_type: 'cruise',
                re_status: 'pending',
                total_amount: 1000000,
                paid_amount: 0,
                payment_status: 'pending'
            })
            .select();

        if (error2) {
            console.error('❌ Test 2 실패:', error2.message);
            console.error('상세:', JSON.stringify(error2, null, 2));
        } else {
            console.log('✅ Test 2 성공!');
            console.log('생성된 데이터:', test2[0]);

            // 삭제
            await supabase.from('reservation').delete().eq('re_id', test2[0].re_id);
            console.log('✅ 테스트 데이터 삭제');
        }

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
    }
}

main();
