#!/usr/bin/env node

/**
 * 크루즈 매핑 테이블 검증
 * mapping-cruise-names.json을 사용하여 SH_R 데이터의 매칭 결과 확인
 */

const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SH_R_RANGE = 'SH_R!A2:AC';

async function getGoogleSheetsClient() {
    const auth = new GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });

    const authClient = await auth.getClient();
    return google.sheets({ version: 'v4', auth: authClient });
}

async function main() {
    console.log('🔍 크루즈 매핑 테이블 검증\n');

    try {
        // 1. 매핑 테이블 로드
        const mappingPath = path.join(__dirname, 'mapping-cruise-names.json');
        if (!fs.existsSync(mappingPath)) {
            console.error('❌ mapping-cruise-names.json 파일을 찾을 수 없습니다.');
            process.exit(1);
        }

        const mappingData = JSON.parse(fs.readFileSync(mappingPath, 'utf8'));
        const mapping = mappingData.mapping;

        console.log('📋 로드된 매핑 테이블:');
        console.log(`   - 총 매핑 개수: ${Object.keys(mapping).length}개\n`);

        // 2. SH_R 데이터 읽기
        console.log('📊 SH_R 시트 데이터 분석');
        const sheets = await getGoogleSheetsClient();

        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_R!A1:AC1',
        });
        const headers = headerResponse.data.values[0];
        const cruiseIdx = headers.indexOf('크루즈');

        const dataResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: SH_R_RANGE,
        });
        const rows = dataResponse.data.values || [];

        // 3. 매칭 결과 분석
        console.log('   크루즈별 매칭 결과:\n');

        const cruiseStats = {};
        let totalMatched = 0;
        let totalUnmatched = 0;
        const unmatchedList = [];

        rows.forEach((row, idx) => {
            const shRCruise = row[cruiseIdx];
            if (!shRCruise) return;

            if (!cruiseStats[shRCruise]) {
                cruiseStats[shRCruise] = {
                    count: 0,
                    matched: false,
                    dbCruise: null
                };
            }
            cruiseStats[shRCruise].count++;

            if (mapping[shRCruise]) {
                cruiseStats[shRCruise].matched = true;
                cruiseStats[shRCruise].dbCruise = mapping[shRCruise];
                totalMatched++;
            } else {
                totalUnmatched++;
                if (!unmatchedList.includes(shRCruise)) {
                    unmatchedList.push(shRCruise);
                }
            }
        });

        // 4. 매칭된 크루즈 출력
        const matchedCruises = Object.entries(cruiseStats)
            .filter(([_, stats]) => stats.matched)
            .sort((a, b) => b[1].count - a[1].count);

        console.log('   ✅ 매칭 성공 크루즈:');
        matchedCruises.forEach(([shRCruise, stats], idx) => {
            const arrow = shRCruise === stats.dbCruise ? '=' : '→';
            console.log(`     ${idx + 1}. "${shRCruise}" (${stats.count}건) ${arrow} "${stats.dbCruise}"`);
        });

        // 5. 미매칭 크루즈 출력
        const unmatchedCruises = Object.entries(cruiseStats)
            .filter(([_, stats]) => !stats.matched)
            .sort((a, b) => b[1].count - a[1].count);

        if (unmatchedCruises.length > 0) {
            console.log('\n   ⚠️  미매칭 크루즈 (수동 이관 대상):');
            unmatchedCruises.forEach(([shRCruise, stats], idx) => {
                console.log(`     ${idx + 1}. "${shRCruise}" (${stats.count}건)`);
            });
        }

        // 6. 통계
        const totalRecords = rows.filter(row => row[cruiseIdx]).length;
        const matchRate = (totalMatched / totalRecords * 100).toFixed(1);

        console.log('\n📊 최종 매칭 통계:');
        console.log(`   - 총 예약 건수: ${totalRecords}건`);
        console.log(`   - 매칭 성공: ${totalMatched}건 (${matchRate}%)`);
        console.log(`   - 미매칭: ${totalUnmatched}건 (${(100 - matchRate).toFixed(1)}%)`);
        console.log(`   - 매칭된 크루즈: ${matchedCruises.length}개`);
        console.log(`   - 미매칭 크루즈: ${unmatchedCruises.length}개`);

        // 7. 수동 매핑 안내
        if (unmatchedCruises.length > 0) {
            console.log('\n💡 수동 이관 처리 방법:');
            console.log('   1. 이관 스크립트 실행 시 미매칭 크루즈는 스킵');
            console.log('   2. room_price 테이블에 해당 크루즈 추가 후');
            console.log('   3. mapping-cruise-names.json 업데이트');
            console.log('   4. 미매칭 건만 재이관');
        } else {
            console.log('\n✅ 모든 크루즈 매칭 완료! Phase 1-2로 진행 가능합니다.');
        }

        // 8. 결과 저장
        const verificationResult = {
            verifiedAt: new Date().toISOString(),
            totalRecords,
            totalMatched,
            totalUnmatched,
            matchRate: `${matchRate}%`,
            matchedCruises: matchedCruises.length,
            unmatchedCruises: unmatchedCruises.length,
            unmatchedList: unmatchedCruises.map(([cruise, stats]) => ({
                cruise,
                count: stats.count
            }))
        };

        const resultPath = path.join(__dirname, 'cruise-mapping-verification.json');
        fs.writeFileSync(resultPath, JSON.stringify(verificationResult, null, 2));
        console.log(`\n✅ 검증 결과 저장: ${resultPath}`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
