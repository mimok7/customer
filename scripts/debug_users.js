const { createClient } = require('@supabase/supabase-js');

// .env.local 파일 수동 로드
require('dotenv').config({ path: '.env.local' });

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

async function checkData() {
    try {
        // 1. reservation 데이터 확인
        const { data: reservations, error: resError } = await supabase
            .from('reservation')
            .select('re_id, re_user_id, re_type, re_status')
            .limit(5);

        console.log('📋 Reservations (첫 5개):');
        console.log('Error:', resError?.message || 'none');
        console.log('Count:', reservations?.length || 0);
        if (reservations?.length > 0) {
            reservations.forEach((r, i) => {
                console.log(`  [${i + 1}] ID: ${r.re_id.slice(0, 8)}... UserID: ${r.re_user_id?.slice(0, 8) || 'null'}... Type: ${r.re_type}`);
            });
        }

        // 2. users 데이터 확인
        const userIds = reservations?.map(r => r.re_user_id).filter(Boolean) || [];
        if (userIds.length > 0) {
            const { data: users, error: userError } = await supabase
                .from('users')
                .select('id, name, email')
                .in('id', userIds);

            console.log('\n👥 Users:');
            console.log('Error:', userError?.message || 'none');
            console.log('Count:', users?.length || 0);
            if (users?.length > 0) {
                users.forEach((u, i) => {
                    console.log(`  [${i + 1}] ID: ${u.id.slice(0, 8)}... Name: '${u.name || 'null'}' Email: '${u.email || 'null'}'`);
                });
            }
        } else {
            console.log('\n👥 Users: No userIds to check');
        }

    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

checkData();
