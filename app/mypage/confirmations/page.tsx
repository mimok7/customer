'use client';
import React from 'react';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import supabase from '../../../lib/supabase';
import PageWrapper from '../../../components/PageWrapper';
import SectionBox from '../../../components/SectionBox';
import Link from 'next/link';

interface Quote {
    id: string;
    quote_id: string;
    title: string;
    total_price: number;
    payment_status: string;
    created_at: string;
    confirmed_at?: string;
    reservation_count: number;
}

export default function MyConfirmationsPage() {
    const router = useRouter();
    const [user, setUser] = useState<any>(null);
    const [quotes, setQuotes] = useState<Quote[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    // 결제 완료만 보여주므로 filter 상태 제거

    const handleGoHome = () => {
        router.push('/mypage');
    };

    useEffect(() => {
        const fetchData = async () => {
            const { data: userData } = await supabase.auth.getUser();
            if (!userData?.user) {
                alert('로그인이 필요합니다.');
                router.push('/login');
                return;
            }

            setUser(userData.user);
            await loadQuotes(userData.user.id);
        };

        fetchData();
    }, [router]);

    // 필터 관련 useEffect 제거

    const loadQuotes = async (userId: string) => {
        try {
            setIsLoading(true);

            // 1. 결제 완료된 예약(payment_status = 'completed') 조회
            const { data: completedPayments, error: paymentError } = await supabase
                .from('reservation_payment')
                .select('reservation_id')
                .eq('user_id', userId)
                .eq('payment_status', 'completed');

            if (paymentError) {
                console.error('결제 조회 실패:', paymentError);
                setQuotes([]);
                setIsLoading(false);
                return;
            }

            const completedReservationIds = completedPayments?.map(p => p.reservation_id) || [];
            if (completedReservationIds.length === 0) {
                setQuotes([]);
                setIsLoading(false);
                return;
            }

            // 2. 해당 예약 정보 조회
            const { data: reservations, error: reservationError } = await supabase
                .from('reservation')
                .select('re_id, re_quote_id, re_user_id')
                .in('re_id', completedReservationIds);

            if (reservationError) {
                console.error('예약 조회 실패:', reservationError);
                setQuotes([]);
                setIsLoading(false);
                return;
            }

            // 3. 본인 예약만 필터링
            const myReservations = reservations?.filter(r => r.re_user_id === userId) || [];
            const myQuoteIds = myReservations.map(r => r.re_quote_id);
            if (myQuoteIds.length === 0) {
                setQuotes([]);
                setIsLoading(false);
                return;
            }

            // 4. 해당 quote 정보 조회
            const { data: quotesData, error: quotesError } = await supabase
                .from('quote')
                .select('*')
                .in('id', myQuoteIds)
                .order('created_at', { ascending: false });

            if (quotesError) {
                console.error('견적 조회 실패:', quotesError);
                setQuotes([]);
                setIsLoading(false);
                return;
            }

            // 5. 각 quote별 서비스 개수 집계 (quote_item)
            const { data: quoteItems, error: quoteItemError } = await supabase
                .from('quote_item')
                .select('quote_id')
                .in('quote_id', myQuoteIds);

            if (quoteItemError) {
                console.error('quote_item 조회 실패:', quoteItemError);
            }

            const serviceCountMap = new Map<string, number>();
            quoteItems?.forEach(item => {
                const count = serviceCountMap.get(item.quote_id) || 0;
                serviceCountMap.set(item.quote_id, count + 1);
            });

            const processedQuotes: Quote[] = quotesData.map(quote => ({
                id: quote.id,
                quote_id: quote.quote_id || quote.id,
                title: quote.title || '제목 없음',
                total_price: quote.total_price || 0,
                payment_status: quote.payment_status || 'pending',
                created_at: quote.created_at,
                confirmed_at: quote.confirmed_at,
                reservation_count: serviceCountMap.get(quote.id) || 0 // 서비스 개수로 변경
            }));

            setQuotes(processedQuotes);

        } catch (error) {
            console.error('데이터 로드 실패:', error);
            setQuotes([]);
        } finally {
            setIsLoading(false);
        }
    };

    const viewConfirmation = (quote: Quote) => {
        const confirmationUrl = `/customer/confirmation?quote_id=${quote.id}&token=customer`;
        window.open(confirmationUrl, '_blank');
    };

    const formatDate = (dateString: string) => {
        return new Date(dateString).toLocaleDateString('ko-KR', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        });
    };

    const getStatusBadge = (status: string, hasReservations: boolean) => {
        if (status === 'paid' && hasReservations) {
            return <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">✅ 예약완료</span>;
        } else if (status === 'paid') {
            return <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">💳 결제완료</span>;
        } else {
            return <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">📋 견적대기</span>;
        }
    };

    if (isLoading) {
        return (
            <PageWrapper title="예약확인서">
                <div className="text-center py-12">
                    <div className="text-4xl mb-4">🔄</div>
                    <p>로딩 중...</p>
                </div>
            </PageWrapper>
        );
    }

    // paidQuotes만 사용, pendingQuotes 제거
    const paidQuotes = quotes;

    return (
        <PageWrapper title="예약확인서">
            {/* 홈 + 새로고침 버튼 */}
            <div className="flex justify-end items-center gap-2 mb-4">
                <button
                    onClick={handleGoHome}
                    className="flex items-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors text-sm"
                >
                    🏠 홈
                </button>
                <button
                    onClick={() => loadQuotes(user?.id)}
                    className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm"
                >
                    🔄 새로고침
                </button>
            </div>

            {/* 상단 안내 */}
            <SectionBox title="">
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-6 mb-6">
                    <div className="flex items-start space-x-4">
                        <div className="text-3xl">📄</div>
                        <div>
                            <h2 className="text-lg font-semibold text-blue-900 mb-2">나의 예약확인서</h2>
                            <p className="text-blue-700 text-sm">
                                결제가 완료된 예약의 확인서를 확인하고 인쇄할 수 있습니다.
                                확인서에는 여행 상세 정보, 준비사항, 연락처 등이 포함되어 있습니다.
                            </p>
                        </div>
                    </div>
                </div>
            </SectionBox>

            {/* 새로고침 버튼 영역 삭제 */}

            {/* 예약 목록 - 결제 완료된 예약만 표시 */}
            <SectionBox title="예약 목록">
                {quotes.length === 0 ? (
                    <div className="text-center py-12">
                        <div className="text-4xl mb-4">📭</div>
                        <h3 className="text-lg font-medium text-gray-900 mb-2">예약 내역이 없습니다</h3>
                        <p className="text-gray-600 mb-6">결제 완료된 예약이 없습니다.</p>
                        <Link
                            href="/mypage/quotes/new"
                            className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                        >
                            <span className="mr-2">📝</span>
                            새 견적 생성하기
                        </Link>
                    </div>
                ) : (
                    <div className="space-y-4">
                        {quotes.map((quote) => (
                            <div key={quote.id} className="bg-white border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow">
                                <div className="flex items-center justify-between">
                                    <div className="flex-1">
                                        <div className="flex items-center space-x-3 mb-2">
                                            <h3 className="text-lg font-semibold text-gray-900">{quote.title}</h3>
                                            {getStatusBadge(quote.payment_status, quote.reservation_count > 0)}
                                        </div>
                                        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm text-gray-600">
                                            <div>
                                                <span className="font-medium">예약번호:</span>
                                                <div className="font-mono text-xs">{quote.quote_id}</div>
                                            </div>
                                            <div>
                                                <span className="font-medium">예약일:</span>
                                                <div>{formatDate(quote.created_at)}</div>
                                            </div>
                                            <div>
                                                <span className="font-medium">서비스:</span>
                                                <div>{quote.reservation_count}개</div>
                                            </div>
                                            <div>
                                                <span className="font-medium">총 금액:</span>
                                                <div className="text-blue-600 font-bold">{quote.total_price.toLocaleString()}동</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="flex items-center space-x-3 ml-6">
                                        <button
                                            onClick={() => viewConfirmation(quote)}
                                            className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm flex items-center space-x-2"
                                        >
                                            <span>📄</span>
                                            <span>확인서 보기</span>
                                        </button>
                                        {quote.confirmed_at && (
                                            <div className="text-xs text-green-600">
                                                발송완료: {formatDate(quote.confirmed_at)}
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </SectionBox>

            {/* 안내사항 */}
            <SectionBox title="">
                <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-6">
                    <h3 className="text-lg font-semibold text-yellow-800 mb-3 flex items-center">
                        <span className="mr-2">💡</span>
                        예약확인서 안내
                    </h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6 text-sm text-yellow-700">
                        <div>
                            <h4 className="font-semibold mb-2">📄 확인서 내용</h4>
                            <ul className="space-y-1">
                                <li>• 예약자 정보 및 연락처</li>
                                <li>• 예약 서비스 상세 내역</li>
                                <li>• 여행 일정 및 준비사항</li>
                                <li>• 긴급연락처 및 고객지원</li>
                            </ul>
                        </div>
                        <div>
                            <h4 className="font-semibold mb-2">🖨️ 이용 방법</h4>
                            <ul className="space-y-1">
                                <li>• 확인서 페이지에서 인쇄 가능</li>
                                <li>• 여행 시 출력본 지참 권장</li>
                                <li>• 모바일에서도 열람 가능</li>
                                <li>• 24시간 언제든 접근 가능</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </SectionBox>

            {/* 통계 요약 */}
            {quotes.length > 0 && (
                <SectionBox title="">
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 text-center">
                            <div className="text-2xl text-blue-600 mb-2">📊</div>
                            <div className="text-xl font-bold text-blue-800">{quotes.length}</div>
                            <div className="text-sm text-blue-600">전체 견적</div>
                        </div>
                        <div className="bg-green-50 border border-green-200 rounded-lg p-4 text-center">
                            <div className="text-2xl text-green-600 mb-2">✅</div>
                            <div className="text-xl font-bold text-green-800">{paidQuotes.length}</div>
                            <div className="text-sm text-green-600">예약 완료</div>
                        </div>
                        <div className="bg-orange-50 border border-orange-200 rounded-lg p-4 text-center">
                            <div className="text-2xl text-orange-600 mb-2">💰</div>
                            <div className="text-xl font-bold text-orange-800">
                                {paidQuotes.reduce((sum, quote) => sum + quote.total_price, 0).toLocaleString()}동
                            </div>
                            <div className="text-sm text-orange-600">총 결제 금액</div>
                        </div>
                    </div>
                </SectionBox>
            )}
        </PageWrapper>
    );
}
