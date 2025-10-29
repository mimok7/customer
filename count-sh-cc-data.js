#!/usr/bin/env node
/**
 * SH_CC 시트 데이터 개수 확인 스크립트
 */

const { GoogleAuth } = require('google-auth-library');
const { google } = require('googleapis');
const path = require('path');
const dotenv = require('dotenv');

// Load environment variables
try { dotenv.config({ path: path.join(process.cwd(), '.env.local') }); } catch { }
try { dotenv.config({ path: path.join(process.cwd(), '.env') }); } catch { }

const GOOGLE_SHEETS_ID = process.env.GOOGLE_SHEETS_ID;
const GOOGLE_SERVICE_ACCOUNT = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const GOOGLE_SERVICE_KEY = process.env.GOOGLE_SERVICE_ACCOUNT_KEY;

if (!GOOGLE_SHEETS_ID || !GOOGLE_SERVICE_ACCOUNT || !GOOGLE_SERVICE_KEY) {
    console.error('❌ Missing Google Sheets env variables.');
    process.exit(1);
}

async function getSheetsClient() {
    const auth = new GoogleAuth({
        credentials: {
            client_email: GOOGLE_SERVICE_ACCOUNT,
            private_key: GOOGLE_SERVICE_KEY.replace(/\\n/g, '\n'),
        },
        scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly'],
    });
    const authClient = await auth.getClient();
    return google.sheets({ version: 'v4', auth: authClient });
}

async function main() {
    console.log('📊 SH_CC 시트 데이터 개수 확인\n');

    try {
        const sheets = await getSheetsClient();

        // 전체 데이터 조회 (A열 기준)
        console.log('🔍 전체 데이터 조회 중...');
        const response = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range: 'SH_CC!A:A', // A열 전체
        });

        const rows = response.data.values || [];
        const dataCount = rows.length - 1; // 헤더 제외

        console.log(`\n✅ SH_CC 시트 데이터 개수: ${dataCount}건 (헤더 제외)\n`);

        // 구분별 개수 확인
        console.log('📋 구분별 데이터 개수 확인 중...');
        const dataResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range: 'SH_CC!D:E', // D열(구분), E열(분류)
        });

        const dataRows = dataResponse.data.values || [];
        const categories = {};
        const classifications = {};

        // 헤더 제외하고 카운트
        for (let i = 1; i < dataRows.length; i++) {
            const category = dataRows[i][0] || '(비어있음)';
            const classification = dataRows[i][1] || '(비어있음)';

            categories[category] = (categories[category] || 0) + 1;
            classifications[classification] = (classifications[classification] || 0) + 1;
        }

        console.log('\n구분(D열) 통계:');
        Object.entries(categories).forEach(([key, count]) => {
            console.log(`  - ${key}: ${count}건`);
        });

        console.log('\n분류(E열) 통계:');
        Object.entries(classifications).forEach(([key, count]) => {
            console.log(`  - ${key}: ${count}건`);
        });

        // 승차일 범위 확인
        console.log('\n📅 승차일 범위 확인 중...');
        const dateResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range: 'SH_CC!C:C', // C열(승차일)
        });

        const dateRows = dateResponse.data.values || [];
        const dates = [];

        for (let i = 1; i < dateRows.length; i++) {
            if (dateRows[i][0]) {
                dates.push(dateRows[i][0]);
            }
        }

        if (dates.length > 0) {
            console.log(`\n승차일 범위:`);
            console.log(`  - 최소: ${dates[0]}`);
            console.log(`  - 최대: ${dates[dates.length - 1]}`);
            console.log(`  - 샘플: ${dates.slice(0, 5).join(', ')}`);
        }

        console.log('\n✅ 데이터 개수 확인 완료!');
        console.log(`\n📌 총 ${dataCount}건의 데이터가 이관 대상입니다.\n`);

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        process.exit(1);
    }
}

main();
