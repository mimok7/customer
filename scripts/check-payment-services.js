const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

async function checkPaymentServices() {
    console.log('🔍 결제 서비스 데이터 확인 시작...\n');

    try {
        // 1. 결제 정보 조회
        const { data: payments, error: paymentError } = await supabase
            .from('reservation_payment')
            .select('id, reservation_id, amount, payment_status')
            .order('created_at', { ascending: false })
            .limit(5);

        if (paymentError) {
            console.error('결제 조회 실패:', paymentError);
            return;
        }

        console.log('📊 최근 결제 5건:');
        for (const payment of payments) {
            console.log(`- 결제 ID: ${payment.id}`);
            console.log(`  예약 ID: ${payment.reservation_id}`);
            console.log(`  금액: ${payment.amount?.toLocaleString() || 0}동`);
            console.log(`  상태: ${payment.payment_status}\n`);
        }

        // 2. 예약별 서비스 금액 확인
        const resIds = payments.map(p => p.reservation_id);
        if (resIds.length === 0) {
            console.log('⚠️ 확인할 예약이 없습니다.');
            return;
        }

        console.log('🔍 예약별 서비스 금액 확인...\n');

        // 각 서비스 테이블에서 데이터 조회
        const [
            cruiseData,
            cruiseCarData,
            airportData,
            hotelData,
            rentcarData,
            tourData
        ] = await Promise.all([
            supabase.from('reservation_cruise').select('*').in('reservation_id', resIds),
            supabase.from('reservation_cruise_car').select('*').in('reservation_id', resIds),
            supabase.from('reservation_airport').select('*').in('reservation_id', resIds),
            supabase.from('reservation_hotel').select('*').in('reservation_id', resIds),
            supabase.from('reservation_rentcar').select('*').in('reservation_id', resIds),
            supabase.from('reservation_tour').select('*').in('reservation_id', resIds)
        ]);

        console.log('📋 서비스 데이터 수집 결과:');
        console.log(`- 크루즈 객실: ${cruiseData.data?.length || 0}건`);
        console.log(`- 크루즈 차량: ${cruiseCarData.data?.length || 0}건`);
        console.log(`- 공항 서비스: ${airportData.data?.length || 0}건`);
        console.log(`- 호텔: ${hotelData.data?.length || 0}건`);
        console.log(`- 렌터카: ${rentcarData.data?.length || 0}건`);
        console.log(`- 투어: ${tourData.data?.length || 0}건\n`);

        // 3. 예약별 서비스 상세 분석
        for (const resId of resIds) {
            console.log(`📍 예약 ID: ${resId}`);
            let totalAmount = 0;
            const services = [];

            // 크루즈 객실 확인
            const cruise = cruiseData.data?.find(c => c.reservation_id === resId);
            if (cruise) {
                const roomAmount = Number(cruise.room_total_price || 0);
                const calcAmount = cruise.unit_price && cruise.guest_count
                    ? Number(cruise.unit_price) * Number(cruise.guest_count) : 0;
                const finalAmount = roomAmount || calcAmount;

                if (finalAmount > 0) {
                    services.push(`크루즈 객실: ${finalAmount.toLocaleString()}동`);
                    totalAmount += finalAmount;
                }

                console.log(`  - 크루즈 객실: room_total_price=${roomAmount}, unit_price=${cruise.unit_price}, guest_count=${cruise.guest_count}`);
            }

            // 크루즈 차량 확인
            const cruiseCar = cruiseCarData.data?.find(c => c.reservation_id === resId);
            if (cruiseCar) {
                const carAmount = Number(cruiseCar.car_total_price || 0);
                const calcAmount = cruiseCar.unit_price && cruiseCar.passenger_count
                    ? Number(cruiseCar.unit_price) * Number(cruiseCar.passenger_count) : 0;
                const finalAmount = carAmount || calcAmount;

                if (finalAmount > 0) {
                    services.push(`크루즈 차량: ${finalAmount.toLocaleString()}동`);
                    totalAmount += finalAmount;
                }

                console.log(`  - 크루즈 차량: car_total_price=${carAmount}, unit_price=${cruiseCar.unit_price}, passenger_count=${cruiseCar.passenger_count}`);
            }

            // 공항 서비스 확인
            const airport = airportData.data?.find(a => a.reservation_id === resId);
            if (airport && airport.total_price) {
                const amount = Number(airport.total_price);
                services.push(`공항 서비스: ${amount.toLocaleString()}동`);
                totalAmount += amount;
                console.log(`  - 공항 서비스: ${amount}동`);
            }

            // 호텔 서비스 확인
            const hotel = hotelData.data?.find(h => h.reservation_id === resId);
            if (hotel && hotel.total_price) {
                const amount = Number(hotel.total_price);
                services.push(`호텔: ${amount.toLocaleString()}동`);
                totalAmount += amount;
                console.log(`  - 호텔: ${amount}동`);
            }

            // 렌터카 서비스 확인
            const rentcar = rentcarData.data?.find(r => r.reservation_id === resId);
            if (rentcar && rentcar.total_price) {
                const amount = Number(rentcar.total_price);
                services.push(`렌터카: ${amount.toLocaleString()}동`);
                totalAmount += amount;
                console.log(`  - 렌터카: ${amount}동`);
            }

            // 투어 서비스 확인
            const tour = tourData.data?.find(t => t.reservation_id === resId);
            if (tour && tour.total_price) {
                const amount = Number(tour.total_price);
                services.push(`투어: ${amount.toLocaleString()}동`);
                totalAmount += amount;
                console.log(`  - 투어: ${amount}동`);
            }

            console.log(`  💰 계산된 총액: ${totalAmount.toLocaleString()}동`);
            console.log(`  📋 서비스 목록: ${services.length > 0 ? services.join(', ') : '없음'}\n`);
        }

    } catch (error) {
        console.error('❌ 오류 발생:', error);
    }
}

checkPaymentServices();
