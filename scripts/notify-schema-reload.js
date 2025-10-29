#!/usr/bin/env node

/**
 * Supabase PostgREST 스키마 리로드 (NOTIFY 사용)
 */

const { createClient } = require('@supabase/supabase-js');
const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function main() {
    console.log('🔄 PostgREST 스키마 캐시 리로드 중...\n');

    try {
        // PostgreSQL NOTIFY를 통해 PostgREST에 스키마 리로드 알림
        const { data, error } = await supabase.rpc('pgrst_watch', {});

        if (error) {
            console.log('⚠️  RPC 방법 실패:', error.message);
            console.log('\n📌 수동 방법을 사용하세요:');
            console.log('   1. Supabase Dashboard (https://supabase.com/dashboard)');
            console.log('   2. 프로젝트 선택');
            console.log('   3. Settings → API → Configuration');
            console.log('   4. "Reload schema" 버튼 클릭');
            console.log('\n💡 또는 SQL Editor에서 실행:');
            console.log('   NOTIFY pgrst, \'reload schema\';');
        } else {
            console.log('✅ 스키마 리로드 성공!');
        }

        // 대안: SQL로 직접 실행
        console.log('\n🔄 SQL NOTIFY 시도...');
        const { error: sqlError } = await supabase.rpc('exec_sql', {
            sql: "NOTIFY pgrst, 'reload schema';"
        });

        if (sqlError) {
            console.log('⚠️  SQL 방법도 실패');
            console.log('\n📌 해결책: Supabase Dashboard에서 수동으로 리로드하세요');
        } else {
            console.log('✅ NOTIFY 전송 성공!');
        }

        console.log('\n⏳ 30초 대기 후 다시 테스트하세요...');

    } catch (error) {
        console.error('❌ 오류:', error.message);
    }
}

main();
