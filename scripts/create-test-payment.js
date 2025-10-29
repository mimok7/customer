const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

async function createTestPaymentData() {
    console.log('🔍 실제 금액 있는 결제로 새로운 테스트 결제 생성...\n');

    try {
        // 실제 금액이 있는 예약 중 하나를 선택
        const testReservationId = '4e3aed92-1c07-4a53-9a67-27a538be2786'; // 17,100,000원 크루즈

        // 해당 예약의 실제 서비스 데이터 확인
        const [cruiseData, cruiseCarData, airportData] = await Promise.all([
            supabase.from('reservation_cruise').select('*').eq('reservation_id', testReservationId),
            supabase.from('reservation_cruise_car').select('*').eq('reservation_id', testReservationId),
            supabase.from('reservation_airport').select('*').eq('reservation_id', testReservationId)
        ]);

        console.log('📊 선택된 예약의 서비스 데이터:');
        console.log('크루즈 객실:', cruiseData.data?.length || 0, '건');
        cruiseData.data?.forEach((c, idx) => {
            const amount = Number(c.room_total_price || 0) || (Number(c.unit_price || 0) * Number(c.guest_count || 0));
            console.log(`  [${idx + 1}] ${c.room_price_code}: ${amount.toLocaleString()}동 (${c.guest_count}명)`);
        });

        console.log('크루즈 차량:', cruiseCarData.data?.length || 0, '건');
        cruiseCarData.data?.forEach((c, idx) => {
            const amount = Number(c.car_total_price || 0) || (Number(c.unit_price || 0) * Number(c.passenger_count || 0));
            console.log(`  [${idx + 1}] ${c.car_price_code}: ${amount.toLocaleString()}동 (${c.passenger_count}명)`);
        });

        console.log('공항 서비스:', airportData.data?.length || 0, '건');

        // 총 금액 계산
        let totalAmount = 0;

        // 크루즈 객실 금액
        cruiseData.data?.forEach(c => {
            const amount = Number(c.room_total_price || 0) || (Number(c.unit_price || 0) * Number(c.guest_count || 0));
            totalAmount += amount;
        });

        // 크루즈 차량 금액
        cruiseCarData.data?.forEach(c => {
            const amount = Number(c.car_total_price || 0) || (Number(c.unit_price || 0) * Number(c.passenger_count || 0));
            totalAmount += amount;
        });

        console.log(`\n💰 계산된 총 금액: ${totalAmount.toLocaleString()}동`);

        // 해당 예약의 사용자 ID 찾기
        const { data: reservation } = await supabase
            .from('reservation')
            .select('re_user_id')
            .eq('re_id', testReservationId)
            .maybeSingle();

        if (!reservation) {
            console.log('❌ 예약 정보를 찾을 수 없습니다.');
            return;
        }

        console.log(`\n🆔 사용자 ID: ${reservation.re_user_id}`);

        // 새로운 테스트 결제 생성 (실제 계산된 금액으로)
        const { data: newPayment, error } = await supabase
            .from('reservation_payment')
            .insert({
                reservation_id: testReservationId,
                user_id: reservation.re_user_id,
                amount: totalAmount,
                payment_method: 'CARD',
                payment_status: 'pending',
                memo: '[테스트] 실제 서비스 금액 기반 결제'
            })
            .select()
            .single();

        if (error) {
            console.error('❌ 결제 생성 실패:', error);
            return;
        }

        console.log('\n✅ 테스트 결제 생성 완료:');
        console.log(`   결제 ID: ${newPayment.id}`);
        console.log(`   금액: ${newPayment.amount.toLocaleString()}동`);
        console.log(`   상태: ${newPayment.payment_status}`);

    } catch (error) {
        console.error('❌ 오류 발생:', error);
    }
}

createTestPaymentData();
