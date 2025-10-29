#!/usr/bin/env node
/**
 * SH_C 시트 구조 확인 스크립트
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
    console.log('🔍 SH_C 시트 구조 확인\n');

    try {
        const sheets = await getSheetsClient();

        // 헤더 조회
        console.log('📋 헤더 조회 중...');
        const headerResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range: 'SH_C!A1:Z1',
        });

        const headers = headerResponse.data.values?.[0] || [];
        console.log(`\n✅ 총 ${headers.length}개 컬럼 발견:\n`);

        headers.forEach((header, index) => {
            const columnLetter = String.fromCharCode(65 + index); // A, B, C, ...
            console.log(`  ${columnLetter}열: ${header}`);
        });

        // 샘플 데이터 조회 (처음 5개 행)
        console.log('\n📊 샘플 데이터 조회 중 (첫 5개 행)...\n');
        const dataResponse = await sheets.spreadsheets.values.get({
            spreadsheetId: GOOGLE_SHEETS_ID,
            range: 'SH_C!A2:Z6', // 헤더 제외 5개 행
        });

        const rows = dataResponse.data.values || [];

        rows.forEach((row, rowIndex) => {
            console.log(`\n📌 행 ${rowIndex + 2}:`);
            headers.forEach((header, colIndex) => {
                const value = row[colIndex] || '(비어있음)';
                const columnLetter = String.fromCharCode(65 + colIndex);
                console.log(`  ${columnLetter}. ${header}: ${value}`);
            });
        });

        console.log('\n✅ 구조 확인 완료!');

    } catch (error) {
        console.error('❌ 오류 발생:', error.message);
        process.exit(1);
    }
}

main();
