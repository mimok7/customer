#!/usr/bin/env node

/**
 * room_price 테이블 전체 데이터 조회 (페이징 처리)
 */

const { createClient } = require('@supabase/supabase-js');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function fetchAllRoomPrices() {
    console.log('📥 전체 room_price 데이터 조회 중...');

    let allData = [];
    let page = 0;
    const pageSize = 1000;
    let hasMore = true;

    while (hasMore) {
        const { data, error } = await supabase
            .from('room_price')
            .select('*')
            .range(page * pageSize, (page + 1) * pageSize - 1);

        if (error) {
            console.error('   ❌ 조회 실패:', error.message);
            throw error;
        }

        if (data && data.length > 0) {
            allData = allData.concat(data);
            console.log(`   페이지 ${page + 1}: ${data.length}개 조회 (누적: ${allData.length}개)`);
            page++;

            if (data.length < pageSize) {
                hasMore = false;
            }
        } else {
            hasMore = false;
        }
    }

    console.log(`   ✅ 총 ${allData.length}개 데이터 조회 완료\n`);
    return allData;
}

async function main() {
    console.log('🔍 room_price 테이블 전체 분석 (페이징 처리)\n');

    try {
        const allRoomPrices = await fetchAllRoomPrices();

        // 크루즈 종류 분석
        console.log('📊 크루즈 종류 분석');
        const cruises = allRoomPrices.map(p => p.cruise).filter(Boolean);
        const uniqueCruises = [...new Set(cruises)];

        console.log(`   - 고유 크루즈 개수: ${uniqueCruises.length}개`);
        console.log(`   - 크루즈 목록:`);

        const cruiseCount = {};
        cruises.forEach(cruise => {
            cruiseCount[cruise] = (cruiseCount[cruise] || 0) + 1;
        });

        Object.entries(cruiseCount)
            .sort((a, b) => b[1] - a[1])
            .forEach(([cruise, count], idx) => {
                console.log(`     ${idx + 1}. ${cruise}: ${count}개 가격 옵션`);
            });

        // 객실종류 분석
        console.log('\n📊 객실종류 분석');
        const roomTypes = allRoomPrices.map(p => p.room_type).filter(Boolean);
        const uniqueRoomTypes = [...new Set(roomTypes)];

        console.log(`   - 고유 객실종류 개수: ${uniqueRoomTypes.length}개`);

        // 날짜 범위
        console.log('\n📊 날짜 범위 분석');
        const startDates = allRoomPrices.map(p => p.start_date).filter(Boolean).sort();
        const endDates = allRoomPrices.map(p => p.end_date).filter(Boolean).sort();

        if (startDates.length > 0 && endDates.length > 0) {
            console.log(`   - 시작 날짜 범위: ${startDates[0]} ~ ${startDates[startDates.length - 1]}`);
            console.log(`   - 종료 날짜 범위: ${endDates[0]} ~ ${endDates[endDates.length - 1]}`);
        }

        // 가격 범위
        console.log('\n📊 가격 범위 분석');
        const prices = allRoomPrices.map(p => p.price).filter(p => p != null && p > 0);
        if (prices.length > 0) {
            const minPrice = Math.min(...prices);
            const maxPrice = Math.max(...prices);
            const avgPrice = prices.reduce((sum, p) => sum + p, 0) / prices.length;

            console.log(`   - 최소 가격: ${minPrice.toLocaleString()}동`);
            console.log(`   - 최대 가격: ${maxPrice.toLocaleString()}동`);
            console.log(`   - 평균 가격: ${Math.round(avgPrice).toLocaleString()}동`);
        }

        // 전체 크루즈 목록 저장
        const cruiseList = {
            totalRecords: allRoomPrices.length,
            uniqueCruises: uniqueCruises.length,
            cruises: Object.entries(cruiseCount)
                .sort((a, b) => b[1] - a[1])
                .map(([cruise, count]) => ({ cruise, count })),
            uniqueRoomTypes: uniqueRoomTypes.length,
            generatedAt: new Date().toISOString()
        };

        const outputPath = path.join(__dirname, 'room-price-cruises.json');
        fs.writeFileSync(outputPath, JSON.stringify(cruiseList, null, 2));
        console.log(`\n✅ 크루즈 목록 저장: ${outputPath}`);

        console.log(`\n💡 요약:`);
        console.log(`   - 총 ${allRoomPrices.length}개 가격 데이터`);
        console.log(`   - ${uniqueCruises.length}개 크루즈`);
        console.log(`   - ${uniqueRoomTypes.length}개 객실 종류`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
