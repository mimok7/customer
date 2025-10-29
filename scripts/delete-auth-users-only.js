#!/usr/bin/env node
/**
 * Auth 사용자만 삭제하는 스크립트
 * SQL로 users 테이블을 삭제한 후 실행
 */

const { createClient } = require('@supabase/supabase-js');
const path = require('path');
const dotenv = require('dotenv');

// Load environment variables
try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_SERVICE_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
    console.error('❌ Missing SUPABASE env variables.');
    process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

/**
 * Auth 사용자만 삭제 (users 테이블은 이미 비워진 상태)
 */
async function deleteAuthUsersOnly() {
    console.log('\n🗑️  Auth 사용자 삭제 중...');
    console.log('(users 테이블이 이미 비워진 상태여야 합니다)\n');

    let totalDeleted = 0;
    let round = 0;
    let hasMore = true;

    while (hasMore) {
        round++;
        console.log(`🔄 라운드 ${round} 시작...`);

        try {
            const { data: authData, error: authListError } = await supabase.auth.admin.listUsers({
                page: 1,
                perPage: 1000
            });

            if (authListError) {
                console.error('❌ Auth 사용자 목록 조회 실패:', authListError.message);
                break;
            }

            const authUsers = authData?.users || [];

            if (authUsers.length === 0) {
                console.log('✅ 모든 Auth 사용자 삭제 완료!');
                hasMore = false;
                break;
            }

            console.log(`📋 ${authUsers.length}명 발견 (누적 삭제: ${totalDeleted}명)`);

            let roundDeleted = 0;
            let roundFailed = 0;

            for (let i = 0; i < authUsers.length; i++) {
                const user = authUsers[i];
                const progress = `[${i + 1}/${authUsers.length}]`;

                try {
                    const { error: deleteError } = await supabase.auth.admin.deleteUser(user.id);

                    if (!deleteError) {
                        totalDeleted++;
                        roundDeleted++;
                        if ((i + 1) % 50 === 0) {
                            console.log(`${progress} 삭제 중... (라운드: ${roundDeleted}, 전체: ${totalDeleted}명)`);
                        }
                    } else {
                        roundFailed++;
                        if (roundFailed <= 5) {
                            console.log(`${progress} ⚠️  삭제 실패: ${user.email} - ${deleteError.message}`);
                        }
                    }

                    await new Promise(resolve => setTimeout(resolve, 30));
                } catch (error) {
                    roundFailed++;
                    if (roundFailed <= 5) {
                        console.log(`${progress} ⚠️  예외: ${user.email}`);
                    }
                }
            }

            console.log(`✅ 라운드 ${round} 완료: 성공 ${roundDeleted}명, 실패 ${roundFailed}명 (전체: ${totalDeleted}명)\n`);

            // 실패가 너무 많으면 중단
            if (roundFailed === authUsers.length && roundDeleted === 0) {
                console.error('❌ 모든 사용자 삭제 실패. users 테이블을 먼저 비워야 합니다.');
                console.error('SQL 파일(delete-all-users.sql)을 먼저 실행하세요.');
                hasMore = false;
                break;
            }

            await new Promise(resolve => setTimeout(resolve, 500));

        } catch (error) {
            console.error('❌ 라운드 처리 중 오류:', error.message);
            await new Promise(resolve => setTimeout(resolve, 2000));
        }
    }

    console.log(`\n✅ Auth 사용자 삭제 완료: 총 ${totalDeleted}명`);
    return totalDeleted;
}

/**
 * 메인 함수
 */
async function main() {
    console.log('╔════════════════════════════════════════════════════════════╗');
    console.log('║  Auth 사용자만 삭제 (users 테이블 비워진 후 실행)        ║');
    console.log('╚════════════════════════════════════════════════════════════╝');

    try {
        const deletedCount = await deleteAuthUsersOnly();

        console.log('\n╔════════════════════════════════════════════════════════════╗');
        console.log('║  삭제 완료                                                ║');
        console.log('╚════════════════════════════════════════════════════════════╝');
        console.log(`✅ 총 ${deletedCount}명의 Auth 사용자가 삭제되었습니다.\n`);

    } catch (error) {
        console.error('\n❌ 실패:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

// 스크립트 실행
if (require.main === module) {
    console.log('\n⚠️  주의: 이 스크립트는 Auth 사용자만 삭제합니다.');
    console.log('먼저 SQL 파일(delete-all-users.sql)로 users 테이블을 비워야 합니다.\n');
    console.log('계속하려면 3초 후 실행됩니다...\n');

    setTimeout(() => {
        main().catch(error => {
            console.error('❌ 치명적 오류:', error);
            process.exit(1);
        });
    }, 3000);
}

module.exports = { deleteAuthUsersOnly };
