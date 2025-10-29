const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: '.env.local' });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error('❌ 환경 변수가 설정되지 않았습니다.');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function runSQL() {
    try {
        console.log('🔧 reservation_cruise 테이블에 updated_at 컬럼 추가 중...');

        // SQL 파일 읽기
        const sqlPath = path.join(__dirname, 'add-updated-at-to-reservation-cruise.sql');
        const sql = fs.readFileSync(sqlPath, 'utf8');

        console.log('📝 실행할 SQL:', sql.substring(0, 200) + '...');

        // SQL 실행
        const { data, error } = await supabase.rpc('exec_sql', { sql_query: sql });

        if (error) {
            console.error('❌ SQL 실행 실패:', error);
            console.error('상세 정보:', {
                message: error.message,
                details: error.details,
                hint: error.hint,
                code: error.code
            });

            console.log('\n💡 대안: Supabase 대시보드의 SQL Editor에서 직접 실행하세요.');
            console.log('파일 위치:', sqlPath);
            process.exit(1);
        }

        console.log('✅ updated_at 컬럼 추가 완료!');
        console.log('결과:', data);

        // 확인
        const { data: columns, error: checkError } = await supabase
            .from('reservation_cruise')
            .select('*')
            .limit(1);

        if (!checkError && columns && columns.length > 0) {
            console.log('\n📋 reservation_cruise 테이블 컬럼 확인:');
            console.log(Object.keys(columns[0]));
        }

    } catch (err) {
        console.error('❌ 오류 발생:', err);
        console.log('\n💡 Supabase 대시보드(https://supabase.com/dashboard)에서');
        console.log('   SQL Editor를 열고 add-updated-at-to-reservation-cruise.sql 파일의 내용을 붙여넣어 실행하세요.');
        process.exit(1);
    }
}

runSQL();
