#!/usr/bin/env node

/**
 * Phase 1-2: 객실종류 매핑 분석
 * SH_R 시트의 객실종류와 Supabase room_price 테이블의 room_type 컬럼 매칭 분석
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

// 문자열 정규화 함수
function normalizeName(name) {
    if (!name) return '';
    return name
        .toLowerCase()
        .replace(/\s+/g, '') // 공백 제거
        .replace(/[()]/g, '') // 괄호 제거
        .replace(/층/g, '') // "층" 제거
        .replace(/룸/g, '') // "룸" 제거
        .trim();
}

// 유사도 계산 (Levenshtein distance)
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
    console.log('🔍 Phase 1-2: 객실종류 매핑 분석 시작\n');

    try {
        // 1. SH_R 시트에서 객실종류 추출
        console.log('📊 Step 1: SH_R 시트에서 객실종류 추출');
        const sheets = await getGoogleSheetsClient();

        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_R!A1:AC1',
        });
        const headers = headerResponse.data.values[0];
        const roomTypeIdx = headers.indexOf('객실종류');
        const cruiseIdx = headers.indexOf('크루즈');

        const dataResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: SH_R_RANGE,
        });
        const rows = dataResponse.data.values || [];

        // 크루즈별 객실종류 수집
        const roomTypeByCruise = {};
        rows.forEach(row => {
            const cruise = row[cruiseIdx];
            const roomType = row[roomTypeIdx];

            if (!cruise || !roomType) return;

            if (!roomTypeByCruise[cruise]) {
                roomTypeByCruise[cruise] = [];
            }
            roomTypeByCruise[cruise].push(roomType);
        });

        const shRRoomTypes = rows.map(row => row[roomTypeIdx]).filter(Boolean);
        const uniqueShRRoomTypes = [...new Set(shRRoomTypes)];

        console.log(`   - SH_R 객실종류 총 개수: ${shRRoomTypes.length}건`);
        console.log(`   - SH_R 고유 객실종류: ${uniqueShRRoomTypes.length}개\n`);

        // 2. Supabase room_price에서 객실종류 추출 (페이징 처리)
        console.log('📊 Step 2: Supabase room_price에서 객실종류 추출');

        let allRoomPrices = [];
        let page = 0;
        const pageSize = 1000;
        let hasMore = true;

        while (hasMore) {
            const { data, error } = await supabase
                .from('room_price')
                .select('room_type, cruise')
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

        const dbRoomTypes = allRoomPrices.map(p => p.room_type).filter(Boolean);
        const uniqueDbRoomTypes = [...new Set(dbRoomTypes)];

        console.log(`   - DB room_type 총 개수: ${dbRoomTypes.length}건`);
        console.log(`   - DB 고유 room_type: ${uniqueDbRoomTypes.length}개\n`);

        // 3. 크루즈별 객실종류 매핑
        console.log('📊 Step 3: 크루즈별 객실종류 자동 매칭 분석');
        console.log('   매칭 기준: 유사도 80% 이상\n');

        // 크루즈 매핑 테이블 로드
        const cruiseMappingPath = path.join(__dirname, 'mapping-cruise-names.json');
        let cruiseMapping = {};
        if (fs.existsSync(cruiseMappingPath)) {
            const cruiseMappingData = JSON.parse(fs.readFileSync(cruiseMappingPath, 'utf8'));
            cruiseMapping = cruiseMappingData.mapping;
        }

        const mapping = {};
        const unmatchedShR = [];
        const matchResults = [];

        uniqueShRRoomTypes.forEach(shRRoomType => {
            const normalized = normalizeName(shRRoomType);
            let bestMatch = null;
            let bestScore = 0;

            uniqueDbRoomTypes.forEach(dbRoomType => {
                const dbNormalized = normalizeName(dbRoomType);

                // 완전 일치 확인
                if (normalized === dbNormalized) {
                    bestMatch = dbRoomType;
                    bestScore = 1.0;
                    return;
                }

                // 포함 관계 확인
                if (normalized.includes(dbNormalized) || dbNormalized.includes(normalized)) {
                    const score = 0.95;
                    if (score > bestScore) {
                        bestMatch = dbRoomType;
                        bestScore = score;
                    }
                }

                // 유사도 계산
                const score = similarity(normalized, dbNormalized);
                if (score > bestScore) {
                    bestMatch = dbRoomType;
                    bestScore = score;
                }
            });

            const result = {
                shRRoomType,
                dbRoomType: bestMatch,
                score: bestScore,
                matched: bestScore >= 0.8,
                count: shRRoomTypes.filter(t => t === shRRoomType).length
            };

            matchResults.push(result);

            if (bestScore >= 0.8) {
                mapping[shRRoomType] = bestMatch;
            } else {
                unmatchedShR.push(shRRoomType);
            }
        });

        // 4. 매칭 결과 출력 (상위 30개만)
        console.log('✅ 자동 매칭 성공 케이스 (상위 30개):');
        const matched = matchResults.filter(r => r.matched).sort((a, b) => b.count - a.count);
        matched.slice(0, 30).forEach((result, idx) => {
            const matchIcon = result.score === 1.0 ? '=' : '→';
            console.log(`   ${idx + 1}. "${result.shRRoomType}" (${result.count}건)`);
            console.log(`      ${matchIcon} "${result.dbRoomType}" (유사도: ${(result.score * 100).toFixed(1)}%)`);
        });
        if (matched.length > 30) {
            console.log(`   ... 외 ${matched.length - 30}개 매칭 성공`);
        }

        console.log(`\n⚠️  매칭 실패 케이스 (상위 30개):`);
        const unmatched = matchResults.filter(r => !r.matched).sort((a, b) => b.count - a.count);
        unmatched.slice(0, 30).forEach((result, idx) => {
            console.log(`   ${idx + 1}. "${result.shRRoomType}" (${result.count}건)`);
            console.log(`      최유사: "${result.dbRoomType}" (유사도: ${(result.score * 100).toFixed(1)}%)`);
        });
        if (unmatched.length > 30) {
            console.log(`   ... 외 ${unmatched.length - 30}개 매칭 실패`);
        }

        // 5. 통계
        const totalRecords = shRRoomTypes.length;
        const matchedRecords = shRRoomTypes.filter(t => mapping[t]).length;
        const matchRate = (matchedRecords / totalRecords * 100).toFixed(1);

        console.log(`\n📊 매칭 통계:`);
        console.log(`   - 총 예약 건수: ${totalRecords}건`);
        console.log(`   - 매칭 성공: ${matchedRecords}건 (${matchRate}%)`);
        console.log(`   - 매칭 실패: ${totalRecords - matchedRecords}건 (${(100 - matchRate).toFixed(1)}%)`);
        console.log(`   - 매칭된 객실종류: ${matched.length}개`);
        console.log(`   - 미매칭 객실종류: ${unmatched.length}개`);

        // 6. 매칭 테이블 저장
        const mappingFilePath = path.join(__dirname, 'mapping-room-types.json');
        fs.writeFileSync(mappingFilePath, JSON.stringify({
            generatedAt: new Date().toISOString(),
            stats: {
                totalShRRoomTypes: uniqueShRRoomTypes.length,
                totalDbRoomTypes: uniqueDbRoomTypes.length,
                matchedCount: matched.length,
                unmatchedCount: unmatched.length,
                matchRate: `${matchRate}%`
            },
            mapping,
            unmatched: unmatched.map(r => ({
                shRRoomType: r.shRRoomType,
                count: r.count,
                bestMatch: r.dbRoomType,
                score: r.score
            })),
            allDbRoomTypes: uniqueDbRoomTypes,
            allShRRoomTypes: uniqueShRRoomTypes
        }, null, 2));

        console.log(`\n✅ 매칭 테이블 저장: ${mappingFilePath}`);

        // 7. 다음 단계 안내
        if (unmatchedShR.length > 0) {
            console.log(`\n💡 다음 단계:`);
            console.log(`   1. ${mappingFilePath} 파일 확인`);
            console.log(`   2. "unmatched" 항목의 수동 매핑 필요`);
            console.log(`   3. 높은 건수부터 우선 처리 권장`);
            console.log(`   4. 매칭률이 ${matchRate}%이므로 대부분 자동 매칭 성공`);
        } else {
            console.log(`\n✅ 모든 객실종류 자동 매칭 완료!`);
        }

        console.log(`\n✅ Phase 1-2 완료`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

main();
