const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

async function checkReservationData() {
    console.log('🔍 예약 데이터 확인 시작...');

    try {
        // 1. 최근 견적들 조회
        const { data: quotes, error: quotesError } = await supabase
            .from('quote')
            .select('quote_id, title, user_name, total_price')
            .order('created_at', { ascending: false })
            .limit(5);

        if (quotesError) {
            console.error('❌ 견적 조회 실패:', quotesError);
            return;
        }

        console.log('📋 최근 견적 5개:', quotes);

        // 2. 각 견적별 예약 확인
        for (const quote of quotes) {
            console.log(`\n🔍 견적 ${quote.quote_id} (${quote.title}) 예약 확인:`);

            const { data: reservations, error: resError } = await supabase
                .from('reservation')
                .select('re_id, re_type, re_status')
                .eq('re_quote_id', quote.quote_id);

            if (resError) {
                console.error('❌ 예약 조회 실패:', resError);
                continue;
            }

            console.log(`  📋 예약 ${reservations?.length || 0}개:`, reservations);

            // 3. 예약이 있다면 상세 데이터 확인
            if (reservations && reservations.length > 0) {
                for (const res of reservations) {
                    console.log(`    🔍 예약 ${res.re_id} (${res.re_type}) 상세 확인:`);

                    // 타입별 상세 테이블 확인
                    let detailTable = '';
                    let detailData = null;

                    switch (res.re_type) {
                        case 'cruise':
                            detailTable = 'reservation_cruise';
                            break;
                        case 'airport':
                            detailTable = 'reservation_airport';
                            break;
                        case 'hotel':
                            detailTable = 'reservation_hotel';
                            break;
                        case 'rentcar':
                            detailTable = 'reservation_rentcar';
                            break;
                        case 'tour':
                            detailTable = 'reservation_tour';
                            break;
                        case 'sht':
                            detailTable = 'reservation_car_sht';
                            break;
                    }

                    if (detailTable) {
                        const { data: details, error: detailError } = await supabase
                            .from(detailTable)
                            .select('*')
                            .eq('reservation_id', res.re_id);

                        if (detailError) {
                            console.error(`    ❌ ${detailTable} 조회 실패:`, detailError);
                        } else {
                            console.log(`    ✅ ${detailTable} 데이터:`, details);
                        }
                    }
                }
            }
        }

    } catch (error) {
        console.error('❌ 전체 확인 실패:', error);
    }
}

checkReservationData();
