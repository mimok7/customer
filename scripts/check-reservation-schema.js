#!/usr/bin/env node

/**
 * reservation 테이블 스키마 확인
 */

const { createClient } = require('@supabase/supabase-js');
const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function main() {
    console.log('🔍 reservation 테이블 스키마 확인\n');

    try {
        // 1. 테이블 존재 확인 및 첫 번째 레코드 조회
        const { data, error } = await supabase
            .from('reservation')
            .select('*')
            .limit(1);

        if (error) {
            console.error('❌ 오류:', error.message);
            console.error('상세:', error);
            return;
        }

        if (!data || data.length === 0) {
            console.log('⚠️  reservation 테이블에 데이터가 없습니다.');
            return;
        }

        console.log('✅ reservation 테이블 컬럼:');
        const columns = Object.keys(data[0]);
        columns.forEach((col, idx) => {
            console.log(`   ${idx + 1}. ${col}: ${typeof data[0][col]} (${data[0][col] === null ? 'NULL' : JSON.stringify(data[0][col]).slice(0, 50)})`);
        });

        // 2. 직접 INSERT 테스트
        console.log('\n🔍 INSERT 테스트 (re_user_id만으로)');

        const testUserId = '1b2e88f9-7b1a-4d6e-8f3a-1c5e9d4a2b7f'; // 테스트용 UUID

        const { data: insertData, error: insertError } = await supabase
            .from('reservation')
            .insert({
                re_user_id: testUserId,
                re_type: 'cruise',
                re_status: 'pending'
            })
            .select();

        if (insertError) {
            console.error('❌ INSERT 실패:', insertError.message);
            console.error('상세:', insertError);
        } else {
            console.log('✅ INSERT 성공:', insertData);

            // 방금 삽입한 데이터 삭제
            await supabase.from('reservation').delete().eq('re_id', insertData[0].re_id);
            console.log('✅ 테스트 데이터 삭제 완료');
        }

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
    }
}

main();
