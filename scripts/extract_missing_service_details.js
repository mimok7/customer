const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..');
const inPath = path.join(repoRoot, 'reports', 'missing_service_details.json');
const outPath = path.join(repoRoot, 'reports', 'missing_service_details_extracted.csv');

function quoteCsv(val) {
    if (val === undefined || val === null) return '';
    const s = String(val);
    if (s.includes(',') || s.includes('"') || s.includes('\n')) {
        return '"' + s.replace(/"/g, '""') + '"';
    }
    return s;
}

try {
    if (!fs.existsSync(inPath)) {
        console.error('Input file not found:', inPath);
        process.exit(2);
    }

    const raw = fs.readFileSync(inPath, 'utf8');
    const parsed = JSON.parse(raw);
    const items = Array.isArray(parsed.items) ? parsed.items : [];

    const headers = [
        're_id',
        're_user_id',
        're_quote_id',
        're_type',
        're_status',
        're_created_at',
        'reason',
        'triedColumns',
        'error',
        'extra'
    ];

    const rows = [headers.join(',')];

    for (const it of items) {
        const tried = Array.isArray(it.triedColumns) ? it.triedColumns.join('|') : (it.triedColumns || '');
        const extra = [];
        // capture any other interesting keys
        for (const k of Object.keys(it)) {
            if (!headers.includes(k)) {
                // include small values
                const v = it[k];
                if (v && (typeof v === 'string' || typeof v === 'number' || typeof v === 'boolean')) {
                    extra.push(`${k}:${v}`);
                }
            }
        }

        const cols = [
            quoteCsv(it.re_id),
            quoteCsv(it.re_user_id),
            quoteCsv(it.re_quote_id),
            quoteCsv(it.re_type),
            quoteCsv(it.re_status),
            quoteCsv(it.re_created_at),
            quoteCsv(it.reason),
            quoteCsv(tried),
            quoteCsv(it.error || ''),
            quoteCsv(extra.join(';'))
        ];

        rows.push(cols.join(','));
    }

    fs.writeFileSync(outPath, rows.join('\n'), 'utf8');

    console.log('Exported', items.length, 'items to', outPath);

    // summary counts by reason
    const reasonCounts = items.reduce((acc, it) => { acc[it.reason] = (acc[it.reason] || 0) + 1; return acc; }, {});
    console.log('Reason summary:');
    for (const [k, v] of Object.entries(reasonCounts)) {
        console.log('  ', k, ':', v);
    }

    process.exit(0);
} catch (err) {
    console.error('Error during extraction:', err);
    process.exit(1);
}
