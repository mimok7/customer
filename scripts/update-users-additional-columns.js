/**
 * 기존 users 테이블에 추가 컬럼 데이터 업데이트
 * SH_M 시트에서: 예약일, 영문이름, 닉네임, 전화번호, 카톡ID, 생년월일
 */

require('dotenv').config({ path: '.env.local' });
const { google } = require('googleapis');
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

// Supabase 클라이언트 설정
const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

// Google Sheets API 설정
const SPREADSHEET_ID = process.env.GOOGLE_SHEETS_ID;
const SHEET_NAME = 'SH_M';
const GOOGLE_SERVICE_ACCOUNT = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const GOOGLE_SERVICE_KEY = process.env.GOOGLE_SERVICE_ACCOUNT_KEY;

/**
 * Google Sheets 클라이언트 생성
 */
async function getSheetsClient() {
    const auth = new google.auth.GoogleAuth({
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
        const date = new Date(1900, 0, days - 1);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    return null;
}

/**
 * SH_M 시트에서 추가 데이터 읽기
 */
async function readAdditionalDataFromSheet(sheets) {
    try {
        const response = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: `${SHEET_NAME}!A:Z`,
        });

        const rows = response.data.values;
        if (!rows || rows.length === 0) {
            console.log('❌ 시트에 데이터가 없습니다.');
            return [];
        }

        // 헤더 분석
        const headers = rows[0];
        console.log('\n📋 컬럼 헤더:', headers);

        // 컬럼 인덱스 찾기
        const emailIdx = headers.findIndex(h => /^(이메일|email)$/i.test(h));
        const phoneIdx = headers.findIndex(h => /^(전화번호|전화|Phone|phone_number)$/i.test(h));
        const englishNameIdx = headers.findIndex(h => /^(영문이름|영문 이름|English Name|english_name)$/i.test(h));
        const nicknameIdx = headers.findIndex(h => /^(닉네임|별명|Nickname|nickname)$/i.test(h));
        const kakaoIdIdx = headers.findIndex(h => /^(카톡ID|카카오ID|카카오톡ID|KakaoID|Kakao ID)$/i.test(h));
        const birthDateIdx = headers.findIndex(h => /^(생년월일|생일|Birth Date|birth_date|Birthday)$/i.test(h));
        const reservationDateIdx = headers.findIndex(h => /^(예약일|예약날짜|Reservation Date|reservation_date)$/i.test(h));

        console.log(`\n✅ 컬럼 매핑:`);
        console.log(`  - 이메일: ${emailIdx} (${headers[emailIdx]})`);
        console.log(`  - 전화번호: ${phoneIdx >= 0 ? `${phoneIdx} (${headers[phoneIdx]})` : '없음'}`);
        console.log(`  - 영문이름: ${englishNameIdx >= 0 ? `${englishNameIdx} (${headers[englishNameIdx]})` : '없음'}`);
        console.log(`  - 닉네임: ${nicknameIdx >= 0 ? `${nicknameIdx} (${headers[nicknameIdx]})` : '없음'}`);
        console.log(`  - 카톡ID: ${kakaoIdIdx >= 0 ? `${kakaoIdIdx} (${headers[kakaoIdIdx]})` : '없음'}`);
        console.log(`  - 생년월일: ${birthDateIdx >= 0 ? `${birthDateIdx} (${headers[birthDateIdx]})` : '없음'}`);
        console.log(`  - 예약일: ${reservationDateIdx >= 0 ? `${reservationDateIdx} (${headers[reservationDateIdx]})` : '없음'}`);

        if (emailIdx === -1) {
            console.log('❌ 이메일 컬럼을 찾을 수 없습니다.');
            return [];
        }

        // 데이터 추출
        const usersData = [];
        for (let i = 1; i < rows.length; i++) {
            const row = rows[i];
            const email = row[emailIdx]?.trim();

            if (!isValidEmail(email)) {
                continue;
            }

            const phone = phoneIdx >= 0 ? row[phoneIdx]?.trim() : null;
            const englishName = englishNameIdx >= 0 ? row[englishNameIdx]?.trim() : null;
            const nickname = nicknameIdx >= 0 ? row[nicknameIdx]?.trim() : null;
            const kakaoId = kakaoIdIdx >= 0 ? row[kakaoIdIdx]?.trim() : null;
            const birthDate = birthDateIdx >= 0 ? row[birthDateIdx]?.trim() : null;
            const reservationDate = reservationDateIdx >= 0 ? row[reservationDateIdx]?.trim() : null;

            usersData.push({
                email,
                phone_number: phone || null,
                english_name: englishName || null,
                nickname: nickname || null,
                kakao_id: kakaoId || null,
                birth_date: birthDate ? parseDate(birthDate) : null,
                reservation_date: reservationDate ? parseDate(reservationDate) : null,
            });
        }

        console.log(`\n✅ 유효한 사용자 데이터: ${usersData.length}명`);
        return usersData;

    } catch (error) {
        console.error('❌ 시트 읽기 실패:', error.message);
        throw error;
    }
}

/**
 * users 테이블 업데이트
 */
async function updateUsersTable(userData) {
    try {
        const { data, error } = await supabase
            .from('users')
            .update({
                phone_number: userData.phone_number,
                english_name: userData.english_name,
                nickname: userData.nickname,
                kakao_id: userData.kakao_id,
                birth_date: userData.birth_date,
                reservation_date: userData.reservation_date,
                updated_at: new Date().toISOString()
            })
            .eq('email', userData.email);

        if (error) throw error;
        return { success: true };
    } catch (error) {
        return { success: false, error: error.message };
    }
}

/**
 * 메인 업데이트 함수
 */
async function main() {
    console.log('╔════════════════════════════════════════════════════════════╗');
    console.log('║  users 테이블 추가 컬럼 업데이트                           ║');
    console.log('║  예약일, 영문이름, 닉네임, 전화번호, 카톡ID, 생년월일     ║');
    console.log('╚════════════════════════════════════════════════════════════╝');

    const startTime = Date.now();
    const logMessages = [];

    try {
        // 1. Google Sheets 연결
        console.log('\n🔌 Google Sheets 연결 중...');
        const sheets = await getSheetsClient();
        console.log('✅ Google Sheets 연결 성공');

        // 2. SH_M 시트에서 추가 데이터 읽기
        const usersData = await readAdditionalDataFromSheet(sheets);

        if (usersData.length === 0) {
            console.log('\n❌ 업데이트할 데이터가 없습니다.');
            return;
        }

        // 3. Supabase users 테이블 업데이트
        console.log('\n📤 users 테이블 업데이트 시작...');
        console.log(`총 ${usersData.length}명 처리 예정\n`);

        let stats = {
            success: 0,
            failed: 0,
            notFound: 0,
            total: usersData.length
        };

        for (let i = 0; i < usersData.length; i++) {
            const userData = usersData[i];
            const progress = `[${i + 1}/${usersData.length}]`;

            // 사용자가 DB에 존재하는지 확인
            const { data: existingUser, error: findError } = await supabase
                .from('users')
                .select('id, email')
                .eq('email', userData.email)
                .single();

            if (findError || !existingUser) {
                console.log(`${progress} ${userData.email}`);
                console.log(`  ⚠️  사용자 없음 - 스킵`);
                stats.notFound++;
                logMessages.push(`${progress} ${userData.email} - 사용자 없음`);
                continue;
            }

            // 업데이트 실행
            console.log(`${progress} ${userData.email}`);
            const updateResult = await updateUsersTable(userData);

            if (updateResult.success) {
                console.log(`  ✅ 업데이트 성공`);
                stats.success++;

                // 업데이트된 필드 로그
                const updatedFields = [];
                if (userData.phone_number) updatedFields.push('전화');
                if (userData.english_name) updatedFields.push('영문이름');
                if (userData.nickname) updatedFields.push('닉네임');
                if (userData.kakao_id) updatedFields.push('카톡ID');
                if (userData.birth_date) updatedFields.push('생년월일');
                if (userData.reservation_date) updatedFields.push('예약일');

                if (updatedFields.length > 0) {
                    console.log(`     📝 ${updatedFields.join(', ')}`);
                }

                logMessages.push(`${progress} ${userData.email} - 성공`);
            } else {
                console.log(`  ❌ 업데이트 실패: ${updateResult.error}`);
                stats.failed++;
                logMessages.push(`${progress} ${userData.email} - 실패: ${updateResult.error}`);
            }

            // 진행률 표시 (100명마다)
            if ((i + 1) % 100 === 0) {
                const percent = ((i + 1) / usersData.length * 100).toFixed(1);
                console.log(`\n⏳ 진행률: ${percent}% (${i + 1}/${usersData.length})\n`);
            }
        }

        // 결과 출력
        const endTime = Date.now();
        const duration = ((endTime - startTime) / 1000).toFixed(2);

        console.log('\n╔════════════════════════════════════════════════════════════╗');
        console.log('║  업데이트 완료                                             ║');
        console.log('╚════════════════════════════════════════════════════════════╝');
        console.log(`\n📊 결과 통계:`);
        console.log(`  ✅ 성공: ${stats.success}명`);
        console.log(`  ⚠️  사용자 없음: ${stats.notFound}명`);
        console.log(`  ❌ 실패: ${stats.failed}명`);
        console.log(`  📋 전체: ${stats.total}명`);
        console.log(`  ⏱️  소요 시간: ${duration}초`);

        // 로그 파일 저장
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-').split('.')[0];
        const logPath = `reports/update-users-additional-columns_${timestamp}.log`;

        const logContent = [
            '='.repeat(60),
            'users 테이블 추가 컬럼 업데이트 로그',
            `실행 시간: ${new Date().toISOString()}`,
            `소요 시간: ${duration}초`,
            '='.repeat(60),
            '',
            '📊 결과 통계:',
            `  - 성공: ${stats.success}명`,
            `  - 사용자 없음: ${stats.notFound}명`,
            `  - 실패: ${stats.failed}명`,
            `  - 전체: ${stats.total}명`,
            '',
            '='.repeat(60),
            '상세 로그:',
            '='.repeat(60),
            ...logMessages
        ].join('\n');

        fs.writeFileSync(logPath, logContent, 'utf8');
        console.log(`\n📝 로그 파일 저장: ${process.cwd()}\\${logPath}`);

        if (stats.failed > 0) {
            console.log('\n⚠️  일부 항목이 실패했습니다. 로그를 확인하세요.');
        }

    } catch (error) {
        console.error('\n❌ 처리 중 오류 발생:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

// 실행
main();
