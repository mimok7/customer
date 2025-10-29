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

async function deleteAllData() {
  console.log('🗑️  데이터베이스 정리 시작\n');

  // 1. 현재 데이터 개수 확인
  console.log('1️⃣ 삭제 전 데이터 확인:');
  
  const [usersCount, reservationCount, cruiseCount] = await Promise.all([
    supabase.from('users').select('*', { count: 'exact', head: true }),
    supabase.from('reservation').select('*', { count: 'exact', head: true }),
    supabase.from('reservation_cruise').select('*', { count: 'exact', head: true })
  ]);

  console.log(`   - users: ${usersCount.count}개`);
  console.log(`   - reservation: ${reservationCount.count}개`);
  console.log(`   - reservation_cruise: ${cruiseCount.count}개\n`);

  // 2. 데이터 삭제
  console.log('2️⃣ 데이터 삭제 중...\n');

  // reservation_cruise 삭제
  const { error: cruiseError } = await supabase
    .from('reservation_cruise')
    .delete()
    .neq('id', '00000000-0000-0000-0000-000000000000');
  
  if (cruiseError) {
    console.error('   ❌ reservation_cruise 삭제 실패:', cruiseError.message);
  } else {
    console.log('   ✅ reservation_cruise 삭제 완료');
  }

  // reservation 삭제
  const { error: reservationError } = await supabase
    .from('reservation')
    .delete()
    .neq('re_id', '00000000-0000-0000-0000-000000000000');
  
  if (reservationError) {
    console.error('   ❌ reservation 삭제 실패:', reservationError.message);
  } else {
    console.log('   ✅ reservation 삭제 완료');
  }

  // users 삭제
  const { error: usersError } = await supabase
    .from('users')
    .delete()
    .neq('id', '00000000-0000-0000-0000-000000000000');
  
  if (usersError) {
    console.error('   ❌ users 삭제 실패:', usersError.message);
  } else {
    console.log('   ✅ users 삭제 완료');
  }

  // 3. 삭제 후 확인
  console.log('\n3️⃣ 삭제 후 데이터 확인:');
  
  const [usersCountAfter, reservationCountAfter, cruiseCountAfter] = await Promise.all([
    supabase.from('users').select('*', { count: 'exact', head: true }),
    supabase.from('reservation').select('*', { count: 'exact', head: true }),
    supabase.from('reservation_cruise').select('*', { count: 'exact', head: true })
  ]);

  console.log(`   - users: ${usersCountAfter.count}개`);
  console.log(`   - reservation: ${reservationCountAfter.count}개`);
  console.log(`   - reservation_cruise: ${cruiseCountAfter.count}개\n`);

  if (usersCountAfter.count === 0 && reservationCountAfter.count === 0 && cruiseCountAfter.count === 0) {
    console.log('✅ 모든 데이터가 성공적으로 삭제되었습니다!\n');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    console.log('📝 다음 단계:');
    console.log('   1. Supabase Dashboard → Table Editor');
    console.log('   2. CSV 파일 업로드 (순서 중요!):');
    console.log('      ① users 테이블 ← users-auth.csv');
    console.log('      ② reservation 테이블 ← reservations-auth.csv');
    console.log('      ③ reservation_cruise 테이블 ← reservation-cruise-auth.csv\n');
  } else {
    console.log('⚠️  일부 데이터가 남아있습니다. SQL Editor에서 수동 삭제가 필요할 수 있습니다.\n');
  }
}

deleteAllData().catch(console.error);
