#!/usr/bin/env node

/**
 * Batch 16-18 (행 1502-1801) 데이터 분석
 * 왜 300건이 모두 스킵되었는지 확인
 */

const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';

async function getGoogleSheetsClient() {
    const auth = new GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets'],
    });

    const authClient = await auth.getClient();
    return google.sheets({ version: 'v4', auth: authClient });
}

async function main() {
    console.log('🔍 Batch 16-18 (행 1502-1801) 데이터 분석\n');

    try {
        const sheets = await getGoogleSheetsClient();

        // 헤더 읽기
        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_R!A1:AC1',
        });
        const headers = headerResponse.data.values[0];

        console.log('📋 컬럼 헤더:');
        headers.forEach((h, idx) => console.log(`   ${idx}: ${h}`));

        // Batch 16-18 데이터 읽기 (행 1502-1801)
        const dataResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_R!A1502:AC1801',
        });

        const rows = dataResponse.data.values || [];
        console.log(`\n📊 총 ${rows.length}개 행 읽기 완료\n`);

        if (rows.length === 0) {
            console.log('⚠️  데이터가 없습니다.');
            return;
        }

        // 컬럼 인덱스
        const orderIdIdx = headers.indexOf('주문ID');
        const cruiseIdx = headers.indexOf('크루즈');
        const categoryIdx = headers.indexOf('구분');
        const roomTypeIdx = headers.indexOf('객실종류');
        const checkinIdx = headers.indexOf('체크인');
        const priceIdx = headers.indexOf('금액');

        // 데이터 패턴 분석
        const analysis = {
            totalRows: rows.length,
            emptyOrderId: 0,
            emptyCruise: 0,
            emptyRoomType: 0,
            emptyCheckin: 0,
            emptyPrice: 0,
            uniqueCruises: new Set(),
            uniqueRoomTypes: new Set(),
            sampleData: []
        };

        rows.forEach((row, idx) => {
            const rowNum = 1502 + idx;
            const orderId = row[orderIdIdx];
            const cruise = row[cruiseIdx];
            const roomType = row[roomTypeIdx];
            const checkin = row[checkinIdx];
            const price = row[priceIdx];

            if (!orderId) analysis.emptyOrderId++;
            if (!cruise) analysis.emptyCruise++;
            if (!roomType) analysis.emptyRoomType++;
            if (!checkin) analysis.emptyCheckin++;
            if (!price) analysis.emptyPrice++;

            if (cruise) analysis.uniqueCruises.add(cruise);
            if (roomType) analysis.uniqueRoomTypes.add(roomType);

            // 처음 20개 샘플 수집
            if (idx < 20) {
                analysis.sampleData.push({
                    rowNum,
                    orderId: orderId || '(없음)',
                    cruise: cruise || '(없음)',
                    category: row[categoryIdx] || '(없음)',
                    roomType: roomType || '(없음)',
                    checkin: checkin || '(없음)',
                    price: price || '(없음)'
                });
            }
        });

        // 결과 출력
        console.log('📊 분석 결과:');
        console.log(`   - 총 행 수: ${analysis.totalRows}개`);
        console.log(`   - 주문ID 없음: ${analysis.emptyOrderId}개 (${(analysis.emptyOrderId / analysis.totalRows * 100).toFixed(1)}%)`);
        console.log(`   - 크루즈명 없음: ${analysis.emptyCruise}개 (${(analysis.emptyCruise / analysis.totalRows * 100).toFixed(1)}%)`);
        console.log(`   - 객실종류 없음: ${analysis.emptyRoomType}개 (${(analysis.emptyRoomType / analysis.totalRows * 100).toFixed(1)}%)`);
        console.log(`   - 체크인 없음: ${analysis.emptyCheckin}개 (${(analysis.emptyCheckin / analysis.totalRows * 100).toFixed(1)}%)`);
        console.log(`   - 금액 없음: ${analysis.emptyPrice}개 (${(analysis.emptyPrice / analysis.totalRows * 100).toFixed(1)}%)`);

        console.log(`\n   - 고유 크루즈: ${analysis.uniqueCruises.size}개`);
        if (analysis.uniqueCruises.size > 0) {
            console.log('     크루즈 목록:');
            Array.from(analysis.uniqueCruises).forEach(c => console.log(`       - ${c}`));
        }

        console.log(`\n   - 고유 객실종류: ${analysis.uniqueRoomTypes.size}개`);
        if (analysis.uniqueRoomTypes.size > 0) {
            console.log('     객실종류 목록:');
            Array.from(analysis.uniqueRoomTypes).slice(0, 20).forEach(r => console.log(`       - ${r}`));
            if (analysis.uniqueRoomTypes.size > 20) {
                console.log(`       ... 외 ${analysis.uniqueRoomTypes.size - 20}개`);
            }
        }

        console.log('\n📋 샘플 데이터 (처음 20개):');
        analysis.sampleData.forEach((sample, idx) => {
            console.log(`\n   [${idx + 1}] 행 ${sample.rowNum}:`);
            console.log(`      - 주문ID: ${sample.orderId}`);
            console.log(`      - 크루즈: ${sample.cruise}`);
            console.log(`      - 구분: ${sample.category}`);
            console.log(`      - 객실종류: ${sample.roomType}`);
            console.log(`      - 체크인: ${sample.checkin}`);
            console.log(`      - 금액: ${sample.price}`);
        });

        // 결과 저장
        const resultPath = path.join(__dirname, 'batch16-18-analysis.json');
        fs.writeFileSync(resultPath, JSON.stringify({
            analyzedAt: new Date().toISOString(),
            range: '1502-1801',
            analysis: {
                totalRows: analysis.totalRows,
                emptyOrderId: analysis.emptyOrderId,
                emptyCruise: analysis.emptyCruise,
                emptyRoomType: analysis.emptyRoomType,
                emptyCheckin: analysis.emptyCheckin,
                emptyPrice: analysis.emptyPrice,
                uniqueCruises: Array.from(analysis.uniqueCruises),
                uniqueRoomTypes: Array.from(analysis.uniqueRoomTypes)
            },
            sampleData: analysis.sampleData
        }, null, 2));

        console.log(`\n✅ 결과 저장: ${resultPath}`);

        // 결론
        console.log('\n💡 결론:');
        if (analysis.emptyCruise > analysis.totalRows * 0.9) {
            console.log('   ⚠️  이 구간은 대부분 크루즈 정보가 없습니다.');
            console.log('   → 크루즈 예약 데이터가 아닌 다른 서비스(공항, 호텔, 투어 등)일 가능성이 높습니다.');
        } else if (analysis.uniqueRoomTypes.size > 0 && Array.from(analysis.uniqueRoomTypes).some(r => r.includes('당일') || r.includes('투어') || r.includes('공항'))) {
            console.log('   ⚠️  객실종류에 "당일", "투어", "공항" 등이 포함되어 있습니다.');
            console.log('   → 크루즈가 아닌 다른 서비스 데이터입니다.');
        }

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
    }
}

main();
