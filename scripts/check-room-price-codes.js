require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function checkRoomPriceCodes() {
    console.log('🔍 room_price 테이블 코드 조회\n');

    try {
        // room_price 테이블의 모든 코드 조회
        const { data: roomPrices, error } = await supabase
            .from('room_price')
            .select('*')
            .order('cruise', { ascending: true });

        if (error) {
            console.error('❌ 조회 실패:', error.message);
            return;
        }

        console.log(`✅ 총 ${roomPrices.length}개의 room_price 레코드 발견\n`);

        // 크루즈별로 그룹화
        const byCruise = {};
        roomPrices.forEach(rp => {
            const cruiseName = rp.cruise || '크루즈 정보 없음';
            if (!byCruise[cruiseName]) {
                byCruise[cruiseName] = [];
            }
            byCruise[cruiseName].push({
                room_code: rp.room_code,
                schedule: rp.schedule,
                room_category: rp.room_category,
                room_type: rp.room_type,
                price: rp.price || 0,
                start_date: rp.start_date,
                end_date: rp.end_date,
                payment: rp.payment
            });
        });

        // 출력
        console.log('============================================================');
        console.log('📋 크루즈별 객실 코드 목록');
        console.log('============================================================\n');

        Object.keys(byCruise).sort().forEach(cruiseName => {
            const rooms = byCruise[cruiseName];
            console.log(`\n🚢 ${cruiseName} (${rooms.length}개 객실)`);
            console.log('─'.repeat(60));

            rooms.forEach((room, idx) => {
                console.log(`   ${idx + 1}. ${room.room_code} - ${room.schedule || '일정없음'}`);
                console.log(`      └─ ${room.room_type || '타입없음'} / ${room.room_category || '카테고리없음'}`);
                console.log(`         기간: ${room.start_date || '미지정'} ~ ${room.end_date || '미지정'}`);
                console.log(`         가격: ${room.price?.toLocaleString()}원 (${room.payment || '결제조건없음'})`);
            });
        });

        console.log('\n============================================================');
        console.log('📊 통계');
        console.log('============================================================');
        console.log(`총 크루즈: ${Object.keys(byCruise).length}개`);
        console.log(`총 객실코드: ${roomPrices.length}개`);
        console.log('');

        // 코드만 추출하여 파일로 저장
        const codes = roomPrices.map(rp => rp.room_code);
        const fs = require('fs');
        fs.writeFileSync('room-price-codes.json', JSON.stringify({
            total: codes.length,
            codes: codes,
            by_cruise: byCruise,
            all_records: roomPrices
        }, null, 2));

        console.log('✅ room-price-codes.json 파일에 저장됨\n');

    } catch (error) {
        console.error('❌ 오류:', error);
    }
}

checkRoomPriceCodes();
