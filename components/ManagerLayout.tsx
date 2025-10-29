'use client';
import React from 'react';
import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import supabase from '@/lib/supabase';
import { getCachedRole, getCookieRole, setCachedRole } from '@/lib/userUtils';
import { RoleContext } from '@/app/components/RoleContext';
import ManagerSidebar from './ManagerSidebar';

interface ManagerLayoutProps {
  children: React.ReactNode;
  title?: string;
  activeTab?: string;
}

export default function ManagerLayout({ children, title, activeTab }: ManagerLayoutProps) {
  const [user, setUser] = useState<any>(null);
  const [userRole, setUserRole] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const router = useRouter();

  useEffect(() => {
    const checkManager = async () => {
      const { data } = await supabase.auth.getUser();
      if (!data.user) {
        alert('로그인이 필요합니다.');
        router.push('/login');
        return;
      }

      setUser(data.user);

      // 1) 세션 캐시 → 2) 쿠키 캐시 순으로 확인
      const cached = getCachedRole();
      const cookieRole = !cached ? getCookieRole() : null;
      const roleFromCache = cached || cookieRole;
      if (roleFromCache && ['manager', 'admin', 'dispatcher'].includes(roleFromCache)) {
        setUserRole(roleFromCache);
        setIsLoading(false);
        // 세션 캐시에 동기화
        if (!cached && roleFromCache) setCachedRole(roleFromCache);
        return;
      }

      // 2) 캐시가 없으면 1회만 DB 조회 후 캐시 저장
      const { data: userData } = await supabase
        .from('users')
        .select('role')
        .eq('id', data.user.id)
        .single();

      // 특정 사용자에게 리포트 접근 허용 (사용자 ID를 여기에 추가)
      const allowedReportUsers = [
        // 예: 'user-id-1', 'user-id-2'
      ];

      if (!userData || !['manager', 'admin', 'dispatcher'].includes(userData.role)) {
        alert('매니저 권한이 필요합니다.');
        router.push('/');
        return;
      }

      setUserRole(userData.role);
      setCachedRole(userData.role);
      setIsLoading(false);
    };

    checkManager();
  }, [router]);

  const handleLogout = async () => {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      console.warn('로그아웃 처리 중 경고:', e);
    } finally {
      router.push('/login');
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-100 flex items-center justify-center">
        <div className="text-center">
          <div className="text-4xl mb-4">⚙️</div>
          <p>매니저 권한 확인 중...</p>
        </div>
      </div>
    );
  }

  return (
    <RoleContext.Provider value={{ role: userRole as any, user }}>
      <div className="h-screen w-full flex bg-gray-100 overflow-hidden">
        {/* 모바일 오버레이 */}
        {isSidebarOpen && (
          <div
            className="fixed inset-0 bg-black bg-opacity-50 z-40 lg:hidden print:hidden"
            onClick={() => setIsSidebarOpen(false)}
          />
        )}

        {/* 좌측 사이드바 */}
        <div className={`print:hidden fixed lg:static inset-y-0 left-0 z-50 transform transition-transform duration-300 ease-in-out lg:transform-none ${isSidebarOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
          }`}>
          <ManagerSidebar
            activeTab={activeTab}
            userEmail={user?.email}
            userRole={userRole}
            onLogout={handleLogout}
            onClose={() => setIsSidebarOpen(false)}
          />
        </div>

        {/* 우측 콘텐츠 영역 */}
        <div className="flex-1 flex flex-col min-w-0">
          {/* 상단 바 (선택적 타이틀) */}
          <div className="h-16 flex items-center px-4 border-b border-gray-200 bg-white/90 backdrop-blur supports-[backdrop-filter]:backdrop-blur-sm sticky top-0 z-30 print:hidden">
            {/* 모바일 햄버거 메뉴 버튼 */}
            <button
              onClick={() => setIsSidebarOpen(true)}
              className="lg:hidden mr-3 p-2 rounded-md hover:bg-gray-100 text-gray-600"
              aria-label="메뉴 열기"
            >
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </button>
            {title && <h1 className="text-lg font-semibold text-gray-800 truncate">{title}</h1>}
          </div>
          <main className="flex-1 overflow-y-auto px-4 py-6">
            {children}
            <div className="h-10" />
          </main>
        </div>
      </div>
    </RoleContext.Provider>
  );
}
