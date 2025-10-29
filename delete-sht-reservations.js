// 스하(SHT) 예약 데이터 삭제 스크립트
// 작성일: 2025-10-27
// 실행 방법: node delete-sht-reservations.js

const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

async function deleteShtReservations() {
    console.log('🗑️ 스하(SHT) 예약 데이터 삭제 시작...\n');

    try {
        // 1단계: 삭제 전 데이터 확인
        console.log('📊 1단계: 삭제 전 데이터 확인');

        const { data: reservations, error: resError } = await supabase
            .from('reservation')
            .select('re_id, re_type, re_user_id, re_quote_id, re_created_at')
            .eq('re_type', 'sht');

        if (resError) {
            console.error('❌ reservation 조회 오류:', resError);
            return;
        }

        console.log(`   - reservation 테이블 (re_type='sht'): ${reservations?.length || 0}건`);

        if (reservations && reservations.length > 0) {
            console.log('\n   삭제될 예약 목록:');
            reservations.forEach((res, idx) => {
                console.log(`   ${idx + 1}. re_id: ${res.re_id}, quote_id: ${res.re_quote_id}, 생성일: ${res.re_created_at}`);
            });

            const reservationIds = reservations.map(r => r.re_id);

            // reservation_car_sht 확인
            const { data: carShtData, error: carShtError } = await supabase
                .from('reservation_car_sht')
                .select('id, reservation_id, vehicle_number, seat_number')
                .in('reservation_id', reservationIds);

            if (carShtError) {
                console.error('❌ reservation_car_sht 조회 오류:', carShtError);
            } else {
                console.log(`\n   - reservation_car_sht 테이블: ${carShtData?.length || 0}건`);
                if (carShtData && carShtData.length > 0) {
                    console.log('   관련 차량 데이터:');
                    carShtData.forEach((car, idx) => {
                        console.log(`   ${idx + 1}. 차량번호: ${car.vehicle_number || 'N/A'}, 좌석: ${car.seat_number || 'N/A'}`);
                    });
                }
            }

            // 사용자 확인 (실제로는 여기서 입력 받아야 함)
            console.log('\n⚠️ 위의 데이터를 삭제하시겠습니까?');
            console.log('   계속 진행하려면 코드에서 CONFIRM_DELETE를 true로 설정하세요.\n');

            const CONFIRM_DELETE = false; // 🔒 안전 잠금: true로 변경하여 실행

            if (!CONFIRM_DELETE) {
                console.log('❌ 삭제가 취소되었습니다. (CONFIRM_DELETE = false)');
                return;
            }

            // 2단계: reservation_car_sht 삭제
            console.log('\n🗑️ 2단계: reservation_car_sht 테이블 데이터 삭제...');
            const { error: deleteCarError } = await supabase
                .from('reservation_car_sht')
                .delete()
                .in('reservation_id', reservationIds);

            if (deleteCarError) {
                console.error('❌ reservation_car_sht 삭제 오류:', deleteCarError);
                return;
            }
            console.log('✅ reservation_car_sht 삭제 완료');

            // 3단계: reservation 삭제
            console.log('\n🗑️ 3단계: reservation 테이블 데이터 삭제...');
            const { error: deleteResError } = await supabase
                .from('reservation')
                .delete()
                .eq('re_type', 'sht');

            if (deleteResError) {
                console.error('❌ reservation 삭제 오류:', deleteResError);
                return;
            }
            console.log('✅ reservation 삭제 완료');

            // 4단계: 삭제 후 확인
            console.log('\n📊 4단계: 삭제 후 확인');
            const { data: remainingRes } = await supabase
                .from('reservation')
                .select('re_id')
                .eq('re_type', 'sht');

            const { data: remainingCar } = await supabase
                .from('reservation_car_sht')
                .select('id');

            console.log(`   - reservation 테이블 (re_type='sht'): ${remainingRes?.length || 0}건 남음`);
            console.log(`   - reservation_car_sht 테이블: ${remainingCar?.length || 0}건 남음`);

            console.log('\n✅ 스하(SHT) 예약 데이터 삭제 완료!');

        } else {
            console.log('\nℹ️ 삭제할 데이터가 없습니다.');
        }

    } catch (error) {
        console.error('❌ 예상치 못한 오류 발생:', error);
    }
}

// 실행
deleteShtReservations();
