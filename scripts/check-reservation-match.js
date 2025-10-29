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

async function checkReservationMatch() {
  console.log('🔍 reservation_cruise와 reservation 연결 확인\n');

  // 1. reservation_cruise 샘플
  const { data: cruiseData } = await supabase
    .from('reservation_cruise')
    .select('id, reservation_id, checkin')
    .limit(5);

  console.log('1️⃣ reservation_cruise 샘플:');
  cruiseData?.forEach(item => {
    console.log(`   - id: ${item.id}`);
    console.log(`     reservation_id: ${item.reservation_id}`);
    console.log(`     checkin: ${item.checkin}\n`);
  });

  // 2. 해당 reservation_id로 reservation 테이블 조회
  const reservationIds = cruiseData?.map(item => item.reservation_id) || [];
  
  const { data: matchedReservations } = await supabase
    .from('reservation')
    .select('re_id, re_type, re_status')
    .in('re_id', reservationIds);

  console.log(`\n2️⃣ 매칭되는 reservation 데이터: ${matchedReservations?.length || 0}개`);
  matchedReservations?.forEach(item => {
    console.log(`   - re_id: ${item.re_id}`);
    console.log(`     re_type: ${item.re_type}`);
    console.log(`     re_status: ${item.re_status}\n`);
  });

  // 3. 매칭 여부 확인
  const matched = reservationIds.filter(id => 
    matchedReservations?.some(r => r.re_id === id)
  );
  const unmatched = reservationIds.filter(id => 
    !matchedReservations?.some(r => r.re_id === id)
  );

  console.log(`\n3️⃣ 매칭 결과:`);
  console.log(`   ✅ 매칭: ${matched.length}개`);
  console.log(`   ❌ 불일치: ${unmatched.length}개`);
  
  if (unmatched.length > 0) {
    console.log(`\n   불일치하는 reservation_id:`);
    unmatched.forEach(id => console.log(`     - ${id}`));
  }
}

checkReservationMatch().catch(console.error);
