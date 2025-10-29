require('dotenv').config({ path: '.env.local' });
const fs = require('fs');
const path = require('path');
const { createClient } = require('@supabase/supabase-js');
const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);

(async function () {
    try {
        const outDir = path.resolve(__dirname, '..', 'reports');
        fs.mkdirSync(outDir, { recursive: true });

        const tableMap = {
            cruise: 'reservation_cruise',
            cruise_car: 'reservation_cruise_car',
            sht_car: 'reservation_sht_car',
            airport: 'reservation_airport',
            hotel: 'reservation_hotel',
            tour: 'reservation_tour',
            rentcar: 'reservation_rentcar',
            car: 'reservation_car_sht'
        };

        const colCandidates = ['reservation_id', 're_id', 'ra_reservation_id'];

        const pageSize = 1000;
        // get total count
        const totalResCountResp = await supabase.from('reservation').select('*', { head: true, count: 'exact' });
        const totalCount = totalResCountResp.count || 0;
        console.log('Total reservations (approx):', totalCount);

        let page = 0;
        let hasMore = true;
        const missing = [];
        const scanned = [];

        while (hasMore) {
            const from = page * pageSize;
            const to = (page + 1) * pageSize - 1;
            console.log(`Fetching reservations ${from}..${to}`);
            const { data: reservations, error: resError } = await supabase.from('reservation').select('re_id,re_user_id,re_quote_id,re_type,re_status,re_created_at').range(from, to).order('re_created_at', { ascending: false });
            if (resError) {
                console.error('Error fetching reservations:', resError);
                break;
            }
            if (!reservations || reservations.length === 0) break;

            for (const r of reservations) {
                const reId = r.re_id;
                const reType = r.re_type;
                const table = tableMap[reType];
                let found = false;
                let errorMsg = null;
                let tried = [];

                if (!table) {
                    missing.push(Object.assign({ reason: 'no_mapped_table', triedTables: [] }, r));
                    continue;
                }

                for (const col of colCandidates) {
                    tried.push(col);
                    try {
                        const check = await supabase.from(table).select('*', { head: true, count: 'exact' }).eq(col, reId);
                        if (check && check.count && check.count > 0) {
                            found = true;
                            break;
                        }
                        // if error (e.g., column doesn't exist), check.error will be set
                        if (check && check.error) {
                            // mark and continue to try other columns
                            // but if column doesn't exist, postgres error code 42703 will appear
                            // we'll capture message
                            // continue
                            // console.log('col check error', check.error);
                        }
                    } catch (e) {
                        // unexpected
                        errorMsg = String(e.message || e);
                    }
                }

                if (!found) {
                    // try a scan of first 1000 rows to find substring of id
                    let scannedRow = null;
                    try {
                        const all = await supabase.from(table).select('*').limit(1000);
                        const arr = all.data || [];
                        scannedRow = arr.find(row => JSON.stringify(row).includes(String(reId).slice(0, 8)));
                        if (scannedRow) {
                            found = true;
                        }
                    } catch (e) {
                        // ignore
                    }
                }

                if (!found) {
                    missing.push(Object.assign({ reason: 'no_service_row', triedColumns: tried, error: errorMsg }, r));
                }

                scanned.push(reId);
            }

            page++;
            if (reservations.length < pageSize) hasMore = false;
        }

        const outJson = path.join(outDir, 'missing_service_details.json');
        fs.writeFileSync(outJson, JSON.stringify({ generated_at: new Date().toISOString(), totalReservations: totalCount, missingCount: missing.length, items: missing }, null, 2));

        // also write CSV summary (lightweight)
        const csvPath = path.join(outDir, 'missing_service_details.csv');
        const csvHeader = 're_id,re_user_id,re_quote_id,re_type,re_status,re_created_at,reason\n';
        const csvLines = missing.map(it => `${it.re_id},${it.re_user_id},${it.re_quote_id},${it.re_type},${it.re_status},"${it.re_created_at}",${it.reason}`);
        fs.writeFileSync(csvPath, csvHeader + csvLines.join('\n'));

        console.log('\nDone. Missing count:', missing.length);
        console.log('JSON ->', outJson);
        console.log('CSV  ->', csvPath);
    } catch (err) {
        console.error('Script error:', err);
        process.exit(1);
    }
})();
