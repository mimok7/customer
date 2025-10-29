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

async function checkScheduleJoin() {
  console.log('🔍 Schedule 페이지 조인 문제 확인\n');

  const today = new Date();
  const start = new Date(today);
  start.setHours(0, 0, 0, 0);
  const end = new Date(today);
  end.setHours(23, 59, 59, 999);

  console.log(`오늘: ${today.toISOString().slice(0, 10)}\n`);

  // 1. reservation_cruise 데이터 조회 (schedule 페이지와 동일)
  const { data: cruiseRes } = await supabase
    .from('reservation_cruise')
    .select('*, reservation_id')
    .gte('checkin', start.toISOString().slice(0, 10))
    .lte('checkin', end.toISOString().slice(0, 10));

  console.log(`1️⃣ reservation_cruise 조회: ${cruiseRes?.length || 0}개\n`);

  if (!cruiseRes || cruiseRes.length === 0) {
    console.log('   데이터 없음');
    return;
  }

  // 2. reservation_id 목록 추출
  const reservationIds = Array.from(
    new Set(cruiseRes.map(r => r.reservation_id).filter(Boolean))
  );

  console.log(`2️⃣ reservation_id 목록: ${reservationIds.length}개`);
  console.log(`   샘플: ${reservationIds.slice(0, 3).join(', ')}\n`);

  // 3. reservation 테이블에서 조회
  const { data: reservationsData, error: resErr } = await supabase
    .from('reservation')
    .select('re_id, re_type, re_status, re_user_id')
    .in('re_id', reservationIds);

  console.log(`3️⃣ reservation 테이블 조회:`);
  if (resErr) {
    console.error(`   ❌ 오류: ${resErr.message}`);
  } else {
    console.log(`   ✅ 결과: ${reservationsData?.length || 0}개`);
    
    if (reservationsData && reservationsData.length > 0) {
      console.log(`\n   샘플 데이터:`);
      reservationsData.slice(0, 2).forEach(r => {
        console.log(`     - re_id: ${r.re_id}`);
        console.log(`       re_type: ${r.re_type}`);
        console.log(`       re_status: ${r.re_status}`);
        console.log(`       re_user_id: ${r.re_user_id}\n`);
      });
    }
  }

  // 4. 매칭 확인
  const matched = reservationIds.filter(id =>
    reservationsData?.some(r => r.re_id === id)
  );

  console.log(`4️⃣ 매칭 결과:`);
  console.log(`   ✅ 매칭: ${matched.length}/${reservationIds.length}개`);
  console.log(`   ❌ 불일치: ${reservationIds.length - matched.length}개\n`);

  if (matched.length === 0) {
    console.log('⚠️  경고: reservation 테이블과 매칭되는 데이터가 없습니다!');
    console.log('   → Schedule 페이지에 데이터가 표시되지 않는 원인\n');
    
    // reservation 테이블의 실제 데이터 확인
    const { data: actualReservations } = await supabase
      .from('reservation')
      .select('re_id')
      .limit(5);
    
    console.log('5️⃣ reservation 테이블의 실제 데이터 (샘플):');
    actualReservations?.forEach(r => {
      console.log(`   - ${r.re_id}`);
    });
  }
}

checkScheduleJoin().catch(console.error);
