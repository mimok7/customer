#!/usr/bin/env node

/**
 * room_price 테이블 전체 점검
 * 총 데이터 수, 크루즈 종류, 객실 타입 등 상세 분석
 */

const { createClient } = require('@supabase/supabase-js');
const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function main() {
    console.log('🔍 room_price 테이블 전체 점검 시작\n');

    try {
        // 1. 전체 데이터 조회
        console.log('📊 Step 1: 전체 데이터 조회');
        const { data: allRoomPrices, error, count } = await supabase
            .from('room_price')
            .select('*', { count: 'exact' });

        if (error) {
            console.error('   ❌ room_price 조회 실패:', error.message);
            process.exit(1);
        }

        console.log(`   ✅ 총 데이터 개수: ${allRoomPrices.length}개\n`);

        // 2. 크루즈 종류 분석
        console.log('📊 Step 2: 크루즈 종류 분석');
        const cruises = allRoomPrices.map(p => p.cruise).filter(Boolean);
        const uniqueCruises = [...new Set(cruises)];

        console.log(`   - 고유 크루즈 개수: ${uniqueCruises.length}개`);
        console.log(`   - 크루즈 목록:`);

        uniqueCruises.sort().forEach((cruise, idx) => {
            const count = cruises.filter(c => c === cruise).length;
            console.log(`     ${idx + 1}. ${cruise}: ${count}개 가격 옵션`);
        });

        // 3. 객실종류 분석
        console.log('\n📊 Step 3: 객실종류 분석');
        const roomTypes = allRoomPrices.map(p => p.room_type).filter(Boolean);
        const uniqueRoomTypes = [...new Set(roomTypes)];

        console.log(`   - 고유 객실종류 개수: ${uniqueRoomTypes.length}개`);
        console.log(`   - 주요 객실종류 (상위 20개):`);

        const roomTypeCount = {};
        roomTypes.forEach(type => {
            roomTypeCount[type] = (roomTypeCount[type] || 0) + 1;
        });

        const sortedRoomTypes = Object.entries(roomTypeCount)
            .sort((a, b) => b[1] - a[1])
            .slice(0, 20);

        sortedRoomTypes.forEach(([type, count], idx) => {
            console.log(`     ${idx + 1}. ${type}: ${count}개`);
        });

        // 4. room_category 분석
        console.log('\n📊 Step 4: 객실 카테고리 분석');
        const categories = allRoomPrices.map(p => p.room_category).filter(Boolean);
        const uniqueCategories = [...new Set(categories)];

        console.log(`   - 고유 카테고리 개수: ${uniqueCategories.length}개`);
        uniqueCategories.forEach((category, idx) => {
            const count = categories.filter(c => c === category).length;
            console.log(`     ${idx + 1}. ${category}: ${count}개`);
        });

        // 5. 날짜 범위 분석
        console.log('\n📊 Step 5: 날짜 범위 분석');
        const startDates = allRoomPrices.map(p => p.start_date).filter(Boolean).sort();
        const endDates = allRoomPrices.map(p => p.end_date).filter(Boolean).sort();

        console.log(`   - 시작 날짜 범위: ${startDates[0]} ~ ${startDates[startDates.length - 1]}`);
        console.log(`   - 종료 날짜 범위: ${endDates[0]} ~ ${endDates[endDates.length - 1]}`);

        // 6. 가격 범위 분석
        console.log('\n📊 Step 6: 가격 범위 분석');
        const prices = allRoomPrices.map(p => p.price).filter(p => p != null);
        const minPrice = Math.min(...prices);
        const maxPrice = Math.max(...prices);
        const avgPrice = prices.reduce((sum, p) => sum + p, 0) / prices.length;

        console.log(`   - 최소 가격: ${minPrice.toLocaleString()}동`);
        console.log(`   - 최대 가격: ${maxPrice.toLocaleString()}동`);
        console.log(`   - 평균 가격: ${Math.round(avgPrice).toLocaleString()}동`);

        // 7. schedule 분석
        console.log('\n📊 Step 7: 일정 분석');
        const schedules = allRoomPrices.map(p => p.schedule).filter(Boolean);
        const uniqueSchedules = [...new Set(schedules)];

        console.log(`   - 일정 종류: ${uniqueSchedules.length}개`);
        uniqueSchedules.forEach((schedule, idx) => {
            const count = schedules.filter(s => s === schedule).length;
            console.log(`     ${idx + 1}. ${schedule}: ${count}개`);
        });

        // 8. payment 분석
        console.log('\n📊 Step 8: 결제방식 분석');
        const payments = allRoomPrices.map(p => p.payment).filter(Boolean);
        const uniquePayments = [...new Set(payments)];

        console.log(`   - 결제방식 종류: ${uniquePayments.length}개`);
        uniquePayments.forEach((payment, idx) => {
            const count = payments.filter(p => p === payment).length;
            console.log(`     ${idx + 1}. ${payment}: ${count}개`);
        });

        // 9. 크루즈별 상세 통계
        console.log('\n📊 Step 9: 크루즈별 상세 통계');
        uniqueCruises.forEach(cruise => {
            const cruiseData = allRoomPrices.filter(p => p.cruise === cruise);
            const cruiseRoomTypes = [...new Set(cruiseData.map(p => p.room_type))];
            const cruisePrices = cruiseData.map(p => p.price).filter(p => p != null);
            const minCruisePrice = Math.min(...cruisePrices);
            const maxCruisePrice = Math.max(...cruisePrices);

            console.log(`\n   ${cruise}:`);
            console.log(`     - 가격 옵션 수: ${cruiseData.length}개`);
            console.log(`     - 객실 종류: ${cruiseRoomTypes.length}개`);
            console.log(`     - 가격 범위: ${minCruisePrice.toLocaleString()}동 ~ ${maxCruisePrice.toLocaleString()}동`);
            console.log(`     - 주요 객실 타입 (상위 5개):`);

            const cruiseRoomTypeCount = {};
            cruiseData.forEach(p => {
                const type = p.room_type;
                cruiseRoomTypeCount[type] = (cruiseRoomTypeCount[type] || 0) + 1;
            });

            Object.entries(cruiseRoomTypeCount)
                .sort((a, b) => b[1] - a[1])
                .slice(0, 5)
                .forEach(([type, count]) => {
                    console.log(`        - ${type}: ${count}개`);
                });
        });

        // 10. room_code 분석
        console.log('\n📊 Step 10: room_code 분석');
        const roomCodes = allRoomPrices.map(p => p.room_code).filter(Boolean);
        const uniqueRoomCodes = [...new Set(roomCodes)];

        console.log(`   - 총 room_code 개수: ${uniqueRoomCodes.length}개`);
        console.log(`   - room_code 샘플 (처음 10개):`);
        uniqueRoomCodes.slice(0, 10).forEach((code, idx) => {
            console.log(`     ${idx + 1}. ${code}`);
        });

        console.log('\n✅ room_price 테이블 점검 완료');
        console.log(`\n💡 요약:`);
        console.log(`   - 총 ${allRoomPrices.length}개 가격 데이터`);
        console.log(`   - ${uniqueCruises.length}개 크루즈`);
        console.log(`   - ${uniqueRoomTypes.length}개 객실 종류`);
        console.log(`   - ${uniqueRoomCodes.length}개 고유 room_code`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
