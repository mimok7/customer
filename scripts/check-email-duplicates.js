require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function checkEmailDuplicates() {
    console.log('🔍 이메일 중복 확인\n');

    // 1. Auth 사용자 목록 조회
    console.log('============================================================');
    console.log('📋 Auth 사용자 확인');
    console.log('============================================================\n');

    const { data: authUsers, error: authError } = await supabase.auth.admin.listUsers();

    if (authError) {
        console.error('❌ Auth 사용자 조회 실패:', authError.message);
        return;
    }

    console.log(`✅ Auth 사용자: ${authUsers.users.length}명\n`);

    // 2. Users 테이블 사용자 수
    console.log('============================================================');
    console.log('📋 Users 테이블 확인');
    console.log('============================================================\n');

    const { data: dbUsers, error: dbError } = await supabase
        .from('users')
        .select('id, email, name, role, status');

    if (dbError) {
        console.error('❌ Users 테이블 조회 실패:', dbError.message);
        return;
    }

    console.log(`✅ Users 테이블: ${dbUsers.length}명\n`);

    // 3. 이메일 중복 확인
    console.log('============================================================');
    console.log('📊 이메일 중복 분석');
    console.log('============================================================\n');

    const emailCount = {};
    dbUsers.forEach(user => {
        if (user.email) {
            emailCount[user.email] = (emailCount[user.email] || 0) + 1;
        }
    });

    const duplicates = Object.entries(emailCount).filter(([_, count]) => count > 1);

    if (duplicates.length === 0) {
        console.log('✅ 중복된 이메일 없음\n');
    } else {
        console.log(`⚠️  중복된 이메일: ${duplicates.length}개\n`);

        for (const [email, count] of duplicates) {
            console.log(`📧 ${email} (${count}건)`);

            const users = dbUsers.filter(u => u.email === email);
            users.forEach((u, idx) => {
                console.log(`   ${idx + 1}. ID: ${u.id.substring(0, 8)}... | Name: ${u.name || '(없음)'} | Role: ${u.role} | Status: ${u.status}`);
            });
            console.log('');
        }
    }

    // 4. Auth에는 있지만 Users 테이블에 없는 사용자
    console.log('============================================================');
    console.log('🔍 Auth ↔ Users 테이블 동기화 확인');
    console.log('============================================================\n');

    const authEmails = new Set(authUsers.users.map(u => u.email).filter(Boolean));
    const dbEmails = new Set(dbUsers.map(u => u.email).filter(Boolean));

    const onlyInAuth = authUsers.users.filter(u => u.email && !dbEmails.has(u.email));
    const onlyInDb = dbUsers.filter(u => u.email && !authEmails.has(u.email));

    if (onlyInAuth.length > 0) {
        console.log(`⚠️  Auth에만 있는 사용자: ${onlyInAuth.length}명`);
        onlyInAuth.slice(0, 5).forEach(u => {
            console.log(`   - ${u.email} (Auth ID: ${u.id.substring(0, 8)}...)`);
        });
        if (onlyInAuth.length > 5) {
            console.log(`   ... 외 ${onlyInAuth.length - 5}명`);
        }
        console.log('');
    } else {
        console.log('✅ Auth에만 있는 사용자 없음\n');
    }

    if (onlyInDb.length > 0) {
        console.log(`⚠️  Users 테이블에만 있는 사용자: ${onlyInDb.length}명 (마이그레이션된 데이터)`);
        onlyInDb.slice(0, 5).forEach(u => {
            console.log(`   - ${u.email} (DB ID: ${u.id.substring(0, 8)}...)`);
        });
        if (onlyInDb.length > 5) {
            console.log(`   ... 외 ${onlyInDb.length - 5}명`);
        }
        console.log('');
    } else {
        console.log('✅ Users 테이블에만 있는 사용자 없음\n');
    }

    // 5. 문제가 있는 이메일 상세 분석
    if (duplicates.length > 0) {
        console.log('============================================================');
        console.log('💡 해결 방법');
        console.log('============================================================\n');

        console.log('옵션 1: 중복 레코드 수동 삭제');
        console.log('   → Supabase Dashboard > Table Editor > users');
        console.log('   → 중복 이메일 검색하여 불필요한 레코드 삭제\n');

        console.log('옵션 2: SQL로 일괄 정리 (신중히!)');
        console.log('   → Supabase Dashboard > SQL Editor\n');
        console.log('-- 중복 이메일 확인');
        console.log('SELECT email, COUNT(*) as count');
        console.log('FROM users');
        console.log('GROUP BY email');
        console.log('HAVING COUNT(*) > 1;\n');

        console.log('-- 각 이메일의 최신 레코드만 남기고 삭제 (주의!)');
        console.log('DELETE FROM users');
        console.log('WHERE id NOT IN (');
        console.log('  SELECT DISTINCT ON (email) id');
        console.log('  FROM users');
        console.log('  ORDER BY email, created_at DESC NULLS LAST');
        console.log(');\n');
    }

    // 6. 통계 요약
    console.log('============================================================');
    console.log('📊 최종 통계');
    console.log('============================================================');
    console.log(`   Auth 사용자: ${authUsers.users.length}명`);
    console.log(`   Users 테이블: ${dbUsers.length}명`);
    console.log(`   이메일 중복: ${duplicates.length}건`);
    console.log(`   Auth에만 있음: ${onlyInAuth.length}명`);
    console.log(`   DB에만 있음: ${onlyInDb.length}명 (마이그레이션)`);
    console.log('');
}

checkEmailDuplicates().catch(console.error);
