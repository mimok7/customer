import { NextRequest, NextResponse } from 'next/server';
import serviceSupabase from '../../../../../lib/serviceSupabase';
import { buildOnepayUrl, getOnepayConfigFromEnv, getBaseSiteUrl } from '../../../../../lib/onepay';

export async function POST(req: NextRequest) {
    try {
        const cfg = getOnepayConfigFromEnv();
        if (!cfg) return NextResponse.json({ error: 'OnePay env not configured' }, { status: 500 });
        if (!serviceSupabase) return NextResponse.json({ error: 'Service client unavailable' }, { status: 500 });

        const body = await req.json();
        const paymentId: string = body?.paymentId;
        if (!paymentId) return NextResponse.json({ error: 'paymentId required' }, { status: 400 });

        // Load payment record
        const { data: payment, error } = await serviceSupabase
            .from('reservation_payment')
            .select('id, amount, reservation_id, user_id')
            .eq('id', paymentId)
            .maybeSingle();
        if (error || !payment) return NextResponse.json({ error: 'Payment not found' }, { status: 404 });

        // Ensure pending
        // Optionally: prevent duplicate if already completed
        // Create redirect URL
        const base = getBaseSiteUrl();
        const returnURL = `${base}/api/payments/onepay/return`;
        const ipnURL = `${base}/api/payments/onepay/notify`;

        const orderInfo = `SHT Payment ${payment.id}`;
        const url = buildOnepayUrl(cfg, {
            amount: Number(payment.amount || 0),
            merchTxnRef: payment.id,
            orderInfo,
            returnURL,
            ipnURL,
            currency: 'VND',
            locale: 'vn',
        });

        return NextResponse.json({ url });
    } catch (e: any) {
        console.error('OnePay create error', e);
        return NextResponse.json({ error: 'internal' }, { status: 500 });
    }
}
