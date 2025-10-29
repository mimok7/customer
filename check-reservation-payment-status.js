const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function main() {
    console.log('🔍 reservation 테이블의 payment_status 제약 조건 확인 중...\n');

    // 기존 데이터에서 payment_status 값 확인
    const { data: existing } = await supabase
        .from('reservation')
        .select('payment_status')
        .limit(10);

    console.log('📊 기존 데이터의 payment_status 값들:');
    if (existing && existing.length > 0) {
        const statusSet = new Set(existing.map(r => r.payment_status));
        console.log(Array.from(statusSet));
    } else {
        console.log('  (데이터 없음)');
    }

    console.log('\n🧪 테스트: 다양한 payment_status 값 삽입 시도...\n');

    const testStatuses = ['unpaid', 'pending', 'paid', 'partial', 'cancelled', '', null];

    for (const status of testStatuses) {
        const { error } = await supabase
            .from('reservation')
            .insert({
                re_user_id: '00000000-0000-0000-0000-000000000000',
                re_type: 'test',
                re_status: 'test',
                payment_status: status,
                total_amount: 0,
                paid_amount: 0
            });

        if (error) {
            console.log(`❌ "${status}": ${error.message.substring(0, 80)}...`);
        } else {
            console.log(`✅ "${status}": 성공`);
            // 테스트 데이터 삭제
            await supabase.from('reservation').delete().eq('re_type', 'test');
        }
    }
}

main().catch(console.error);
