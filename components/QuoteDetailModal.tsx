"use client";

import React, { useState, useEffect } from 'react';
import supabase from '@/lib/supabase';
import { updateQuoteItemPrices } from '@/lib/updateQuoteItemPrices';

function QuoteDetailModal({ quoteId, onClose }: { quoteId: string; onClose: () => void }) {
  const [user, setUser] = useState<any>(null);
  const [calculating, setCalculating] = useState(false);
  const [loading, setLoading] = useState(true);
  const [quote, setQuote] = useState<any>(null);
  const [detailedServices, setDetailedServices] = useState<any>({});
  const [approvalNote, setApprovalNote] = useState('');
  const [rejectionReason, setRejectionReason] = useState('');
  const [showApprovalModal, setShowApprovalModal] = useState(false);
  const [showRejectionModal, setShowRejectionModal] = useState(false);

  useEffect(() => {
    checkAuth();
  }, []);

  useEffect(() => {
    if (user && quoteId) {
      loadQuoteDetail();
      loadDetailedServices();
    }
  }, [user, quoteId]);

  const checkAuth = async () => {
    try {
      const { data: { user }, error: userError } = await supabase.auth.getUser();
      if (userError || !user) {
        alert('로그인이 필요합니다.');
        onClose();
        return;
      }

      const { data: profile } = await supabase
        .from('users')
        .select('role')
        .eq('id', user.id)
        .single();

      if (!profile || (profile.role !== 'manager' && profile.role !== 'admin')) {
        alert('매니저 권한이 필요합니다.');
        onClose();
        return;
      }

      setUser(user);
    } catch (error) {
      console.error('권한 확인 오류:', error);
      onClose();
    }
  };

  const loadQuoteDetail = async () => {
    try {
      setLoading(true);
      const { data: quoteData, error: quoteError } = await supabase
        .from('quote')
        .select('*')
        .eq('id', quoteId)
        .single();

      if (quoteError) throw quoteError;

      // 사용자 정보 조회
      let userData = null;
      try {
        const { data: userResult, error: userError } = await supabase
          .from('users')
          .select('id, name, email, phone_number')
          .eq('id', quoteData.user_id)
          .single();

        if (!userError) userData = userResult;
      } catch (e) {
        console.warn('사용자 조회 실패:', e);
      }

      setQuote({ ...quoteData, users: userData || { name: '알 수 없음', email: '미확인' } });
    } catch (error) {
      console.error('견적 상세 정보 로딩 실패:', error);
      alert('견적을 불러오는 중 오류가 발생했습니다.');
      onClose();
    } finally {
      setLoading(false);
    }
  };

  const loadDetailedServices = async () => {
    try {
      const { data: quoteItems, error } = await supabase
        .from('quote_item')
        .select('*')
        .eq('quote_id', quoteId);

      if (error) throw error;

      const detailed: any = { rooms: [], cars: [], airports: [], hotels: [], rentcars: [], tours: [] };

      for (const item of quoteItems || []) {
        try {
          if (item.service_type === 'room') {
            const { data: roomData } = await supabase
              .from('room')
              .select('*')
              .eq('id', item.service_ref_id)
              .single();

            if (roomData) {
              const { data: priceData } = await supabase
                .from('room_price')
                .select('*')
                .eq('room_code', roomData.room_code);

              detailed.rooms.push({ ...item, roomInfo: roomData, priceInfo: priceData || [] });
            }
          } else if (item.service_type === 'car') {
            const { data: carData } = await supabase
              .from('car')
              .select('*')
              .eq('id', item.service_ref_id)
              .single();

            if (carData) {
              const { data: priceData } = await supabase
                .from('car_price')
                .select('*')
                .eq('car_code', carData.car_code);

              detailed.cars.push({ ...item, carInfo: carData, priceInfo: priceData || [] });
            }
          } else if (item.service_type === 'airport') {
            const { data: airportData } = await supabase
              .from('airport')
              .select('*')
              .eq('id', item.service_ref_id)
              .single();

            if (airportData) {
              const { data: priceData } = await supabase
                .from('airport_price')
                .select('*')
                .eq('airport_code', airportData.airport_code);

              detailed.airports.push({ ...item, airportInfo: airportData, priceInfo: priceData || [] });
            }
          } else if (item.service_type === 'hotel') {
            const { data: hotelData } = await supabase
              .from('hotel')
              .select('*')
              .eq('id', item.service_ref_id)
              .single();

            if (hotelData) {
              const { data: priceData } = await supabase
                .from('hotel_price')
                .select('*')
                .eq('hotel_code', hotelData.hotel_code);

              detailed.hotels.push({ ...item, hotelInfo: hotelData, priceInfo: priceData || [] });
            }
          } else if (item.service_type === 'rentcar') {
            const { data: rentcarData } = await supabase
              .from('rentcar')
              .select('*')
              .eq('id', item.service_ref_id)
              .single();

            if (rentcarData) {
              const { data: priceData } = await supabase
                .from('rent_price')
                .select('*')
                .eq('rent_code', rentcarData.rentcar_code);

              detailed.rentcars.push({ ...item, rentcarInfo: rentcarData, priceInfo: priceData || [] });
            }
          } else if (item.service_type === 'tour') {
            const { data: tourData } = await supabase
              .from('tour')
              .select('*')
              .eq('id', item.service_ref_id)
              .single();

            if (tourData) {
              const { data: priceData } = await supabase
                .from('tour_price')
                .select('*')
                .eq('tour_code', tourData.tour_code);

              detailed.tours.push({ ...item, tourInfo: tourData, priceInfo: priceData || [] });
            }
          }
        } catch (serviceError) {
          console.warn(`서비스 로드 중 일부 실패:`, serviceError);
        }
      }

      setDetailedServices(detailed);
    } catch (error) {
      console.error('상세 서비스 정보 로드 실패:', error);
    }
  };

  const getStatusBadge = (status: string) => {
    const badges = {
      pending: 'bg-yellow-100 text-yellow-800',
      submitted: 'bg-yellow-100 text-yellow-800',
      draft: 'bg-gray-100 text-gray-800',
      confirmed: 'bg-blue-100 text-blue-800',
      approved: 'bg-blue-100 text-blue-800',
      rejected: 'bg-red-100 text-red-800'
    } as any;
    const labels = {
      pending: '검토 대기',
      submitted: '제출됨',
      draft: '임시저장',
      confirmed: '확정됨 (예약)',
      approved: '승인됨',
      rejected: '거절됨'
    } as any;
    return (
      <span className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${badges[status] || 'bg-gray-100 text-gray-800'}`}>
        {labels[status] || status}
      </span>
    );
  };

  const handleCalculatePrices = async () => {
    try {
      setCalculating(true);
      const success = await updateQuoteItemPrices(quoteId);
      if (success) {
        alert('가격 계산이 완료되었습니다.');
        await Promise.all([loadQuoteDetail(), loadDetailedServices()]);
      } else {
        alert('가격 계산에 실패했습니다.');
      }
    } catch (error) {
      console.error('가격 계산 오류:', error);
      alert('가격 계산 중 오류가 발생했습니다.');
    } finally {
      setCalculating(false);
    }
  };

  const handleApproval = async () => {
    try {
      const updateData: any = { status: 'approved', updated_at: new Date().toISOString() };
      if (approvalNote.trim()) updateData.manager_note = approvalNote.trim();

      const { data, error } = await supabase
        .from('quote')
        .update(updateData)
        .eq('id', quoteId)
        .select();

      if (error) throw error;
      alert('견적이 승인되었습니다.');
      setShowApprovalModal(false);
      setApprovalNote('');
      await loadQuoteDetail();
    } catch (error: any) {
      console.error('승인 처리 실패:', error);
      alert(`승인 실패: ${error?.message || '알 수 없는 오류'}`);
    }
  };

  const handleRejection = async () => {
    try {
      const updateData: any = { status: 'rejected', updated_at: new Date().toISOString(), manager_note: rejectionReason.trim() };

      const { data, error } = await supabase
        .from('quote')
        .update(updateData)
        .eq('id', quoteId)
        .select();

      if (error) throw error;
      alert('견적이 거절되었습니다.');
      setShowRejectionModal(false);
      setRejectionReason('');
      await loadQuoteDetail();
    } catch (error: any) {
      console.error('거절 처리 실패:', error);
      alert(`거절 실패: ${error?.message || '알 수 없는 오류'}`);
    }
  };

  if (loading || !quote) {
    return (
      <div className="fixed inset-0 z-50 flex items-start justify-center pt-20 px-4">
        <div className="fixed inset-0 bg-black opacity-40" onClick={onClose} />
        <div className="bg-white w-full max-w-4xl rounded shadow-lg z-50 overflow-auto max-h-[80vh] p-8 text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <div className="text-gray-600">견적 정보를 불러오는 중...</div>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto">
      <div className="min-h-screen flex items-start justify-center pt-10 px-4">
        <div className="fixed inset-0 bg-black opacity-40" onClick={onClose} />

        <div className="relative bg-white w-full max-w-6xl rounded shadow-lg z-50 overflow-y-auto max-h-[85vh]">
          {/* Header */}
          <div className="bg-white shadow">
            <div className="px-4 sm:px-6 lg:px-8 py-4 flex justify-between items-center">
              <div className="flex items-center space-x-4">
                <h1 className="text-xl font-bold text-gray-900">📋 견적 상세 (모달)</h1>
                {getStatusBadge(quote.status)}
                <button onClick={handleCalculatePrices} disabled={calculating} className={`ml-4 px-3 py-1 rounded text-sm font-medium ${calculating ? 'bg-gray-300 text-gray-500 cursor-not-allowed' : 'bg-blue-600 text-white hover:bg-blue-700'}`}>
                  {calculating ? '계산 중...' : '💰 가격 계산'}
                </button>
                <button onClick={() => { window.location.href = `/manager/quotes/${quoteId}/edit`; }} className="px-3 py-1 bg-green-600 text-white rounded text-sm">✏️ 견적 수정</button>
              </div>
              <div className="flex items-center gap-3">
                <div className="text-sm text-gray-500">매니저: {user?.email}</div>
                <button onClick={onClose} aria-label="모달 닫기" className="px-3 py-1 bg-blue-600 text-white rounded hover:bg-blue-700">닫기</button>
              </div>
            </div>
          </div>

          <div className="p-6 grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div className="lg:col-span-2 space-y-6">
              {/* 고객 정보 */}
              <div className="bg-white shadow rounded-lg p-6">
                <h2 className="text-lg font-medium text-gray-900 mb-4">👤 고객 정보</h2>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700">고객명</label>
                    <p className="mt-1 text-sm text-gray-900">{quote.users?.name || '정보 없음'}</p>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700">이메일</label>
                    <p className="mt-1 text-sm text-gray-900">{quote.users?.email || '정보 없음'}</p>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700">연락처</label>
                    <p className="mt-1 text-sm text-gray-900">{quote.users?.phone_number || '정보 없음'}</p>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700">견적 ID</label>
                    <p className="mt-1 text-sm text-gray-900 font-mono">{quote.id}</p>
                  </div>
                </div>
              </div>

              {/* 상세 서비스 섹션 */}
              {detailedServices.rooms && detailedServices.rooms.length > 0 && (
                <div className="bg-white shadow rounded-lg p-6">
                  <h2 className="text-lg font-medium text-gray-900 mb-4">🛏 객실 정보 (상세)</h2>
                  <div className="space-y-4">
                    {detailedServices.rooms.map((room: any, index: number) => (
                      <div key={index} className="border border-gray-200 rounded-lg p-4">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div>
                            <h3 className="font-medium text-gray-900 mb-2">기본 정보</h3>
                            <p className="text-sm text-gray-600">객실 코드: {room.roomInfo?.room_code}</p>
                            <p className="text-sm text-gray-600">성인수: {room.roomInfo?.adult_count}명</p>
                          </div>
                          <div>
                            <h3 className="font-medium text-gray-900 mb-2">가격 정보</h3>
                            {room.priceInfo && room.priceInfo.length > 0 ? (
                              <div className="space-y-2">
                                {room.priceInfo.map((price: any, priceIndex: number) => (
                                  <div key={priceIndex} className="bg-gray-50 p-2 rounded">
                                    <p className="text-sm text-gray-600">일정: {price.schedule}</p>
                                    <p className="text-sm text-gray-600">크루즈: {price.cruise}</p>
                                    <p className="text-sm text-gray-600">객실 타입: {price.room_type}</p>
                                    <p className="text-sm font-medium text-green-600">기본 가격: {price.price?.toLocaleString()}동</p>
                                  </div>
                                ))}
                              </div>
                            ) : (
                              <p className="text-sm text-red-600">가격 정보 없음</p>
                            )}
                            <p className="text-sm font-medium text-blue-600 mt-2">총액: {room.total_price?.toLocaleString()}동</p>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {detailedServices.cars && detailedServices.cars.length > 0 && (
                <div className="bg-white shadow rounded-lg p-6">
                  <h2 className="text-lg font-medium text-gray-900 mb-4">🚗 차량 정보 (상세)</h2>
                  <div className="space-y-4">
                    {detailedServices.cars.map((car: any, index: number) => (
                      <div key={index} className="border border-gray-200 rounded-lg p-4">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div>
                            <h3 className="font-medium text-gray-900 mb-2">기본 정보</h3>
                            <p className="text-sm text-gray-600">차량 코드: {car.carInfo?.car_code}</p>
                          </div>
                          <div>
                            <h3 className="font-medium text-gray-900 mb-2">가격 정보</h3>
                            {car.priceInfo && car.priceInfo.length > 0 ? (
                              <div className="space-y-2">
                                {car.priceInfo.map((price: any, priceIndex: number) => (
                                  <div key={priceIndex} className="bg-gray-50 p-2 rounded">
                                    <p className="text-sm text-gray-600">차량 타입: {price.car_type}</p>
                                    <p className="text-sm font-medium text-green-600">기본 가격: {price.price?.toLocaleString()}동</p>
                                  </div>
                                ))}
                              </div>
                            ) : (
                              <p className="text-sm text-red-600">가격 정보 없음</p>
                            )}
                            <p className="text-sm font-medium text-blue-600 mt-2">총액: {car.total_price?.toLocaleString()}동</p>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* other service sections rendered above in this file when used as extracted component */}
            </div>

            {/* 사이드바 영역: 요약 및 승인 */}
            <div className="space-y-6">
              <div className="bg-white shadow rounded-lg p-6">
                <h2 className="text-lg font-medium text-gray-900 mb-4">💰 견적 요약</h2>
                <div className="space-y-3">
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">총 견적가</span>
                    <span className="text-lg font-bold text-blue-600">{quote.total_price?.toLocaleString() || '0'}동</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">신청일</span>
                    <span className="text-gray-900">{new Date(quote.created_at).toLocaleDateString()}</span>
                  </div>
                </div>
              </div>

              <div className="bg-white shadow rounded-lg p-6">
                <h2 className="text-lg font-medium text-gray-900 mb-4">🔍 승인 관리</h2>

                <div className="mb-4 p-3 bg-gray-50 rounded-md">
                  <span className="text-sm text-gray-600">현재 상태: </span>
                  {getStatusBadge(quote.status)}
                  <div className="text-xs text-gray-500 mt-1">실제 DB 값: "{quote.status}"</div>
                </div>

                {(quote.status === 'pending' || quote.status === 'submitted' || quote.status === 'draft') && (
                  <div className="space-y-3">
                    <button onClick={() => setShowApprovalModal(true)} className="w-full bg-green-600 hover:bg-green-700 text-white font-medium py-3 px-4 rounded-md">✅ 승인하기</button>
                    <button onClick={() => setShowRejectionModal(true)} className="w-full bg-red-600 hover:bg-red-700 text-white font-medium py-3 px-4 rounded-md">❌ 거절하기</button>
                    <p className="text-xs text-gray-500 text-center">승인 후 고객이 예약 신청을 할 수 있습니다.</p>
                  </div>
                )}

                {quote.status === 'approved' && (
                  <div className="text-center py-4">
                    <div className="text-green-600 font-medium">✅ 견적 승인됨</div>
                    <p className="text-sm text-gray-500 mt-1">고객이 예약 신청을 할 수 있습니다.</p>
                  </div>
                )}

                {quote.status === 'rejected' && (
                  <div className="text-center py-4">
                    <div className="text-red-600 font-medium">❌ 거절됨</div>
                    <p className="text-sm text-gray-500 mt-1">이 견적은 거절되었습니다.</p>
                    {quote.manager_note && <p className="text-sm text-red-600 mt-2 bg-red-50 p-2 rounded">사유: {quote.manager_note}</p>}
                  </div>
                )}
              </div>

              {quote.manager_note && (
                <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                  <h3 className="text-sm font-medium text-yellow-800 mb-2">📝 매니저 노트</h3>
                  <p className="text-sm text-yellow-700">{quote.manager_note}</p>
                </div>
              )}
            </div>
          </div>

          {/* 승인 모달 */}
          {showApprovalModal && (
            <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
              <div className="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
                <div className="mt-3">
                  <h3 className="text-lg font-medium text-gray-900 mb-4">견적 승인</h3>
                  <p className="text-sm text-gray-600 mb-4">이 견적을 승인하시겠습니까? 승인 후 고객이 예약 신청을 할 수 있습니다.</p>
                  <div className="mb-4">
                    <label className="block text-sm font-medium text-gray-700 mb-2">승인 메모 (선택)</label>
                    <textarea value={approvalNote} onChange={(e) => setApprovalNote(e.target.value)} className="w-full border border-gray-300 rounded-md px-3 py-2 text-sm" rows={3} placeholder="고객에게 전달할 추가 안내사항을 입력하세요..." />
                  </div>
                  <div className="flex space-x-3">
                    <button onClick={handleApproval} className="flex-1 bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-md">승인하기</button>
                    <button onClick={() => setShowApprovalModal(false)} className="flex-1 bg-gray-300 hover:bg-gray-400 text-gray-700 font-medium py-2 px-4 rounded-md">취소</button>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* 거절 모달 */}
          {showRejectionModal && (
            <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
              <div className="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
                <div className="mt-3">
                  <h3 className="text-lg font-medium text-gray-900 mb-4">견적 거절</h3>
                  <p className="text-sm text-gray-600 mb-4">이 견적을 거절하시겠습니까? 거절 사유를 입력해주세요.</p>
                  <div className="mb-4">
                    <label className="block text-sm font-medium text-gray-700 mb-2">거절 사유 <span className="text-red-500">*</span></label>
                    <textarea value={rejectionReason} onChange={(e) => setRejectionReason(e.target.value)} className="w-full border border-gray-300 rounded-md px-3 py-2 text-sm" rows={3} placeholder="거절 사유를 구체적으로 입력해주세요..." required />
                  </div>
                  <div className="flex space-x-3">
                    <button onClick={handleRejection} disabled={!rejectionReason.trim()} className="flex-1 bg-red-600 hover:bg-red-700 disabled:bg-gray-300 text-white font-medium py-2 px-4 rounded-md">거절하기</button>
                    <button onClick={() => setShowRejectionModal(false)} className="flex-1 bg-gray-300 hover:bg-gray-400 text-gray-700 font-medium py-2 px-4 rounded-md">취소</button>
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default QuoteDetailModal;
