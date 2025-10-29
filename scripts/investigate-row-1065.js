require('dotenv').config({ path: '.env.local' });
const { createClient } = require('@supabase/supabase-js');
const { google } = require('googleapis');
const fs = require('fs');
const path = require('path');

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

const SPREADSHEET_ID = '1GZRHXGR9JrRbNrEGAk1KVzENDgOS0Iit7BPfGopqemA';

async function investigateRow1065() {
    console.log('🔍 행 1065 실패 케이스 분석\n');

    // 1. Google Sheets 인증
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
            private_key: process.env.GOOGLE_SERVICE_ACCOUNT_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets'],
    });

    const sheets = google.sheets({ version: 'v4', auth });

    // 2. 행 1065 데이터 가져오기 (헤더 포함이므로 실제로는 1066행)
    const response = await sheets.spreadsheets.values.get({
        spreadsheetId: SPREADSHEET_ID,
        range: 'SH_R!A1066:AC1066',
    });

    const row = response.data.values[0];

    console.log('============================================================');
    console.log('📋 행 1065 원본 데이터');
    console.log('============================================================\n');
    console.log('주문ID (B):', row[1]);
    console.log('크루즈 (C):', row[2]);
    console.log('객실종류 (E):', row[4]);
    console.log('체크인 (I):', row[8]);
    console.log('금액 (W):', row[22]);
    console.log('');

    // 3. 매핑 파일 로드
    const mappingPath = path.join(__dirname, 'mapping-order-user.json');
    const mapping = JSON.parse(fs.readFileSync(mappingPath, 'utf8'));
    const orderUserMap = mapping.orderUserMap || mapping;

    const orderId = row[1];
    const userId = orderUserMap[orderId];

    console.log('============================================================');
    console.log('🔍 Order ID → User ID 매핑');
    console.log('============================================================\n');
    console.log('Order ID:', orderId);
    console.log('Mapped User ID:', userId || '(매핑 없음)');
    console.log('');

    if (!userId) {
        console.log('❌ 이 Order ID는 매핑되지 않았습니다.');
        console.log('   → 이것이 FK 실패 원인입니다.\n');

        // SH_M에서 이 Order ID 찾기
        const shMResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: SPREADSHEET_ID,
            range: 'SH_M!A:I',
        });

        const shMRows = shMResponse.data.values.slice(1);
        const foundRow = shMRows.find(r => r[0] === orderId);

        if (foundRow) {
            console.log('✅ SH_M에서 발견:');
            console.log('   - 주문ID:', foundRow[0]);
            console.log('   - 이름:', foundRow[3]);
            console.log('   - Email:', foundRow[2] || '(없음)');
            console.log('   - 전화:', foundRow[8] || '(없음)');
            console.log('');

            const email = foundRow[2]?.toLowerCase().trim();
            if (email) {
                // Users 테이블에서 검색
                const { data: user, error } = await supabase
                    .from('users')
                    .select('id, name, email, status')
                    .eq('email', email)
                    .single();

                if (error) {
                    console.log('❌ Users 테이블에 없음:', error.message);
                } else {
                    console.log('✅ Users 테이블에 존재!');
                    console.log('   - User ID:', user.id);
                    console.log('   - Name:', user.name);
                    console.log('   - Status:', user.status);
                    console.log('');
                    console.log('💡 이 매핑을 추가하면 해결됩니다:');
                    console.log(`   "${orderId}": "${user.id}"`);
                }
            }
        } else {
            console.log('❌ SH_M에도 없음!');
        }
    } else {
        // User 정보 확인
        const { data: user, error: userError } = await supabase
            .from('users')
            .select('*')
            .eq('id', userId)
            .single();

        if (userError) {
            console.log('❌ User 조회 실패:', userError.message);
            console.log('   → User ID가 유효하지 않습니다.');
        } else {
            console.log('✅ User 확인:');
            console.log('   - Name:', user.name);
            console.log('   - Email:', user.email);
            console.log('   - Status:', user.status);
            console.log('   - Role:', user.role);
            console.log('');

            // INSERT 테스트
            console.log('🧪 INSERT 테스트...');
            const { data: insertResult, error: insertError } = await supabase
                .from('reservation')
                .insert({
                    re_user_id: userId,
                    re_type: 'cruise',
                    re_status: 'pending',
                    total_amount: 0,
                    paid_amount: 0,
                    payment_status: 'pending'
                })
                .select();

            if (insertError) {
                console.log('❌ INSERT 실패:', insertError.message);
            } else {
                console.log('✅ INSERT 성공!');
                await supabase.from('reservation').delete().eq('re_id', insertResult[0].re_id);
                console.log('   (테스트 데이터 삭제됨)');
            }
        }
    }
}

investigateRow1065().catch(console.error);
