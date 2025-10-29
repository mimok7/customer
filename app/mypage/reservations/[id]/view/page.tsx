"use client";

import React, { useEffect, useState, Suspense } from 'react';
import { useRouter, useParams } from 'next/navigation';
import supabase from '@/lib/supabase';
import PageWrapper from '@/components/PageWrapper';
import SectionBox from '@/components/SectionBox';

type ServiceType = 'cruise' | 'airport' | 'hotel' | 'rentcar' | 'tour';

interface ReservationRow {
  re_id: string;
  re_type: ServiceType;
  re_status: string;
  re_created_at: string;
  re_quote_id: string | null;
  re_user_id: string;
}

interface QuoteInfo { id: string; title: string | null; status?: string | null }

function getStatusText(status: string) {
  switch (status) {
    case 'pending': return '예약 대기중';
    case 'confirmed': return '예약 확정';
    case 'cancelled': return '예약 취소';
    default: return status;
  }
}

function getStatusColor(status: string) {
  switch (status) {
    case 'pending': return 'bg-yellow-50 text-yellow-700 border-yellow-200';
    case 'confirmed': return 'bg-green-50 text-green-700 border-green-200';
    case 'cancelled': return 'bg-red-50 text-red-700 border-red-200';
    default: return 'bg-gray-50 text-gray-700 border-gray-200';
  }
}

function getTypeIcon(type: string) {
  switch (type) {
    case 'cruise': return '🚢';
    case 'airport': return '✈️';
    case 'hotel': return '🏨';
    case 'rentcar': return '🚗';
    case 'tour': return '🎫';
    default: return '📋';
  }
}

function getTypeName(type: string) {
  switch (type) {
    case 'cruise': return '크루즈';
    case 'airport': return '공항 서비스';
    case 'hotel': return '호텔';
    case 'rentcar': return '렌터카';
    case 'tour': return '투어';
    default: return type;
  }
}

// 고객에게 표시할 필드만 선택
const customerFriendlyFields: Record<string, string[]> = {
  cruise: ['guest_count', 'room_total_price', 'boarding_assist', 'request_note'],
  airport: ['ra_airport_location', 'ra_flight_number', 'ra_datetime', 'ra_stopover_location', 'ra_passenger_count', 'ra_luggage_count', 'request_note'],
  hotel: ['checkin_date', 'room_count', 'guest_count', 'breakfast_service', 'hotel_category', 'total_price', 'request_note'],
  rentcar: ['pickup_datetime', 'pickup_location', 'destination', 'via_location', 'passenger_count', 'luggage_count', 'total_price', 'request_note'],
  tour: ['tour_capacity', 'pickup_location', 'dropoff_location', 'total_price', 'request_note'],
  cruise_car: ['pickup_datetime', 'pickup_location', 'dropoff_location', 'passenger_count', 'car_total_price', 'request_note']
};

const labelMap: Record<string, Record<string, string>> = {
  cruise: {
    guest_count: '👥 탑승 인원',
    room_total_price: '💰 객실 요금',
    boarding_assist: '🤝 승선 지원',
    request_note: '📝 요청사항'
  },
  airport: {
    ra_airport_location: '📍 공항',
    ra_flight_number: '✈️ 항공편',
    ra_datetime: '🕐 일시',
    ra_stopover_location: '🔄 경유지',
    ra_passenger_count: '👥 승객 수',
    ra_luggage_count: '🧳 수하물',
    request_note: '📝 요청사항'
  },
  hotel: {
    checkin_date: '🗓️ 체크인',
    room_count: '🏠 객실 수',
    guest_count: '👥 투숙 인원',
    breakfast_service: '🍳 조식',
    hotel_category: '⭐ 호텔 등급',
    total_price: '💰 총 금액',
    request_note: '📝 요청사항'
  },
  rentcar: {
    pickup_datetime: '🕐 픽업 시간',
    pickup_location: '📍 픽업 장소',
    destination: '🎯 목적지',
    via_location: '🔄 경유지',
    passenger_count: '👥 승객 수',
    luggage_count: '🧳 수하물',
    total_price: '💰 총 금액',
    request_note: '📝 요청사항'
  },
  tour: {
    tour_capacity: '👥 정원',
    pickup_location: '📍 픽업 장소',
    dropoff_location: '🎯 하차 장소',
    total_price: '💰 총 금액',
    request_note: '📝 요청사항'
  },
  cruise_car: {
    pickup_datetime: '🕐 픽업 시간',
    pickup_location: '📍 픽업 장소',
    dropoff_location: '🎯 하차 장소',
    passenger_count: '👥 승객 수',
    car_total_price: '💰 차량 요금',
    request_note: '📝 요청사항'
  }
};

function formatValue(key: string, value: any): string {
  if (value === null || value === undefined) return '-';

  // 날짜/시간 포맷
  if (typeof value === 'string' && /\d{4}-\d{2}-\d{2}/.test(value)) {
    const d = new Date(value);
    if (!isNaN(d.getTime())) {
      // 시간이 포함된 경우
      if (value.includes('T') || value.includes(':')) {
        return d.toLocaleString('ko-KR', {
          year: 'numeric',
          month: 'long',
          day: 'numeric',
          hour: '2-digit',
          minute: '2-digit',
          weekday: 'short'
        });
      }
      // 날짜만
      return d.toLocaleDateString('ko-KR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        weekday: 'short'
      });
    }
  }

  // 금액 포맷
  if ((key.includes('price') || key.includes('total')) && typeof value === 'number') {
    return `${value.toLocaleString('ko-KR')}동`;
  }

  // 숫자 포맷
  if (typeof value === 'number') {
    return value.toLocaleString('ko-KR');
  }

  // 불린 포맷
  if (typeof value === 'boolean') {
    return value ? '✅ 예' : '❌ 아니오';
  }

  return String(value);
}

function renderCustomerFriendlyInfo(obj: any, type: keyof typeof labelMap) {
  if (!obj) return null;

  const allowedFields = customerFriendlyFields[type] || [];
  const labels = labelMap[type] || {};

  const entries = allowedFields
    .map(key => ({ key, value: obj[key], label: labels[key] || key }))
    .filter(({ value }) => value !== null && value !== undefined && value !== '');

  if (entries.length === 0) {
    return <div className="text-sm text-gray-500">상세 정보가 없습니다.</div>;
  }

  return (
    <div className="space-y-4">
      {entries.map(({ key, value, label }) => {
        const isPrice = key.includes('price') || key.includes('total');
        const isNote = key.includes('note');

        return (
          <div key={key} className={`${isNote ? 'col-span-full' : ''}`}>
            <div className="text-xs text-gray-500 mb-1">{label}</div>
            <div className={`text-base ${isPrice ? 'text-blue-600 font-bold text-lg' : 'text-gray-900'} ${isNote ? 'bg-yellow-50 p-3 rounded border border-yellow-200' : ''}`}>
              {formatValue(key, value)}
            </div>
          </div>
        );
      })}
    </div>
  );
}

function ReservationViewInner() {
  const router = useRouter();
  const params = useParams();
  const reservationId = params?.id as string;

  const [reservation, setReservation] = useState<ReservationRow | null>(null);
  const [quote, setQuote] = useState<QuoteInfo | null>(null);
  const [serviceDetails, setServiceDetails] = useState<any[] | null>(null);
  const [serviceDetailsExtra, setServiceDetailsExtra] = useState<any[] | null>(null);
  const [cruiseInfo, setCruiseInfo] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!reservationId) return;
    (async () => {
      try {
        setLoading(true);
        const { data: { user } } = await supabase.auth.getUser();
        if (!user) { router.push('/login'); return; }

        // 본인 예약만 조회
        const { data: row, error: rErr } = await supabase
          .from('reservation')
          .select('*')
          .eq('re_id', reservationId)
          .eq('re_user_id', user.id)
          .maybeSingle();
        if (rErr) throw rErr;
        if (!row) { setError('예약이 없거나 접근 권한이 없습니다.'); return; }

        setReservation(row as ReservationRow);

        // 견적 정보
        if (row.re_quote_id) {
          const { data: q } = await supabase
            .from('quote')
            .select('id, title, status')
            .eq('id', row.re_quote_id)
            .maybeSingle();
          if (q) setQuote(q as QuoteInfo);
        }

        // 서비스 상세
        const tableByType: Record<ServiceType, string> = {
          cruise: 'reservation_cruise',
          airport: 'reservation_airport',
          hotel: 'reservation_hotel',
          rentcar: 'reservation_rentcar',
          tour: 'reservation_tour',
        };
        const table = tableByType[row.re_type as ServiceType];
        if (table) {
          const { data: svc } = await supabase
            .from(table)
            .select('*')
            .eq('reservation_id', reservationId)
            .order('created_at', { ascending: false });
          setServiceDetails(Array.isArray(svc) ? svc : (svc ? [svc] : []));

          // 크루즈인 경우 room_price 정보 조회
          if (row.re_type === 'cruise' && svc && svc.length > 0) {
            const roomPriceCode = svc[0].room_price_code;
            const checkinDate = svc[0].checkin;
            const guestCount = svc[0].guest_count;
            
            if (roomPriceCode) {
              const { data: roomPrice } = await supabase
                .from('room_price')
                .select('cruise, room_type, schedule')
                .eq('room_code', roomPriceCode)
                .maybeSingle();

              if (roomPrice) {
                setCruiseInfo({
                  cruise_name: roomPrice.cruise,
                  room_type: roomPrice.room_type,
                  schedule: roomPrice.schedule,
                  checkin: checkinDate,
                  guest_count: guestCount
                });
              }
            }
          }
        }

        // 크루즈 차량 추가 데이터
        if (row.re_type === 'cruise') {
          const { data: car } = await supabase
            .from('reservation_cruise_car')
            .select('*')
            .eq('reservation_id', reservationId)
            .order('created_at', { ascending: false });
          setServiceDetailsExtra(Array.isArray(car) ? car : (car ? [car] : []));
        }

        setError(null);
      } catch (e: any) {
        console.error('예약 상세 조회 실패', e);
        setError(e?.message || '예약 정보를 불러오는 중 오류가 발생했습니다.');
      } finally {
        setLoading(false);
      }
    })();
  }, [reservationId]);

  if (loading) {
    return (
      <PageWrapper>
        <div className="flex flex-col justify-center items-center h-64">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
          <p className="mt-4 text-gray-600">예약 정보를 불러오는 중...</p>
        </div>
      </PageWrapper>
    );
  }

  if (error) {
    return (
      <PageWrapper>
        <div className="text-center py-12">
          <div className="text-6xl mb-4">⚠️</div>
          <h3 className="text-lg font-medium text-gray-800 mb-2">예약 정보를 불러올 수 없습니다</h3>
          <p className="text-sm text-gray-600 mb-4">{error}</p>
          <button
            onClick={() => router.push('/mypage/reservations/list')}
            className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
          >
            목록으로 돌아가기
          </button>
        </div>
      </PageWrapper>
    );
  }

  if (!reservation) {
    return (
      <PageWrapper>
        <div className="text-center py-12">
          <div className="text-6xl mb-4">📭</div>
          <h3 className="text-lg font-medium text-gray-800 mb-2">예약 정보를 찾을 수 없습니다</h3>
          <p className="text-sm text-gray-600 mb-4">예약이 존재하지 않거나 접근 권한이 없습니다.</p>
          <button
            onClick={() => router.push('/mypage/reservations/list')}
            className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
          >
            목록으로 돌아가기
          </button>
        </div>
      </PageWrapper>
    );
  }

  const title = quote?.title ?? '예약 상세';
  const createdDate = new Date(reservation.re_created_at);

  return (
    <PageWrapper>
      <div className="space-y-6 max-w-4xl mx-auto pb-8">
        {/* 헤더 - 고객 친화적으로 개선 */}
        <div className="bg-gradient-to-r from-blue-500 to-blue-600 rounded-xl p-6 text-white shadow-lg">
          <div className="flex items-start justify-between">
            <div className="flex-1">
              <div className="flex items-center gap-3 mb-2">
                <span className="text-4xl">{getTypeIcon(reservation.re_type)}</span>
                <div>
                  <h1 className="text-2xl font-bold">{getTypeName(reservation.re_type)} 예약</h1>
                  <p className="text-blue-100 text-sm mt-1">
                    {title}
                  </p>
                </div>
              </div>
              <div className="flex items-center gap-4 mt-4 text-sm">
                <span className={`px-3 py-1 rounded-full font-medium ${getStatusColor(reservation.re_status)} bg-white bg-opacity-90`}>
                  {getStatusText(reservation.re_status)}
                </span>
                <span className="text-blue-100">
                  예약일: {createdDate.toLocaleDateString('ko-KR')}
                </span>
              </div>
            </div>
            <button
              onClick={() => router.push('/mypage/reservations/list')}
              className="px-4 py-2 bg-white bg-opacity-20 hover:bg-opacity-30 text-white rounded-lg transition-all text-sm font-medium"
            >
              ← 목록으로
            </button>
          </div>
        </div>

        {/* 견적 정보 카드 */}
        {reservation.re_quote_id && (
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                📋 연결된 견적
              </h2>
              <button
                onClick={() => router.push(`/mypage/quotes/${reservation.re_quote_id}/view`)}
                className="px-4 py-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition-colors text-sm font-medium"
              >
                견적서 보기 →
              </button>
            </div>
            <div className="bg-gray-50 rounded-lg p-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <div className="text-xs text-gray-500 mb-1">견적 제목</div>
                  <div className="font-medium text-gray-900">{title}</div>
                </div>
                <div>
                  <div className="text-xs text-gray-500 mb-1">견적 상태</div>
                  <div className="font-medium text-gray-900">{quote?.status || '-'}</div>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* 서비스 상세 - 고객 친화적 카드 UI */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
          <div className="bg-gradient-to-r from-gray-50 to-gray-100 px-6 py-4 border-b border-gray-200">
            <h2 className="text-lg font-bold text-gray-800 flex items-center gap-2">
              {getTypeIcon(reservation.re_type)} {getTypeName(reservation.re_type)} 상세 정보
            </h2>
          </div>
          <div className="p-6">
            {serviceDetails && serviceDetails.length > 0 ? (
              <div className="space-y-6">
                {/* 크루즈인 경우 크루즈명/객실 정보 먼저 표시 */}
                {reservation.re_type === 'cruise' && cruiseInfo && (
                  <div className="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg p-5 border border-blue-200 mb-6">
                    <h3 className="text-md font-bold text-gray-800 mb-4 flex items-center gap-2">
                      🚢 크루즈 정보
                    </h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                        <div className="text-xs text-gray-600 mb-1">크루즈명</div>
                        <div className="text-lg font-bold text-blue-600">{cruiseInfo.cruise_name || '-'}</div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-600 mb-1">객실명</div>
                        <div className="text-lg font-bold text-indigo-600">{cruiseInfo.room_type || '-'}</div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-600 mb-1">🗓️ 승선일</div>
                        <div className="text-base font-medium text-gray-800">{cruiseInfo.checkin ? formatValue('checkin', cruiseInfo.checkin) : '-'}</div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-600 mb-1">👥 총 탑승 인원</div>
                        <div className="text-base font-medium text-gray-800">{cruiseInfo.guest_count ? `${cruiseInfo.guest_count}명` : '-'}</div>
                      </div>
                    </div>
                  </div>
                )}

                {serviceDetails.map((it, idx) => (
                  <div key={idx} className={`${serviceDetails.length > 1 ? 'pb-6 border-b border-gray-200 last:border-0 last:pb-0' : ''}`}>
                    {serviceDetails.length > 1 && (
                      <div className="text-sm font-medium text-gray-700 mb-4 flex items-center gap-2">
                        <span className="w-6 h-6 bg-blue-500 text-white rounded-full flex items-center justify-center text-xs">
                          {idx + 1}
                        </span>
                        {reservation.re_type === 'cruise' ? `카테고리 ${idx + 1}` : `${idx + 1}번 항목`}
                      </div>
                    )}
                    {renderCustomerFriendlyInfo(it, reservation.re_type)}
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8 text-gray-500">
                <div className="text-4xl mb-2">📭</div>
                <p>상세 정보가 없습니다.</p>
              </div>
            )}
          </div>
        </div>

        {/* 크루즈 차량 정보 - 개선된 UI */}
        {reservation.re_type === 'cruise' && serviceDetailsExtra && serviceDetailsExtra.length > 0 && (
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="bg-gradient-to-r from-green-50 to-green-100 px-6 py-4 border-b border-gray-200">
              <h2 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                🚗 연결 차량 정보
              </h2>
            </div>
            <div className="p-6">
              <div className="space-y-6">
                {serviceDetailsExtra.map((it, idx) => (
                  <div key={idx} className={`${serviceDetailsExtra.length > 1 ? 'pb-6 border-b border-gray-200 last:border-0 last:pb-0' : ''}`}>
                    {serviceDetailsExtra.length > 1 && (
                      <div className="text-sm font-medium text-gray-700 mb-4 flex items-center gap-2">
                        <span className="w-6 h-6 bg-green-500 text-white rounded-full flex items-center justify-center text-xs">
                          {idx + 1}
                        </span>
                        {idx + 1}번 차량
                      </div>
                    )}
                    {renderCustomerFriendlyInfo(it, 'cruise_car')}
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* 안내 메시지 */}
        <div className="bg-blue-50 rounded-xl p-4 border border-blue-200">
          <div className="flex gap-3">
            <span className="text-2xl">💡</span>
            <div className="flex-1">
              <h3 className="font-medium text-blue-900 mb-1">예약 문의</h3>
              <p className="text-sm text-blue-700">
                예약 내용 변경이나 문의사항이 있으시면 고객센터로 연락 주시기 바랍니다.
              </p>
            </div>
          </div>
        </div>
      </div>
    </PageWrapper>
  );
}

export default function Page() {
  return (
    <Suspense fallback={
      <PageWrapper>
        <div className="flex justify-center items-center h-64">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
        </div>
      </PageWrapper>
    }>
      <ReservationViewInner />
    </Suspense>
  );
}
