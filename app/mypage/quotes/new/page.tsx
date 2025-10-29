'use client';

import React, { useState, useEffect, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import supabase from '@/lib/supabase';
import { createQuote, getQuoteWithItems } from '@/lib/quoteUtils';
import { Quote } from '@/lib/types';

// 메뉴 정의 - quoteId를 URL 파라미터로 전달
const menuList = [
  { key: 'cruise', label: '🚢 크루즈', pathTemplate: '/mypage/quotes/cruise', description: '럭셔리 크루즈 여행을 예약하세요' },
  { key: 'airport', label: '✈️ 공항', pathTemplate: '/mypage/quotes/airport', description: '공항 픽업 및 항공 서비스' },
  { key: 'hotel', label: '🏨 호텔', pathTemplate: '/mypage/quotes/hotel', description: '최고급 호텔에서 편안한 휴식' },
  { key: 'tour', label: '🗺️ 투어', pathTemplate: '/mypage/quotes/tour', description: '전문 가이드와 함께하는 맞춤 투어' },
  { key: 'rentcar', label: '🚗 렌트카', pathTemplate: '/mypage/quotes/rentcar', description: '자유로운 여행을 위한 렌트카' }
];

function QuoteManagementContent() {
  // 상태 한글 변환 함수
  const getStatusLabel = (status: string): string => {
    const labels: Record<string, string> = {
      draft: '작성 중',
      submitted: '제출됨',
      approved: '승인됨',
      rejected: '거절됨',
      completed: '완료됨',
      confirmed: '확정됨'
    };
    return labels[status] || status;
  };
  const router = useRouter();
  const searchParams = useSearchParams();
  const existingQuoteId = searchParams.get('quoteId');

  const [loading, setLoading] = useState(false);
  const [quoteId, setQuoteId] = useState<string | null>(existingQuoteId);
  const [quote, setQuote] = useState<Quote | null>(null);
  const [initialized, setInitialized] = useState(false);
  const [quoteTitle, setQuoteTitle] = useState('');
  const [showTitleInput, setShowTitleInput] = useState(false);
  const [serviceStatus, setServiceStatus] = useState<{ [key: string]: boolean }>({});

  // 서비스 추가 상태 확인 함수
  const checkServiceStatus = async (quoteId: string) => {
    try {
      const { data: quoteItems } = await supabase
        .from('quote_item')
        .select('service_type')
        .eq('quote_id', quoteId);

      const statusMap: { [key: string]: boolean } = {};
      if (quoteItems) {
        quoteItems.forEach((item: any) => {
          // service_type에 따라 메뉴 key로 매핑
          let menuKey = '';
          switch (item.service_type) {
            case 'room':
              menuKey = 'cruise'; // 크루즈 객실
              break;
            case 'car':
              menuKey = 'cruise'; // 크루즈 차량도 크루즈로 분류
              break;
            default:
              menuKey = item.service_type;
          }
          statusMap[menuKey] = true;
        });
      }
      setServiceStatus(statusMap);
    } catch (error) {
      console.error('서비스 상태 확인 오류:', error);
    }
  };

  // 기존 견적 로드 함수
  const loadExistingQuote = async (quoteId: string) => {
    try {
      const quoteData = await getQuoteWithItems(quoteId);
      if (quoteData) {
        setQuote(quoteData);
        setQuoteId(quoteId);
        // 서비스 상태도 함께 확인
        await checkServiceStatus(quoteId);
      }
    } catch (error) {
      console.error('견적 로드 오류:', error);
    }
  };

  // 페이지 진입 시 처리
  useEffect(() => {
    if (!initialized) {
      setInitialized(true);
      if (existingQuoteId) {
        // URL에 quoteId가 있으면 해당 견적 로드
        loadExistingQuote(existingQuoteId);
      }
      // 자동 견적 생성 제거
    }
  }, [existingQuoteId, initialized]);

  // 페이지 포커스 시 서비스 상태 새로고침
  useEffect(() => {
    const handleFocus = () => {
      if (quoteId) {
        checkServiceStatus(quoteId);
      }
    };

    window.addEventListener('focus', handleFocus);
    return () => window.removeEventListener('focus', handleFocus);
  }, [quoteId]);

  // 견적 제목 입력 시작
  const handleStartQuoteCreation = () => {
    setShowTitleInput(true);
  };

  // 견적 제목 입력 취소
  const handleCancelTitleInput = () => {
    setShowTitleInput(false);
    setQuoteTitle('');
  };

  // 새로운 견적 생성 (제목과 함께)
  const handleCreateNewQuote = async () => {
    if (!quoteTitle.trim()) {
      alert('견적 제목을 입력해주세요.');
      return;
    }

    setLoading(true);
    try {
      const { data: { user }, error: userError } = await supabase.auth.getUser();
      if (userError || !user) {
        alert('로그인이 필요합니다.');
        router.push('/login');
        return;
      }

      const newQuote = await createQuote(user.id, quoteTitle.trim());
      if (newQuote) {
        setQuoteId(newQuote.id);
        setQuote(newQuote);
        setShowTitleInput(false);
        // URL도 업데이트
        router.replace(`/mypage/quotes/new?quoteId=${newQuote.id}`);
      } else {
        alert('견적 생성에 실패했습니다.');
      }
    } catch (e) {
      console.error('견적 생성 오류:', e);
      alert('견적 생성 중 오류가 발생했습니다.');
    } finally {
      setLoading(false);
    }
  };

  // 기존 견적 항목 수정 모드로 이동
  const handleEditQuoteItem = async (service: typeof menuList[0]) => {
    try {
      const currentQuoteId = quoteId || existingQuoteId;
      if (!currentQuoteId) {
        alert('견적 ID를 찾을 수 없습니다.');
        return;
      }

      // 기존 견적 항목 데이터 조회
      const { data: quoteItems, error } = await supabase
        .from('quote_item')
        .select('id, service_type, service_ref_id')
        .eq('quote_id', currentQuoteId);

      if (error) {
        console.error('견적 항목 조회 오류:', error);
        alert('기존 견적 항목을 찾을 수 없습니다.');
        return;
      }

      // 해당 서비스의 견적 항목 찾기
      let targetServiceType = service.key;
      if (service.key === 'cruise') {
        // 크루즈는 room 또는 car 타입을 찾음
        const cruiseItem = quoteItems?.find(item =>
          item.service_type === 'room' || item.service_type === 'car'
        );
        if (cruiseItem) {
          targetServiceType = cruiseItem.service_type;
        }
      }

      const quoteItem = quoteItems?.find(item => item.service_type === targetServiceType);

      if (!quoteItem) {
        alert('해당 서비스의 기존 견적 항목을 찾을 수 없습니다.');
        return;
      }

      // 수정 모드로 서비스 폼 페이지 이동 (itemId 파라미터 추가)
      const editUrl = `${service.pathTemplate}?quoteId=${currentQuoteId}&itemId=${quoteItem.id}&serviceRefId=${quoteItem.service_ref_id}&mode=edit`;
      router.push(editUrl);
    } catch (error) {
      console.error('견적 항목 수정 처리 오류:', error);
      alert('견적 항목 수정 처리 중 오류가 발생했습니다.');
    }
  };

  // 서비스 선택 시 quoteId를 URL 파라미터로 포함하여 이동
  const handleServiceSelect = (service: typeof menuList[0]) => {
    // 완료된 서비스인 경우 수정 모드로 이동
    if (serviceStatus[service.key]) {
      handleEditQuoteItem(service);
      return;
    }

    if (!quoteId) {
      alert('먼저 견적 제목을 입력하고 견적을 생성해주세요!');
      setShowTitleInput(true);
      return;
    }
    router.push(`${service.pathTemplate}?quoteId=${quoteId}`);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* 메인 그라데이션 헤더 */}
      <div className="bg-gradient-to-br from-blue-200 via-purple-200 to-indigo-100 text-gray-900">
        <div className="container mx-auto px-4 py-12">
          <div className="flex justify-between items-center mb-8">
            <div>
              <h1 className="text-2xl font-bold mb-2">📝 견적 작성</h1>
              <p className="text-lg opacity-90">
                한 번의 견적에 여러 서비스를 자유롭게 신청할 수 있습니다.
              </p>
            </div>

            <div className="flex gap-3">
              {/* 견적 확인 버튼 */}
              {quoteId && (
                <button
                  onClick={() => router.push(`/mypage/quotes/${quoteId}/view`)}
                  className="bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600 transition-colors"
                >
                  📋 확인
                </button>
              )}

              {/* 새로운 견적 버튼 */}
              {!showTitleInput ? (
                <button
                  onClick={handleStartQuoteCreation}
                  disabled={loading}
                  className="bg-gradient-to-r from-blue-400 to-sky-500 text-white px-6 py-3 rounded-lg font-semibold shadow hover:from-blue-500 hover:to-sky-600 transition-all disabled:opacity-60 disabled:cursor-not-allowed"
                >
                  ➕ 작성
                </button>
              ) : (
                <div className="flex items-center gap-2">


                </div>
              )}
            </div>
          </div>

          {/* 견적 상태 표시 및 입력창 카드 내부 복동 */}
          {quoteId && quote ? (
            <div className="bg-white/70 backdrop-blur rounded-lg p-6 mb-6">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-lg font-semibold text-gray-800 mb-2">
                    ✅ 현재 작업 중인 견적
                  </h3>
                  <div className="text-sm text-gray-600 space-y-1">
                    <p>견적 제목: <span className="font-semibold text-blue-600">{quote.title}</span></p>
                    <p>생성 시간: {new Date(quote.created_at).toLocaleString('ko-KR')}</p>
                  </div>
                </div>
                <div className="text-blue-600">
                  <p className="text-sm">아래 서비스 중 원하는 항목을 선택하여</p>
                  <p className="text-sm">견적에 추가하세요.</p>
                </div>
              </div>
            </div>
          ) : (
            <div className="bg-white/70 backdrop-blur rounded-lg p-6 mb-6">
              <div className="text-left">
                <h3 className="text-lg font-semibold text-gray-800 mb-2">
                  {showTitleInput ? '📝 행복 여행 이름 짓기' : '📝 견적 작성을 시작하세요'}
                </h3>
                <p className="text-gray-600 mb-4">
                  {showTitleInput
                    ? (<><span>행복 여행의 이름을 지어 주세요.<br />예) "하롱베이 3박4일", "가족여행 패키지", "허니문 크루즈" 등</span></>)
                    : (<span>"작성" 버튼을 클릭하여 행복 여행 이름을 입력하고, 원하는 서비스를 선택해주세요.</span>)}
                </p>
                <div className="text-blue-600 text-sm">
                  {showTitleInput
                    ? (<p>💡 제목은 나중에 견적 목록에서 구분하는데 도움이 됩니다</p>)
                    : (<p>💡 한 번의 견적에 여러 서비스를 추가할 수 있습니다</p>)}
                </div>
              </div>
            </div>
          )}

          {/* 견적 제목 입력창과 버튼을 카드 아래에 위치 */}
          {showTitleInput && (
            <div className="flex items-center justify-center gap-2 mb-1">
              <input
                type="text"
                value={quoteTitle}
                onChange={(e) => setQuoteTitle(e.target.value)}
                placeholder="행복 여행 이름 입력하세요 (예: 하롱베이 3박4일)"
                className="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 w-40"
                autoFocus
                onKeyPress={(e) => {
                  if (e.key === 'Enter') {
                    handleCreateNewQuote();
                  }
                }}
              />
              <button
                onClick={handleCreateNewQuote}
                disabled={loading || !quoteTitle.trim()}
                className="bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600 transition-colors disabled:opacity-60 disabled:cursor-not-allowed"
              >
                {loading ? '생성 중...' : '생성'}
              </button>
              <button
                onClick={handleCancelTitleInput}
                disabled={loading}
                className="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition-colors"
              >
                취소
              </button>
            </div>
          )}
        </div>
      </div>
      {/* 서비스 메뉴 그리드 및 하단 안내, 기존 견적 확인 버튼 등 기존 코드 */}
      <div className="container mx-auto px-4 py-12">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {menuList.map((menu, index) => {
            const isServiceComplete = serviceStatus[menu.key] || false;

            return (
              <div
                key={menu.key}
                className="group relative rounded-xl shadow-lg transform transition-all duration-300 overflow-hidden border-2 cursor-pointer border-gray-200 bg-white/80 hover:shadow-2xl hover:scale-105"
                onClick={() => handleServiceSelect(menu)}
                style={{
                  animationDelay: `${index * 100}ms`,
                  animation: 'fadeInUp 0.6s ease-out forwards'
                }}
              >
                {/* 완료 배지 */}
                {isServiceComplete && (
                  <div className="absolute top-3 right-3 bg-blue-500 text-white text-sm px-3 py-2 rounded-full font-bold shadow-lg z-10 flex items-center gap-1">
                    ✅ 완료
                  </div>
                )}

                <div className={`h-20 bg-gradient-to-br ${getGradientClass(menu.key, true)} flex items-center justify-center relative`}>
                  <span className="text-4xl relative z-10">{menu.label.split(' ')[0]}</span>
                </div>
                <div className="p-2 relative z-10">
                  <h3 className="text-lg font-bold mb-2 transition-colors text-gray-800 group-hover:text-blue-500">
                    {menu.label}
                  </h3>
                  <p className="text-gray-700 text-sm mb-3 leading-relaxed">
                    {menu.description}
                  </p>
                  <div className="flex items-center justify-between">
                    <span className="font-semibold text-xs text-blue-400">
                      {isServiceComplete ? '견적 완료 - 수정하기' : '견적 신청하기'}
                    </span>
                    <span className="transition-transform text-base text-blue-400 group-hover:transform group-hover:translate-x-1">
                      {isServiceComplete ? '✏️' : '→'}
                    </span>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
        {/* 하단 추가 정보 */}
        <div className="mt-16 text-center">
          <div className="bg-white rounded-xl shadow-lg p-8">
            <h2 className="text-2xl font-bold text-gray-800 mb-4">🎉 특별 혜택</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="p-4 bg-blue-50 rounded-lg">
                <h3 className="font-semibold text-blue-700 mb-2">� 빠른 답변 상담</h3>
                <p className="text-sm text-gray-600">언제든지 전문 상담사와 상담 가능</p>
              </div>
              <div className="p-4 bg-green-50 rounded-lg">
                <h3 className="font-semibold text-green-700 mb-2">💎 회동 특가</h3>
                <p className="text-sm text-gray-600">회원님만을 위한 특별 할인 혜택</p>
              </div>
              <div className="p-4 bg-purple-50 rounded-lg">
                <h3 className="font-semibold text-purple-700 mb-2">🛡️ 안전 보장</h3>
                <p className="text-sm text-gray-600">하롱현지 유일한 한국인 여행사 서비스로 빠른대처</p>
              </div>
            </div>
          </div>
        </div>
        {/* 기존 견적 확인 버튼 */}
        <div className="mt-8 text-center">
          <button
            onClick={() => router.push('/mypage/quotes')}
            className="bg-gradient-to-r from-gray-600 to-gray-700 text-white px-8 py-3 rounded-lg hover:from-gray-700 hover:to-gray-800 transition-all duration-200 shadow-lg"
          >
            📋 기존 견적 목록 보기
          </button>
        </div>
      </div>
      <style jsx>{`
        @keyframes fadeInUp {
          from {
            opacity: 0;
            transform: translateY(30px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
      `}</style>
    </div>
  );
}

// 각 서비스별 그라데이션 클래스
function getGradientClass(key: string, light?: boolean): string {
  // 밝은 색상용 그라데이션
  const gradientsLight = {
    cruise: 'from-blue-100 to-purple-100',
    vehicle: 'from-green-100 to-teal-100',
    airport: 'from-sky-100 to-blue-100',
    hotel: 'from-pink-100 to-rose-100',
    tour: 'from-orange-100 to-amber-100',
    rentcar: 'from-red-100 to-rose-100'
  };
  // 기존 진한 색상
  const gradientsDark = {
    cruise: 'from-blue-500 to-purple-600',
    vehicle: 'from-green-500 to-teal-600',
    airport: 'from-sky-500 to-blue-600',
    hotel: 'from-pink-500 to-rose-600',
    tour: 'from-orange-500 to-amber-600',
    rentcar: 'from-red-500 to-rose-600'
  };
  if (light) {
    return gradientsLight[key as keyof typeof gradientsLight] || 'from-gray-100 to-gray-200';
  }
  return gradientsDark[key as keyof typeof gradientsDark] || 'from-gray-500 to-gray-600';
}


export default function QuoteManagementPage() {
  return (
    <Suspense fallback={<div className="flex justify-center items-center h-64">로딩 중...</div>}>
      <QuoteManagementContent />
    </Suspense>
  );
}

