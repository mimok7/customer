require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY,
    {
        auth: {
            autoRefreshToken: false,
            persistSession: false
        }
    }
);

async function deleteAllAuthUsers() {
    console.log('🗑️  모든 Auth users 삭제 시작\n');

    // 모든 Auth users 조회
    let allUsers = [];
    let page = 1;
    const perPage = 1000;

    console.log('1️⃣ 전체 사용자 목록 조회 중...\n');

    while (true) {
        const { data: users, error } = await supabase.auth.admin.listUsers({
            page: page,
            perPage: perPage
        });

        if (error) {
            console.error('❌ Auth users 조회 실패:', error);
            break;
        }

        if (!users || users.users.length === 0) break;

        allUsers = allUsers.concat(users.users);
        console.log(`   Page ${page}: ${users.users.length}개`);

        if (users.users.length < perPage) break;
        page++;
    }

    console.log(`\n✅ 총 ${allUsers.length}명 조회 완료\n`);

    // 삭제 시작
    console.log('2️⃣ 사용자 삭제 중...\n');

    let successCount = 0;
    let failCount = 0;
    const errors = [];

    for (let i = 0; i < allUsers.length; i++) {
        const user = allUsers[i];

        try {
            const { error } = await supabase.auth.admin.deleteUser(user.id);

            if (error) {
                console.error(`   ❌ 실패: ${user.email} (${error.message})`);
                failCount++;
                errors.push({ email: user.email, error: error.message });
            } else {
                successCount++;

                // 100명마다 진행상황 출력
                if (successCount % 100 === 0) {
                    console.log(`   ✅ ${successCount}/${allUsers.length} 삭제 완료...`);
                }
            }
        } catch (err) {
            console.error(`   ❌ 오류: ${user.email}`, err.message);
            failCount++;
            errors.push({ email: user.email, error: err.message });
        }

        // API rate limit 방지를 위한 짧은 지연
        if (i % 10 === 0 && i > 0) {
            await new Promise(resolve => setTimeout(resolve, 100));
        }
    }

    console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    console.log('📊 삭제 결과:');
    console.log(`   ✅ 성공: ${successCount}명`);
    console.log(`   ❌ 실패: ${failCount}명`);

    if (errors.length > 0) {
        console.log('\n❌ 실패 목록:');
        errors.forEach(err => {
            console.log(`   - ${err.email}: ${err.error}`);
        });

        const fs = require('fs');
        fs.writeFileSync(
            'delete-errors.json',
            JSON.stringify(errors, null, 2)
        );
        console.log('\n📄 실패 상세 정보 저장: delete-errors.json');
    }

    // 최종 확인
    console.log('\n3️⃣ 삭제 후 확인 중...\n');

    const { data: remainingUsers } = await supabase.auth.admin.listUsers({
        page: 1,
        perPage: 10
    });

    console.log(`✅ 남은 사용자: ${remainingUsers?.users?.length || 0}명\n`);

    if (remainingUsers?.users && remainingUsers.users.length > 0) {
        console.log('⚠️  남은 사용자 목록:');
        remainingUsers.users.forEach(u => {
            console.log(`   - ${u.email}`);
        });
    } else {
        console.log('✅ 모든 Auth 사용자가 삭제되었습니다!\n');
    }
}

deleteAllAuthUsers().catch(console.error);
