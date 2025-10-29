require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

async function debugPaymentData() {
    console.log('🔍 결제 데이터 디버깅 시작...\n');

    try {
        // 1. 결제 정보 조회
        const { data: payments, error: payError } = await supabase
            .from('reservation_payment')
            .select('*')
            .limit(10);

        if (payError) {
            console.error('결제 데이터 조회 오류:', payError);
            return;
        }

        if (payments?.length) {
            console.log('💰 결제 데이터 샘플:');
            payments.forEach(p => {
                console.log(`  - ID: ${p.id}, 예약ID: ${p.reservation_id}, 금액: ${p.amount}동`);
            });

            // 2. 모든 금액이 있는 결제들 확인
            console.log('\n🔍 모든 결제별 서비스 확인:');
            for (const payment of payments.filter(p => p.amount > 0)) {
                const resId = payment.reservation_id;
                console.log(`\n예약 ID: ${resId} (금액: ${payment.amount.toLocaleString()}동)`);

                const [cruise, cruiseCar, airport, hotel, rentcar, tour] = await Promise.all([
                    supabase.from('reservation_cruise').select('reservation_id, room_total_price, unit_price, guest_count').eq('reservation_id', resId),
                    supabase.from('reservation_cruise_car').select('reservation_id, car_total_price, unit_price, passenger_count').eq('reservation_id', resId),
                    supabase.from('reservation_airport').select('reservation_id, total_price').eq('reservation_id', resId),
                    supabase.from('reservation_hotel').select('reservation_id, total_price').eq('reservation_id', resId),
                    supabase.from('reservation_rentcar').select('reservation_id, total_price').eq('reservation_id', resId),
                    supabase.from('reservation_tour').select('reservation_id, total_price').eq('reservation_id', resId)
                ]);

                let totalCalculated = 0;

                if (cruise.data?.length) {
                    const c = cruise.data[0];
                    let roomAmount = Number(c.room_total_price || 0);
                    if (roomAmount === 0 && c.unit_price && c.guest_count) {
                        roomAmount = Number(c.unit_price) * Number(c.guest_count);
                    }
                    if (roomAmount > 0) {
                        console.log(`  - 크루즈 객실: ${roomAmount.toLocaleString()}동`);
                        totalCalculated += roomAmount;
                    }
                }

                if (cruiseCar.data?.length) {
                    const cc = cruiseCar.data[0];
                    let carAmount = Number(cc.car_total_price || 0);
                    if (carAmount === 0 && cc.unit_price && cc.passenger_count) {
                        carAmount = Number(cc.unit_price) * Number(cc.passenger_count);
                    }
                    if (carAmount > 0) {
                        console.log(`  - 크루즈 차량: ${carAmount.toLocaleString()}동`);
                        totalCalculated += carAmount;
                    }
                }

                if (airport.data?.length && airport.data[0].total_price) {
                    const amount = Number(airport.data[0].total_price);
                    console.log(`  - 공항 서비스: ${amount.toLocaleString()}동`);
                    totalCalculated += amount;
                }

                if (hotel.data?.length && hotel.data[0].total_price) {
                    const amount = Number(hotel.data[0].total_price);
                    console.log(`  - 호텔: ${amount.toLocaleString()}동`);
                    totalCalculated += amount;
                }

                if (rentcar.data?.length && rentcar.data[0].total_price) {
                    const amount = Number(rentcar.data[0].total_price);
                    console.log(`  - 렌터카: ${amount.toLocaleString()}동`);
                    totalCalculated += amount;
                }

                if (tour.data?.length && tour.data[0].total_price) {
                    const amount = Number(tour.data[0].total_price);
                    console.log(`  - 투어: ${amount.toLocaleString()}동`);
                    totalCalculated += amount;
                }

                console.log(`  계산된 합계: ${totalCalculated.toLocaleString()}동`);
                console.log(`  저장된 금액: ${payment.amount.toLocaleString()}동`);
                console.log(`  차이: ${Math.abs(totalCalculated - payment.amount).toLocaleString()}동`);
            }

        } else {
            console.log('❌ 결제 데이터가 없습니다.');
        }
    } catch (error) {
        console.error('디버깅 실행 오류:', error);
    }
}

debugPaymentData();
