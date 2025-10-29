#!/usr/bin/env node
/**
 * Step 1: SH_M 시트 → users 테이블 이관
 * - SH_M 시트에서 사용자 데이터를 읽어 Supabase users 테이블에 이관
 * - Supabase Auth 계정도 자동 생성 (비밀번호: qwe123!)
 * - 중복 체크 후 신규 사용자만 등록
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

// Validation
if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
    console.error('❌ Missing SUPABASE env variables.');
    console.error('Required: NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY');
    process.exit(1);
}
if (!GOOGLE_SHEETS_ID || !GOOGLE_SERVICE_ACCOUNT || !GOOGLE_SERVICE_KEY) {
    console.error('❌ Missing Google Sheets env variables.');
    console.error('Required: GOOGLE_SHEETS_ID, GOOGLE_SERVICE_ACCOUNT_EMAIL, GOOGLE_SERVICE_ACCOUNT_KEY');
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
 * 이메일 유효성 검사
 */
function isValidEmail(email) {
    if (!email) return false;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * 날짜 파싱 (여러 형식 지원)
 */
function parseDate(dateStr) {
    if (!dateStr) return null;

    // 이미 YYYY-MM-DD 형식인 경우
    if (/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) {
        return dateStr;
    }

    // YYYYMMDD 형식
    if (/^\d{8}$/.test(dateStr)) {
        return `${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}`;
    }

    // YYYY.MM.DD 또는 YYYY/MM/DD 형식
    const match = dateStr.match(/(\d{4})[\.\/-](\d{1,2})[\.\/-](\d{1,2})/);
    if (match) {
        const [, year, month, day] = match;
        return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    }

    // Excel 날짜 숫자 (1900년 1월 1일부터의 일수)
    if (/^\d+$/.test(dateStr)) {
        const days = parseInt(dateStr);
        const date = new Date(1900, 0, days - 1); // Excel은 1900-01-01을 1로 시작
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    console.log(`⚠️  날짜 파싱 실패: ${dateStr}`);
    return null;
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

        // 헤더 찾기 (1행 또는 2행)
        let headerRowIndex = 0;
        const row0 = (values[0] || []).map(v => String(v || '').trim());
        const row1 = values.length > 1 ? (values[1] || []).map(v => String(v || '').trim()) : [];

        // Email 컬럼이 있는 행을 헤더로 사용
        const row0HasEmail = row0.some(h => /^(이메일|Email|email|EMAIL)$/i.test(h));
        const row1HasEmail = row1.some(h => /^(이메일|Email|email|EMAIL)$/i.test(h));

        if (!row0HasEmail && row1HasEmail) {
            headerRowIndex = 1;
        }

        const header = (values[headerRowIndex] || []).map(v => String(v || '').trim());
        const rows = values.slice(headerRowIndex + 1);

        console.log(`✅ 헤더: ${header.join(', ')}`);
        console.log(`✅ 데이터 행 수: ${rows.length}`);

        // 컬럼 인덱스 찾기 (한글이름 우선, 없으면 이름 사용)
        const emailIdx = header.findIndex(h => /^(이메일|Email|email|EMAIL)$/i.test(h));
        const koreanNameIdx = header.findIndex(h => /^(한글이름|한글 이름)$/i.test(h));
        const nameIdx = header.findIndex(h => /^(이름|Name|name|NAME)$/i.test(h));
        const phoneIdx = header.findIndex(h => /^(전화|전화번호|Phone|phone|PHONE|휴대폰)$/i.test(h));
        const englishNameIdx = header.findIndex(h => /^(영문이름|영문 이름|English Name|english_name)$/i.test(h));
        const nicknameIdx = header.findIndex(h => /^(닉네임|별명|Nickname|nickname)$/i.test(h));
        const kakaoIdIdx = header.findIndex(h => /^(카톡ID|카카오ID|카카오톡ID|KakaoID|Kakao ID)$/i.test(h));
        const birthDateIdx = header.findIndex(h => /^(생년월일|생일|Birth Date|birth_date|Birthday)$/i.test(h));
        const reservationDateIdx = header.findIndex(h => /^(예약일|예약날짜|Reservation Date|reservation_date)$/i.test(h));

        // 한글이름이 있으면 우선 사용, 없으면 이름 사용
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
        console.log(`  - Phone: ${phoneIdx >= 0 ? `컬럼 ${phoneIdx + 1} (${header[phoneIdx]})` : '없음'}`);
        console.log(`  - English Name: ${englishNameIdx >= 0 ? `컬럼 ${englishNameIdx + 1} (${header[englishNameIdx]})` : '없음'}`);
        console.log(`  - Nickname: ${nicknameIdx >= 0 ? `컬럼 ${nicknameIdx + 1} (${header[nicknameIdx]})` : '없음'}`);
        console.log(`  - Kakao ID: ${kakaoIdIdx >= 0 ? `컬럼 ${kakaoIdIdx + 1} (${header[kakaoIdIdx]})` : '없음'}`);
        console.log(`  - Birth Date: ${birthDateIdx >= 0 ? `컬럼 ${birthDateIdx + 1} (${header[birthDateIdx]})` : '없음'}`);
        console.log(`  - Reservation Date: ${reservationDateIdx >= 0 ? `컬럼 ${reservationDateIdx + 1} (${header[reservationDateIdx]})` : '없음'}`);

        // 데이터 파싱
        const users = [];
        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            const email = (row[emailIdx] || '').trim();
            const name = finalNameIdx >= 0 ? (row[finalNameIdx] || '').trim() : '';
            const phone = phoneIdx >= 0 ? (row[phoneIdx] || '').trim() : '';
            const englishName = englishNameIdx >= 0 ? (row[englishNameIdx] || '').trim() : '';
            const nickname = nicknameIdx >= 0 ? (row[nicknameIdx] || '').trim() : '';
            const kakaoId = kakaoIdIdx >= 0 ? (row[kakaoIdIdx] || '').trim() : '';
            const birthDate = birthDateIdx >= 0 ? (row[birthDateIdx] || '').trim() : '';
            const reservationDate = reservationDateIdx >= 0 ? (row[reservationDateIdx] || '').trim() : '';

            // 유효성 검사
            if (!email) {
                console.log(`⚠️  행 ${i + 2}: 이메일 없음, 건너뜀`);
                continue;
            }

            if (!isValidEmail(email)) {
                console.log(`⚠️  행 ${i + 2}: 이메일 형식 오류 (${email}), 건너뜀`);
                continue;
            }

            users.push({
                email,
                name: name || email.split('@')[0], // 이름 없으면 이메일 앞부분 사용
                phone_number: phone || null,
                english_name: englishName || null,
                nickname: nickname || null,
                kakao_id: kakaoId || null,
                birth_date: birthDate ? parseDate(birthDate) : null,
                reservation_date: reservationDate ? parseDate(reservationDate) : null,
                role: 'member', // 기본 역할
            });
        }

        console.log(`\n✅ 유효한 사용자 데이터: ${users.length}명`);
        return users;

    } catch (error) {
        console.error('❌ 시트 읽기 실패:', error.message);
        if (error.message.includes('Unable to parse range')) {
            console.error('💡 SH_M 시트 탭이 존재하지 않습니다. 시트 이름을 확인하세요.');
        }
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
            password: 'qwe123!', // 기본 비밀번호
            email_confirm: true, // 이메일 확인 자동 처리
            user_metadata: { name }
        });

        if (error) {
            // 이미 존재하는 경우
            if (error.message.includes('already registered')) {
                return { exists: true, userId: null };
            }
            throw error;
        }

        return { exists: false, userId: data.user.id };
    } catch (error) {
        console.error(`  ❌ Auth 생성 실패 (${email}):`, error.message);
        return { exists: false, userId: null, error: error.message };
    }
}

/**
 * users 테이블에 사용자 정보 저장
 */
async function saveToUsersTable(userId, userData) {
    try {
        const { data, error } = await supabase
            .from('users')
            .upsert({
                id: userId,
                email: userData.email,
                name: userData.name,
                phone_number: userData.phone_number,
                english_name: userData.english_name,
                nickname: userData.nickname,
                kakao_id: userData.kakao_id,
                birth_date: userData.birth_date,
                reservation_date: userData.reservation_date,
                role: userData.role,
                created_at: new Date().toISOString()
            }, {
                onConflict: 'id',
                ignoreDuplicates: false
            });

        if (error) throw error;
        return { success: true };
    } catch (error) {
        console.error(`  ❌ users 테이블 저장 실패:`, error.message);
        return { success: false, error: error.message };
    }
}/**
 * 기존 사용자 데이터 삭제
 */
async function deleteExistingUsers() {
    console.log('\n🗑️  기존 사용자 데이터 삭제 중...');

    try {
        // Auth에서 모든 사용자 목록 가져오기
        console.log('📋 Auth 사용자 목록 조회 중...');
        const { data: authData, error: authListError } = await supabase.auth.admin.listUsers();

        if (authListError) {
            console.error('❌ Auth 사용자 목록 조회 실패:', authListError.message);
            return { deleted: 0, authDeleted: 0 };
        }

        const authUsers = authData?.users || [];
        console.log(`✅ Auth에서 ${authUsers.length}명 발견`);

        if (authUsers.length === 0) {
            console.log('ℹ️  삭제할 기존 사용자가 없습니다.');
            return { deleted: 0, authDeleted: 0 };
        }

        let deletedCount = 0;
        let authDeletedCount = 0;

        // 모든 Auth 사용자 삭제
        console.log('⏳ 사용자 삭제 시작 (시간이 소요될 수 있습니다)...\n');
        for (let i = 0; i < authUsers.length; i++) {
            const user = authUsers[i];
            const progress = `[${i + 1}/${authUsers.length}]`;

            try {
                // Auth 사용자 삭제 (users 테이블도 자동 삭제됨 - CASCADE)
                const { error: authError } = await supabase.auth.admin.deleteUser(user.id);
                if (!authError) {
                    authDeletedCount++;
                    deletedCount++;
                    console.log(`${progress} ✓ 삭제: ${user.email}`);
                } else {
                    console.log(`${progress} ⚠️  Auth 삭제 실패: ${user.email} - ${authError.message}`);
                }

                // API 제한 방지 (100ms 대기)
                await new Promise(resolve => setTimeout(resolve, 100));
            } catch (error) {
                console.log(`${progress} ⚠️  삭제 예외: ${user.email} - ${error.message}`);
            }
        }

        console.log(`✅ 삭제 완료: Auth ${authDeletedCount}명, users 테이블 ${deletedCount}명`);
        return { deleted: deletedCount, authDeleted: authDeletedCount };

    } catch (error) {
        console.error('❌ 삭제 중 오류:', error.message);
        return { deleted: 0, authDeleted: 0 };
    }
}

/**
 * 메인 이관 함수
 */
async function main() {
    console.log('╔════════════════════════════════════════════════════════════╗');
    console.log('║  Step 1: SH_M 시트 → users 테이블 이관 (전체 새로고침)   ║');
    console.log('╚════════════════════════════════════════════════════════════╝');

    try {
        // 1. 기존 사용자 데이터 삭제
        const deleteResult = await deleteExistingUsers();

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
            deletedBefore: deleteResult.deleted
        };

        for (let i = 0; i < users.length; i++) {
            const user = users[i];
            const progress = `[${i + 1}/${users.length}]`;

            console.log(`${progress} ${user.email} (${user.name})`);

            // Auth 사용자 생성
            const authResult = await createAuthUser(user.email, user.name);

            if (!authResult.userId) {
                console.log(`  ❌ Auth 생성 실패`);
                stats.failed++;
                continue;
            }

            // users 테이블에 저장
            const saveResult = await saveToUsersTable(authResult.userId, user);

            if (saveResult.success) {
                console.log(`  ✅ 등록 완료 (ID: ${authResult.userId.substring(0, 8)}...)`);
                stats.success++;
            } else {
                console.log(`  ❌ 테이블 저장 실패`);
                stats.failed++;
            }

            // API 제한 방지 (100ms 대기)
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
        const logFile = path.join(reportsDir, `step1-users-import_${timestamp}.log`);

        const logContent = `
Step 1: SH_M 시트 → users 테이블 이관 결과 (전체 새로고침)
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
    main().catch(error => {
        console.error('❌ 치명적 오류:', error);
        process.exit(1);
    });
}

module.exports = { main, readUsersFromSheet, createAuthUser, saveToUsersTable, deleteExistingUsers };
