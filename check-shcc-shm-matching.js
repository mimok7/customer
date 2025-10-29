const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const dotenv = require('dotenv');

try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

const GOOGLE_SHEETS_ID = process.env.GOOGLE_SHEETS_ID;
const GOOGLE_SERVICE_ACCOUNT = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const GOOGLE_SERVICE_KEY = process.env.GOOGLE_SERVICE_ACCOUNT_KEY;

async function getSheetsClient() {
    const auth = new GoogleAuth({
        credentials: {
            client_email: GOOGLE_SERVICE_ACCOUNT,
            private_key: GOOGLE_SERVICE_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });
    const authClient = await auth.getClient();
    return google.sheets({ version: 'v4', auth: authClient });
}

async function main() {
    console.log('🔍 SH_CC와 SH_M 주문ID 매칭 점검\n');
    console.log('='.repeat(60));

    const sheets = await getSheetsClient();

    // 1. SH_CC B열(주문ID) 로드
    console.log('\n📥 SH_CC 시트 데이터 로드 중...');
    const shccResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_CC!A2:B',
    });
    const shccRows = shccResponse.data.values || [];

    const shccOrderIds = new Map(); // orderId → [row numbers]
    shccRows.forEach((row, index) => {
        const orderId = row[1]?.trim();
        if (orderId) {
            if (!shccOrderIds.has(orderId)) {
                shccOrderIds.set(orderId, []);
            }
            shccOrderIds.get(orderId).push(index + 2); // 시트 행 번호 (헤더 포함)
        }
    });

    console.log(`✅ SH_CC: ${shccRows.length}행 조회`);
    console.log(`   - 주문ID 있는 행: ${Array.from(shccOrderIds.values()).flat().length}건`);
    console.log(`   - 유니크 주문ID: ${shccOrderIds.size}개`);

    // 2. SH_M A열(주문ID) 로드
    console.log('\n📥 SH_M 시트 데이터 로드 중...');
    const shmResponse = await sheets.spreadsheets.values.get({
        spreadsheetId: GOOGLE_SHEETS_ID,
        range: 'SH_M!A2:C',
    });
    const shmRows = shmResponse.data.values || [];

    const shmOrderIds = new Map(); // orderId → email
    shmRows.forEach(row => {
        const orderId = row[0]?.trim();
        const email = row[2]?.trim();
        if (orderId) {
            shmOrderIds.set(orderId, email);
        }
    });

    console.log(`✅ SH_M: ${shmRows.length}행 조회`);
    console.log(`   - 유니크 주문ID: ${shmOrderIds.size}개`);

    // 3. 매칭 분석
    console.log('\n' + '='.repeat(60));
    console.log('📊 매칭 분석 결과');
    console.log('='.repeat(60));

    const matched = [];
    const unmatched = [];

    for (const [orderId, rowNumbers] of shccOrderIds.entries()) {
        if (shmOrderIds.has(orderId)) {
            matched.push({
                orderId,
                rowNumbers,
                count: rowNumbers.length,
                email: shmOrderIds.get(orderId)
            });
        } else {
            unmatched.push({
                orderId,
                rowNumbers,
                count: rowNumbers.length
            });
        }
    }

    console.log(`\n✅ 매칭 성공: ${matched.length}개 주문ID (${((matched.length / shccOrderIds.size) * 100).toFixed(1)}%)`);
    console.log(`   - 총 SH_CC 레코드: ${matched.reduce((sum, m) => sum + m.count, 0)}건`);

    console.log(`\n❌ 매칭 실패: ${unmatched.length}개 주문ID (${((unmatched.length / shccOrderIds.size) * 100).toFixed(1)}%)`);
    console.log(`   - 총 SH_CC 레코드: ${unmatched.reduce((sum, m) => sum + m.count, 0)}건`);

    // 4. 매칭 실패 상세 분석
    if (unmatched.length > 0) {
        console.log('\n' + '='.repeat(60));
        console.log('🔍 매칭 실패 주문ID 상세 (SH_M에 없음)');
        console.log('='.repeat(60));

        // 레코드 수 많은 순으로 정렬
        unmatched.sort((a, b) => b.count - a.count);

        console.log(`\n총 ${unmatched.length}개 주문ID, ${unmatched.reduce((sum, u) => sum + u.count, 0)}건의 SH_CC 레코드 영향\n`);

        // 상위 50개만 표시
        const displayCount = Math.min(50, unmatched.length);
        console.log(`상위 ${displayCount}개 주문ID (레코드 수 많은 순):\n`);

        unmatched.slice(0, displayCount).forEach((item, index) => {
            const rowNumbersStr = item.rowNumbers.length <= 5
                ? item.rowNumbers.join(', ')
                : `${item.rowNumbers.slice(0, 5).join(', ')} ... (외 ${item.rowNumbers.length - 5}개)`;

            console.log(`${(index + 1).toString().padStart(3)}. 주문ID: ${item.orderId.padEnd(12)} | 레코드: ${item.count}건 | 행: ${rowNumbersStr}`);
        });

        if (unmatched.length > displayCount) {
            console.log(`\n... 외 ${unmatched.length - displayCount}개 주문ID 생략\n`);
        }

        // 패턴 분석
        console.log('\n' + '='.repeat(60));
        console.log('🔍 미매칭 주문ID 패턴 분석');
        console.log('='.repeat(60));

        const patterns = {
            hex8: [], // 8자리 16진수 (예: 2fcb6800)
            alphanumeric8: [], // 8자리 영숫자 (예: SEeclBTI)
            other: []
        };

        unmatched.forEach(item => {
            if (/^[0-9a-f]{8}$/i.test(item.orderId)) {
                patterns.hex8.push(item);
            } else if (/^[A-Za-z0-9]{8}$/.test(item.orderId)) {
                patterns.alphanumeric8.push(item);
            } else {
                patterns.other.push(item);
            }
        });

        console.log(`\n1️⃣ 8자리 16진수 형식 (예: 2fcb6800): ${patterns.hex8.length}개`);
        if (patterns.hex8.length > 0) {
            const totalRecords = patterns.hex8.reduce((sum, p) => sum + p.count, 0);
            console.log(`   - 영향 레코드: ${totalRecords}건`);
            console.log(`   - 샘플: ${patterns.hex8.slice(0, 5).map(p => p.orderId).join(', ')}`);
        }

        console.log(`\n2️⃣ 8자리 영숫자 형식 (예: AbPg75tk): ${patterns.alphanumeric8.length}개`);
        if (patterns.alphanumeric8.length > 0) {
            const totalRecords = patterns.alphanumeric8.reduce((sum, p) => sum + p.count, 0);
            console.log(`   - 영향 레코드: ${totalRecords}건`);
            console.log(`   - 샘플: ${patterns.alphanumeric8.slice(0, 5).map(p => p.orderId).join(', ')}`);
        }

        console.log(`\n3️⃣ 기타 형식: ${patterns.other.length}개`);
        if (patterns.other.length > 0) {
            const totalRecords = patterns.other.reduce((sum, p) => sum + p.count, 0);
            console.log(`   - 영향 레코드: ${totalRecords}건`);
            console.log(`   - 샘플: ${patterns.other.slice(0, 5).map(p => p.orderId).join(', ')}`);
        }
    }

    // 5. 매칭 성공 샘플
    console.log('\n' + '='.repeat(60));
    console.log('✅ 매칭 성공 샘플 (10개)');
    console.log('='.repeat(60) + '\n');

    matched.slice(0, 10).forEach((item, index) => {
        console.log(`${index + 1}. 주문ID: ${item.orderId} | 레코드: ${item.count}건 | Email: ${item.email}`);
    });

    // 6. 요약
    console.log('\n' + '='.repeat(60));
    console.log('📋 최종 요약');
    console.log('='.repeat(60));

    console.log(`\n📊 SH_CC 시트:`);
    console.log(`   - 총 레코드: ${shccRows.length}건`);
    console.log(`   - 유니크 주문ID: ${shccOrderIds.size}개`);

    console.log(`\n📊 SH_M 시트:`);
    console.log(`   - 총 주문ID: ${shmOrderIds.size}개`);

    console.log(`\n🎯 매칭 결과:`);
    console.log(`   ✅ 매칭 성공: ${matched.length}개 주문ID → ${matched.reduce((sum, m) => sum + m.count, 0)}건 레코드`);
    console.log(`   ❌ 매칭 실패: ${unmatched.length}개 주문ID → ${unmatched.reduce((sum, u) => sum + u.count, 0)}건 레코드`);

    const matchedPercentage = ((matched.length / shccOrderIds.size) * 100).toFixed(1);
    const unmatchedPercentage = ((unmatched.length / shccOrderIds.size) * 100).toFixed(1);

    console.log(`\n📈 비율:`);
    console.log(`   ✅ ${matchedPercentage}% 매칭`);
    console.log(`   ❌ ${unmatchedPercentage}% 미매칭`);

    console.log('\n' + '='.repeat(60));

    // 7. SH_M에만 있는 주문ID 확인
    const shmOnly = [];
    for (const orderId of shmOrderIds.keys()) {
        if (!shccOrderIds.has(orderId)) {
            shmOnly.push(orderId);
        }
    }

    if (shmOnly.length > 0) {
        console.log(`\n💡 추가 정보: SH_M에만 있는 주문ID: ${shmOnly.length}개`);
        console.log(`   (SH_CC에는 없지만 SH_M에 존재하는 주문)`);
        console.log(`   샘플: ${shmOnly.slice(0, 10).join(', ')}`);
    }

    console.log('\n' + '='.repeat(60));
}

main().catch(console.error);
