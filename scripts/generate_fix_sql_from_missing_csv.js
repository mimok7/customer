const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..');
const inPath = path.join(repoRoot, 'reports', 'missing_service_details_extracted.csv');
const outPath = path.join(repoRoot, 'reports', 'missing_service_details_fix.sql');

function unquote(s) {
    if (!s) return '';
    if (s.startsWith('"') && s.endsWith('"')) return s.slice(1, -1).replace(/""/g, '"');
    return s;
}

function parseCsv(csv) {
    const rows = [];
    let cur = '';
    let inQuotes = false;
    const r = [];
    for (let i = 0; i < csv.length; i++) {
        const ch = csv[i];
        if (ch === '"') {
            if (inQuotes && csv[i + 1] === '"') { cur += '"'; i++; } else { inQuotes = !inQuotes; }
        } else if (ch === ',' && !inQuotes) {
            r.push(cur); cur = '';
        } else if ((ch === '\n' || ch === '\r') && !inQuotes) {
            if (ch === '\r' && csv[i + 1] === '\n') continue; // skip CRLF handling here, split will handle
            if (r.length > 0 || cur !== '') { r.push(cur); rows.push(r.splice(0)); cur = ''; }
        } else {
            cur += ch;
        }
    }
    if (cur !== '' || r.length > 0) { r.push(cur); rows.push(r); }
    return rows;
}

function parseKeyValueExtra(extraStr) {
    // extra column format: "k1:v1;k2:v2"
    const out = {};
    if (!extraStr) return out;
    const parts = extraStr.split(';');
    for (const p of parts) {
        const idx = p.indexOf(':');
        if (idx > -1) {
            const k = p.slice(0, idx).trim();
            const v = p.slice(idx + 1).trim();
            if (k) out[k] = v;
        }
    }
    return out;
}

function esc(s) {
    if (s === undefined || s === null || s === '') return null;
    return s.replace(/'/g, "''");
}

try {
    if (!fs.existsSync(inPath)) {
        console.error('Input CSV not found:', inPath);
        process.exit(2);
    }

    const raw = fs.readFileSync(inPath, 'utf8');
    const lines = raw.split(/\r?\n/);
    const header = lines.shift();
    if (!header) { console.error('Empty CSV'); process.exit(2); }
    const headers = parseCsv(header)[0].map(unquote);

    const rows = [];
    for (const ln of lines) {
        if (!ln.trim()) continue;
        const parsed = parseCsv(ln)[0].map(unquote);
        const obj = {};
        for (let i = 0; i < headers.length; i++) obj[headers[i]] = parsed[i] || '';
        rows.push(obj);
    }

    const blocks = []; // each block is a multi-line string for one reservation
    let generated = 0;

    for (const r of rows) {
        const id = r.re_id;
        const type = (r.re_type || '').toLowerCase();
        const created = r.re_created_at || '';
        const extra = parseKeyValueExtra(r.extra || '');

        // prefer explicit datetime in extra, else fallback to re_created_at
        const dtCandidates = [extra.ra_datetime, extra.pickup_datetime, extra.pickup_date, extra.usage_date, created];
        const datetime = dtCandidates.find(Boolean) || null;

        // helpers
        const idQ = id ? `'${esc(id)}'` : 'NULL';
        const dtQ = datetime ? `'${esc(datetime)}'` : 'NULL';

        if (!id) continue;

        // Generate table-specific minimal INSERTs with safe existence check
        if (type === 'airport') {
            const airport_price_code = extra.airport_price_code || '';
            const apcQ = airport_price_code ? `'${esc(airport_price_code)}'` : 'NULL';
            const block = [];
            block.push(`-- reservation_airport for reservation ${id}`);
            block.push(`INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)`);
            block.push(`SELECT ${idQ}, ${dtQ}, ${apcQ}`);
            block.push(`WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = ${idQ});`);
            blocks.push(block.join('\n'));
            generated++;
        } else if (type === 'rentcar' || type === 'rent-car' || type === 'rent_car') {
            const rent_price_code = extra.rentcar_price_code || extra.rent_price_code || '';
            const rpcQ = rent_price_code ? `'${esc(rent_price_code)}'` : 'NULL';
            const block = [];
            block.push(`-- reservation_rentcar for reservation ${id}`);
            block.push(`INSERT INTO reservation_rentcar (reservation_id, pickup_datetime, rentcar_price_code)`);
            block.push(`SELECT ${idQ}, ${dtQ}, ${rpcQ}`);
            block.push(`WHERE NOT EXISTS (SELECT 1 FROM reservation_rentcar WHERE reservation_id = ${idQ});`);
            blocks.push(block.join('\n'));
            generated++;
        } else if (type === 'cruise') {
            // placeholder - detailed cruise handling occurs after the main type-dispatch to allow
            // building a combined reservation + detail block (below).
        } else if (type === 'car' || type.includes('sht') || type === 'car_sht' || type === 'sht_car') {
            const vehicle_number = extra.vehicle_number || '';
            const vnQ = vehicle_number ? `'${esc(vehicle_number)}'` : 'NULL';
            const block = [];
            block.push(`-- reservation_car_sht for reservation ${id}`);
            block.push(`INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)`);
            block.push(`SELECT ${idQ}, ${dtQ}, ${vnQ}`);
            block.push(`WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = ${idQ});`);
            blocks.push(block.join('\n'));
            generated++;
        } else {
            // unknown mapping: output comment for manual handling
            blocks.push(`-- SKIP: Unknown re_type '${r.re_type}' for reservation ${id}; review manually.`);
        }
        // Only create/update top-level reservation and cruise detail for cruise-type rows
        if (type === 'cruise') {
            const userQ = r.re_user_id ? `'${esc(r.re_user_id)}'` : 'NULL';
            const quoteQ = r.re_quote_id ? `'${esc(r.re_quote_id)}'` : 'NULL';
            const statusQ = r.re_status ? `'${esc(r.re_status)}'` : 'NULL';
            const createdQ = created ? `'${esc(created)}'` : 'NULL';
            const car_price_code = extra.car_price_code || '';
            const cpcQ = car_price_code ? `'${esc(car_price_code)}'` : 'NULL';

            const block = [];
            // idempotent create reservation if missing
            block.push(`-- ensure reservation for ${id}`);
            block.push(`INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)`);
            block.push(`SELECT ${idQ}, ${userQ}, ${quoteQ}, 'car', ${statusQ}, ${createdQ}`);
            block.push(`WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = ${idQ});`);
            // update only if quote or type differ (avoid unnecessary writes)
            block.push(`UPDATE reservation SET re_quote_id = ${quoteQ}, re_type = 'car'`);
            block.push(`WHERE re_id = ${idQ} AND (re_quote_id IS DISTINCT FROM ${quoteQ} OR re_type <> 'car');`);

            // then ensure cruise car detail row
            block.push(`-- reservation_cruise_car for reservation ${id}`);
            block.push(`INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)`);
            block.push(`SELECT ${idQ}, ${dtQ}, ${cpcQ}`);
            block.push(`WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = ${idQ});`);

            blocks.push(block.join('\n'));
            generated++;
        }
    }

    const banner = [];
    banner.push('-- Auto-generated SQL to insert minimal missing service-detail rows');
    banner.push('-- Review carefully before running. This script uses re_created_at as a fallback datetime where explicit service dates are absent.');
    banner.push('-- Run in a transaction and/or on a replica for verification.');
    banner.push('\nBEGIN;\n');

    // write single combined file
    const content = banner.join('\n') + '\n' + blocks.join('\n\n') + '\n\nCOMMIT;\n';
    fs.writeFileSync(outPath, content, 'utf8');

    // also write chunked files for SQL editor convenience
    const chunkSize = 100; // blocks per file
    const numChunks = Math.ceil(blocks.length / chunkSize);
    for (let i = 0; i < numChunks; i++) {
        const start = i * chunkSize;
        const chunkBlocks = blocks.slice(start, start + chunkSize);
        const chunkContent = banner.join('\n') + '\n' + chunkBlocks.join('\n\n') + '\n\nCOMMIT;\n';
        const chunkPath = path.join(repoRoot, 'reports', `missing_service_details_fix_part_${i + 1}.sql`);
        fs.writeFileSync(chunkPath, chunkContent, 'utf8');
        console.log(`Wrote chunk ${i + 1} to ${chunkPath}`);
    }

    console.log('Generated SQL statements:', generated);
    console.log('Wrote SQL file to:', outPath);
    process.exit(0);

} catch (err) {
    console.error('Error generating SQL:', err);
    process.exit(1);
}
