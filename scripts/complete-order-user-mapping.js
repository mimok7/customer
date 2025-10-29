require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function completeOrderUserMapping() {
    console.log('🔄 Order-User 매핑 완성 시작\n');

    // 1. 누락된 Order ID 정보 로드
    const missingMappings = JSON.parse(fs.readFileSync('scripts/missing-order-mappings-result.json', 'utf-8'));
    const foundOrderInfo = missingMappings.foundInShM;

    console.log(`📊 처리할 Order ID: ${Object.keys(foundOrderInfo).length}개\n`);

    // 2. 기존 매핑 파일 로드
    const existingMapping = JSON.parse(fs.readFileSync('scripts/mapping-order-user.json', 'utf-8'));
    console.log(`📋 기존 매핑: ${Object.keys(existingMapping).length}개\n`);

    // 3. Email로 users 테이블에서 User ID 찾기
    const newMappings = {};
    const notFound = [];
    const pendingUsers = [];

    console.log('============================================================');
    console.log('🔍 Users 테이블에서 매칭 시작');
    console.log('============================================================\n');

    for (const [orderId, info] of Object.entries(foundOrderInfo)) {
        const email = info.email?.toLowerCase().trim();
        const phone = info.phone?.trim();
        const nameKr = info.nameKr;

        console.log(`🔍 ${orderId} (${nameKr})`);
        console.log(`   Email: ${email || '(없음)'}`);
        console.log(`   Phone: ${phone || '(없음)'}`);

        // Email로 먼저 검색
        let user = null;
        if (email) {
            const { data, error } = await supabase
                .from('users')
                .select('id, name, email, status')
                .eq('email', email)
                .single();

            if (!error && data) {
                user = data;
            }
        }

        // Email로 못 찾으면 Phone으로 검색
        if (!user && phone) {
            const { data, error } = await supabase
                .from('users')
                .select('id, name, email, status')
                .eq('phone_number', phone)
                .single();

            if (!error && data) {
                user = data;
            }
        }

        if (user) {
            console.log(`   ✅ 매칭 성공: ${user.name} (${user.id})`);
            console.log(`   Status: ${user.status}`);
            newMappings[orderId] = user.id;

            if (user.status === 'pending') {
                pendingUsers.push({ orderId, userId: user.id, name: user.name, email: user.email });
            }
        } else {
            console.log(`   ❌ 매칭 실패: users 테이블에 없음`);
            notFound.push({ orderId, email, phone, nameKr });
        }
        console.log('');
    }

    // 4. 기존 매핑에 새 매핑 추가
    const updatedMapping = { ...existingMapping, ...newMappings };

    console.log('============================================================');
    console.log('📊 매핑 결과');
    console.log('============================================================');
    console.log(`   - 새로운 매핑 추가: ${Object.keys(newMappings).length}개`);
    console.log(`   - 매핑 실패: ${notFound.length}개`);
    console.log(`   - Pending 상태 사용자: ${pendingUsers.length}명`);
    console.log(`   - 총 매핑: ${Object.keys(updatedMapping).length}개`);
    console.log('');

    // 5. 업데이트된 매핑 파일 저장
    fs.writeFileSync('scripts/mapping-order-user.json', JSON.stringify(updatedMapping, null, 2));
    console.log('✅ mapping-order-user.json 업데이트 완료\n');

    // 6. Pending 사용자 목록 저장 (활성화 필요)
    if (pendingUsers.length > 0) {
        console.log('============================================================');
        console.log('⚠️  Pending 상태 사용자 목록');
        console.log('============================================================\n');

        pendingUsers.forEach(u => {
            console.log(`   - ${u.name} (${u.email}): ${u.userId}`);
        });
        console.log('');

        fs.writeFileSync('scripts/pending-users-to-activate.json', JSON.stringify({
            timestamp: new Date().toISOString(),
            count: pendingUsers.length,
            users: pendingUsers
        }, null, 2));

        console.log('✅ pending-users-to-activate.json 저장\n');
        console.log('💡 다음 단계: 이 사용자들을 활성화해야 retry가 성공합니다.\n');
    }

    // 7. 매칭 실패 케이스 저장
    if (notFound.length > 0) {
        console.log('============================================================');
        console.log('❌ 매칭 실패 Order ID');
        console.log('============================================================\n');

        notFound.forEach(nf => {
            console.log(`   - ${nf.orderId} (${nf.nameKr}): ${nf.email || nf.phone || 'no contact'}`);
        });
        console.log('');

        fs.writeFileSync('scripts/unmatched-order-ids.json', JSON.stringify({
            timestamp: new Date().toISOString(),
            count: notFound.length,
            orderIds: notFound
        }, null, 2));

        console.log('✅ unmatched-order-ids.json 저장\n');
    }

    console.log('🎉 Order-User 매핑 완성!');
}

completeOrderUserMapping().catch(console.error);
