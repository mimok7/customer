'use client';

import { useEffect, useState } from 'react';
import supabase from '@/lib/supabase';

interface Notification {
    id: string;
    type: string;
    category: string;
    title: string;
    message: string;
    priority: string;
    status: string;
    created_at: string;
    due_date?: string;
    processed_by_name?: string;
    customer_notifications?: {
        customer_name: string;
        customer_phone: string;
        inquiry_type: string;
        service_type: string;
    };
    business_notifications?: {
        business_type: string;
        department: string;
        urgency_level: number;
    };
}

interface GlobalNotificationPopupProps {
    userRole?: string;
}

// 한국어 매핑 함수들
const getKoreanType = (type: string) => {
    const typeMap: { [key: string]: string } = {
        'business': '업무',
        'customer': '고객',
        'system': '시스템',
        'urgent': '긴급'
    };
    return typeMap[type] || type;
};

const getKoreanPriority = (priority: string) => {
    const priorityMap: { [key: string]: string } = {
        'low': '낮음',
        'medium': '보통',
        'high': '높음',
        'urgent': '긴급'
    };
    return priorityMap[priority] || priority;
};

const getKoreanStatus = (status: string) => {
    const statusMap: { [key: string]: string } = {
        'unread': '읽지 않음',
        'read': '읽음',
        'processing': '처리 중',
        'completed': '완료',
        'pending': '대기'
    };
    return statusMap[status] || status;
};

export default function GlobalNotificationPopup({ userRole }: GlobalNotificationPopupProps) {
    const [notifications, setNotifications] = useState<Notification[]>([]);
    const [dismissedIds, setDismissedIds] = useState<Set<string>>(new Set());

    // 매니저/관리자만 전역 알림 표시
    const shouldShowNotifications = userRole === 'manager' || userRole === 'admin';

    // 알림 데이터 로드
    const loadNotifications = async () => {
        if (!shouldShowNotifications) return;

        try {
            // 업무 알림 조회
            const { data: businessData } = await supabase
                .from('notifications')
                .select(`
          *,
          business_notifications (
            business_type,
            department,
            urgency_level,
            required_action
          )
        `)
                .eq('type', 'business')
                .in('status', ['unread', 'processing'])
                .order('created_at', { ascending: false });

            // 고객 알림 조회
            const { data: customerData } = await supabase
                .from('notifications')
                .select(`
          *,
          customer_notifications (
            customer_name,
            customer_phone,
            customer_email,
            inquiry_type,
            service_type
          )
        `)
                .eq('type', 'customer')
                .in('status', ['unread', 'processing'])
                .order('created_at', { ascending: false });

            const allNotifications = [
                ...(businessData || []),
                ...(customerData || [])
            ];

            // 긴급/높은 우선순위만 팝업으로 표시
            const urgentNotifications = allNotifications.filter(n =>
                ['urgent', 'high'].includes(n.priority) &&
                !dismissedIds.has(n.id)
            );

            setNotifications(urgentNotifications);
        } catch (error) {
            console.error('전역 알림 로드 실패:', error);
        }
    };

    // 알림 팝업 닫기
    const dismissNotification = (notificationId: string) => {
        setDismissedIds(prev => new Set([...prev, notificationId]));
        setNotifications(prev => prev.filter(n => n.id !== notificationId));
    };

    // 알림 상세 페이지로 이동
    const goToNotifications = () => {
        window.location.href = '/manager/notifications';
    };

    // 30초마다 알림 새로고침
    useEffect(() => {
        loadNotifications();
        const interval = setInterval(loadNotifications, 30000);
        return () => clearInterval(interval);
    }, [shouldShowNotifications, dismissedIds]);

    if (!shouldShowNotifications || notifications.length === 0) {
        return null;
    }

    return (
        <div className="fixed top-4 right-4 z-50 space-y-2 max-w-sm">
            {notifications.map((notification) => (
                <div
                    key={notification.id}
                    className={`
            bg-white rounded-lg shadow-lg border-l-4 p-4 animate-slideInRight
            ${notification.priority === 'urgent' ? 'border-red-500 bg-red-50' : 'border-yellow-500 bg-yellow-50'}
            transform transition-all duration-300 hover:scale-105
          `}
                >
                    {/* 헤더 */}
                    <div className="flex justify-between items-start mb-2">
                        <div className="flex items-center space-x-2">
                            <span className={`text-xs px-2 py-1 rounded-full ${notification.type === 'customer'
                                ? 'bg-blue-100 text-blue-600'
                                : 'bg-green-100 text-green-600'
                                }`}>
                                {getKoreanType(notification.type)}
                            </span>
                            <span className={`text-xs px-2 py-1 rounded-full ${notification.priority === 'urgent'
                                ? 'bg-red-100 text-red-600'
                                : 'bg-yellow-100 text-yellow-600'
                                }`}>
                                {getKoreanPriority(notification.priority)}
                            </span>
                        </div>
                        <button
                            onClick={() => dismissNotification(notification.id)}
                            className="text-gray-400 hover:text-gray-600 text-lg font-bold"
                        >
                            ×
                        </button>
                    </div>

                    {/* 제목 */}
                    <h4 className="font-bold text-sm text-gray-800 mb-1">
                        {notification.title}
                    </h4>

                    {/* 고객 정보 또는 업무 정보 */}
                    {notification.type === 'customer' && notification.customer_notifications && (
                        <div className="text-xs text-gray-600 mb-2">
                            <div>👤 {notification.customer_notifications.customer_name}</div>
                            <div>📞 {notification.customer_notifications.customer_phone}</div>
                            <div>📋 {notification.customer_notifications.inquiry_type}</div>
                        </div>
                    )}

                    {notification.type === 'business' && notification.business_notifications && (
                        <div className="text-xs text-gray-600 mb-2">
                            <div>🏢 {notification.business_notifications.department}</div>
                            <div>📋 {notification.business_notifications.business_type}</div>
                        </div>
                    )}

                    {/* 메시지 */}
                    <p className="text-xs text-gray-700 mb-3">
                        {notification.message}
                    </p>

                    {/* 시간 정보 */}
                    <div className="text-xs text-gray-500 mb-3">
                        🕒 {new Date(notification.created_at).toLocaleString('ko-KR')}
                    </div>

                    {/* 액션 버튼 */}
                    <div className="flex space-x-2">
                        <button
                            onClick={goToNotifications}
                            className="flex-1 bg-blue-500 text-white text-xs px-3 py-1 rounded hover:bg-blue-600 transition-colors"
                        >
                            알림 관리
                        </button>
                        <button
                            onClick={() => dismissNotification(notification.id)}
                            className="bg-gray-300 text-gray-700 text-xs px-3 py-1 rounded hover:bg-gray-400 transition-colors"
                        >
                            닫기
                        </button>
                    </div>
                </div>
            ))}
        </div>
    );
}
