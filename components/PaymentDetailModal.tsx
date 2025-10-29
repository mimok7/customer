'use client';

import React from 'react';
import supabase from '@/lib/supabase';
import {
    Calendar,
    Clock,
    Ship,
    Plane,
    Building,
    MapPin,
    Car,
    User,
    Mail,
    CreditCard,
    FileText,
    X
} from 'lucide-react';

// 크루즈 상세 정보 컴포넌트
const CruiseDetailSection = ({ payment }: { payment: any }) => {
    const [cruiseDetails, setCruiseDetails] = React.useState<any[]>([]);
    const [carDetails, setCarDetails] = React.useState<any[]>([]);
    const [loading, setLoading] = React.useState(false);

    React.useEffect(() => {
        const fetchCruiseDetails = async () => {
            if (!payment?.reservation_id || payment?.reservation?.re_type !== 'cruise') return;

            setLoading(true);
            try {
                // 크루즈 예약 정보 조회 (reservation_cruise 테이블)
                const { data: cruiseData, error: cruiseError } = await supabase
                    .from('reservation_cruise')
                    .select('*')
                    .eq('reservation_id', payment.reservation_id);

                // 크루즈 차량 예약 정보 조회 (reservation_cruise_car 테이블)
                const { data: carData, error: carError } = await supabase
                    .from('reservation_cruise_car')
                    .select('*')
                    .eq('reservation_id', payment.reservation_id);

                if (!cruiseError && cruiseData) {
                    // room_price 정보 조회하여 크루즈 데이터에 추가
                    const enrichedCruiseData = await Promise.all(
                        cruiseData.map(async (cruise) => {
                            if (cruise.room_price_code) {
                                const { data: roomPrice } = await supabase
                                    .from('room_price')
                                    .select('*')
                                    .eq('room_code', cruise.room_price_code)
                                    .single();
                                return { ...cruise, room_price: roomPrice };
                            }
                            return cruise;
                        })
                    );
                    setCruiseDetails(enrichedCruiseData);
                }

                if (!carError && carData) {
                    // car_price 정보 조회하여 차량 데이터에 추가
                    const enrichedCarData = await Promise.all(
                        carData.map(async (car) => {
                            if (car.car_price_code) {
                                const { data: carPrice } = await supabase
                                    .from('car_price')
                                    .select('*')
                                    .eq('car_code', car.car_price_code)
                                    .single();
                                return { ...car, car_price: carPrice };
                            }
                            return car;
                        })
                    );
                    setCarDetails(enrichedCarData);
                }
            } catch (error) {
                console.error('크루즈 상세 정보 조회 실패:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchCruiseDetails();
    }, [payment?.reservation_id]);

    if (payment?.reservation?.re_type !== 'cruise') return null;

    return (
        <div className="bg-blue-50 p-6 rounded-lg border border-blue-200">
            <h3 className="text-lg font-semibold text-blue-800 mb-4 flex items-center">
                <Ship className="w-5 h-5 mr-2" />
                크루즈 상세 정보
            </h3>

            {loading ? (
                <div className="text-center py-4">
                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto"></div>
                    <p className="mt-2 text-gray-600">데이터를 불러오는 중...</p>
                </div>
            ) : (
                <div className="space-y-6">
                    {/* 크루즈 객실 정보 */}
                    {cruiseDetails.length > 0 && (
                        <div>
                            <h4 className="font-semibold text-blue-700 mb-3 flex items-center">
                                <Building className="w-4 h-4 mr-1" />
                                크루즈 객실 정보
                            </h4>
                            <div className="space-y-3">
                                {cruiseDetails.map((cruise, index) => (
                                    <div key={index} className="bg-white p-4 rounded border border-blue-100">
                                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
                                            <div><strong>룸 가격 코드:</strong> <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs">{cruise.room_price_code}</span></div>
                                            <div><strong>룸 스케줄:</strong> {cruise.room_price?.schedule || '정보 없음'}</div>
                                            <div><strong>룸 카테고리:</strong> {cruise.room_price?.room_category || '정보 없음'}</div>
                                            <div><strong>크루즈:</strong> {cruise.room_price?.cruise || '정보 없음'}</div>
                                            <div><strong>룸 타입:</strong> {cruise.room_price?.room_type || '정보 없음'}</div>
                                            <div><strong>가격:</strong> <span className="text-green-600 font-medium">{cruise.room_price?.price?.toLocaleString() || 0}동</span></div>
                                            <div><strong>투숙객 수:</strong> {cruise.guest_count}명</div>
                                            <div><strong>체크인:</strong> {cruise.checkin ? new Date(cruise.checkin).toLocaleDateString('ko-KR') : '미정'}</div>
                                            <div><strong>총 금액:</strong> <span className="text-lg font-bold text-green-600">{cruise.room_total_price?.toLocaleString() || 0}동</span></div>
                                            {cruise.boarding_code && <div><strong>탑승 코드:</strong> {cruise.boarding_code}</div>}
                                            {cruise.boarding_assist && <div><strong>탑승 지원:</strong> 예</div>}
                                        </div>
                                        {cruise.request_note && (
                                            <div className="mt-3 pt-3 border-t border-blue-100">
                                                <strong>요청사항:</strong>
                                                <div className="bg-gray-50 p-2 rounded mt-1 text-sm">{cruise.request_note}</div>
                                            </div>
                                        )}
                                    </div>
                                ))}
                            </div>
                        </div>
                    )}

                    {/* 크루즈 차량 정보 */}
                    {carDetails.length > 0 && (
                        <div>
                            <h4 className="font-semibold text-blue-700 mb-3 flex items-center">
                                <Car className="w-4 h-4 mr-1" />
                                크루즈 차량 정보
                            </h4>
                            <div className="space-y-3">
                                {carDetails.map((car, index) => (
                                    <div key={index} className="bg-white p-4 rounded border border-blue-100">
                                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
                                            <div><strong>차량 가격 코드:</strong> <span className="bg-green-100 text-green-800 px-2 py-1 rounded text-xs">{car.car_price_code}</span></div>
                                            <div><strong>차량 카테고리:</strong> {car.car_price?.car_category || '정보 없음'}</div>
                                            <div><strong>크루즈:</strong> {car.car_price?.cruise || '정보 없음'}</div>
                                            <div><strong>차량 타입:</strong> {car.car_price?.car_type || '정보 없음'}</div>
                                            <div><strong>가격:</strong> <span className="text-green-600 font-medium">{car.car_price?.price?.toLocaleString() || 0}동</span></div>
                                            <div><strong>스케줄:</strong> {car.car_price?.schedule || '정보 없음'}</div>
                                            <div><strong>차량 수:</strong> {car.car_count}대</div>
                                            <div><strong>승객 수:</strong> {car.passenger_count}명</div>
                                            <div><strong>픽업 일시:</strong> {car.pickup_datetime ? new Date(car.pickup_datetime).toLocaleDateString('ko-KR') : '미정'}</div>
                                            <div><strong>픽업 장소:</strong> {car.pickup_location || '미정'}</div>
                                            <div><strong>도착 장소:</strong> {car.dropoff_location || '미정'}</div>
                                            <div><strong>총 금액:</strong> <span className="text-lg font-bold text-green-600">{car.car_total_price?.toLocaleString() || 0}동</span></div>
                                        </div>
                                        {car.request_note && (
                                            <div className="mt-3 pt-3 border-t border-green-100">
                                                <strong>요청사항:</strong>
                                                <div className="bg-gray-50 p-2 rounded mt-1 text-sm">{car.request_note}</div>
                                            </div>
                                        )}
                                    </div>
                                ))}
                            </div>
                        </div>
                    )}

                    {/* 상세 정보가 없는 경우 */}
                    {cruiseDetails.length === 0 && carDetails.length === 0 && !loading && (
                        <div className="text-center py-6 text-gray-600">
                            <p>크루즈 상세 정보를 찾을 수 없습니다.</p>
                            <p className="text-sm mt-1">예약 ID: {payment.reservation_id}</p>
                        </div>
                    )}
                </div>
            )}
        </div>
    );
};

// 다른 서비스 상세 정보 컴포넌트
const ServiceDetailSection = ({ payment }: { payment: any }) => {
    const [serviceDetails, setServiceDetails] = React.useState<any[]>([]);
    const [loading, setLoading] = React.useState(false);

    React.useEffect(() => {
        const fetchServiceDetails = async () => {
            if (!payment?.reservation_id || !payment?.reservation?.re_type) return;

            const serviceType = payment.reservation.re_type;
            if (serviceType === 'cruise') return; // 크루즈는 별도 컴포넌트에서 처리

            setLoading(true);
            try {
                let tableName = '';
                let selectQuery = '*';

                switch (serviceType) {
                    case 'airport':
                        tableName = 'reservation_airport';
                        break;
                    case 'hotel':
                        tableName = 'reservation_hotel';
                        break;
                    case 'tour':
                        tableName = 'reservation_tour';
                        break;
                    case 'rentcar':
                        tableName = 'reservation_rentcar';
                        break;
                    default:
                        return;
                }

                const { data, error } = await supabase
                    .from(tableName)
                    .select('*')
                    .eq('reservation_id', payment.reservation_id);

                if (!error && data) {
                    // 각 서비스별로 가격 정보를 별도 조회하여 추가
                    const enrichedData = await Promise.all(
                        data.map(async (item) => {
                            let priceData = null;
                            switch (serviceType) {
                                case 'airport':
                                    if (item.airport_price_code) {
                                        const { data: priceInfo } = await supabase
                                            .from('airport_price')
                                            .select('*')
                                            .eq('airport_code', item.airport_price_code)
                                            .single();
                                        priceData = priceInfo;
                                    }
                                    break;
                                case 'hotel':
                                    if (item.hotel_price_code) {
                                        const { data: priceInfo } = await supabase
                                            .from('hotel_price')
                                            .select('*')
                                            .eq('hotel_code', item.hotel_price_code)
                                            .single();
                                        priceData = priceInfo;
                                    }
                                    break;
                                case 'tour':
                                    if (item.tour_price_code) {
                                        const { data: priceInfo } = await supabase
                                            .from('tour_price')
                                            .select('*')
                                            .eq('tour_code', item.tour_price_code)
                                            .single();
                                        priceData = priceInfo;
                                    }
                                    break;
                                case 'rentcar':
                                    if (item.rentcar_price_code) {
                                        const { data: priceInfo } = await supabase
                                            .from('rent_price')
                                            .select('*')
                                            .eq('rent_code', item.rentcar_price_code)
                                            .single();
                                        priceData = priceInfo;
                                    }
                                    break;
                            }
                            return { ...item, price_info: priceData };
                        })
                    );
                    setServiceDetails(enrichedData);
                }
            } catch (error) {
                console.error('서비스 상세 정보 조회 실패:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchServiceDetails();
    }, [payment?.reservation_id, payment?.reservation?.re_type]);

    if (!payment?.reservation?.re_type || payment?.reservation?.re_type === 'cruise') {
        return null;
    }

    const serviceType = payment.reservation.re_type;
    const getServiceIcon = () => {
        switch (serviceType) {
            case 'airport': return <Plane className="w-4 h-4 mr-1" />;
            case 'hotel': return <Building className="w-4 h-4 mr-1" />;
            case 'tour': return <MapPin className="w-4 h-4 mr-1" />;
            case 'rentcar': return <Car className="w-4 h-4 mr-1" />;
            default: return <FileText className="w-4 h-4 mr-1" />;
        }
    };

    const getServiceName = (type: string) => {
        const names: Record<string, string> = {
            airport: '공항 서비스',
            hotel: '호텔',
            tour: '투어',
            rentcar: '렌터카'
        };
        return names[type] || type;
    };

    return (
        <div className="bg-green-50 p-6 rounded-lg border border-green-200">
            <h3 className="text-lg font-semibold text-green-800 mb-4 flex items-center">
                {getServiceIcon()}
                {getServiceName(serviceType)} 상세 정보
            </h3>

            {loading ? (
                <div className="text-center py-4">
                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-500 mx-auto"></div>
                    <p className="mt-2 text-gray-600">데이터를 불러오는 중...</p>
                </div>
            ) : (
                <div className="space-y-4">
                    {serviceDetails.length > 0 ? (
                        serviceDetails.map((detail, index) => (
                            <div key={index} className="bg-white p-4 rounded border border-green-100">
                                {serviceType === 'airport' && (
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
                                        <div><strong>공항 가격 코드:</strong> <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs">{detail.airport_price_code}</span></div>
                                        <div><strong>공항 카테고리:</strong> {detail.price_info?.airport_category || '정보 없음'}</div>
                                        <div><strong>공항 경로:</strong> {detail.price_info?.airport_route || '정보 없음'}</div>
                                        <div><strong>차량 타입:</strong> {detail.price_info?.airport_car_type || '정보 없음'}</div>
                                        <div><strong>가격:</strong> <span className="text-green-600 font-medium">{detail.price_info?.price?.toLocaleString() || 0}동</span></div>
                                        <div><strong>공항 위치:</strong> {detail.ra_airport_location || '미정'}</div>
                                        <div><strong>항공편 번호:</strong> {detail.ra_flight_number || '미정'}</div>
                                        <div><strong>일시:</strong> {detail.ra_datetime ? new Date(detail.ra_datetime).toLocaleString('ko-KR') : '미정'}</div>
                                        <div><strong>경유지:</strong> {detail.ra_stopover_location || '없음'}</div>
                                        <div><strong>대기시간:</strong> {detail.ra_stopover_wait_minutes ? `${detail.ra_stopover_wait_minutes}분` : '없음'}</div>
                                        <div><strong>차량 수:</strong> {detail.ra_car_count || 0}대</div>
                                        <div><strong>승객 수:</strong> {detail.ra_passenger_count || 0}명</div>
                                        <div><strong>짐 개수:</strong> {detail.ra_luggage_count || 0}개</div>
                                        <div><strong>총 금액:</strong> <span className="text-lg font-bold text-green-600">{detail.total_price?.toLocaleString() || 0}동</span></div>
                                        {detail.request_note && (
                                            <div className="md:col-span-2 mt-3 pt-3 border-t border-blue-100">
                                                <strong>요청사항:</strong>
                                                <div className="bg-gray-50 p-2 rounded mt-1 text-sm">{detail.request_note}</div>
                                            </div>
                                        )}
                                    </div>
                                )}

                                {serviceType === 'hotel' && (
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
                                        <div><strong>호텔 가격 코드:</strong> <span className="bg-purple-100 text-purple-800 px-2 py-1 rounded text-xs">{detail.hotel_price_code}</span></div>
                                        <div><strong>호텔명:</strong> {detail.price_info?.hotel_name || '정보 없음'}</div>
                                        <div><strong>룸명:</strong> {detail.price_info?.room_name || '정보 없음'}</div>
                                        <div><strong>룸 타입:</strong> {detail.price_info?.room_type || '정보 없음'}</div>
                                        <div><strong>가격:</strong> <span className="text-green-600 font-medium">{detail.price_info?.price?.toLocaleString() || 0}동</span></div>
                                        <div><strong>스케줄:</strong> {detail.schedule || '정보 없음'}</div>
                                        <div><strong>객실 수:</strong> {detail.room_count || 0}개</div>
                                        <div><strong>투숙객 수:</strong> {detail.guest_count || 0}명</div>
                                        <div><strong>체크인:</strong> {detail.checkin_date ? new Date(detail.checkin_date).toLocaleDateString('ko-KR') : '미정'}</div>
                                        <div><strong>조식 서비스:</strong> {detail.breakfast_service || '없음'}</div>
                                        <div><strong>호텔 카테고리:</strong> {detail.hotel_category || '정보 없음'}</div>
                                        <div><strong>총 금액:</strong> <span className="text-lg font-bold text-green-600">{detail.total_price?.toLocaleString() || 0}동</span></div>
                                        {detail.request_note && (
                                            <div className="md:col-span-2 mt-3 pt-3 border-t border-purple-100">
                                                <strong>요청사항:</strong>
                                                <div className="bg-gray-50 p-2 rounded mt-1 text-sm">{detail.request_note}</div>
                                            </div>
                                        )}
                                    </div>
                                )}

                                {serviceType === 'tour' && (
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
                                        <div><strong>투어 가격 코드:</strong> <span className="bg-orange-100 text-orange-800 px-2 py-1 rounded text-xs">{detail.tour_price_code}</span></div>
                                        <div><strong>투어명:</strong> {detail.price_info?.tour_name || '정보 없음'}</div>
                                        <div><strong>투어 타입:</strong> {detail.price_info?.tour_type || '정보 없음'}</div>
                                        <div><strong>투어 차량:</strong> {detail.price_info?.tour_vehicle || '정보 없음'}</div>
                                        <div><strong>가격:</strong> <span className="text-green-600 font-medium">{detail.price_info?.price?.toLocaleString() || 0}동</span></div>
                                        <div><strong>투어 정원:</strong> {detail.price_info?.tour_capacity || 0}명</div>
                                        <div><strong>투어 인원:</strong> {detail.tour_capacity || 0}명</div>
                                        <div><strong>사용 날짜:</strong> {detail.usage_date ? new Date(detail.usage_date).toLocaleDateString('ko-KR') : '미정'}</div>
                                        <div><strong>픽업 위치:</strong> {detail.pickup_location || '미정'}</div>
                                        <div><strong>드롭오프 위치:</strong> {detail.dropoff_location || '미정'}</div>
                                        <div><strong>총 금액:</strong> <span className="text-lg font-bold text-green-600">{detail.total_price?.toLocaleString() || 0}동</span></div>
                                        {detail.request_note && (
                                            <div className="md:col-span-2 mt-3 pt-3 border-t border-orange-100">
                                                <strong>요청사항:</strong>
                                                <div className="bg-gray-50 p-2 rounded mt-1 text-sm">{detail.request_note}</div>
                                            </div>
                                        )}
                                    </div>
                                )}

                                {serviceType === 'rentcar' && (
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
                                        <div><strong>렌터카 가격 코드:</strong> <span className="bg-red-100 text-red-800 px-2 py-1 rounded text-xs">{detail.rentcar_price_code}</span></div>
                                        <div><strong>렌터카 타입:</strong> {detail.price_info?.rent_type || '정보 없음'}</div>
                                        <div><strong>렌터카 카테고리:</strong> {detail.price_info?.rent_category || '정보 없음'}</div>
                                        <div><strong>렌터카 경로:</strong> {detail.price_info?.rent_route || '정보 없음'}</div>
                                        <div><strong>차량 타입:</strong> {detail.price_info?.rent_car_type || '정보 없음'}</div>
                                        <div><strong>가격:</strong> <span className="text-green-600 font-medium">{detail.price_info?.price?.toLocaleString() || 0}동</span></div>
                                        <div><strong>렌터카 수:</strong> {detail.rentcar_count || 0}대</div>
                                        <div><strong>차량 수:</strong> {detail.car_count || 0}대</div>
                                        <div><strong>승객 수:</strong> {detail.passenger_count || 0}명</div>
                                        <div><strong>픽업 일시:</strong> {detail.pickup_datetime ? new Date(detail.pickup_datetime).toLocaleString('ko-KR') : '미정'}</div>
                                        <div><strong>픽업 위치:</strong> {detail.pickup_location || '미정'}</div>
                                        <div><strong>목적지:</strong> {detail.destination || '미정'}</div>
                                        <div><strong>경유지:</strong> {detail.via_location || '없음'}</div>
                                        <div><strong>경유 대기:</strong> {detail.via_waiting || '없음'}</div>
                                        <div><strong>짐 개수:</strong> {detail.luggage_count || 0}개</div>
                                        <div><strong>총 금액:</strong> <span className="text-lg font-bold text-green-600">{detail.total_price?.toLocaleString() || 0}동</span></div>
                                        {detail.request_note && (
                                            <div className="md:col-span-2 mt-3 pt-3 border-t border-red-100">
                                                <strong>요청사항:</strong>
                                                <div className="bg-gray-50 p-2 rounded mt-1 text-sm">{detail.request_note}</div>
                                            </div>
                                        )}
                                    </div>
                                )}
                            </div>
                        ))
                    ) : (
                        <div className="text-center py-6 text-gray-600">
                            <p>{getServiceName(serviceType)} 상세 정보를 찾을 수 없습니다.</p>
                            <p className="text-sm mt-1">예약 ID: {payment.reservation_id}</p>
                        </div>
                    )}
                </div>
            )}
        </div>
    );
};

interface PaymentDetailModalProps {
    isOpen: boolean;
    onClose: () => void;
    payment: any;
    title?: string;
}

export default function PaymentDetailModal({
    isOpen,
    onClose,
    payment,
    title = "결제 상세 정보"
}: PaymentDetailModalProps) {
    if (!isOpen || !payment) return null;

    const [paymentDetails, setPaymentDetails] = React.useState<any | null>(null);
    const [loading, setLoading] = React.useState(false);

    // 결제 상세 정보 조회
    React.useEffect(() => {
        const fetchPaymentDetails = async () => {
            if (!payment?.id) return;

            setLoading(true);
            try {
                // 결제 정보와 연관된 추가 데이터 조회
                const { data: paymentData, error } = await supabase
                    .from('payment')
                    .select(`
                        *,
                        reservation:reservation_id(
                            *,
                            users:re_user_id(name, email, phone)
                        )
                    `)
                    .eq('id', payment.id)
                    .single();

                if (!error && paymentData) {
                    setPaymentDetails(paymentData);
                }
            } catch (error) {
                console.error('결제 상세 정보 조회 실패:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchPaymentDetails();
    }, [payment?.id]); const safeText = (v: any, fb = '정보 없음') =>
        v !== undefined && v !== null && String(v).trim() !== '' ? String(v) : fb;

    const getServiceName = (type: string) => {
        const names: Record<string, string> = {
            cruise: '크루즈',
            cruise_car: '크루즈 차량',
            airport: '공항 서비스',
            hotel: '호텔',
            tour: '투어',
            rentcar: '렌터카',
            car: '차량 서비스',
            sht_car: 'SHT 차량'
        };
        return names[type] || type;
    };

    return (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div className="bg-white rounded-lg shadow-xl max-w-6xl w-full mx-4 max-h-[90vh] overflow-y-auto">
                {/* 헤더 */}
                <div className="sticky top-0 bg-white border-b px-6 py-4 flex justify-between items-center">
                    <h2 className="text-xl font-bold text-gray-900">{title}</h2>
                    <button
                        onClick={onClose}
                        className="p-2 hover:bg-gray-100 rounded-full transition-colors"
                    >
                        <X className="w-6 h-6" />
                    </button>
                </div>

                {/* 컨텐츠 */}
                <div className="p-6 space-y-6">
                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        {/* 결제자 정보 */}
                        <div className="bg-blue-50 p-6 rounded-lg border border-blue-200">
                            <h4 className="text-lg font-semibold text-blue-800 mb-4 flex items-center">
                                <User className="w-5 h-5 mr-2" />
                                결제자 정보
                            </h4>
                            <div className="space-y-3 text-sm">
                                <div><strong>이름:</strong> {safeText(payment.users?.name || paymentDetails?.reservation?.users?.name)}</div>
                                <div className="flex items-center gap-1">
                                    <strong>이메일:</strong>
                                    <span className="flex items-center gap-1 ml-1">
                                        <Mail className="w-3 h-3" />
                                        {safeText(payment.users?.email || paymentDetails?.reservation?.users?.email)}
                                    </span>
                                </div>
                                <div><strong>전화번호:</strong> {safeText(payment.users?.phone || paymentDetails?.reservation?.users?.phone)}</div>
                            </div>
                        </div>

                        {/* 결제 기본 정보 */}
                        <div className="bg-green-50 p-6 rounded-lg border border-green-200">
                            <h4 className="text-lg font-semibold text-green-800 mb-4 flex items-center">
                                <CreditCard className="w-5 h-5 mr-2" />
                                결제 기본 정보
                            </h4>
                            <div className="space-y-2 text-sm">
                                <div><strong>결제 ID:</strong> <span className="font-mono text-xs bg-gray-100 px-2 py-1 rounded">{payment.id}</span></div>
                                <div><strong>예약 ID:</strong> <span className="font-mono text-xs bg-gray-100 px-2 py-1 rounded">{payment.reservation_id}</span></div>
                                <div><strong>견적 ID:</strong> {safeText(payment.reservation?.re_quote_id)}</div>
                                <div><strong>서비스 타입:</strong> <span className="bg-green-100 text-green-800 px-2 py-1 rounded text-xs">{getServiceName(payment.reservation?.re_type)}</span></div>
                                <div><strong>결제일:</strong> {payment.created_at ? new Date(payment.created_at).toLocaleDateString('ko-KR') : '정보 없음'}</div>
                            </div>
                        </div>
                    </div>

                    {/* 결제 상세 정보 */}
                    <div className="bg-purple-50 p-6 rounded-lg border border-purple-200">
                        <h4 className="text-lg font-semibold text-purple-800 mb-4 flex items-center">
                            <CreditCard className="w-5 h-5 mr-2" />
                            결제 상세 정보
                        </h4>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                            <div><strong>결제 금액:</strong> <span className="text-lg font-bold text-green-600">{(payment.calculatedAmount || payment.amount || 0).toLocaleString()}동</span></div>
                            <div><strong>결제 상태:</strong> <span className={`px-2 py-1 rounded text-xs ${payment.payment_status === 'completed' ? 'bg-green-100 text-green-800' : payment.payment_status === 'pending' ? 'bg-yellow-100 text-yellow-800' : 'bg-red-100 text-red-800'}`}>
                                {payment.payment_status === 'completed' ? '결제 완료' : payment.payment_status === 'pending' ? '결제 대기' : payment.payment_status === 'failed' ? '결제 실패' : payment.payment_status || '상태 없음'}
                            </span></div>
                            <div><strong>결제 수단:</strong> {payment.payment_method === 'CARD' ? '신용카드' : payment.payment_method === 'BANK' ? '계좌이체' : payment.payment_method || '정보 없음'}</div>
                            <div><strong>결제 요청일:</strong> {payment.payment_date ? new Date(payment.payment_date).toLocaleDateString('ko-KR') : '정보 없음'}</div>
                            <div><strong>PG 거래번호:</strong> {payment.pg_transaction_id || '정보 없음'}</div>
                            <div><strong>승인번호:</strong> {payment.approval_number || '정보 없음'}</div>
                            {payment.memo && (
                                <div className="md:col-span-3"><strong>메모:</strong>
                                    <div className="bg-white p-3 rounded mt-2 border">{payment.memo}</div>
                                </div>
                            )}
                        </div>
                    </div>

                    {/* 서비스별 금액 및 상세 정보 */}
                    {payment.serviceData?.services && payment.serviceData.services.length > 0 && (
                        <div className="bg-blue-50 p-6 rounded-lg border border-blue-200">
                            <h3 className="text-lg font-semibold text-blue-800 mb-4 flex items-center">
                                <CreditCard className="w-5 h-5 mr-2" />
                                💰 서비스별 금액 상세
                            </h3>
                            <div className="space-y-3">
                                {payment.serviceData.services.map((service: any, idx: number) => (
                                    <div key={idx} className="bg-white p-4 rounded border border-blue-100">
                                        <div className="flex justify-between items-start mb-2">
                                            <span className="font-medium text-blue-800">{service.type}</span>
                                            <span className="font-bold text-blue-700 text-lg">{service.amount?.toLocaleString() || 0}동</span>
                                        </div>
                                        <div className="text-sm text-blue-600">
                                            {service.unitPrice?.toLocaleString() || 0}동 × {service.quantity || 1}{service.quantityUnit ? ` ${service.quantityUnit}` : ''} = {service.amount?.toLocaleString() || 0}동
                                        </div>
                                    </div>
                                ))}
                                <div className="border-t border-blue-300 pt-3 flex justify-between text-lg font-bold text-blue-900">
                                    <span>총 계산 금액:</span>
                                    <span>{payment.serviceData.total?.toLocaleString() || 0}동</span>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* 크루즈 상세 정보 */}
                    <CruiseDetailSection payment={payment} />

                    {/* 다른 서비스 상세 정보 */}
                    <ServiceDetailSection payment={payment} />                    {/* 결제 이력 정보 */}
                    {paymentDetails && (
                        <div className="bg-gray-50 p-6 rounded-lg">
                            <h3 className="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                                <FileText className="w-5 h-5 mr-2" />
                                결제 처리 이력
                            </h3>
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                                <div><strong>최초 요청일:</strong> {paymentDetails.created_at ? new Date(paymentDetails.created_at).toLocaleDateString('ko-KR') : '정보 없음'}</div>
                                <div><strong>최종 수정일:</strong> {paymentDetails.updated_at ? new Date(paymentDetails.updated_at).toLocaleDateString('ko-KR') : '정보 없음'}</div>
                                <div><strong>처리 상태:</strong> <span className={`px-2 py-1 rounded text-xs ${paymentDetails.status === 'completed' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'}`}>{paymentDetails.status || '대기중'}</span></div>
                                <div><strong>결제 방식:</strong> {paymentDetails.payment_gateway || '정보 없음'}</div>
                                {paymentDetails.failure_reason && (
                                    <div className="md:col-span-2">
                                        <strong>실패 사유:</strong>
                                        <div className="bg-red-50 text-red-700 p-3 rounded mt-2 border border-red-200">{paymentDetails.failure_reason}</div>
                                    </div>
                                )}
                                {paymentDetails.notes && (
                                    <div className="md:col-span-2">
                                        <strong>처리 노트:</strong>
                                        <div className="bg-white p-3 rounded mt-2 border">{paymentDetails.notes}</div>
                                    </div>
                                )}
                            </div>
                        </div>
                    )}

                    {/* 연결된 예약 정보 */}
                    {payment.reservation && (
                        <div className="bg-yellow-50 p-6 rounded-lg border border-yellow-200">
                            <h3 className="text-lg font-semibold text-yellow-800 mb-4 flex items-center">
                                <Calendar className="w-5 h-5 mr-2" />
                                연결된 예약 정보
                            </h3>
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                                <div><strong>예약 상태:</strong> <span className={`px-2 py-1 rounded text-xs ${payment.reservation.re_status === 'confirmed' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'}`}>
                                    {payment.reservation.re_status === 'confirmed' ? '확정' : payment.reservation.re_status === 'pending' ? '대기중' : payment.reservation.re_status || '정보 없음'}
                                </span></div>
                                <div><strong>예약 생성일:</strong> {payment.reservation.re_created_at ? new Date(payment.reservation.re_created_at).toLocaleDateString('ko-KR') : '정보 없음'}</div>
                                <div><strong>서비스 타입:</strong> {getServiceName(payment.reservation.re_type)}</div>
                                <div><strong>견적 ID:</strong> {payment.reservation.re_quote_id || '정보 없음'}</div>
                            </div>
                        </div>
                    )}

                    {/* 서비스 상세 정보가 없는 경우 */}
                    {(!payment.serviceData?.services || payment.serviceData.services.length === 0) && (
                        <div className="bg-yellow-50 p-6 rounded-lg border border-yellow-200">
                            <h3 className="text-lg font-semibold text-yellow-800 mb-4">
                                📋 결제 상세 정보
                            </h3>
                            <div className="text-yellow-700">
                                <p>결제 상세 정보를 불러올 수 없습니다.</p>
                                <p className="text-sm mt-2">결제 ID: {payment.id}</p>
                                <p className="text-sm">예약 ID: {payment.reservation_id}</p>
                                {payment.serviceData && (
                                    <p className="text-xs text-yellow-600 mt-1">
                                        디버그: {JSON.stringify(payment.serviceData)}
                                    </p>
                                )}
                            </div>
                        </div>
                    )}
                </div>

                {/* 푸터 */}
                <div className="sticky bottom-0 bg-gray-50 px-6 py-4 border-t flex justify-end">
                    <button
                        onClick={onClose}
                        className="px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700 transition-colors"
                    >
                        닫기
                    </button>
                </div>
            </div>
        </div>
    );
}
