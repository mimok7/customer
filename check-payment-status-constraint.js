const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function main() {
    console.log('🔍 reservation 테이블의 payment_status CHECK 제약 조건 확인 중...\n');

    // 제약 조건 확인
    const { data: constraints, error } = await supabase.rpc('run_sql_query', {
        query: `
      SELECT 
        conname AS constraint_name,
        pg_get_constraintdef(oid) AS constraint_definition
      FROM pg_constraint
      WHERE conrelid = 'reservation'::regclass
        AND contype = 'c'
        AND conname LIKE '%payment_status%';
    `
    });

    if (error) {
        console.log('⚠️ RPC 함수가 없습니다. SQL 직접 조회...\n');

        // payment_status 컬럼 정보 확인
        const { data: columns } = await supabase
            .from('reservation')
            .select('*')
            .limit(1);

        console.log('📋 현재 스크립트가 삽입하려는 payment_status 값: null 또는 빈 문자열');
        console.log('✅ 허용될 가능성이 있는 값: "unpaid", "partial", "paid", "pending" 등\n');

        // 제약 조건을 직접 찾아보기
        console.log('💡 해결 방법:');
        console.log('  1. payment_status에 기본값 설정: "pending" 또는 "unpaid"');
        console.log('  2. 또는 import 스크립트에서 re_payment_status 필드에 유효한 값 삽입');
    } else {
        console.log('📊 제약 조건:', constraints);
    }
}

main().catch(console.error);
