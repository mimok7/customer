#!/usr/bin/env node
/**
 * 완전 초기화 + 전체 사용자 이관 스크립트
 * - 모든 Auth 사용자를 완전히 삭제
 * - SH_M 시트에서 사용자 데이터를 읽어 새로 이관
 * - 한글이름 컬럼 우선 사용
 */

const { createClient } = require('@supabase/supabase-js');
const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

// Load environment variables
try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_SERVICE_KEY;
const GOOGLE_SHEETS_ID = process.env.GOOGLE_SHEETS_ID;
const GOOGLE_SERVICE_ACCOUNT = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const GOOGLE_SERVICE_KEY = process.env.GOOGLE_SERVICE_ACCOUNT_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
    console.error('❌ Missing SUPABASE env variables.');
    process.exit(1);
}
if (!GOOGLE_SHEETS_ID || !GOOGLE_SERVICE_ACCOUNT || !GOOGLE_SERVICE_KEY) {
    console.error('❌ Missing Google Sheets env variables.');
    process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

/**
 * Google Sheets 클라이언트 생성
 */
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

/**
 * 모든 Auth 사용자 완전 삭제 (반복 삭제)
 * Supabase listUsers는 페이지네이션이 제대로 작동하지 않으므로
 * 사용자가 없을 때까지 반복적으로 첫 페이지를 조회하고 삭제
 */
async function deleteAllAuthUsers() {
    console.log('\n🗑️  모든 사용자 완전 삭제 중...');

    let totalDeleted = 0;
    let round = 0;
    let hasMore = true;

    while (hasMore) {
        round++;
        console.log(`\n� 라운드 ${round} 시작...`);

        try {
            // Auth에서 사용자 목록 가져오기 (항상 page=1로 조회)
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
                console.log('✅ 모든 사용자 삭제 완료!');
                hasMore = false;
                break;
            }

            console.log(`📋 ${authUsers.length}명 발견 (누적 삭제: ${totalDeleted}명)`);

            // 사용자 삭제
            let roundDeleted = 0;
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
                        console.log(`${progress} ⚠️  삭제 실패: ${user.email} - ${deleteError.message}`);
                    }

                    // API 제한 방지 - 속도 증가 (30ms로 단축)
                    await new Promise(resolve => setTimeout(resolve, 30));
                } catch (error) {
                    console.log(`${progress} ⚠️  예외: ${user.email}`);
                }
            }

            console.log(`✅ 라운드 ${round} 완료: ${roundDeleted}명 삭제 (전체: ${totalDeleted}명)`);

            // 라운드 간 짧은 대기
            await new Promise(resolve => setTimeout(resolve, 500));

        } catch (error) {
            console.error('❌ 라운드 처리 중 오류:', error.message);
            // 오류 발생해도 계속 시도
            await new Promise(resolve => setTimeout(resolve, 2000));
        }
    }

    console.log(`\n✅ 완전 삭제 완료: 총 ${totalDeleted}명`);
    return totalDeleted;
}

/**
 * 이메일 유효성 검사
 */
function isValidEmail(email) {
    if (!email) return false;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * SH_M 시트에서 사용자 데이터 읽기
 */
async function readUsersFromSheet(sheets) {
    console.log('\n📖 SH_M 시트 읽는 중...');

    const sheetName = 'SH_M';
    const range = `${sheetName}!A:Z`;

    try {
        const res = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range
        });

        const values = res.data.values || [];

        if (values.length === 0) {
            console.error('❌ SH_M 시트에 데이터가 없습니다.');
            return [];
        }

        // 헤더 찾기
        let headerRowIndex = 0;
        const row0 = (values[0] || []).map(v => String(v || '').trim());
        const row1 = values.length > 1 ? (values[1] || []).map(v => String(v || '').trim()) : [];

        const row0HasEmail = row0.some(h => /^(이메일|Email|email|EMAIL)$/i.test(h));
        const row1HasEmail = row1.some(h => /^(이메일|Email|email|EMAIL)$/i.test(h));

        if (!row0HasEmail && row1HasEmail) {
            headerRowIndex = 1;
        }

        const header = (values[headerRowIndex] || []).map(v => String(v || '').trim());
        const rows = values.slice(headerRowIndex + 1);

        console.log(`✅ 헤더: ${header.join(', ')}`);
        console.log(`✅ 데이터 행 수: ${rows.length}`);

        // 컬럼 인덱스 찾기 (한글이름 우선)
        const emailIdx = header.findIndex(h => /^(이메일|Email|email|EMAIL)$/i.test(h));
        const koreanNameIdx = header.findIndex(h => /^(한글이름|한글 이름)$/i.test(h));
        const nameIdx = header.findIndex(h => /^(이름|Name|name|NAME)$/i.test(h));

        const finalNameIdx = koreanNameIdx >= 0 ? koreanNameIdx : nameIdx;

        if (emailIdx === -1) {
            console.error('❌ 이메일 컬럼을 찾을 수 없습니다.');
            console.error('사용 가능한 컬럼:', header);
            return [];
        }

        console.log(`\n📋 컬럼 매핑:`);
        console.log(`  - Email: 컬럼 ${emailIdx + 1} (${header[emailIdx]})`);
        if (koreanNameIdx >= 0) {
            console.log(`  - Name: 컬럼 ${koreanNameIdx + 1} (${header[koreanNameIdx]}) ✨ 한글이름 사용`);
        } else if (nameIdx >= 0) {
            console.log(`  - Name: 컬럼 ${nameIdx + 1} (${header[nameIdx]})`);
        } else {
            console.log(`  - Name: 없음`);
        }

        // 데이터 파싱
        const users = [];
        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            const email = (row[emailIdx] || '').trim();
            const name = finalNameIdx >= 0 ? (row[finalNameIdx] || '').trim() : '';

            if (!email) {
                continue;
            }

            if (!isValidEmail(email)) {
                console.log(`⚠️  행 ${i + 2}: 이메일 형식 오류 (${email}), 건너뜀`);
                continue;
            }

            users.push({
                email,
                name: name || email.split('@')[0],
                role: 'member',
            });
        }

        console.log(`\n✅ 유효한 사용자 데이터: ${users.length}명`);
        return users;

    } catch (error) {
        console.error('❌ 시트 읽기 실패:', error.message);
        throw error;
    }
}

/**
 * Supabase Auth에 사용자 생성
 */
async function createAuthUser(email, name) {
    try {
        const { data, error } = await supabase.auth.admin.createUser({
            email,
            password: 'qwe123!',
            email_confirm: true,
            user_metadata: { name }
        });

        if (error) throw error;
        return { success: true, userId: data.user.id };
    } catch (error) {
        return { success: false, error: error.message };
    }
}

/**
 * users 테이블에 사용자 정보 저장
 */
async function saveToUsersTable(userId, userData) {
    try {
        const { error } = await supabase
            .from('users')
            .upsert({
                id: userId,
                email: userData.email,
                name: userData.name,
                role: userData.role,
                created_at: new Date().toISOString()
            }, {
                onConflict: 'id',
                ignoreDuplicates: false
            });

        if (error) throw error;
        return { success: true };
    } catch (error) {
        return { success: false, error: error.message };
    }
}

/**
 * 메인 함수
 */
async function main() {
    console.log('╔════════════════════════════════════════════════════════════╗');
    console.log('║  완전 초기화 + SH_M 시트 → users 테이블 전체 이관        ║');
    console.log('╚════════════════════════════════════════════════════════════╝');

    try {
        // 1. 모든 기존 사용자 삭제
        const deletedCount = await deleteAllAuthUsers();

        console.log('\n⏳ 삭제 후 대기 중... (5초)');
        await new Promise(resolve => setTimeout(resolve, 5000));

        // 2. Google Sheets 연결
        console.log('\n🔌 Google Sheets 연결 중...');
        const sheets = await getSheetsClient();
        console.log('✅ Google Sheets 연결 성공');

        // 3. SH_M 시트에서 사용자 데이터 읽기
        const users = await readUsersFromSheet(sheets);

        if (users.length === 0) {
            console.log('\n❌ 이관할 사용자가 없습니다.');
            return;
        }

        // 4. Supabase에 사용자 이관
        console.log('\n📤 Supabase에 사용자 이관 시작...');
        console.log(`총 ${users.length}명 처리 예정\n`);

        let stats = {
            success: 0,
            failed: 0,
            total: users.length,
            deletedBefore: deletedCount
        };

        for (let i = 0; i < users.length; i++) {
            const user = users[i];
            const progress = `[${i + 1}/${users.length}]`;

            console.log(`${progress} ${user.email} (${user.name})`);

            // Auth 사용자 생성
            const authResult = await createAuthUser(user.email, user.name);

            if (!authResult.success) {
                console.log(`  ❌ Auth 생성 실패: ${authResult.error}`);
                stats.failed++;
                continue;
            }

            // users 테이블에 저장
            const saveResult = await saveToUsersTable(authResult.userId, user);

            if (saveResult.success) {
                console.log(`  ✅ 등록 완료 (ID: ${authResult.userId.substring(0, 8)}...)`);
                stats.success++;
            } else {
                console.log(`  ❌ 테이블 저장 실패: ${saveResult.error}`);
                stats.failed++;
            }

            // API 제한 방지
            await new Promise(resolve => setTimeout(resolve, 100));
        }

        // 5. 결과 요약
        console.log('\n╔════════════════════════════════════════════════════════════╗');
        console.log('║  이관 완료                                                 ║');
        console.log('╚════════════════════════════════════════════════════════════╝');
        console.log(`\n📊 결과 통계:`);
        console.log(`  🗑️  삭제된 기존 사용자: ${stats.deletedBefore}명`);
        console.log(`  ✅ 신규 등록: ${stats.success}명`);
        console.log(`  ❌ 실패: ${stats.failed}명`);
        console.log(`  📋 전체: ${stats.total}명`);

        if (stats.success > 0) {
            console.log(`\n💡 등록된 사용자 기본 비밀번호: qwe123!`);
        }

        if (stats.failed > 0) {
            console.log(`\n⚠️  실패한 항목이 있습니다. 로그를 확인하세요.`);
        }

        // 6. 로그 저장
        const reportsDir = path.join(process.cwd(), 'reports');
        if (!fs.existsSync(reportsDir)) {
            fs.mkdirSync(reportsDir, { recursive: true });
        }

        const timestamp = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
        const logFile = path.join(reportsDir, `full-reset-users-import_${timestamp}.log`);

        const logContent = `
완전 초기화 + SH_M 시트 → users 테이블 전체 이관 결과
실행 시간: ${new Date().toLocaleString('ko-KR')}

결과 통계:
- 삭제된 기존 사용자: ${stats.deletedBefore}명
- 신규 등록: ${stats.success}명
- 실패: ${stats.failed}명
- 전체: ${stats.total}명

기본 비밀번호: qwe123!
`;

        fs.writeFileSync(logFile, logContent, 'utf-8');
        console.log(`\n📝 로그 파일 저장: ${logFile}`);

    } catch (error) {
        console.error('\n❌ 이관 실패:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

// 스크립트 실행
if (require.main === module) {
    console.log('\n⚠️  경고: 이 스크립트는 모든 기존 사용자를 삭제합니다!');
    console.log('계속하려면 5초 후 실행됩니다...\n');

    setTimeout(() => {
        main().catch(error => {
            console.error('❌ 치명적 오류:', error);
            process.exit(1);
        });
    }, 5000);
}

module.exports = { main };
