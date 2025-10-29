// CSV 파일 간 reservation_id 매칭 확인
const fs = require('fs');

console.log('📋 CSV 파일 간 reservation_id 매칭 확인\n');

// reservations.csv 읽기
const resLines = fs.readFileSync('reservations.csv', 'utf8').split('\n');
const resIds = new Set();

for (let i = 1; i < resLines.length; i++) {
    const line = resLines[i].trim();
    if (!line) continue;
    const cols = line.split(',');
    if (cols[0]) {
        resIds.add(cols[0]);
    }
}

console.log('✅ reservations.csv의 re_id:', resIds.size, '개');

// reservation_cruise.csv 읽기 (복잡한 파싱)
const cruiseContent = fs.readFileSync('reservation_cruise.csv', 'utf8');
const cruiseLines = cruiseContent.split('\n');
const cruiseResIds = [];

for (let i = 1; i < cruiseLines.length; i++) {
    const line = cruiseLines[i];
    if (!line.trim()) continue;

    // 첫 번째 쉼표와 두 번째 쉼표 사이가 reservation_id
    const firstComma = line.indexOf(',');
    const secondComma = line.indexOf(',', firstComma + 1);

    if (firstComma > 0 && secondComma > firstComma) {
        const reservationId = line.substring(firstComma + 1, secondComma);
        if (reservationId && reservationId.length === 36) {  // UUID 길이
            cruiseResIds.push(reservationId);
        }
    }
}

console.log('✅ reservation_cruise.csv의 reservation_id:', cruiseResIds.length, '개');

// 매칭 확인
const cruiseResIdSet = new Set(cruiseResIds);
console.log('✅ 고유한 reservation_id:', cruiseResIdSet.size, '개');

const missing = [];
cruiseResIds.forEach(id => {
    if (!resIds.has(id)) {
        missing.push(id);
    }
});

console.log('\n🔍 결과:');
if (missing.length === 0) {
    console.log('✅ 모든 reservation_id가 매칭됩니다!');
} else {
    console.log(`❌ 매칭되지 않는 reservation_id: ${missing.length}개`);
    console.log('샘플:', missing.slice(0, 5));
}

// 샘플 확인
console.log('\n📊 샘플 데이터:');
console.log('reservations.csv 첫 3개 re_id:');
[...resIds].slice(0, 3).forEach(id => console.log('  -', id));

console.log('\nreservation_cruise.csv 첫 3개 reservation_id:');
cruiseResIds.slice(0, 3).forEach(id => console.log('  -', id));
