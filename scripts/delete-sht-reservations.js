#!/usr/bin/env node
/**
 * SHT 예약 데이터 삭제 스크립트
 * - reservation 테이블의 re_type='sht' 데이터 삭제
 * - reservation_car_sht 테이블은 CASCADE로 자동 삭제됨
 */
const { createClient } = require('@supabase/supabase-js');
const dotenv = require('dotenv');
const path = require('path');

// Load environment variables
try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
    console.error('❌ Missing SUPABASE env variables.');
    process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

async function deleteSHTReservations() {
    console.log('🗑️  SHT 예약 데이터 삭제 시작...\n');

    // 1. 삭제 전 확인
    const { count: beforeCount } = await supabase
        .from('reservation')
        .select('*', { count: 'exact', head: true })
        .eq('re_type', 'sht');

    console.log(`📋 삭제 대상: ${beforeCount}건\n`);

    if (beforeCount === 0) {
        console.log('✅ 삭제할 데이터가 없습니다.');
        return;
    }

    // 2. 삭제 실행
    const { error: deleteError } = await supabase
        .from('reservation')
        .delete()
        .eq('re_type', 'sht');

    if (deleteError) {
        console.error('❌ 삭제 실패:', deleteError);
        process.exit(1);
    }

    // 3. 삭제 후 확인
    const { count: afterCount } = await supabase
        .from('reservation')
        .select('*', { count: 'exact', head: true })
        .eq('re_type', 'sht');

    console.log(`✅ 삭제 완료!`);
    console.log(`   - 삭제 전: ${beforeCount}건`);
    console.log(`   - 삭제 후: ${afterCount}건`);
    console.log(`   - 삭제된 건수: ${beforeCount - afterCount}건\n`);
}

deleteSHTReservations().then(() => {
    console.log('✅ 작업 완료!');
    process.exit(0);
}).catch(err => {
    console.error('\n❌ 오류 발생:', err);
    process.exit(1);
});
