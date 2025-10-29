require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  }
);

async function checkReservationConstraints() {
  console.log('🔍 reservation 테이블 제약 조건 확인\n');

  const { data, error } = await supabase.rpc('exec_sql', {
    sql: `
      SELECT 
        conname AS constraint_name,
        pg_get_constraintdef(c.oid) AS constraint_definition
      FROM pg_constraint c
      JOIN pg_namespace n ON n.oid = c.connamespace
      JOIN pg_class cl ON cl.oid = c.conrelid
      WHERE cl.relname = 'reservation'
        AND n.nspname = 'public'
        AND contype = 'c'
      ORDER BY conname;
    `
  });

  if (error) {
    console.error('❌ 오류:', error.message);
    console.log('\n대신 SQL 직접 실행:');
    console.log(`
SELECT 
  conname AS constraint_name,
  pg_get_constraintdef(c.oid) AS constraint_definition
FROM pg_constraint c
JOIN pg_namespace n ON n.oid = c.connamespace
JOIN pg_class cl ON cl.oid = c.conrelid
WHERE cl.relname = 'reservation'
  AND n.nspname = 'public'
  AND contype = 'c'
ORDER BY conname;
    `);
  } else {
    console.log('📋 Check Constraints:\n');
    data.forEach(row => {
      console.log(`✅ ${row.constraint_name}`);
      console.log(`   ${row.constraint_definition}\n`);
    });
  }
}

checkReservationConstraints().catch(console.error);
