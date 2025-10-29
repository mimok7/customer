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

async function checkTodaySchedule() {
  console.log('🔍 오늘 날짜 스케줄 데이터 확인\n');

  const today = new Date();
  const start = new Date(today);
  start.setHours(0, 0, 0, 0);
  const end = new Date(today);
  end.setHours(23, 59, 59, 999);

  console.log(`오늘 날짜: ${today.toLocaleDateString('ko-KR')}`);
  console.log(`조회 범위: ${start.toISOString().slice(0, 10)} ~ ${end.toISOString().slice(0, 10)}\n`);

  // 오늘 날짜로 크루즈 예약 조회
  const { data: todayCruise, error } = await supabase
    .from('reservation_cruise')
    .select('*, reservation_id')
    .gte('checkin', start.toISOString().slice(0, 10))
    .lte('checkin', end.toISOString().slice(0, 10));

  console.log(`1️⃣ 오늘(${today.toISOString().slice(0, 10)}) 크루즈 예약: ${todayCruise?.length || 0}개`);

  if (todayCruise && todayCruise.length > 0) {
    console.log('\n   샘플 데이터:');
    todayCruise.slice(0, 3).forEach(item => {
      console.log(`     - checkin: ${item.checkin}`);
      console.log(`       reservation_id: ${item.reservation_id}`);
      console.log(`       room_price_code: ${item.room_price_code}\n`);
    });
  }

  // 가장 가까운 미래 예약 찾기
  const { data: futureCruise } = await supabase
    .from('reservation_cruise')
    .select('checkin')
    .gte('checkin', today.toISOString().slice(0, 10))
    .order('checkin', { ascending: true })
    .limit(5);

  console.log(`\n2️⃣ 오늘 이후 가장 가까운 크루즈 예약:`);
  if (futureCruise && futureCruise.length > 0) {
    futureCruise.forEach(item => {
      console.log(`   - ${item.checkin}`);
    });
  } else {
    console.log('   없음 (모든 예약이 과거)');
  }

  // 10월 15일 전후 데이터 확인
  const { data: oct15 } = await supabase
    .from('reservation_cruise')
    .select('checkin')
    .gte('checkin', '2025-10-14')
    .lte('checkin', '2025-10-16')
    .order('checkin');

  console.log(`\n3️⃣ 10월 14~16일 크루즈 예약: ${oct15?.length || 0}개`);
  if (oct15 && oct15.length > 0) {
    oct15.forEach(item => {
      console.log(`   - ${item.checkin}`);
    });
  }

  // 전체 예약 날짜 범위
  const { data: allDates } = await supabase
    .from('reservation_cruise')
    .select('checkin')
    .order('checkin', { ascending: true });

  if (allDates && allDates.length > 0) {
    const dates = allDates.map(item => item.checkin);
    const uniqueDates = Array.from(new Set(dates));
    console.log(`\n4️⃣ 전체 예약 날짜 범위:`);
    console.log(`   최초: ${uniqueDates[0]}`);
    console.log(`   최종: ${uniqueDates[uniqueDates.length - 1]}`);
    console.log(`   총 ${allDates.length}개 예약, ${uniqueDates.length}개의 날짜`);
  }
}

checkTodaySchedule().catch(console.error);
