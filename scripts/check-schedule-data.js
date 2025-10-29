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

async function checkScheduleData() {
  console.log('🔍 스케줄 페이지 데이터 확인\n');

  // 1. reservation_cruise 데이터 확인
  const { data: cruiseData, error: cruiseError } = await supabase
    .from('reservation_cruise')
    .select('*')
    .limit(5);

  console.log('1️⃣ reservation_cruise 테이블:');
  if (cruiseError) {
    console.error('   ❌ 오류:', cruiseError.message);
  } else {
    console.log(`   ✅ 총 ${cruiseData?.length || 0}개 (샘플)`);
    if (cruiseData && cruiseData.length > 0) {
      console.log('   샘플 데이터:');
      cruiseData.slice(0, 2).forEach(item => {
        console.log(`     - reservation_id: ${item.reservation_id}`);
        console.log(`       checkin: ${item.checkin}`);
        console.log(`       room_price_code: ${item.room_price_code}`);
      });
    }
  }

  // 2. reservation 테이블 확인
  const { data: reservationData, error: reservationError } = await supabase
    .from('reservation')
    .select('re_id, re_type, re_status, re_user_id')
    .limit(5);

  console.log('\n2️⃣ reservation 테이블:');
  if (reservationError) {
    console.error('   ❌ 오류:', reservationError.message);
  } else {
    console.log(`   ✅ 총 ${reservationData?.length || 0}개 (샘플)`);
    if (reservationData && reservationData.length > 0) {
      console.log('   샘플 데이터:');
      reservationData.slice(0, 2).forEach(item => {
        console.log(`     - re_id: ${item.re_id}`);
        console.log(`       re_type: ${item.re_type}`);
        console.log(`       re_status: ${item.re_status}`);
        console.log(`       re_user_id: ${item.re_user_id}`);
      });
    }
  }

  // 3. users 테이블 확인
  const { data: usersData, error: usersError } = await supabase
    .from('users')
    .select('id, name, email')
    .limit(5);

  console.log('\n3️⃣ users 테이블:');
  if (usersError) {
    console.error('   ❌ 오류:', usersError.message);
  } else {
    console.log(`   ✅ 총 ${usersData?.length || 0}개 (샘플)`);
    if (usersData && usersData.length > 0) {
      console.log('   샘플 데이터:');
      usersData.slice(0, 2).forEach(item => {
        console.log(`     - id: ${item.id}`);
        console.log(`       name: ${item.name}`);
        console.log(`       email: ${item.email}`);
      });
    }
  }

  // 4. 오늘 날짜 기준 데이터 조회 (스케줄 페이지와 동일한 조회)
  const today = new Date();
  const startDate = new Date(today);
  startDate.setHours(0, 0, 0, 0);
  const endDate = new Date(today);
  endDate.setHours(23, 59, 59, 999);

  console.log(`\n4️⃣ 오늘(${today.toLocaleDateString('ko-KR')}) 기준 데이터 조회:`);
  
  const { data: todayCruise, error: todayError } = await supabase
    .from('reservation_cruise')
    .select('*, reservation_id')
    .gte('checkin', startDate.toISOString().slice(0, 10))
    .lte('checkin', endDate.toISOString().slice(0, 10));

  if (todayError) {
    console.error('   ❌ 오류:', todayError.message);
  } else {
    console.log(`   ✅ 오늘 크루즈 예약: ${todayCruise?.length || 0}개`);
  }

  // 5. 전체 기간 데이터 확인 (2025년 전체)
  const { data: allCruise2025 } = await supabase
    .from('reservation_cruise')
    .select('checkin')
    .gte('checkin', '2025-01-01')
    .lte('checkin', '2025-12-31')
    .order('checkin', { ascending: true });

  console.log(`\n5️⃣ 2025년 크루즈 예약: ${allCruise2025?.length || 0}개`);
  if (allCruise2025 && allCruise2025.length > 0) {
    const dates = allCruise2025.map(item => item.checkin).filter((v, i, a) => a.indexOf(v) === i);
    console.log(`   날짜 범위: ${dates[0]} ~ ${dates[dates.length - 1]}`);
    console.log(`   첫 5개 날짜: ${dates.slice(0, 5).join(', ')}`);
  }
}

checkScheduleData().catch(console.error);
