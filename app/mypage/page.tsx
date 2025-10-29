'use client';
import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import PageWrapper from '../../components/PageWrapper';
import SectionBox from '../../components/SectionBox';
import Link from 'next/link';
import supabase from '@/lib/supabase';

export default function MyPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [userProfile, setUserProfile] = useState<any>(null);

  useEffect(() => {
    loadUserInfo();
  }, []);

  const loadUserInfo = async () => {
    try {
      const { data: { user }, error: userError } = await supabase.auth.getUser();
      if (userError || !user) {
        router.push('/login');
        return;
      }
      setUser(user);

      // 사용자 프로필 정보 조회
      const { data: profile } = await supabase
        .from('users')
        .select('name, email')
        .eq('id', user.id)
        .single();

      setUserProfile(profile);
    } catch (error) {
      console.error('사용자 정보 로드 실패:', error);
    }
  };

  const getUserDisplayName = () => {
    if (userProfile?.name) return userProfile.name;
    if (user?.email) {
      // 이메일에서 @ 앞부분 추출
      return user.email.split('@')[0];
    }
    return '고객';
  };

  const handleLogout = async () => {
    try {
      const { error } = await supabase.auth.signOut();
      if (error) {
        console.error('로그아웃 오류:', error);
        alert('로그아웃 중 오류가 발생했습니다.');
        return;
      }
      alert('로그아웃되었습니다.');
      router.push('/login');
    } catch (error) {
      console.error('로그아웃 처리 실패:', error);
      alert('로그아웃 처리에 실패했습니다.');
    }
  };

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
  const quickActions = [
    { icon: '📝', label: '새 견적', href: '/mypage/quotes/new' },
    { icon: '📋', label: '견적 목록', href: '/mypage/quotes' },
    { icon: '✅', label: '승인 견적', href: '/mypage/quotes/confirmed' },
    { icon: '🎯', label: '견적없이 예약', href: '/mypage/direct-booking' },
    { icon: '📜', label: '예약 목록', href: '/mypage/reservations/list' },
    { icon: '🚌', label: '배차 정보', href: '/mypage/dispatch' },
    { icon: '📢', label: '알림 및 요청사항', href: '/mypage/requests' },
    { icon: '💳', label: '결제하기', href: '/mypage/payments' },
    { icon: '📄', label: '예약확인서', href: '/mypage/confirmations' },
    { icon: '👤', label: '내 정보', href: '/mypage/profile' },
  ];

  return (
    <PageWrapper title={`🌟 ${getUserDisplayName()}님 즐거운 하루 되세요 ^^`}>
      <div className="sticky top-0 z-20 bg-white border-b border-gray-200 py-2 mb-2">
        <div className="flex justify-end items-center gap-3">
          <button
            type="button"
            className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm font-medium shadow-md hover:shadow-lg"
            onClick={requestNotificationPermission}
          >
            📲 스마트폰 알림 활성화
          </button>
          <button
            onClick={handleLogout}
            className="flex items-center gap-2 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors text-sm font-medium shadow-md hover:shadow-lg"
          >
            🚪 로그아웃
          </button>
        </div>
      </div>
      <SectionBox title="원하는 서비스를 선택하세요">
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-7 gap-6">
          {quickActions.map((action, index) => (
            <Link key={index} href={action.href} className="group">
              <div className="relative overflow-hidden bg-gradient-to-br from-white via-gray-50 to-blue-50 border border-gray-200 rounded-xl shadow-lg hover:shadow-xl transform hover:-translate-y-1 transition-all duration-300 ease-out cursor-pointer">
                <div className="absolute inset-0 bg-gradient-to-br from-blue-500/5 to-purple-500/5 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                <div className="relative p-6 text-center">
                  <div className="text-3xl mb-3 transform group-hover:scale-110 transition-transform duration-300">
                    {action.icon}
                  </div>
                  <div className="text-sm font-semibold text-gray-800 group-hover:text-blue-700 transition-colors duration-300">
                    {action.label}
                  </div>
                </div>
                <div className="absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r from-blue-500 to-purple-500 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-300 origin-left"></div>
              </div>
            </Link>
          ))}
        </div>
      </SectionBox>
    </PageWrapper>
  );
}
