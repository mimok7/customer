require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function migrateNewShMUsers() {
    console.log('🚀 SH_M 신규 사용자 이관 시작\n');

    // 1. 분석 결과 로드
    const analysisPath = 'scripts/new-shm-data-analysis.json';
    if (!fs.existsSync(analysisPath)) {
        console.error('❌ 분석 파일이 없습니다. 먼저 check-new-shm-data.js를 실행하세요.');
        return;
    }

    const analysis = JSON.parse(fs.readFileSync(analysisPath, 'utf-8'));
    const newUsers = analysis.newUsers;

    console.log('============================================================');
    console.log('📊 이관 대상');
    console.log('============================================================');
    console.log(`   신규 사용자: ${newUsers.length}명`);
    console.log('');

    if (newUsers.length === 0) {
        console.log('✅ 이관할 신규 사용자가 없습니다.');
        return;
    }

    // 2. 배치 단위로 이관
    const BATCH_SIZE = 100;
    const totalBatches = Math.ceil(newUsers.length / BATCH_SIZE);

    const results = {
        success: [],
        failed: [],
        skipped: [],
    };

    console.log('============================================================');
    console.log('🔄 이관 진행');
    console.log('============================================================\n');

    for (let i = 0; i < totalBatches; i++) {
        const start = i * BATCH_SIZE;
        const end = Math.min(start + BATCH_SIZE, newUsers.length);
        const batch = newUsers.slice(start, end);

        console.log(`📦 Batch ${i + 1}/${totalBatches} (${start + 1}-${end}/${newUsers.length})`);

        const batchInserts = [];

        for (const user of batch) {
            try {
                // UUID 생성
                const userId = uuidv4();

                // 사용자 데이터 준비
                const userData = {
                    id: userId,
                    email: user.email || null,
                    name: user.nameKr || null,
                    english_name: user.nameEn || null,
                    phone_number: user.phone || null,
                    role: 'member', // SH_M의 사용자는 이미 예약한 회원
                    status: 'active',
                    created_at: new Date().toISOString(),
                    updated_at: new Date().toISOString(),
                };

                batchInserts.push(userData);

                results.success.push({
                    rowNum: user.rowNum,
                    orderId: user.orderId,
                    userId: userId,
                    email: user.email,
                    name: user.nameKr,
                });

            } catch (error) {
                console.error(`   ❌ 행 ${user.rowNum} 실패:`, error.message);
                results.failed.push({
                    rowNum: user.rowNum,
                    orderId: user.orderId,
                    error: error.message,
                });
            }
        }

        // 배치 INSERT
        if (batchInserts.length > 0) {
            const { error: insertError } = await supabase
                .from('users')
                .insert(batchInserts);

            if (insertError) {
                console.error(`   ❌ Batch INSERT 실패:`, insertError.message);

                // 실패한 배치는 개별 처리
                for (const userData of batchInserts) {
                    const { error: singleError } = await supabase
                        .from('users')
                        .insert(userData);

                    if (singleError) {
                        const failedUser = results.success.find(u => u.userId === userData.id);
                        if (failedUser) {
                            results.success = results.success.filter(u => u.userId !== userData.id);
                            results.failed.push({
                                ...failedUser,
                                error: singleError.message,
                            });
                        }
                    }
                }
            } else {
                console.log(`   ✅ ${batchInserts.length}명 이관 성공`);
            }
        }

        // 진행률 표시
        const progress = ((end / newUsers.length) * 100).toFixed(1);
        console.log(`   진행률: ${progress}%\n`);
    }

    // 3. 결과 요약
    console.log('============================================================');
    console.log('📊 이관 결과');
    console.log('============================================================');
    console.log(`   - 성공: ${results.success.length}명`);
    console.log(`   - 실패: ${results.failed.length}명`);
    console.log(`   - 스킵: ${results.skipped.length}명`);
    console.log('');

    // 4. 실패 케이스 출력
    if (results.failed.length > 0) {
        console.log('============================================================');
        console.log('❌ 실패 케이스');
        console.log('============================================================\n');

        results.failed.slice(0, 10).forEach((f, idx) => {
            console.log(`   ${idx + 1}. 행 ${f.rowNum}: ${f.error}`);
            console.log(`      Order ID: ${f.orderId}`);
        });

        if (results.failed.length > 10) {
            console.log(`   ... 외 ${results.failed.length - 10}건\n`);
        }
    }

    // 5. 결과 저장
    const resultPath = 'scripts/migrate-new-shm-users-result.json';
    fs.writeFileSync(resultPath, JSON.stringify({
        timestamp: new Date().toISOString(),
        totalUsers: newUsers.length,
        successCount: results.success.length,
        failedCount: results.failed.length,
        skippedCount: results.skipped.length,
        results: results,
    }, null, 2));

    console.log('============================================================');
    console.log('💾 결과 저장');
    console.log('============================================================');
    console.log(`✅ ${resultPath}\n`);

    // 6. Order-User 매핑 업데이트
    if (results.success.length > 0) {
        console.log('============================================================');
        console.log('🔄 Order-User 매핑 업데이트');
        console.log('============================================================\n');

        // 기존 매핑 로드
        const mappingPath = 'scripts/mapping-order-user.json';
        let mapping = {};

        if (fs.existsSync(mappingPath)) {
            mapping = JSON.parse(fs.readFileSync(mappingPath, 'utf-8'));
        }

        // orderUserMap 업데이트
        if (!mapping.orderUserMap) {
            mapping.orderUserMap = {};
        }

        let addedCount = 0;
        results.success.forEach(user => {
            if (user.orderId) {
                mapping.orderUserMap[user.orderId] = user.userId;
                mapping[user.orderId] = user.userId; // 최상위에도 추가
                addedCount++;
            }
        });

        // 통계 업데이트
        mapping.lastUpdated = new Date().toISOString();
        if (!mapping.stats) {
            mapping.stats = {};
        }
        mapping.stats.totalOrders = Object.keys(mapping.orderUserMap).length;

        // 저장
        fs.writeFileSync(mappingPath, JSON.stringify(mapping, null, 2));
        console.log(`✅ Order-User 매핑 업데이트: ${addedCount}개 추가`);
        console.log(`   총 매핑: ${mapping.stats.totalOrders}개\n`);
    }

    // 7. 최종 통계
    console.log('============================================================');
    console.log('🎉 이관 완료!');
    console.log('============================================================');
    console.log(`   신규 사용자 ${results.success.length}명이 users 테이블에 추가되었습니다.`);
    console.log('');

    if (results.failed.length > 0) {
        console.log(`⚠️  ${results.failed.length}명 실패 - 수동 확인 필요`);
        console.log('   결과 파일을 확인하세요: ' + resultPath);
        console.log('');
    }
}

migrateNewShMUsers().catch(console.error);
