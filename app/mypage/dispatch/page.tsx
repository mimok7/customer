'use client';
import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import PageWrapper from '../../../components/PageWrapper';
import SectionBox from '../../../components/SectionBox';
import supabase from '@/lib/supabase';
import { Car, Clock, MapPin, User, Phone, Calendar, Copy, CheckCircle, AlertCircle, Home } from 'lucide-react';
import { format } from 'date-fns';
import { ko } from 'date-fns/locale';

interface DispatchInfo {
  id: string;
  service_type: string;
  service_name: string;
  usage_date: string;
  pickup_datetime?: string;
  pickup_location?: string;
  dropoff_location?: string;
  destination?: string;
  vehicle_number?: string;
  car_type?: string;
  seat_number?: string;
  dispatch_code?: string;
  status: string;
  booker_name: string;
  booker_phone?: string;
  dispatch_memo?: string;
  pickup_confirmed_at?: string;
  // 공항 서비스 특화
  airport_location?: string;
  flight_number?: string;
  // 크루즈 특화
  cruise_name?: string;
  pier_location?: string;
  // 호텔 특화
  hotel_name?: string;
  checkin_date?: string;
  // 렌터카 특화
  rental_days?: number;
  // 투어 특화
  tour_name?: string;
}

export default function MyDispatchPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [dispatchList, setDispatchList] = useState<DispatchInfo[]>([]);
  const [loading, setLoading] = useState(true);
  const [copiedId, setCopiedId] = useState<string | null>(null);

  useEffect(() => {
    loadDispatchInfo();
  }, []);

  const loadDispatchInfo = async () => {
    try {
      setLoading(true);

      // 사용자 인증 확인
      const { data: { user }, error: userError } = await supabase.auth.getUser();
      if (userError || !user) {
        router.push('/login');
        return;
      }
      setUser(user);

      const dispatchData: DispatchInfo[] = [];

      // 1. 공항 서비스 배차 정보
      const { data: airportDispatch } = await supabase
        .from('reservation_airport')
        .select(`
          id,
          reservation_id,
          ra_airport_location,
          ra_flight_number,
          ra_datetime,
          reservation:reservation_id (
            re_user_id,
            re_status,
            re_created_at
          )
        `)
        .eq('reservation.re_user_id', user.id);

      if (airportDispatch) {
        for (const item of airportDispatch) {
          if (item.reservation?.re_user_id === user.id) {
            // 배차 상세 정보 조회
            const { data: dispatchDetail } = await supabase
              .from('reservation_airport')
              .select('id, dispatch_code, pickup_confirmed_at, dispatch_memo, airport_price_code')
              .eq('id', item.id)
              .single();

            // 사용자 정보 조회
            const { data: userInfo } = await supabase
              .from('users')
              .select('name, phone')
              .eq('id', user.id)
              .single();

            // 차종 정보 조회
            let carType = null;
            if (dispatchDetail?.airport_price_code) {
              const { data: priceInfo } = await supabase
                .from('airport_price')
                .select('airport_car_type')
                .eq('airport_code', dispatchDetail.airport_price_code)
                .single();
              carType = priceInfo?.airport_car_type;
            }

            dispatchData.push({
              id: item.id,
              service_type: 'airport',
              service_name: '공항 서비스',
              usage_date: item.ra_datetime,
              pickup_datetime: item.ra_datetime,
              airport_location: item.ra_airport_location,
              flight_number: item.ra_flight_number,
              dispatch_code: dispatchDetail?.dispatch_code || '',
              status: item.reservation?.re_status || 'pending',
              booker_name: userInfo?.name || '고객',
              booker_phone: userInfo?.phone || '',
              dispatch_memo: dispatchDetail?.dispatch_memo || null,
              pickup_confirmed_at: dispatchDetail?.pickup_confirmed_at || null,
              car_type: carType
            });
          }
        }
      }

      // 2. 크루즈 차량 배차 정보
      const { data: cruiseDispatch } = await supabase
        .from('reservation_cruise')
        .select(`
          id,
          reservation_id,
          checkin,
          checkout,
          car_type,
          vehicle_number,
          seat_number,
          cruise_name,
          pier_location,
          reservation:reservation_id (
            re_user_id,
            re_status
          )
        `)
        .eq('reservation.re_user_id', user.id);

      if (cruiseDispatch) {
        for (const item of cruiseDispatch) {
          if (item.reservation?.re_user_id === user.id) {
            // 배차 상세 정보 조회
            const { data: dispatchDetail } = await supabase
              .from('reservation_cruise')
              .select('id, dispatch_code, pickup_confirmed_at, dispatch_memo')
              .eq('id', item.id)
              .single();

            // 사용자 정보 조회
            const { data: userInfo } = await supabase
              .from('users')
              .select('name, phone')
              .eq('id', user.id)
              .single();

            dispatchData.push({
              id: item.id,
              service_type: 'cruise',
              service_name: '크루즈 차량',
              usage_date: item.checkin,
              pickup_datetime: item.checkin,
              vehicle_number: item.vehicle_number,
              seat_number: item.seat_number,
              car_type: item.car_type,
              cruise_name: item.cruise_name,
              pier_location: item.pier_location,
              dispatch_code: dispatchDetail?.dispatch_code || '',
              status: item.reservation?.re_status || 'pending',
              booker_name: userInfo?.name || '고객',
              booker_phone: userInfo?.phone || '',
              dispatch_memo: dispatchDetail?.dispatch_memo || null,
              pickup_confirmed_at: dispatchDetail?.pickup_confirmed_at || null
            });
          }
        }
      }

      // 3. 렌터카 배차 정보
      const { data: rentcarDispatch } = await supabase
        .from('reservation_rentcar')
        .select(`
          id,
          reservation_id,
          pickup_date,
          rental_days,
          pickup_location,
          destination,
          vehicle_number,
          reservation:reservation_id (
            re_user_id,
            re_status
          )
        `)
        .eq('reservation.re_user_id', user.id);

      if (rentcarDispatch) {
        for (const item of rentcarDispatch) {
          if (item.reservation?.re_user_id === user.id) {
            // 배차 상세 정보 조회
            const { data: dispatchDetail } = await supabase
              .from('reservation_rentcar')
              .select('id, dispatch_code, pickup_confirmed_at, dispatch_memo, rentcar_price_code')
              .eq('id', item.id)
              .single();

            // 사용자 정보 조회
            const { data: userInfo } = await supabase
              .from('users')
              .select('name, phone')
              .eq('id', user.id)
              .single();

            // 차종 정보 조회
            let carType = null;
            if (dispatchDetail?.rentcar_price_code) {
              const { data: priceInfo } = await supabase
                .from('rent_price')
                .select('rent_car_type')
                .eq('rent_code', dispatchDetail.rentcar_price_code)
                .single();
              carType = priceInfo?.rent_car_type;
            }

            dispatchData.push({
              id: item.id,
              service_type: 'rentcar',
              service_name: '렌터카',
              usage_date: item.pickup_date,
              pickup_datetime: item.pickup_date,
              pickup_location: item.pickup_location,
              destination: item.destination,
              vehicle_number: item.vehicle_number,
              rental_days: item.rental_days,
              dispatch_code: dispatchDetail?.dispatch_code || '',
              status: item.reservation?.re_status || 'pending',
              booker_name: userInfo?.name || '고객',
              booker_phone: userInfo?.phone || '',
              dispatch_memo: dispatchDetail?.dispatch_memo || null,
              pickup_confirmed_at: dispatchDetail?.pickup_confirmed_at || null,
              car_type: carType
            });
          }
        }
      }

      // 4. 스하차량 배차 정보
      const { data: shtDispatch } = await supabase
        .from('reservation_car_sht')
        .select(`
          id,
          reservation_id,
          usage_date,
          pickup_datetime,
          pickup_location,
          dropoff_location,
          vehicle_number,
          seat_number,
          sht_category,
          cruise_name,
          pier_location,
          reservation:reservation_id (
            re_user_id,
            re_status
          )
        `)
        .eq('reservation.re_user_id', user.id);

      if (shtDispatch) {
        for (const item of shtDispatch) {
          if (item.reservation?.re_user_id === user.id) {
            // 배차 상세 정보 조회
            const { data: dispatchDetail } = await supabase
              .from('reservation_car_sht')
              .select('id, dispatch_code, pickup_confirmed_at, dispatch_memo, car_price_code')
              .eq('id', item.id)
              .single();

            // 사용자 정보 조회
            const { data: userInfo } = await supabase
              .from('users')
              .select('name, phone')
              .eq('id', user.id)
              .single();

            // 차종 정보 조회
            let carType = null;
            if (dispatchDetail?.car_price_code) {
              const { data: priceInfo } = await supabase
                .from('car_price')
                .select('car_type')
                .eq('car_code', dispatchDetail.car_price_code)
                .single();
              carType = priceInfo?.car_type;
            }

            dispatchData.push({
              id: item.id,
              service_type: 'sht-car',
              service_name: '스하차량',
              usage_date: item.usage_date,
              pickup_datetime: item.pickup_datetime,
              pickup_location: item.pickup_location,
              dropoff_location: item.dropoff_location,
              vehicle_number: item.vehicle_number,
              seat_number: item.seat_number,
              cruise_name: item.cruise_name,
              pier_location: item.pier_location,
              dispatch_code: dispatchDetail?.dispatch_code || '',
              status: item.reservation?.re_status || 'pending',
              booker_name: userInfo?.name || '고객',
              booker_phone: userInfo?.phone || '',
              dispatch_memo: dispatchDetail?.dispatch_memo || null,
              pickup_confirmed_at: dispatchDetail?.pickup_confirmed_at || null,
              car_type: carType
            });
          }
        }
      }

      // 사용일자 기준으로 정렬 (최신순)
      dispatchData.sort((a, b) => new Date(b.usage_date).getTime() - new Date(a.usage_date).getTime());

      setDispatchList(dispatchData);
    } catch (error) {
      console.error('배차 정보 로드 실패:', error);
    } finally {
      setLoading(false);
    }
  };

  const getServiceIcon = (serviceType: string) => {
    switch (serviceType) {
      case 'airport': return '✈️';
      case 'cruise': return '🚢';
      case 'rentcar': return '🚗';
      case 'sht-car': return '🚐';
      default: return '🚗';
    }
  };

  const getStatusBadge = (status: string, pickupConfirmed: string | null) => {
    if (pickupConfirmed) {
      return (
        <div className="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
          <CheckCircle className="w-3 h-3" />
          픽업 완료
        </div>
      );
    }

    switch (status) {
      case 'confirmed':
        return (
          <div className="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
            <AlertCircle className="w-3 h-3" />
            배차 대기
          </div>
        );
      case 'pending':
        return (
          <div className="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
            <Clock className="w-3 h-3" />
            예약 대기
          </div>
        );
      default:
        return (
          <div className="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
            <AlertCircle className="w-3 h-3" />
            {status}
          </div>
        );
    }
  };

  const copyToClipboard = async (text: string, id: string) => {
    try {
      await navigator.clipboard.writeText(text);
      setCopiedId(id);
      setTimeout(() => setCopiedId(null), 2000);
    } catch (error) {
      console.error('복사 실패:', error);
    }
  };

  const formatDateTime = (dateTime: string) => {
    try {
      return format(new Date(dateTime), 'yyyy.MM.dd (E) HH:mm', { locale: ko });
    } catch {
      return dateTime;
    }
  };

  const formatDate = (date: string) => {
    try {
      return format(new Date(date), 'yyyy.MM.dd (E)', { locale: ko });
    } catch {
      return date;
    }
  };

  if (loading) {
    return (
      <PageWrapper title="� 내 배차 정보">
        <div className="flex justify-center items-center h-64">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto"></div>
          <p className="mt-4 text-gray-600">배차 정보를 불러오는 중...</p>
        </div>
      </PageWrapper>
    );
  }

  return (
    <PageWrapper title="🚌 내 배차 정보">
      <div className="mb-4 flex justify-end">
        <button
          onClick={() => router.push('/mypage')}
          className="flex items-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors text-sm font-medium"
        >
          <Home className="w-4 h-4" />
          홈
        </button>
      </div>
      <SectionBox title={`총 ${dispatchList.length}건의 배차 정보`}>
        {dispatchList.length === 0 ? (
          <div className="text-center py-12">
            <Car className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <p className="text-gray-500 mb-4">배정된 배차 정보가 없습니다.</p>
            <p className="text-sm text-gray-400">예약이 확정되면 배차 정보가 표시됩니다.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {dispatchList.map((item) => (
              <div key={item.id} className="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-md transition-shadow">
                <div className="flex items-start justify-between mb-4">
                  <div className="flex items-center gap-3">
                    <div className="text-2xl">{getServiceIcon(item.service_type)}</div>
                    <div>
                      <h3 className="font-semibold text-lg text-gray-900">{item.service_name}</h3>
                      <p className="text-sm text-gray-500">예약 ID: {item.id}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    {getStatusBadge(item.status, item.pickup_confirmed_at)}
                    {item.dispatch_code && (
                      <div className="flex items-center gap-1 px-2 py-1 bg-blue-50 border border-blue-200 rounded text-xs font-medium text-blue-700">
                        #{item.dispatch_code}
                        <button
                          onClick={() => copyToClipboard(item.dispatch_code!, `${item.id}-code`)}
                          className="ml-1 p-0.5 hover:bg-blue-100 rounded transition-colors"
                        >
                          {copiedId === `${item.id}-code` ? (
                            <CheckCircle className="w-3 h-3 text-green-600" />
                          ) : (
                            <Copy className="w-3 h-3" />
                          )}
                        </button>
                      </div>
                    )}
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-4">
                  {/* 날짜/시간 정보 */}
                  <div className="flex items-center gap-2 text-sm">
                    <Calendar className="w-4 h-4 text-gray-400" />
                    <div>
                      <div className="font-medium text-gray-700">이용일시</div>
                      <div className="text-gray-600">
                        {item.pickup_datetime ? formatDateTime(item.pickup_datetime) : formatDate(item.usage_date)}
                      </div>
                    </div>
                  </div>

                  {/* 차량 정보 */}
                  {(item.vehicle_number || item.car_type) && (
                    <div className="flex items-center gap-2 text-sm">
                      <Car className="w-4 h-4 text-gray-400" />
                      <div>
                        <div className="font-medium text-gray-700">차량 정보</div>
                        <div className="text-gray-600">
                          {item.vehicle_number && <div>번호: {item.vehicle_number}</div>}
                          {item.car_type && <div className="text-sm font-medium text-blue-700">차종: {item.car_type}</div>}
                          {item.seat_number && <div>좌석: {item.seat_number}</div>}
                        </div>
                      </div>
                    </div>
                  )}

                  {/* 위치 정보 */}
                  <div className="flex items-center gap-2 text-sm">
                    <MapPin className="w-4 h-4 text-gray-400" />
                    <div>
                      <div className="font-medium text-gray-700">위치 정보</div>
                      <div className="text-gray-600">
                        {item.airport_location && <div>공항: {item.airport_location}</div>}
                        {item.pickup_location && <div>픽업: {item.pickup_location}</div>}
                        {item.dropoff_location && <div>목적지: {item.dropoff_location}</div>}
                        {item.destination && <div>목적지: {item.destination}</div>}
                        {item.cruise_name && <div>크루즈: {item.cruise_name}</div>}
                        {item.pier_location && <div>부두: {item.pier_location}</div>}
                      </div>
                    </div>
                  </div>
                </div>

                {/* 추가 정보 */}
                <div className="flex items-start justify-between pt-4 border-t border-gray-100">
                  <div className="flex items-center gap-2 text-sm">
                    <User className="w-4 h-4 text-gray-400" />
                    <div>
                      <span className="font-medium text-gray-700">예약자:</span> {item.booker_name}
                      {item.booker_phone && (
                        <div className="flex items-center gap-1 mt-1">
                          <Phone className="w-3 h-3 text-gray-400" />
                          <span className="text-gray-600">{item.booker_phone}</span>
                          <button
                            onClick={() => copyToClipboard(item.booker_phone!, `${item.id}-phone`)}
                            className="ml-1 p-0.5 hover:bg-gray-100 rounded transition-colors"
                          >
                            {copiedId === `${item.id}-phone` ? (
                              <CheckCircle className="w-3 h-3 text-green-600" />
                            ) : (
                              <Copy className="w-3 h-3" />
                            )}
                          </button>
                        </div>
                      )}
                    </div>
                  </div>

                  {item.dispatch_memo && (
                    <div className="max-w-md">
                      <div className="text-xs font-medium text-gray-500 mb-1">배차 메모</div>
                      <div className="text-sm text-gray-700 bg-gray-50 rounded p-2">
                        {item.dispatch_memo}
                      </div>
                    </div>
                  )}
                </div>

                {/* 특화 정보 */}
                {item.service_type === 'airport' && item.flight_number && (
                  <div className="mt-3 pt-3 border-t border-gray-100">
                    <div className="text-sm">
                      <span className="font-medium text-gray-700">항공편:</span> {item.flight_number}
                    </div>
                  </div>
                )}

                {item.service_type === 'rentcar' && item.rental_days && (
                  <div className="mt-3 pt-3 border-t border-gray-100">
                    <div className="text-sm">
                      <span className="font-medium text-gray-700">대여 기간:</span> {item.rental_days}일
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </SectionBox>
    </PageWrapper>
  );
}