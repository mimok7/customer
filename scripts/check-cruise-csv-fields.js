// reservation_cruise.csv의 request_note 확인
const fs = require('fs');

const lines = fs.readFileSync('reservation_cruise.csv', 'utf8').split('\n');

console.log('📋 reservation_cruise.csv 분석\n');
console.log('총 행:', lines.length - 1);

let hasRequestNotes = 0;
let hasBoardingCode = 0;
let hasBoardingAssist = 0;

for (let i = 1; i < Math.min(50, lines.length); i++) {
    if (!lines[i].trim()) continue;

    const cols = lines[i].split(',');
    const requestNote = cols[7] || '';
    const boardingCode = cols[8] || '';
    const boardingAssist = cols[9] || '';

    if (requestNote && requestNote.length > 10) hasRequestNotes++;
    if (boardingCode && boardingCode !== 'TBA') hasBoardingCode++;
    if (boardingAssist === 'true') hasBoardingAssist++;

    // 요청사항이 길거나 특별한 내용이 있는 경우 출력
    if (i <= 10 || (requestNote && requestNote.includes('요청사항'))) {
        console.log(`\n🔍 Row ${i}:`);
        console.log('  request_note:', requestNote.substring(0, 150));
        console.log('  boarding_code:', boardingCode);
        console.log('  boarding_assist:', boardingAssist);
    }
}

console.log('\n\n📊 통계:');
console.log(`  request_note 있음: ${hasRequestNotes}개`);
console.log(`  boarding_code 있음: ${hasBoardingCode}개 (TBA 제외)`);
console.log(`  boarding_assist=true: ${hasBoardingAssist}개`);
