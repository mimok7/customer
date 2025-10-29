#!/usr/bin/env node

/**
 * Supabase 스키마 캐시 새로고침
 */

const https = require('https');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config({ path: path.join(__dirname, '..', '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

// PostgREST 스키마 캐시 리로드
const url = new URL(supabaseUrl);
const reloadUrl = `${url.protocol}//${url.hostname}/rest/v1/?`;

console.log('🔄 Supabase 스키마 캐시 새로고침 중...\n');

const options = {
    hostname: url.hostname,
    path: '/rest/v1/',
    method: 'POST',
    headers: {
        'apikey': serviceKey,
        'Authorization': `Bearer ${serviceKey}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal'
    }
};

const req = https.request(options, (res) => {
    console.log(`상태 코드: ${res.statusCode}`);

    let data = '';
    res.on('data', (chunk) => {
        data += chunk;
    });

    res.on('end', () => {
        if (res.statusCode === 200 || res.statusCode === 201) {
            console.log('✅ 스키마 캐시 새로고침 성공!');
            console.log('✅ 이제 다시 테스트를 실행하세요.');
        } else {
            console.log('⚠️  응답:', data);
            console.log('\n💡 수동 방법:');
            console.log('   1. Supabase Dashboard 접속');
            console.log('   2. Settings → API');
            console.log('   3. "Reload schema" 버튼 클릭');
        }
    });
});

req.on('error', (error) => {
    console.error('❌ 오류:', error.message);
    console.log('\n💡 수동 방법을 사용하세요:');
    console.log('   1. Supabase Dashboard 접속');
    console.log('   2. Settings → API');
    console.log('   3. "Reload schema" 버튼 클릭');
});

req.end();
