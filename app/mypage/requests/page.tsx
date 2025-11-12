'use client';

import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import PageWrapper from '@/components/PageWrapper';
import SectionBox from '@/components/SectionBox';
import supabase from '@/lib/supabase';
import logger from '@/lib/logger';

// 타입 정의
interface CustomerRequest {
    id: string;
    request_id: string;
    request_type: string;
    request_category: string;
    title: string;
    description: string;
    urgency_level: string;
    status: string;
    related_quote_id?: string;
    related_reservation_id?: string;
    response_message?: string;
    created_at: string;
    updated_at: string;
    processed_at?: string;
}

interface QuoteOption {
    id: string;
    title: string;
    status: string;
    created_at: string;
}

interface ReservationOption {
    re_id: string;
    re_quote_id: string;
    re_type: string;
    re_status: string;
    created_at: string;
    quote?: {
        title: string;
    };
}

export default function CustomerRequestsPage() {
    const router = useRouter();
    const [user, setUser] = useState<any>(null);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState<'list' | 'create' | 'notifications'>('notifications');

    const handleGoHome = () => {
        router.push('/mypage');
    };

    // 요청사항 목록
    const [requests, setRequests] = useState<CustomerRequest[]>([]);
    // 알림 목록 (payment_notifications 기반)
    const [notifications, setNotifications] = useState<any[]>([]);
    const [notifRealtimeEnabled, setNotifRealtimeEnabled] = useState(false);

    // 새 요청사항 폼
    const [requestForm, setRequestForm] = useState({
        request_type: '',
        request_category: '',
        title: '',
        description: '',
        urgency_level: 'normal',
        related_quote_id: '',
        related_reservation_id: ''
    });

    // 선택 옵션들
    const [quoteOptions, setQuoteOptions] = useState<QuoteOption[]>([]);
    const [reservationOptions, setReservationOptions] = useState<ReservationOption[]>([]);
    // 예약 옵션의 quote title 매핑용
    const [quoteMap, setQuoteMap] = useState<Record<string, string>>({});

    // 상세보기 모달
    const [showDetailModal, setShowDetailModal] = useState(false);
    const [selectedRequest, setSelectedRequest] = useState<CustomerRequest | null>(null);

    const requestTypes = [
        { value: 'quote_modification', label: '견적 수정', category: '견적수정요청' },
        { value: 'reservation_modification', label: '예약 변경', category: '예약변경요청' },
        { value: 'service_inquiry', label: '서비스 문의', category: '서비스문의' },
        { value: 'complaint', label: '불만 접수', category: '불만접수' },
        { value: 'cancellation', label: '취소 요청', category: '취소요청' },
        { value: 'additional_service', label: '추가 서비스', category: '추가서비스요청' },
        { value: 'other', label: '기타 요청', category: '기타요청' }
    ];

    const urgencyLevels = [
        { value: 'low', label: '낮음', color: 'bg-gray-100 text-gray-600' },
        { value: 'normal', label: '보통', color: 'bg-blue-100 text-blue-600' },
        { value: 'high', label: '높음', color: 'bg-yellow-100 text-yellow-600' },
        { value: 'urgent', label: '긴급', color: 'bg-red-100 text-red-600' }
    ];

    const statusLabels = [
        { value: 'pending', label: '대기중', color: 'bg-yellow-100 text-yellow-600' },
        { value: 'in_progress', label: '처리중', color: 'bg-blue-100 text-blue-600' },
        { value: 'completed', label: '완료', color: 'bg-green-100 text-green-600' },
        { value: 'rejected', label: '거부', color: 'bg-red-100 text-red-600' },
        { value: 'cancelled', label: '취소', color: 'bg-gray-100 text-gray-600' }
    ];

    useEffect(() => {
        checkAuth();
    }, []);

    useEffect(() => {
        if (user) {
            // Parallelize independent data loads for faster initial render
            (async () => {
                try {
                    await Promise.allSettled([
                        loadRequests(),
                        loadQuoteOptions(),
                        loadReservationOptions(),
                        loadNotifications(),
                    ]);
                    setupRealtime();
                } catch (e) {
                    // non-fatal, just log
                    logger.error('Parallel data load failed', e);
                }
            })();
        }
    }, [user]);

    const checkAuth = async () => {
        try {
            const { data: { user }, error: userError } = await supabase.auth.getUser();
            if (userError || !user) {
                alert('로그인이 필요합니다.');
                router.push('/login');
                return;
            }
            setUser(user);
        } catch (error) {
            logger.error('인증 확인 오류:', error);
            router.push('/login');
        } finally {
            setLoading(false);
        }
    };

    const loadRequests = async () => {
        try {
            // 사용자 null 체크
            if (!user?.id) {
                logger.warn('사용자 정보가 없습니다.');
                return;
            }

            logger.debug('요청사항 로드 시작 - 사용자 ID:', user.id);

            const { data, error } = await supabase
                .from('customer_requests')
                .select('*')
                .eq('user_id', user.id)
                .order('created_at', { ascending: false });

            if (error) {
                logger.error('요청사항 조회 에러:', error);
                throw error;
            }

            logger.debug('요청사항 로드 완료:', data?.length || 0, '개');
            setRequests(data || []);
        } catch (error) {
            logger.error('요청사항 로드 오류:', {
                error: error,
                message: error instanceof Error ? error.message : '알 수 없는 오류',
                stack: error instanceof Error ? error.stack : undefined,
                userId: user?.id
            });
            alert('요청사항을 불러오는데 실패했습니다.');
        }
    };

    const loadNotifications = async () => {
        try {
            // 사용자 null 체크
            if (!user?.id) {
                logger.warn('사용자 정보가 없습니다.');
                return;
            }

            logger.debug('알림 로드 시작 - 사용자 ID:', user.id);

            // 사용자 예약 ID를 먼저 조회하고, 해당 예약에 대한 payment_notifications 조회
            const { data: reservations, error: rErr } = await supabase
                .from('reservation')
                .select('re_id')
                .eq('re_user_id', user.id);

            if (rErr) {
                logger.error('예약 조회 에러:', rErr);
                throw rErr;
            }

            const reservationIds = (reservations || []).map(r => r.re_id);
            logger.debug('사용자 예약 ID들:', reservationIds);

            if (reservationIds.length === 0) {
                console.log('사용자의 예약이 없어 알림을 로드하지 않습니다.');
                setNotifications([]);
                return;
            }

            const { data: notifs, error: nErr } = await supabase
                .from('payment_notifications')
                .select('id, reservation_id, notification_type, notification_date, is_sent, message_content, priority, created_at')
                .in('reservation_id', reservationIds)
                .order('notification_date', { ascending: true });

            if (nErr) {
                logger.error('알림 조회 에러:', nErr);
                throw nErr;
            }

            logger.debug('알림 로드 완료:', notifs?.length || 0, '개');
            setNotifications(notifs || []);
        } catch (error) {
            logger.error('알림 로드 오류:', {
                error: error,
                message: error instanceof Error ? error.message : '알 수 없는 오류',
                stack: error instanceof Error ? error.stack : undefined,
                userId: user?.id
            });
        }
    };

    const setupRealtime = () => {
        if (notifRealtimeEnabled) return;
        try {
            const channel = supabase
                .channel('payment_notifications_changes')
                .on('postgres_changes', { event: '*', schema: 'public', table: 'payment_notifications' }, (payload: any) => {
                    loadNotifications();
                    if (typeof window !== 'undefined' && 'Notification' in window) {
                        if (Notification.permission === 'granted') {
                            const rec: any = payload.new;
                            const title = '새 알림 도착';
                            const body = rec?.message_content || '결제/일정 관련 알림이 도착했습니다.';
                            try { new Notification(title, { body }); } catch { }
                        }
                    }
                })
                .subscribe();
            setNotifRealtimeEnabled(true);
        } catch (e) {
            logger.warn('실시간 구독 설정 실패:', e);
        }
    };

    const loadQuoteOptions = async () => {
        try {
            // 사용자 null 체크
            if (!user?.id) {
                logger.warn('사용자 정보가 없습니다.');
                return;
            }

            logger.debug('견적 옵션 로드 시작 - 사용자 ID:', user.id);

            const { data, error } = await supabase
                .from('quote')
                .select('id, title, status, created_at')
                .eq('user_id', user.id)
                .order('created_at', { ascending: false })
                .limit(10);

            if (error) {
                logger.error('견적 조회 에러:', error);
                throw error;
            }

            logger.debug('견적 옵션 로드 완료:', data?.length || 0, '개');
            setQuoteOptions(data || []);
        } catch (error) {
            logger.error('견적 옵션 로드 오류:', {
                error: error,
                message: error instanceof Error ? error.message : '알 수 없는 오류',
                stack: error instanceof Error ? error.stack : undefined,
                userId: user?.id
            });
        }
    };

    const loadReservationOptions = async () => {
        try {
            // 사용자 null 체크
            if (!user?.id) {
                logger.warn('사용자 정보가 없습니다.');
                return;
            }

            logger.debug('예약 옵션 로드 시작 - 사용자 ID:', user.id);

            const { data, error } = await supabase
                .from('reservation')
                .select('re_id, re_quote_id, re_type, re_status, created_at')
                .eq('re_user_id', user.id)
                .order('created_at', { ascending: false })
                .limit(10);

            if (error) {
                logger.error('예약 조회 에러:', error);
                throw error;
            }

            logger.debug('예약 데이터 로드 완료:', data?.length || 0, '개');
            setReservationOptions(data || []);

            // quote title 매핑
            const quoteIds = (data || []).map(r => r.re_quote_id).filter(Boolean);
            logger.debug('매핑할 견적 ID들:', quoteIds);

            if (quoteIds.length > 0) {
                const { data: quotes, error: quotesError } = await supabase
                    .from('quote')
                    .select('id, title')
                    .in('id', quoteIds);

                if (quotesError) {
                    logger.error('견적 조회 에러:', quotesError);
                    // 견적 조회 실패해도 예약 옵션은 유지
                    setQuoteMap({});
                    return;
                }

                logger.debug('견적 데이터 로드 완료:', quotes?.length || 0, '개');
                const map = Object.fromEntries((quotes || []).map(q => [q.id, q.title]));
                logger.debug('견적 매핑 완료:', map);
                setQuoteMap(map);
            } else {
                setQuoteMap({});
            }
        } catch (error) {
            logger.error('예약 옵션 로드 오류:', {
                error: error,
                message: error instanceof Error ? error.message : '알 수 없는 오류',
                stack: error instanceof Error ? error.stack : undefined,
                userId: user?.id
            });
        }
    };

    const handleSubmitRequest = async (e: React.FormEvent) => {
        e.preventDefault();

        if (!requestForm.title.trim() || !requestForm.description.trim()) {
            alert('제목과 내용을 모두 입력해주세요.');
            return;
        }

        // 사용자 null 체크
        if (!user?.id) {
            alert('사용자 정보가 없습니다. 다시 로그인해주세요.');
            return;
        }

        try {
            const selectedType = requestTypes.find(t => t.value === requestForm.request_type);

            const requestData = {
                user_id: user.id,
                request_type: requestForm.request_type,
                request_category: selectedType?.category || '기타요청',
                title: requestForm.title,
                description: requestForm.description,
                urgency_level: requestForm.urgency_level,
                related_quote_id: requestForm.related_quote_id || null,
                related_reservation_id: requestForm.related_reservation_id || null,
                status: 'pending'
            };

            logger.debug('요청사항 등록 시도:', requestData);

            const { error } = await supabase
                .from('customer_requests')
                .insert(requestData);

            if (error) {
                logger.error('요청사항 등록 DB 에러:', error);
                throw error;
            }

            alert('요청사항이 성공적으로 등록되었습니다.');

            // 폼 초기화
            setRequestForm({
                request_type: '',
                request_category: '',
                title: '',
                description: '',
                urgency_level: 'normal',
                related_quote_id: '',
                related_reservation_id: ''
            });

            // 목록 새로고침 및 탭 이동
            await loadRequests();
            setActiveTab('list');

        } catch (error) {
            logger.error('요청사항 등록 오류:', {
                error: error,
                message: error instanceof Error ? error.message : '알 수 없는 오류',
                stack: error instanceof Error ? error.stack : undefined,
                userId: user?.id
            });
            alert('요청사항 등록에 실패했습니다.');
        }
    };

    const handleRequestDetail = (request: CustomerRequest) => {
        setSelectedRequest(request);
        setShowDetailModal(true);
    };

    const getStatusDisplay = (status: string) => {
        const statusInfo = statusLabels.find(s => s.value === status);
        return statusInfo || { label: status, color: 'bg-gray-100 text-gray-600' };
    };

    const getUrgencyDisplay = (urgency: string) => {
        const urgencyInfo = urgencyLevels.find(u => u.value === urgency);
        return urgencyInfo || { label: urgency, color: 'bg-gray-100 text-gray-600' };
    };

    if (loading) {
        return (
            <PageWrapper title="요청사항 관리">
                <div className="flex justify-center items-center h-64">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
                    <p className="ml-4 text-gray-600">데이터를 불러오는 중...</p>
                </div>
            </PageWrapper>
        );
    }

    const requestNotificationPermission = async () => {
        if (typeof window === 'undefined') return;
        if (!('Notification' in window)) {
            alert('브라우저가 알림을 지원하지 않습니다.');
            return;
        }
        const perm = await Notification.requestPermission();
        if (perm === 'granted') {
            try { new Notification('알림이 활성화되었습니다.', { body: '새 알림이 도착하면 알려드릴게요.' }); } catch { }
        } else {
            alert('알림 권한이 허용되지 않았습니다. 브라우저 설정을 확인해주세요.');
        }
    };

    return (
        <PageWrapper title="� 알림 및 요청사항">
            {/* 탭 네비게이션 */}
            <div className="mb-6">
                <div className="flex gap-4 border-b border-gray-200">
                    <button
                        onClick={() => setActiveTab('notifications')}
                        className={`px-4 py-2 text-sm font-medium border-b-2 transition-colors ${activeTab === 'notifications'
                            ? 'border-blue-500 text-blue-600'
                            : 'border-transparent text-gray-500 hover:text-gray-700'
                            }`}
                    >
                        🔔 알림
                    </button>
                    <button
                        onClick={() => setActiveTab('list')}
                        className={`px-4 py-2 text-sm font-medium border-b-2 transition-colors ${activeTab === 'list'
                            ? 'border-blue-500 text-blue-600'
                            : 'border-transparent text-gray-500 hover:text-gray-700'
                            }`}
                    >
                        📋 요청사항 목록
                    </button>
                    <button
                        onClick={() => setActiveTab('create')}
                        className={`px-4 py-2 text-sm font-medium border-b-2 transition-colors ${activeTab === 'create'
                            ? 'border-blue-500 text-blue-600'
                            : 'border-transparent text-gray-500 hover:text-gray-700'
                            }`}
                    >
                        ✏️ 새 요청사항
                    </button>
                </div>
            </div>

            {/* 알림 목록 */}
            {activeTab === 'notifications' && (
                <SectionBox title="내 알림">
                    <div className="flex justify-between items-center mb-4">
                        <p className="text-sm text-gray-600">새로운 알림이 도착하면 브라우저 알림으로 알려드립니다.</p>
                        <button
                            type="button"
                            className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors text-sm font-medium"
                            onClick={requestNotificationPermission}
                        >
                            📲 스마트폰 알림 활성화
                        </button>
                    </div>
                    {notifications.length === 0 ? (
                        <div className="text-center py-8 text-gray-500">표시할 알림이 없습니다.</div>
                    ) : (
                        <div className="space-y-3">
                            {notifications.map((n) => (
                                <div key={n.id} className="border rounded p-3 bg-white flex items-start justify-between">
                                    <div>
                                        <div className="text-sm text-gray-700 mb-1">
                                            {n.notification_type === 'payment_due' && '💳 결제 예정 알림'}
                                            {n.notification_type === 'payment_overdue' && '⚠️ 결제 연체 알림'}
                                            {n.notification_type === 'checkin_reminder' && '🏨 체크인 알림'}
                                            {!['payment_due', 'payment_overdue', 'checkin_reminder'].includes(n.notification_type) && '📌 일반 알림'}
                                        </div>
                                        <div className="text-gray-900 text-sm whitespace-pre-line">{n.message_content}</div>
                                        <div className="text-xs text-gray-500 mt-1">알림일: {new Date(n.notification_date).toLocaleDateString('ko-KR')}</div>
                                    </div>
                                    <div className="text-xs">
                                        {n.priority === 'urgent' && <span className="px-2 py-1 bg-red-100 text-red-700 rounded">긴급</span>}
                                        {n.priority === 'high' && <span className="px-2 py-1 bg-orange-100 text-orange-700 rounded">중요</span>}
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </SectionBox>
            )}

            {/* 요청사항 목록 */}
            {activeTab === 'list' && (
                <SectionBox title="나의 요청사항 목록">
                    {requests.length === 0 ? (
                        <div className="text-center py-8">
                            <p className="text-gray-500 mb-4">등록된 요청사항이 없습니다.</p>
                            <button
                                onClick={() => setActiveTab('create')}
                                className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                            >
                                첫 요청사항 등록하기
                            </button>
                        </div>
                    ) : (
                        <div className="space-y-4">
                            {requests.map((request) => (
                                <div
                                    key={request.id}
                                    className="bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow cursor-pointer"
                                    onClick={() => handleRequestDetail(request)}
                                >
                                    <div className="flex justify-between items-start mb-2">
                                        <h3 className="font-medium text-gray-900">{request.title}</h3>
                                        <div className="flex gap-2">
                                            <span className={`px-2 py-1 rounded-full text-xs font-medium ${getUrgencyDisplay(request.urgency_level).color}`}>
                                                {getUrgencyDisplay(request.urgency_level).label}
                                            </span>
                                            <span className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusDisplay(request.status).color}`}>
                                                {getStatusDisplay(request.status).label}
                                            </span>
                                        </div>
                                    </div>

                                    <p className="text-sm text-gray-600 mb-2">{request.request_category}</p>
                                    <p className="text-sm text-gray-700 line-clamp-2">{request.description}</p>

                                    <div className="flex justify-between items-center mt-3 text-xs text-gray-500">
                                        <span>요청일: {new Date(request.created_at).toLocaleDateString('ko-KR')}</span>
                                        <span>ID: {request.request_id}</span>
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </SectionBox>
            )}

            {/* 새 요청사항 등록 */}
            {activeTab === 'create' && (
                <SectionBox title="새 요청사항 등록">
                    <form onSubmit={handleSubmitRequest} className="space-y-6">
                        {/* 요청 유형 선택 */}
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                요청 유형 *
                            </label>
                            <select
                                value={requestForm.request_type}
                                onChange={(e) => {
                                    const selectedType = requestTypes.find(t => t.value === e.target.value);
                                    setRequestForm({
                                        ...requestForm,
                                        request_type: e.target.value,
                                        request_category: selectedType?.category || ''
                                    });
                                }}
                                className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                required
                            >
                                <option value="">요청 유형을 선택하세요</option>
                                {requestTypes.map((type) => (
                                    <option key={type.value} value={type.value}>
                                        {type.label}
                                    </option>
                                ))}
                            </select>
                        </div>

                        {/* 관련 견적 선택 (견적 수정시) */}
                        {requestForm.request_type === 'quote_modification' && (
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">
                                    관련 견적 선택 *
                                </label>
                                <select
                                    value={requestForm.related_quote_id}
                                    onChange={(e) => setRequestForm({ ...requestForm, related_quote_id: e.target.value })}
                                    className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    required
                                >
                                    <option value="">견적을 선택하세요</option>
                                    {quoteOptions.map((quote) => (
                                        <option key={quote.id} value={quote.id}>
                                            {quote.title} ({quote.status}) - {new Date(quote.created_at).toLocaleDateString('ko-KR')}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        )}

                        {/* 관련 예약 선택 (예약 변경시) */}
                        {requestForm.request_type === 'reservation_modification' && (
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">
                                    관련 예약 선택 *
                                </label>
                                <select
                                    value={requestForm.related_reservation_id}
                                    onChange={(e) => setRequestForm({ ...requestForm, related_reservation_id: e.target.value })}
                                    className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    required
                                >
                                    <option value="">예약을 선택하세요</option>
                                    {reservationOptions.map((reservation) => (
                                        <option key={reservation.re_id} value={reservation.re_id}>
                                            {quoteMap[reservation.re_quote_id] || reservation.re_type} ({reservation.re_status}) - {new Date(reservation.created_at).toLocaleDateString('ko-KR')}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        )}

                        {/* 제목 */}
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                제목 *
                            </label>
                            <input
                                type="text"
                                value={requestForm.title}
                                onChange={(e) => setRequestForm({ ...requestForm, title: e.target.value })}
                                className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                placeholder="요청사항의 제목을 입력하세요"
                                required
                            />
                        </div>

                        {/* 내용 */}
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                상세 내용 *
                            </label>
                            <textarea
                                value={requestForm.description}
                                onChange={(e) => setRequestForm({ ...requestForm, description: e.target.value })}
                                rows={6}
                                className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                                placeholder="요청사항의 상세 내용을 입력하세요"
                                required
                            />
                        </div>

                        {/* 긴급도 */}
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                긴급도
                            </label>
                            <div className="flex gap-4">
                                {urgencyLevels.map((level) => (
                                    <label key={level.value} className="flex items-center">
                                        <input
                                            type="radio"
                                            name="urgency_level"
                                            value={level.value}
                                            checked={requestForm.urgency_level === level.value}
                                            onChange={(e) => setRequestForm({ ...requestForm, urgency_level: e.target.value })}
                                            className="mr-2"
                                        />
                                        <span className={`px-2 py-1 rounded-full text-xs font-medium ${level.color}`}>
                                            {level.label}
                                        </span>
                                    </label>
                                ))}
                            </div>
                        </div>

                        {/* 제출 버튼 */}
                        <div className="flex gap-3">
                            <button
                                type="submit"
                                className="px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                            >
                                요청사항 등록
                            </button>
                            <button
                                type="button"
                                onClick={() => setActiveTab('list')}
                                className="px-6 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition-colors"
                            >
                                목록으로
                            </button>
                        </div>
                    </form>
                </SectionBox>
            )}

            {/* 상세보기 모달 */}
            {showDetailModal && selectedRequest && (
                <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
                    <div className="bg-white rounded-lg max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto">
                        <div className="p-6">
                            <div className="flex justify-between items-start mb-4">
                                <h3 className="text-lg font-bold text-gray-900">요청사항 상세</h3>
                                <button
                                    onClick={() => setShowDetailModal(false)}
                                    className="text-gray-400 hover:text-gray-600 text-xl"
                                >
                                    ×
                                </button>
                            </div>

                            <div className="space-y-4">
                                <div>
                                    <span className="text-sm font-medium text-gray-600">요청 번호:</span>
                                    <span className="ml-2 text-sm text-gray-800">{selectedRequest.request_id}</span>
                                </div>

                                <div>
                                    <span className="text-sm font-medium text-gray-600">요청 유형:</span>
                                    <span className="ml-2 text-sm text-gray-800">{selectedRequest.request_category}</span>
                                </div>

                                <div className="flex gap-4">
                                    <div>
                                        <span className="text-sm font-medium text-gray-600">상태:</span>
                                        <span className={`ml-2 px-2 py-1 rounded-full text-xs font-medium ${getStatusDisplay(selectedRequest.status).color}`}>
                                            {getStatusDisplay(selectedRequest.status).label}
                                        </span>
                                    </div>
                                    <div>
                                        <span className="text-sm font-medium text-gray-600">긴급도:</span>
                                        <span className={`ml-2 px-2 py-1 rounded-full text-xs font-medium ${getUrgencyDisplay(selectedRequest.urgency_level).color}`}>
                                            {getUrgencyDisplay(selectedRequest.urgency_level).label}
                                        </span>
                                    </div>
                                </div>

                                <div>
                                    <span className="text-sm font-medium text-gray-600">제목:</span>
                                    <p className="text-gray-800 mt-1">{selectedRequest.title}</p>
                                </div>

                                <div>
                                    <span className="text-sm font-medium text-gray-600">내용:</span>
                                    <p className="text-gray-700 mt-1 whitespace-pre-line bg-gray-50 p-3 rounded">{selectedRequest.description}</p>
                                </div>

                                {selectedRequest.response_message && (
                                    <div>
                                        <span className="text-sm font-medium text-gray-600">처리 결과:</span>
                                        <p className="text-gray-700 mt-1 whitespace-pre-line bg-blue-50 p-3 rounded border-l-4 border-blue-400">{selectedRequest.response_message}</p>
                                    </div>
                                )}

                                <div className="grid grid-cols-2 gap-4 text-sm">
                                    <div>
                                        <span className="font-medium text-gray-600">요청일시:</span>
                                        <p className="text-gray-800">{new Date(selectedRequest.created_at).toLocaleString('ko-KR')}</p>
                                    </div>
                                    {selectedRequest.processed_at && (
                                        <div>
                                            <span className="font-medium text-gray-600">처리일시:</span>
                                            <p className="text-gray-800">{new Date(selectedRequest.processed_at).toLocaleString('ko-KR')}</p>
                                        </div>
                                    )}
                                </div>
                            </div>

                            <div className="flex justify-between mt-6">
                                <button
                                    onClick={handleGoHome}
                                    className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
                                >
                                    🏠 홈으로
                                </button>
                                <button
                                    onClick={() => setShowDetailModal(false)}
                                    className="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition-colors"
                                >
                                    닫기
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </PageWrapper>
    );
}
