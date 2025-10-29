const { createClient } = require('@supabase/supabase-js');
const path = require('path');
const dotenv = require('dotenv');

try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

async function main() {
    console.log('🔍 users 테이블 상세 확인\n');
    console.log('='.repeat(70));

    // 전체 사용자 수
    const { count: totalCount } = await supabase
        .from('users')
        .select('*', { count: 'exact', head: true });

    console.log(`\n전체 사용자 수: ${totalCount}명`);

    // order_id가 있는 사용자
    const { data: withOrderId, count: withOrderIdCount } = await supabase
        .from('users')
        .select('id, email, order_id, name, created_at', { count: 'exact' })
        .not('order_id', 'is', null);

    console.log(`order_id 있는 사용자: ${withOrderIdCount}명`);

    // order_id가 없는 사용자
    const { data: withoutOrderId, count: withoutOrderIdCount } = await supabase
        .from('users')
        .select('id, email, order_id, name, created_at', { count: 'exact' })
        .is('order_id', null);

    console.log(`order_id 없는 사용자: ${withoutOrderIdCount}명`);

    // 최근 추가된 사용자 (오늘)
    const today = new Date().toISOString().split('T')[0];
    const { data: todayUsers, count: todayCount } = await supabase
        .from('users')
        .select('id, email, order_id, name, created_at', { count: 'exact' })
        .gte('created_at', today);

    console.log(`\n오늘 추가된 사용자: ${todayCount}명`);

    if (todayUsers && todayUsers.length > 0) {
        console.log('\n샘플 (최대 10명):');
        todayUsers.slice(0, 10).forEach((user, idx) => {
            console.log(`${idx + 1}. ${user.email?.padEnd(35)} | order_id: ${user.order_id || '(NULL)'} | ${user.name}`);
        });
    }

    // order_id 필드 타입 확인을 위해 몇 개 샘플
    console.log('\n' + '='.repeat(70));
    console.log('order_id 필드 샘플 확인');
    console.log('='.repeat(70));

    const { data: samples } = await supabase
        .from('users')
        .select('email, order_id, name')
        .limit(5);

    if (samples) {
        samples.forEach((s, idx) => {
            console.log(`${idx + 1}. ${s.email?.padEnd(35)} | order_id: "${s.order_id}" (${typeof s.order_id})`);
        });
    }

    console.log('\n' + '='.repeat(70));
}

main().catch(console.error);
