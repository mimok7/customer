const https = require('https');
const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
if (!url || !key) {
    console.error('Missing env vars NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_ANON_KEY');
    process.exit(2);
}
const full = `${url.replace(/\/+$/, '')}/rest/v1/room?select=*`;
console.log('GET', full);
const options = {
    method: 'GET',
    headers: {
        apikey: key,
        Authorization: `Bearer ${key}`,
        Accept: 'application/json'
    }
};
https.get(full, options, (res) => {
    console.log('status', res.statusCode);
    let body = '';
    res.on('data', (c) => body += c);
    res.on('end', () => {
        console.log('body:', body);
        try { console.log('json:', JSON.parse(body)); } catch (e) { }
    });
}).on('error', (e) => console.error('err', e));
