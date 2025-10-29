#!/usr/bin/env node

/**
 * Supabase 테이블 스키마 직접 조회 (information_schema 사용)
 */

const { createClient } = require('@supabase/supabase-js');
const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function main() {
    console.log('🔍 reservation 테이블 스키마 조회 (RPC 사용)\n');

    try {
        // RPC 함수로 테이블 스키마 조회
        const { data, error } = await supabase.rpc('get_table_schema', {
            table_name: 'reservation'
        });

        if (error) {
            console.error('❌ RPC 실패:', error.message);

            // 대안: 빈 INSERT로 오류 메시지 확인
            console.log('\n🔍 대안: 빈 INSERT로 필수 컬럼 확인');
            const { error: insertError } = await supabase
                .from('reservation')
                .insert({});

            if (insertError) {
                console.log('✅ 오류 메시지:', insertError.message);
                console.log('✅ 상세:', JSON.stringify(insertError, null, 2));
            }
            return;
        }

        console.log('✅ reservation 테이블 컬럼:');
        data.forEach((col, idx) => {
            console.log(`   ${idx + 1}. ${col.column_name}: ${col.data_type}`);
        });

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
    }
}

main();
