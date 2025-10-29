const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });
require('dotenv').config();

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function main() {
    console.log('🔍 users 테이블 컬럼 확인\n');

    // 샘플 데이터로 컬럼 확인
    const { data: users, error } = await supabase
        .from('users')
        .select('*')
        .limit(3);

    if (error) {
        console.error('❌ 조회 오류:', error);
        return;
    }

    console.log('📊 users 테이블 컬럼:');
    if (users && users.length > 0) {
        const columns = Object.keys(users[0]);
        columns.forEach(col => {
            console.log(`   - ${col}`);
        });

        console.log('\n📝 샘플 데이터 (첫 번째 사용자):');
        console.log(JSON.stringify(users[0], null, 2));

        // order_id 컬럼이 있는지 확인
        if (columns.includes('order_id')) {
            console.log('\n✅ order_id 컬럼이 존재합니다!');

            // order_id 값이 있는 사용자 수 확인
            const { data: withOrderId } = await supabase
                .from('users')
                .select('id, email, order_id')
                .not('order_id', 'is', null);

            console.log(`\n📊 order_id 값이 있는 사용자: ${withOrderId?.length || 0}명`);
            if (withOrderId && withOrderId.length > 0) {
                console.log('\n샘플 order_id:');
                withOrderId.slice(0, 5).forEach(u => {
                    console.log(`   - order_id: ${u.order_id} | email: ${u.email}`);
                });
            }
        } else {
            console.log('\n❌ order_id 컬럼이 없습니다.');
            console.log('   대안: email, kakao_id 또는 다른 식별자를 사용해야 합니다.');
        }
    }
}

main().catch(console.error);
