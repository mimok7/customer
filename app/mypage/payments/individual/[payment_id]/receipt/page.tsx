'use client';
import { useEffect, useState } from 'react';
import { useParams, useRouter, useSearchParams } from 'next/navigation';
import PageWrapper from '@/components/PageWrapper';
import SectionBox from '@/components/SectionBox';
import supabase from '@/lib/supabase';

export default function IndividualPaymentReceiptPage() {
    const params = useParams<{ payment_id: string }>();
    const router = useRouter();
    const search = useSearchParams();
    const [loading, setLoading] = useState(true);
    const [payment, setPayment] = useState<any>(null);
    const status = search?.get('status');
    const error = search?.get('error');
    const code = search?.get('code');

    useEffect(() => {
        (async () => {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) { router.push('/login'); return; }
            const { data } = await supabase
                .from('reservation_payment')
                .select('*')
                .eq('id', params.payment_id)
                .maybeSingle();
            setPayment(data);
            setLoading(false);
        })();
    }, [params.payment_id]);

    if (loading) return <PageWrapper title="개별 결제 영수증"><div className="p-6">로딩중...</div></PageWrapper>;
    if (!payment) return <PageWrapper title="개별 결제 영수증"><div className="p-6">결제를 찾을 수 없습니다.</div></PageWrapper>;

    return (
        <PageWrapper title="개별 결제 영수증">
            <SectionBox title="영수증">
                <div className="space-y-2 text-sm">
                    {status === 'success' && (
                        <div className="bg-green-50 text-green-700 px-3 py-2 rounded mb-2">결제가 성공적으로 완료되었습니다.</div>
                    )}
                    {status === 'failed' && (
                        <div className="bg-red-50 text-red-700 px-3 py-2 rounded mb-2">
                            결제가 완료되지 않았습니다. {code === '1' ? '은행/승인 거절' : code === '2' ? '은행 통신 오류' : code === '3' ? '카드가 허용되지 않음' : code === '4' ? '카드 만료' : code === '5' ? '불충분한 잔액' : code === '7' ? '사용자 취소' : code ? `코드 ${code}` : ''}
                        </div>
                    )}
                    {error === 'hash' && (
                        <div className="bg-yellow-50 text-yellow-800 px-3 py-2 rounded mb-2">응답 검증에 실패했습니다. 고객센터로 문의해주세요.</div>
                    )}
                    <div>결제ID: {payment.id}</div>
                    <div>금액: {(payment.amount || 0).toLocaleString()}동</div>
                    <div>상태: {payment.payment_status}</div>
                    {payment.gateway && <div>게이트웨이: {payment.gateway}</div>}
                    {payment.transaction_id && <div>거래번호: {payment.transaction_id}</div>}
                    <div>수단: {payment.payment_method}</div>
                    <div>일시: {new Date(payment.created_at).toLocaleString('ko-KR')}</div>
                    {payment.raw_response && (
                        <details className="bg-gray-50 p-2 rounded mt-2">
                            <summary className="cursor-pointer text-gray-700">원문 응답 보기</summary>
                            <pre className="text-xs text-gray-600 whitespace-pre-wrap break-all">{JSON.stringify(payment.raw_response, null, 2)}</pre>
                        </details>
                    )}
                    {payment.memo && <div>메모: {payment.memo}</div>}
                </div>
            </SectionBox>
        </PageWrapper>
    );
}
