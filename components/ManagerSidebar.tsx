"use client";
import React from 'react';
import { useRouter, usePathname } from 'next/navigation';

interface ManagerSidebarProps {
    activeTab?: string;
    userEmail?: string;
    onLogout?: () => void;
    userRole?: string;
    onClose?: () => void;
}

interface NavItemProps {
    icon: string;
    label: string;
    path: string;
    isActive: boolean;
    onClick: () => void;
}

function NavItem({ icon, label, path, isActive, onClick }: NavItemProps) {
    return (
        <button
            onClick={onClick}
            className={`w-full flex items-center px-2 py-1.5 text-xs rounded-md transition-colors ${isActive
                ? 'bg-blue-100 text-blue-700 font-medium'
                : 'text-gray-600 hover:bg-gray-50 hover:text-gray-700'
                }`}
        >
            <span className="mr-2">{icon}</span>
            <span className="truncate">{label}</span>
        </button>
    );
}

export default function ManagerSidebar({ activeTab, userEmail, onLogout, userRole, onClose }: ManagerSidebarProps) {
    const router = useRouter();
    const pathname = usePathname();

    // pathname 우선으로 활성 탭 결정 (서브 경로 우선 매핑)
    const derivedTab = (() => {
        if (!pathname) return null;
        if (pathname.startsWith('/manager/reservations/bulk')) return 'reservations-bulk';
        if (pathname === '/manager/reservations') return 'reservations';
        return null;
    })();

    const isActiveTab = (key: string) => {
        if (derivedTab) return derivedTab === key;
        if (activeTab) return activeTab === key;
        return false;
    };

    const handleNavigation = (path: string) => {
        router.push(path);
        // 모바일에서 메뉴 선택 후 사이드바 닫기
        if (onClose) {
            onClose();
        }
    };

    return (
        <div className="h-screen w-56 bg-gray-50 border-r border-gray-200 flex flex-col">
            {/* 로고/타이틀 */}
            <div className="h-16 flex items-center justify-between px-4 border-b border-gray-200 bg-white">
                <h1 className="text-lg font-bold text-gray-800">스테이하롱 매니저</h1>
                {/* 모바일 닫기 버튼 */}
                {onClose && (
                    <button
                        onClick={onClose}
                        className="lg:hidden p-1 rounded-md hover:bg-gray-100 text-gray-600"
                        aria-label="메뉴 닫기"
                    >
                        <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                )}
            </div>

            {/* 스크롤 가능한 네비게이션 */}
            <div className="flex-1 overflow-y-auto p-3">
                <div className="space-y-3">
                    {/* dispatcher 역할일 때는 리포트만 표시 */}
                    {userRole === 'dispatcher' ? (
                        <div className="bg-white rounded-lg shadow-sm border border-indigo-100">
                            <div className="bg-indigo-50 px-3 py-2 rounded-t-lg border-b border-indigo-100">
                                <h3 className="text-sm font-medium text-indigo-700 flex items-center">
                                    <span className="mr-2">📝</span>배차 리포트
                                </h3>
                            </div>
                            <div className="p-2 space-y-1">
                                <NavItem
                                    icon="🚐"
                                    label="스하 차량"
                                    path="/manager/reports/sht-car"
                                    isActive={activeTab === 'reports-sht-car'}
                                    onClick={() => handleNavigation('/manager/reports/sht-car')}
                                />
                                <NavItem
                                    icon="🚢"
                                    label="크루즈 차량"
                                    path="/manager/reports/cruise-car"
                                    isActive={activeTab === 'reports-cruise-car'}
                                    onClick={() => handleNavigation('/manager/reports/cruise-car')}
                                />
                            </div>
                        </div>
                    ) : (
                        <>
                            {/* 견적 관리 카드 */}
                            <div className="bg-white rounded-lg shadow-sm border border-blue-100">
                                <div className="bg-blue-50 px-3 py-2 rounded-t-lg border-b border-blue-100">
                                    <h3 className="text-sm font-medium text-blue-700 flex items-center">
                                        <span className="mr-2">📊</span>견적 관리
                                    </h3>
                                </div>
                                <div className="p-2 space-y-1">
                                    <NavItem
                                        icon="📈"
                                        label="통계 조회"
                                        path="/manager/analytics"
                                        isActive={activeTab === 'analytics'}
                                        onClick={() => handleNavigation('/manager/analytics')}
                                    />
                                    <NavItem
                                        icon="📋"
                                        label="견적 목록"
                                        path="/manager/quotes"
                                        isActive={activeTab === 'quotes'}
                                        onClick={() => handleNavigation('/manager/quotes')}
                                    />
                                    <NavItem
                                        icon="✍️"
                                        label="자료 입력"
                                        path="/manager/quotes/cruise"
                                        isActive={activeTab === 'quotes-cruise'}
                                        onClick={() => handleNavigation('/manager/quotes/cruise')}
                                    />
                                    <NavItem
                                        icon="📋"
                                        label="전체 검색"
                                        path="/manager/quotes/comprehensive"
                                        isActive={activeTab === 'quotes-comprehensive'}
                                        onClick={() => handleNavigation('/manager/quotes/comprehensive')}
                                    />
                                </div>
                            </div>



                            {/* 예약 조회 카드 */}
                            <div className="bg-white rounded-lg shadow-sm border border-green-100">
                                <div className="bg-green-50 px-3 py-2 rounded-t-lg border-b border-green-100">
                                    <h3 className="text-sm font-medium text-green-700 flex items-center">
                                        <span className="mr-2">🔍</span>예약 조회
                                    </h3>
                                </div>
                                <div className="p-2 space-y-1">
                                    <NavItem
                                        icon="🆕"
                                        label="신/구 구분"
                                        path="/manager/schedule/new"
                                        isActive={activeTab === 'schedule-new'}
                                        onClick={() => handleNavigation('/manager/schedule/new')}
                                    />
                                    <NavItem
                                        icon="�"
                                        label="사용자별"
                                        path="/manager/reservations"
                                        isActive={isActiveTab('reservations')}
                                        onClick={() => handleNavigation('/manager/reservations')}
                                    />
                                    <NavItem
                                        icon="📅"
                                        label="일정별"
                                        path="/manager/schedule"
                                        isActive={activeTab === 'schedule'}
                                        onClick={() => handleNavigation('/manager/schedule')}
                                    />
                                    <NavItem
                                        icon="📊"
                                        label="종류별"
                                        path="/manager/service-tables"
                                        isActive={activeTab === 'service-tables'}
                                        onClick={() => handleNavigation('/manager/service-tables')}
                                    />
                                    <NavItem
                                        icon="📆"
                                        label="예약일별"
                                        path="/manager/reservation-details"
                                        isActive={activeTab === 'reservation-details'}
                                        onClick={() => handleNavigation('/manager/reservation-details')}
                                    />
                                    <NavItem
                                        icon="🚐"
                                        label="스하 차량"
                                        path="/manager/sht-car"
                                        isActive={activeTab === 'sht-car'}
                                        onClick={() => handleNavigation('/manager/sht-car')}
                                    />
                                </div>
                            </div>

                            {/* 예약 수정 카드 */}
                            <div className="bg-white rounded-lg shadow-sm border border-orange-100">
                                <div className="bg-orange-50 px-3 py-2 rounded-t-lg border-b border-orange-100">
                                    <h3 className="text-sm font-medium text-orange-700 flex items-center">
                                        <span className="mr-2">✏️</span>수정 / 배정
                                    </h3>
                                </div>
                                <div className="p-2 space-y-1">
                                    <NavItem
                                        icon="📊"
                                        label="수정 대시보드"
                                        path="/manager/reservation-edit/main"
                                        isActive={activeTab === 'reservation-edit-main'}
                                        onClick={() => handleNavigation('/manager/reservation-edit/main')}
                                    />
                                    <NavItem
                                        icon="✏️"
                                        label="예약 수정"
                                        path="/manager/reservation-edit"
                                        isActive={activeTab === 'reservation-edit'}
                                        onClick={() => handleNavigation('/manager/reservation-edit')}
                                    />
                                    <NavItem
                                        icon="⚡"
                                        label="예약 처리"
                                        path="/manager/reservations/bulk"
                                        isActive={isActiveTab('reservations-bulk')}
                                        onClick={() => handleNavigation('/manager/reservations/bulk')}
                                    />

                                    <NavItem
                                        icon="🚢"
                                        label="승선 코드"
                                        path="/manager/boarding-code"
                                        isActive={activeTab === 'boarding-code'}
                                        onClick={() => handleNavigation('/manager/boarding-code')}
                                    />

                                    {/* 코드 관리 페이지 링크 (승선 코드와 동일한 위치에 배치) */}
                                    <NavItem
                                        icon="🚗"
                                        label="차량 코드"
                                        path="/manager/dispatch-codes/vehicle"
                                        isActive={activeTab === 'dispatch-codes-vehicle'}
                                        onClick={() => handleNavigation('/manager/dispatch-codes/vehicle')}
                                    />
                                    <NavItem
                                        icon="🚐"
                                        label="차량 배차"
                                        path="/manager/dispatch"
                                        isActive={activeTab === 'dispatch'}
                                        onClick={() => handleNavigation('/manager/dispatch')}
                                    />
                                    <NavItem
                                        icon="✅"
                                        label="승차 확인"
                                        path="/manager/dispatch-codes/confirm"
                                        isActive={activeTab === 'dispatch-codes-confirm'}
                                        onClick={() => handleNavigation('/manager/dispatch-codes/confirm')}
                                    />
                                    <NavItem
                                        icon="🏨"
                                        label="호텔 코드"
                                        path="/manager/assignment-codes/hotel"
                                        isActive={activeTab === 'assignment-codes-hotel'}
                                        onClick={() => handleNavigation('/manager/assignment-codes/hotel')}
                                    />


                                </div>
                            </div>



                            {/* 결제 관련 카드 */}
                            <div className="bg-white rounded-lg shadow-sm border border-purple-100">
                                <div className="bg-purple-50 px-3 py-2 rounded-t-lg border-b border-purple-100">
                                    <h3 className="text-sm font-medium text-purple-700 flex items-center">
                                        <span className="mr-2">💰</span>결제 관련
                                    </h3>
                                </div>
                                <div className="p-2 space-y-1">
                                    <NavItem
                                        icon="📝"
                                        label="결제 처리"
                                        path="/manager/payment-processing"
                                        isActive={activeTab === 'payment-processing'}
                                        onClick={() => handleNavigation('/manager/payment-processing')}
                                    />
                                    <NavItem
                                        icon="💳"
                                        label="현황 처리"
                                        path="/manager/payments"
                                        isActive={activeTab === 'payments'}
                                        onClick={() => handleNavigation('/manager/payments')}
                                    />
                                    <NavItem
                                        icon="📄"
                                        label="예약 확인서"
                                        path="/manager/confirmation"
                                        isActive={activeTab === 'confirmation'}
                                        onClick={() => handleNavigation('/manager/confirmation')}
                                    />
                                </div>
                            </div>

                            {/* 리포트 카드 (결제 관련 다음에 위치) */}
                            <div className="bg-white rounded-lg shadow-sm border border-indigo-100">
                                <div className="bg-indigo-50 px-3 py-2 rounded-t-lg border-b border-indigo-100">
                                    <h3 className="text-sm font-medium text-indigo-700 flex items-center">
                                        <span className="mr-2">📝</span>리포트
                                    </h3>
                                </div>
                                <div className="p-2 space-y-1">
                                    <NavItem
                                        icon="🚐"
                                        label="스하 차량"
                                        path="/manager/reports/sht-car"
                                        isActive={activeTab === 'reports-sht-car'}
                                        onClick={() => handleNavigation('/manager/reports/sht-car')}
                                    />
                                    <NavItem
                                        icon="🚢"
                                        label="크루즈 차량"
                                        path="/manager/reports/cruise-car"
                                        isActive={activeTab === 'reports-cruise-car'}
                                        onClick={() => handleNavigation('/manager/reports/cruise-car')}
                                    />
                                </div>
                            </div>

                            {/* 관리 도구 카드 */}
                            <div className="bg-white rounded-lg shadow-sm border border-gray-100">
                                <div className="bg-gray-50 px-3 py-2 rounded-t-lg border-b border-gray-100">
                                    <h3 className="text-sm font-medium text-gray-700 flex items-center">
                                        <span className="mr-2">⚙️</span>관리 도구
                                    </h3>
                                </div>
                                <div className="p-2 space-y-1">
                                    <NavItem
                                        icon="🔔"
                                        label="알림 관리"
                                        path="/manager/notifications"
                                        isActive={activeTab === 'notifications'}
                                        onClick={() => handleNavigation('/manager/notifications')}
                                    />

                                    <NavItem
                                        icon="👥"
                                        label="고객 관리"
                                        path="/manager/customers"
                                        isActive={activeTab === 'customers'}
                                        onClick={() => handleNavigation('/manager/customers')}
                                    />
                                    <NavItem
                                        icon="💱"
                                        label="환율 관리"
                                        path="/manager/exchange-rate"
                                        isActive={activeTab === 'exchange-rate'}
                                        onClick={() => handleNavigation('/manager/exchange-rate')}
                                    />
                                </div>
                            </div>
                        </>
                    )}
                </div>
            </div>

            {/* 하단 사용자 정보 */}
            <div className="border-t border-gray-200 p-3 bg-white">
                <div className="flex items-center justify-between">
                    <div className="flex items-center min-w-0 flex-1">
                        <div className="min-w-0 flex-1">
                            <p className="text-xs font-medium text-gray-700 truncate">
                                {userEmail || '매니저'}
                            </p>
                            <p className="text-xs text-gray-500">{userRole === 'dispatcher' ? '배차 담당' : '매니저'}</p>
                        </div>
                    </div>
                    {onLogout && (
                        <button
                            onClick={onLogout}
                            className="ml-2 text-xs text-gray-400 hover:text-gray-600 transition-colors"
                            title="로그아웃"
                        >
                            🚪
                        </button>
                    )}
                </div>
            </div>
        </div>
    );
}
