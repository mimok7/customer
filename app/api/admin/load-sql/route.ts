import fs from 'fs';
import path from 'path';
import { NextResponse } from 'next/server';

export async function GET() {
    try {
        const projectRoot = process.cwd();
        const filePath = path.join(projectRoot, 'sql', 'update-quote-item-prices.sql');

        if (!fs.existsSync(filePath)) {
            return NextResponse.json({ error: '파일이 존재하지 않습니다.' }, { status: 404 });
        }

        const content = await fs.promises.readFile(filePath, 'utf-8');
        return NextResponse.json({ content });
    } catch (err: any) {
        return NextResponse.json({ error: String(err) }, { status: 500 });
    }
}
