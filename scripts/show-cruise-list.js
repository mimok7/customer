const fs = require('fs');
const data = JSON.parse(fs.readFileSync('room-price-codes.json', 'utf8'));

console.log('🚢 크루즈 목록:');
console.log('='.repeat(60));

Object.keys(data.by_cruise).forEach(cruiseName => {
    const rooms = data.by_cruise[cruiseName];
    console.log(`\n${cruiseName}: ${rooms.length}개 객실`);

    // 샘플 객실 3개 출력
    rooms.slice(0, 3).forEach((room, idx) => {
        console.log(`  ${idx + 1}. ${room.room_code} - ${room.room_type} / ${room.room_category}`);
        console.log(`     일정: ${room.schedule}, 기간: ${room.start_date} ~ ${room.end_date}`);
    });
});
