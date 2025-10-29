'use client';
import { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import PageWrapper from '@/components/PageWrapper';
import SectionBox from '@/components/SectionBox';
import supabase from '@/lib/supabase';

export default function IndividualPaymentPayPage() {
    const params = useParams<{ payment_id: string }>();
    const router = useRouter();
    const [loading, setLoading] = useState(true);
    const [payment, setPayment] = useState<any>(null);
    const [processing, setProcessing] = useState(false);

    useEffect(() => {
        (async () => {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) { router.push('/login'); return; }
            const { data } = await supabase.from('reservation_payment').select('*').eq('id', params.payment_id).maybeSingle();
            setPayment(data);
            setLoading(false);
        })();
    }, [params.payment_id]);

    const handlePay = async () => {
        if (!payment) return;
        setProcessing(true);
        try {
            const res = await fetch('/api/payments/onepay/create', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ paymentId: payment.id })
            });
            const json = await res.json();
            if (!res.ok || !json?.url) {
                alert('결제 링크 생성에 실패했습니다.');
                setProcessing(false);
                return;
            }
            // Redirect to OnePay
            window.location.href = json.url as string;
        } catch (e) {
            console.error('결제 생성 실패:', e);
            alert('결제 생성 중 오류가 발생했습니다.');
            setProcessing(false);
        }
    };

    if (loading) return <PageWrapper title="개별 결제"><div className="p-6">로딩중...</div></PageWrapper>;
    if (!payment) return <PageWrapper title="개별 결제"><div className="p-6">결제가 없습니다.</div></PageWrapper>;

    return (
        <PageWrapper title="개별 결제">
            <SectionBox title="결제 진행">
                <div className="mb-4">결제 금액: <span className="font-bold text-red-600">{(payment.amount || 0).toLocaleString()}동</span></div>
                <button disabled={processing} onClick={handlePay} className="px-4 py-2 bg-blue-600 text-white rounded disabled:opacity-50">
                    {processing ? '처리중...' : 'OnePay로 결제하기'}
                </button>
            </SectionBox>
        </PageWrapper>
    );
}
