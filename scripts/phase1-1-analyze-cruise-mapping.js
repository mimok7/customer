#!/usr/bin/env node

/**
 * Phase 1-1: 크루즈명 매핑 분석
 * SH_R 시트의 크루즈명과 Supabase room_price 테이블의 cruise 컬럼 매칭 분석
 */

const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';
const SH_R_RANGE = 'SH_R!A2:AC';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

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

// 문자열 정규화 함수 (공백, 특수문자 제거)
function normalizeName(name) {
    if (!name) return '';
    return name
        .toLowerCase()
        .replace(/\s+/g, '') // 공백 제거
        .replace(/[()]/g, '') // 괄호 제거
        .trim();
}

// 유사도 계산 (Levenshtein distance 기반)
function similarity(s1, s2) {
    const longer = s1.length > s2.length ? s1 : s2;
    const shorter = s1.length > s2.length ? s2 : s1;

    if (longer.length === 0) return 1.0;

    const editDistance = levenshteinDistance(longer, shorter);
    return (longer.length - editDistance) / longer.length;
}

function levenshteinDistance(s1, s2) {
    const costs = [];
    for (let i = 0; i <= s1.length; i++) {
        let lastValue = i;
        for (let j = 0; j <= s2.length; j++) {
            if (i === 0) {
                costs[j] = j;
            } else if (j > 0) {
                let newValue = costs[j - 1];
                if (s1.charAt(i - 1) !== s2.charAt(j - 1)) {
                    newValue = Math.min(Math.min(newValue, lastValue), costs[j]) + 1;
                }
                costs[j - 1] = lastValue;
                lastValue = newValue;
            }
        }
        if (i > 0) costs[s2.length] = lastValue;
    }
    return costs[s2.length];
}

async function main() {
    console.log('🔍 Phase 1-1: 크루즈명 매핑 분석 시작\n');

    try {
        // 1. SH_R 시트에서 크루즈명 추출
        console.log('📊 Step 1: SH_R 시트에서 크루즈명 추출');
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

        const shRCruises = rows.map(row => row[cruiseIdx]).filter(Boolean);
        const uniqueShRCruises = [...new Set(shRCruises)];

        console.log(`   - SH_R 크루즈 총 개수: ${shRCruises.length}건`);
        console.log(`   - SH_R 고유 크루즈명: ${uniqueShRCruises.length}개\n`);

        // 2. Supabase room_price에서 크루즈명 추출 (페이징 처리)
        console.log('📊 Step 2: Supabase room_price에서 크루즈명 추출');

        let allRoomPrices = [];
        let page = 0;
        const pageSize = 1000;
        let hasMore = true;

        while (hasMore) {
            const { data, error } = await supabase
                .from('room_price')
                .select('cruise')
                .range(page * pageSize, (page + 1) * pageSize - 1);

            if (error) {
                console.error('   ❌ room_price 조회 실패:', error.message);
                process.exit(1);
            }

            if (data && data.length > 0) {
                allRoomPrices = allRoomPrices.concat(data);
                page++;

                if (data.length < pageSize) {
                    hasMore = false;
                }
            } else {
                hasMore = false;
            }
        }

        const dbCruises = allRoomPrices.map(p => p.cruise).filter(Boolean);
        const uniqueDbCruises = [...new Set(dbCruises)];

        console.log(`   - DB cruise 총 개수: ${dbCruises.length}건`);
        console.log(`   - DB 고유 cruise명: ${uniqueDbCruises.length}개\n`);

        // 3. 자동 매칭 시도
        console.log('📊 Step 3: 자동 매칭 분석 (유사도 기반)');
        console.log('   매칭 기준: 유사도 70% 이상\n');

        const mapping = {};
        const unmatchedShR = [];
        const matchResults = [];

        uniqueShRCruises.forEach(shRCruise => {
            const normalized = normalizeName(shRCruise);
            let bestMatch = null;
            let bestScore = 0;

            uniqueDbCruises.forEach(dbCruise => {
                const dbNormalized = normalizeName(dbCruise);

                // 완전 일치 확인
                if (normalized === dbNormalized) {
                    bestMatch = dbCruise;
                    bestScore = 1.0;
                    return;
                }

                // 포함 관계 확인
                if (normalized.includes(dbNormalized) || dbNormalized.includes(normalized)) {
                    const score = 0.9;
                    if (score > bestScore) {
                        bestMatch = dbCruise;
                        bestScore = score;
                    }
                }

                // 유사도 계산
                const score = similarity(normalized, dbNormalized);
                if (score > bestScore) {
                    bestMatch = dbCruise;
                    bestScore = score;
                }
            });

            const result = {
                shRCruise,
                dbCruise: bestMatch,
                score: bestScore,
                matched: bestScore >= 0.7,
                count: shRCruises.filter(c => c === shRCruise).length
            };

            matchResults.push(result);

            if (bestScore >= 0.7) {
                mapping[shRCruise] = bestMatch;
            } else {
                unmatchedShR.push(shRCruise);
            }
        });

        // 4. 매칭 결과 출력
        console.log('✅ 자동 매칭 성공 케이스:');
        const matched = matchResults.filter(r => r.matched).sort((a, b) => b.count - a.count);
        matched.forEach((result, idx) => {
            console.log(`   ${idx + 1}. "${result.shRCruise}" (${result.count}건)`);
            console.log(`      → "${result.dbCruise}" (유사도: ${(result.score * 100).toFixed(1)}%)`);
        });

        console.log(`\n⚠️  매칭 실패 케이스 (${unmatchedShR.length}개):`);
        const unmatched = matchResults.filter(r => !r.matched).sort((a, b) => b.count - a.count);
        unmatched.forEach((result, idx) => {
            console.log(`   ${idx + 1}. "${result.shRCruise}" (${result.count}건)`);
            console.log(`      최유사: "${result.dbCruise}" (유사도: ${(result.score * 100).toFixed(1)}%)`);
        });

        // 5. 통계
        const totalRecords = shRCruises.length;
        const matchedRecords = shRCruises.filter(c => mapping[c]).length;
        const matchRate = (matchedRecords / totalRecords * 100).toFixed(1);

        console.log(`\n📊 매칭 통계:`);
        console.log(`   - 총 예약 건수: ${totalRecords}건`);
        console.log(`   - 매칭 성공: ${matchedRecords}건 (${matchRate}%)`);
        console.log(`   - 매칭 실패: ${totalRecords - matchedRecords}건 (${(100 - matchRate).toFixed(1)}%)`);

        // 6. 매칭 테이블 저장
        const mappingFilePath = path.join(__dirname, 'mapping-cruise-names.json');
        fs.writeFileSync(mappingFilePath, JSON.stringify({
            generatedAt: new Date().toISOString(),
            stats: {
                totalShRCruises: uniqueShRCruises.length,
                totalDbCruises: uniqueDbCruises.length,
                matchedCount: matched.length,
                unmatchedCount: unmatched.length,
                matchRate: `${matchRate}%`
            },
            mapping,
            unmatched: unmatched.map(r => ({
                shRCruise: r.shRCruise,
                count: r.count,
                bestMatch: r.dbCruise,
                score: r.score
            })),
            allDbCruises: uniqueDbCruises,
            allShRCruises: uniqueShRCruises
        }, null, 2));

        console.log(`\n✅ 매칭 테이블 저장: ${mappingFilePath}`);

        // 7. 수동 매핑 가이드
        if (unmatchedShR.length > 0) {
            console.log(`\n💡 다음 단계:`);
            console.log(`   1. ${mappingFilePath} 파일 확인`);
            console.log(`   2. "unmatched" 항목의 수동 매핑 필요`);
            console.log(`   3. "mapping" 객체에 수동으로 추가:`);
            console.log(`      예: "엠바사더 크루즈": "그랜드 파이어니스"`);
            console.log(`   4. 수동 매핑 후 Phase 1-2 진행`);
        } else {
            console.log(`\n✅ 모든 크루즈명 자동 매칭 완료!`);
            console.log(`   다음: Phase 1-2 객실종류 매핑 분석`);
        }

        console.log(`\n✅ Phase 1-1 완료`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
