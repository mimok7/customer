'use client';

import { useState, useEffect, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import supabase from '../../../../lib/supabase';
import { createQuote } from '../../../../lib/quoteUtils';
import ShtCarSeatMap from '@/components/ShtCarSeatMap';

function DirectBookingCruiseContent() {
    const router = useRouter();

    // 현재 단계 상태 (quote → reservation)
    const [currentStep, setCurrentStep] = useState<'quote' | 'reservation'>('quote');
    const [quoteId, setQuoteId] = useState<string | null>(null);

    // 견적 폼 상태
    const [quoteForm, setQuoteForm] = useState({
        checkin: '',
        schedule: '',
        cruise_code: '',
        payment_code: '',
        rooms: [{
            room_type: '',
            categories: [{ room_category: '', adult_count: 0, room_code: '' }]
        }],
        special_requests: ''
    });

    // 차량 폼 상태
    const [vehicleForm, setVehicleForm] = useState([{
        car_type: '',
        car_category: '',
        car_code: '',
        count: 1
    }]);

    // 예약 폼 상태
    const [reservationForm, setReservationForm] = useState({
        room_request_note: '',
        car_request_note: '',
        pickup_datetime: '',
        pickup_location: '',
        dropoff_location: ''
    });

    // 옵션 데이터
    const [cruiseOptions, setCruiseOptions] = useState<string[]>([]);
    const [paymentOptions, setPaymentOptions] = useState<string[]>([]);
    const [roomTypeOptions, setRoomTypeOptions] = useState<string[]>([]);
    const [roomCategoryOptions, setRoomCategoryOptions] = useState<string[]>([]);
    const [carCategoryOptions, setCarCategoryOptions] = useState<string[]>([]);
    const [carTypeOptions, setCarTypeOptions] = useState<string[]>([]);

    // 차량 카테고리 상태
    const [selectedCarCategory, setSelectedCarCategory] = useState('');

    // 일정 옵션 (하드코딩)
    const scheduleOptions = ['1박2일', '2박3일', '당일'];

    // 로딩 상태
    const [loading, setLoading] = useState(false);
    const [user, setUser] = useState<any>(null);
    const [quote, setQuote] = useState<any>(null);

    // 예약 관련 상태
    const [roomPriceInfo, setRoomPriceInfo] = useState<any[]>([]);
    const [carPriceInfo, setCarPriceInfo] = useState<any>(null);
    const [roomsData, setRoomsData] = useState<any[]>([]);

    // SHT 차량 좌석도 모달 상태
    const [isShtCarModalOpen, setIsShtCarModalOpen] = useState(false);

    useEffect(() => {
        // 사용자 인증 확인
        supabase.auth.getUser().then(({ data: { user } }) => {
            if (!user) {
                router.push('/login');
            } else {
                setUser(user);
            }
        });
    }, [router]);

    // 견적 관련 useEffect들
    useEffect(() => {
        if (quoteForm.schedule && quoteForm.checkin) {
            loadCruiseOptions();
        } else {
            setCruiseOptions([]);
            // cruise_code가 이미 비어있지 않을 때만 업데이트
            if (quoteForm.cruise_code !== '') {
                setQuoteForm(prev => ({ ...prev, cruise_code: '' }));
            }
        }
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [quoteForm.schedule, quoteForm.checkin]);

    useEffect(() => {
        if (quoteForm.schedule && quoteForm.checkin && quoteForm.cruise_code) {
            loadPaymentOptions();
            loadCarCategoryOptions();
        } else {
            setPaymentOptions([]);
            setCarCategoryOptions([]);
            // payment_code가 이미 비어있지 않을 때만 업데이트
            if (quoteForm.payment_code !== '') {
                setQuoteForm(prev => ({ ...prev, payment_code: '' }));
            }
        }
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [quoteForm.schedule, quoteForm.checkin, quoteForm.cruise_code]);

    useEffect(() => {
        if (quoteForm.schedule && quoteForm.checkin && quoteForm.cruise_code && quoteForm.payment_code) {
            loadRoomTypeOptions();
        } else {
            setRoomTypeOptions([]);
        }
    }, [quoteForm.schedule, quoteForm.checkin, quoteForm.cruise_code, quoteForm.payment_code]);

    useEffect(() => {
        if (selectedCarCategory && quoteForm.schedule && quoteForm.cruise_code) {
            loadCarTypeOptions();
        } else {
            setCarTypeOptions([]);
        }
    }, [selectedCarCategory, quoteForm.schedule, quoteForm.cruise_code]);

    // 크루즈 옵션 로드 함수
    const loadCruiseOptions = async () => {
        try {
            const { data, error } = await supabase
                .from('room_price')
                .select('cruise')
                .eq('schedule', quoteForm.schedule)
                .lte('start_date', quoteForm.checkin)
                .gte('end_date', quoteForm.checkin)
                .order('cruise');

            if (error) throw error;

            const uniqueCruises = [...new Set(data.map((item: any) => item.cruise).filter(Boolean))] as string[];
            setCruiseOptions(uniqueCruises);
            console.log('크루즈 옵션 로드됨:', uniqueCruises);
        } catch (error) {
            console.error('크루즈 옵션 조회 실패:', error);
        }
    };

    // 결제방식 옵션 로드 함수
    const loadPaymentOptions = async () => {
        try {
            const { data, error } = await supabase
                .from('room_price')
                .select('payment')
                .eq('schedule', quoteForm.schedule)
                .eq('cruise', quoteForm.cruise_code)
                .lte('start_date', quoteForm.checkin)
                .gte('end_date', quoteForm.checkin)
                .order('payment');

            if (error) throw error;

            const uniquePayments = [...new Set(data.map((item: any) => item.payment).filter(Boolean))] as string[];
            setPaymentOptions(uniquePayments);
            console.log('결제방식 옵션 로드됨:', uniquePayments);
        } catch (error) {
            console.error('결제방식 옵션 조회 실패:', error);
        }
    };

    // 룸타입 옵션 로드 함수
    const loadRoomTypeOptions = async () => {
        try {
            const { data, error } = await supabase
                .from('room_price')
                .select('room_type')
                .eq('schedule', quoteForm.schedule)
                .eq('cruise', quoteForm.cruise_code)
                .eq('payment', quoteForm.payment_code)
                .lte('start_date', quoteForm.checkin)
                .gte('end_date', quoteForm.checkin)
                .order('room_type');

            if (error) throw error;

            const uniqueRoomTypes = [...new Set(data.map((item: any) => item.room_type).filter(Boolean))] as string[];
            setRoomTypeOptions(uniqueRoomTypes);
            console.log('객실타입 옵션 로드됨:', uniqueRoomTypes);
        } catch (error) {
            console.error('객실타입 옵션 조회 실패:', error);
        }
    };

    // 룸카테고리 옵션 로드 함수
    const loadRoomCategoryOptions = async (roomType?: string) => {
        try {
            const { data, error } = await supabase
                .from('room_price')
                .select('room_category')
                .eq('schedule', quoteForm.schedule)
                .eq('cruise', quoteForm.cruise_code)
                .eq('payment', quoteForm.payment_code)
                .eq('room_type', roomType || '')
                .lte('start_date', quoteForm.checkin)
                .gte('end_date', quoteForm.checkin)
                .order('room_category');

            if (error) throw error;

            const uniqueRoomCategories = [...new Set(data.map((item: any) => item.room_category).filter(Boolean))] as string[];
            setRoomCategoryOptions(uniqueRoomCategories);
            console.log('룸카테고리 옵션 로드됨:', uniqueRoomCategories);
        } catch (error) {
            console.error('룸카테고리 옵션 조회 실패:', error);
        }
    };

    // 차량 카테고리 옵션 로드 함수
    const loadCarCategoryOptions = async () => {
        try {
            const { data, error } = await supabase
                .from('car_price')
                .select('car_category')
                .eq('schedule', quoteForm.schedule)
                .eq('cruise', quoteForm.cruise_code)
                .order('car_category');

            if (error) throw error;

            const uniqueCategories = [...new Set(data.map((item: any) => item.car_category).filter(Boolean))] as string[];
            setCarCategoryOptions(uniqueCategories);
            console.log('차량 카테고리 옵션 로드됨:', uniqueCategories);
        } catch (error) {
            console.error('차량 카테고리 옵션 조회 실패:', error);
        }
    };

    // 차량타입 옵션 로드 함수
    const loadCarTypeOptions = async () => {
        try {
            const { data, error } = await supabase
                .from('car_price')
                .select('car_type')
                .eq('schedule', quoteForm.schedule)
                .eq('cruise', quoteForm.cruise_code)
                .eq('car_category', selectedCarCategory)
                .order('car_type');

            if (error) throw error;

            const uniqueCarTypes = [...new Set(data.map((item: any) => item.car_type).filter(Boolean))] as string[];
            setCarTypeOptions(uniqueCarTypes);
            console.log('차량타입 옵션 로드됨:', uniqueCarTypes);
        } catch (error) {
            console.error('차량타입 옵션 조회 실패:', error);
        }
    };

    // room_code 조회 함수
    const getRoomCode = async (roomType: string, roomCategory: string): Promise<string> => {
        try {
            const { data, error } = await supabase
                .from('room_price')
                .select('room_code')
                .eq('schedule', quoteForm.schedule)
                .eq('cruise', quoteForm.cruise_code)
                .eq('payment', quoteForm.payment_code)
                .eq('room_type', roomType)
                .eq('room_category', roomCategory)
                .lte('start_date', quoteForm.checkin)
                .gte('end_date', quoteForm.checkin)
                .maybeSingle();

            if (error) throw error;
            console.log('room_code 조회됨:', data?.room_code);
            return data?.room_code || '';
        } catch (error) {
            console.error('room_code 조회 실패:', error);
            return '';
        }
    };

    // car_code 조회 함수
    const getCarCode = async (carType: string, carCategory: string): Promise<string> => {
        try {
            const { data, error } = await supabase
                .from('car_price')
                .select('car_code')
                .eq('schedule', quoteForm.schedule)
                .eq('cruise', quoteForm.cruise_code)
                .eq('car_type', carType)
                .eq('car_category', carCategory)
                .maybeSingle();

            if (error) throw error;
            console.log('car_code 조회됨:', data?.car_code);
            return data?.car_code || '';
        } catch (error) {
            console.error('car_code 조회 실패:', error);
            return '';
        }
    };

    // 객실 추가 함수
    const addNewRoom = () => {
        if (quoteForm.rooms.length < 3) {
            setQuoteForm(prev => ({
                ...prev,
                rooms: [...prev.rooms, {
                    room_type: '',
                    categories: [{ room_category: '', adult_count: 0, room_code: '' }]
                }]
            }));
        }
    };

    // 카테고리 추가 함수
    const addNewCategory = (roomIndex: number) => {
        setQuoteForm(prev => {
            const newRooms = [...prev.rooms];
            newRooms[roomIndex].categories.push({ room_category: '', adult_count: 0, room_code: '' });
            return { ...prev, rooms: newRooms };
        });
    };

    // 차량 추가/제거 함수
    const handleAddVehicle = () => {
        if (vehicleForm.length < 3) {
            setVehicleForm([...vehicleForm, { car_type: '', car_category: '', car_code: '', count: 1 }]);
        }
    };

    const handleRemoveVehicle = (index: number) => {
        if (vehicleForm.length > 1) {
            setVehicleForm(vehicleForm.filter((_, i) => i !== index));
        }
    };

    const handleVehicleChange = (index: number, field: string, value: any) => {
        const newVehicleForm = [...vehicleForm];
        (newVehicleForm[index] as any)[field] = value;
        setVehicleForm(newVehicleForm);
    };

    // 견적 제출 함수
    const handleQuoteSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        try {
            setLoading(true);

            if (!user) {
                alert('로그인이 필요합니다.');
                return;
            }

            // 사용자 이름 가져오기
            const { data: userData, error: userError } = await supabase
                .from('users')
                .select('name')
                .eq('id', user.id)
                .single();

            const userName = userData?.name || user.email?.split('@')[0] || '고객';
            const today = new Date().toLocaleDateString('ko-KR', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit'
            }).replace(/\. /g, '.').replace(/\.$/, '');

            // 견적 생성 (예시: 홍길동 행복여행 2025.01.15)
            const travelName = `${userName} 행복여행 ${today}`;
            const newQuote = await createQuote(user.id, travelName);
            if (!newQuote) {
                alert('견적 생성에 실패했습니다.');
                return;
            }

            setQuoteId(newQuote.id);
            setQuote(newQuote);

            // ✅ 성능 개선: 1. 모든 객실 데이터를 한 번에 수집하여 배치 저장
            const roomInserts = [];
            for (const room of quoteForm.rooms) {
                for (const category of room.categories) {
                    if (category.room_code && category.adult_count > 0) {
                        roomInserts.push({
                            room_code: category.room_code,
                            person_count: category.adult_count
                        });
                    }
                }
            }

            // 객실 데이터 배치 저장
            let roomDataArray = [];
            if (roomInserts.length > 0) {
                const { data: savedRooms, error: roomError } = await supabase
                    .from('room')
                    .insert(roomInserts)
                    .select();
                if (roomError) throw roomError;
                roomDataArray = savedRooms || [];
            }

            // quote_item 배치 저장
            const quoteItems = roomDataArray.map((roomData, index) => ({
                quote_id: newQuote.id,
                service_type: 'room',
                service_ref_id: roomData.id,
                quantity: 1,
                unit_price: 0,
                total_price: 0,
                usage_date: quoteForm.checkin
            }));

            // ✅ 성능 개선: 2. 모든 차량 데이터를 한 번에 수집하여 배치 저장
            const carInserts = [];
            for (const vehicle of vehicleForm) {
                if (vehicle.car_code && vehicle.count > 0) {
                    carInserts.push({
                        car_code: vehicle.car_code,
                        car_count: vehicle.count
                    });
                }
            }

            // 차량 데이터 배치 저장
            if (carInserts.length > 0) {
                const { data: savedCars, error: carError } = await supabase
                    .from('car')
                    .insert(carInserts)
                    .select();
                if (carError) throw carError;

                // 차량 quote_item 추가
                (savedCars || []).forEach((carData, index) => {
                    quoteItems.push({
                        quote_id: newQuote.id,
                        service_type: 'car',
                        service_ref_id: carData.id,
                        quantity: vehicleForm[index]?.count || 1,
                        unit_price: 0,
                        total_price: 0,
                        usage_date: quoteForm.checkin
                    });
                });
            }

            // 모든 quote_item을 한 번에 저장
            if (quoteItems.length > 0) {
                const { error: itemError } = await supabase
                    .from('quote_item')
                    .insert(quoteItems);
                if (itemError) throw itemError;
            }

            // 견적에 연결된 데이터 로드
            await loadQuoteLinkedData(newQuote.id);

            alert('가격 정보가 저장되었습니다! 이제 서비스 정보를 입력하세요.');
            setCurrentStep('reservation');

        } catch (error) {
            console.error('견적 저장 실패:', error);
            alert('견적 저장 중 오류가 발생했습니다.');
        } finally {
            setLoading(false);
        }
    };

    // 견적에 연결된 룸/차량 데이터 로드
    const loadQuoteLinkedData = async (quoteId: string) => {
        try {
            const { data: quoteItems } = await supabase
                .from('quote_item')
                .select('service_type, service_ref_id, quantity, unit_price, total_price, usage_date')
                .eq('quote_id', quoteId);

            if (quoteItems) {
                const roomItems = quoteItems.filter(item => item.service_type === 'room');
                if (roomItems.length > 0) {
                    await loadAllRoomInfo(roomItems);
                }

                const carItems = quoteItems.filter(item => item.service_type === 'car');
                if (carItems.length > 0) {
                    await loadCarInfo(carItems[0].service_ref_id, carItems[0]);
                }
            }
        } catch (error) {
            console.error('견적 연결 데이터 로드 오류:', error);
        }
    };

    // 모든 룸 정보 로드
    const loadAllRoomInfo = async (roomItems: any[]) => {
        try {
            // ✅ 성능 개선: 모든 room ID를 한 번에 조회
            const roomIds = roomItems.map(item => item.service_ref_id);
            const { data: roomsDataArray } = await supabase
                .from('room')
                .select('*')
                .in('id', roomIds);

            if (!roomsDataArray || roomsDataArray.length === 0) return;

            // ✅ 성능 개선: 모든 room_code를 한 번에 조회
            const roomCodes = roomsDataArray.map(room => room.room_code);
            const { data: allRoomPrices } = await supabase
                .from('room_price')
                .select('*')
                .in('room_code', roomCodes);

            // 데이터 매핑
            const roomPriceMap = new Map();
            (allRoomPrices || []).forEach(price => {
                if (!roomPriceMap.has(price.room_code)) {
                    roomPriceMap.set(price.room_code, price);
                }
            });

            const allRoomsData = roomsDataArray.map(roomData => {
                const roomItem = roomItems.find(item => item.service_ref_id === roomData.id);
                const priceInfo = roomPriceMap.get(roomData.room_code);

                return {
                    ...roomData,
                    quoteItem: roomItem,
                    priceInfo
                };
            }).filter(room => room.priceInfo);

            const uniqueRooms = deduplicateRooms(allRoomsData);
            setRoomsData(uniqueRooms);

            const uniquePriceInfo = deduplicatePriceInfo(allRoomPrices || []);
            setRoomPriceInfo(uniquePriceInfo);

        } catch (error) {
            console.error('룸 정보 로드 오류:', error);
        }
    };

    // 차량 정보 로드
    const loadCarInfo = async (carId: string, quoteItem?: any) => {
        try {
            const { data: carData } = await supabase
                .from('car')
                .select('car_code')
                .eq('id', carId)
                .single();

            if (carData?.car_code) {
                const { data: carPriceData } = await supabase
                    .from('car_price')
                    .select('*')
                    .eq('car_code', carData.car_code)
                    .maybeSingle();

                if (carPriceData) {
                    setCarPriceInfo(carPriceData);
                }
            }
        } catch (error) {
            console.error('차량 정보 로드 오류:', error);
        }
    };

    // 객실 데이터 중복 제거 함수
    const deduplicateRooms = (rooms: any[]) => {
        const roomMap = new Map();
        rooms.forEach(room => {
            const key = room.room_code;
            if (roomMap.has(key)) {
                const existing = roomMap.get(key);
                existing.person_count += room.person_count || 0;
                existing.totalPrice += room.quoteItem?.total_price || 0;
                existing.roomCount += 1;
                existing.allQuoteItems.push(room.quoteItem);
            } else {
                roomMap.set(key, {
                    ...room,
                    totalPrice: room.quoteItem?.total_price || 0,
                    roomCount: 1,
                    allQuoteItems: [room.quoteItem]
                });
            }
        });
        return Array.from(roomMap.values());
    };

    // 가격 정보 중복 제거 함수
    const deduplicatePriceInfo = (priceList: any[]) => {
        const priceMap = new Map();
        priceList.forEach(price => {
            const key = `${price.room_code}_${price.cruise}_${price.room_type}_${price.schedule}`;
            if (!priceMap.has(key)) {
                priceMap.set(key, price);
            }
        });
        return Array.from(priceMap.values());
    };

    // 예약 제출 함수
    const handleReservationSubmit = async () => {
        try {
            setLoading(true);

            if (!user || !quoteId) {
                alert('잘못된 접근입니다.');
                return;
            }

            // 사용자 역할 업데이트
            const { data: existingUser } = await supabase
                .from('users')
                .select('id, role')
                .eq('id', user.id)
                .single();

            if (!existingUser || existingUser.role === 'guest') {
                await supabase
                    .from('users')
                    .upsert({
                        id: user.id,
                        email: user.email,
                        role: 'member',
                        updated_at: new Date().toISOString()
                    }, { onConflict: 'id' });
            }

            // 새 예약 생성
            const { data: newReservation, error: reservationError } = await supabase
                .from('reservation')
                .insert({
                    re_user_id: user.id,
                    re_quote_id: quoteId,
                    re_type: 'cruise',
                    re_status: 'pending',
                    re_created_at: new Date().toISOString()
                })
                .select()
                .single();

            if (reservationError) throw reservationError;

            // ✅ 성능 개선: 객실 예약을 배치로 한 번에 저장
            if (roomsData.length > 0) {
                const roomReservations = roomsData.map(roomData => ({
                    reservation_id: newReservation.re_id,
                    room_price_code: roomData.room_code,
                    checkin: quoteForm.checkin,
                    guest_count: roomData.person_count || 0,
                    unit_price: roomData.priceInfo?.price || 0,
                    room_total_price: roomData.quoteItem?.total_price || 0,
                    request_note: reservationForm.room_request_note || null
                }));

                const { error: roomError } = await supabase
                    .from('reservation_cruise')
                    .insert(roomReservations);

                if (roomError) throw roomError;
            }

            // 차량 예약 저장
            if (carPriceInfo) {
                // 차량종류에 따라 car_count와 passenger_count 결정
                const carType = vehicleForm[0]?.car_type || '';
                const inputCount = vehicleForm[0]?.count || 1;

                // 셔틀이 포함되면 passenger_count에 저장
                // 포함: 스테이하롱 셔틀, 크루즈 셔틀 리무진
                // 제외: 스테이하롱 셔틀 리무진 단독
                const isShuttle = (carType.includes('셔틀') || carType.includes('크루즈 셔틀 리무진'))
                    && !carType.includes('스테이하롱 셔틀 리무진 단독');

                const carReservationData = {
                    reservation_id: newReservation.re_id,
                    car_price_code: carPriceInfo.car_code,
                    car_count: isShuttle ? 0 : inputCount,
                    passenger_count: isShuttle ? inputCount : 0,
                    pickup_datetime: reservationForm.pickup_datetime ? new Date(reservationForm.pickup_datetime).toISOString() : null,
                    pickup_location: reservationForm.pickup_location,
                    dropoff_location: reservationForm.dropoff_location,
                    car_total_price: 0,
                    request_note: reservationForm.car_request_note || null
                };

                const { error: carError } = await supabase
                    .from('reservation_cruise_car')
                    .insert(carReservationData);

                if (carError) throw carError;
            }

            // 알림 생성 - 예약 신청
            try {
                await supabase.rpc('create_reservation_notification', {
                    p_reservation_id: newReservation.re_id,
                    p_user_id: user.id
                });
            } catch (notificationError) {
                console.error('알림 생성 실패:', notificationError);
                // 알림 생성 실패해도 예약 완료는 성공으로 처리
            }

            alert('예약이 성공적으로 완료되었습니다!');
            router.push('/mypage/direct-booking?completed=cruise');
        } catch (error) {
            console.error('예약 저장 오류:', error);
            alert('예약 저장 중 오류가 발생했습니다.');
        } finally {
            setLoading(false);
        }
    };

    if (loading && currentStep === 'quote') {
        return (
            <div className="min-h-screen bg-gray-50">
                <div className="flex flex-col justify-center items-center h-64">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto"></div>
                    <p className="mt-4 text-gray-600">견적 저장 중...</p>
                </div>
            </div>
        );
    }

    if (loading && currentStep === 'reservation') {
        return (
            <div className="min-h-screen bg-gray-50">
                <div className="flex flex-col justify-center items-center h-64">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-500 mx-auto"></div>
                    <p className="mt-4 text-gray-600">예약 처리 중...</p>
                    <p className="mt-2 text-sm text-gray-500">잠시만 기다려주세요</p>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50">
            {/* 헤더 */}
            <div className="bg-gradient-to-br from-blue-200 via-purple-200 to-indigo-100 text-gray-900">
                <div className="container mx-auto px-4 py-8">
                    <div className="flex items-center justify-between mb-6">
                        <div>
                            <h1 className="text-3xl font-bold mb-2">🚢 크루즈 예약</h1>
                            <p className="text-lg opacity-90">
                                {currentStep === 'quote' ? '자료 입력 → 예약 진행' : '예약 정보 입력'}
                            </p>
                        </div>
                        <button
                            onClick={() => router.back()}
                            className="bg-gray-600 text-white px-4 py-2 rounded-lg hover:bg-gray-700 transition-colors"
                        >
                            ← 뒤로
                        </button>
                    </div>

                    {/* 진행 단계 표시 */}
                    <div className="bg-white/70 backdrop-blur rounded-lg p-4 mb-6">
                        <div className="flex items-center space-x-4">
                            <div className={`flex items-center space-x-2 ${currentStep === 'quote' ? 'text-blue-600 font-semibold' : 'text-green-600'}`}>
                                <span className={`w-8 h-8 rounded-full flex items-center justify-center text-white ${currentStep === 'quote' ? 'bg-blue-500' : 'bg-green-500'}`}>
                                    {currentStep === 'quote' ? '1' : '✓'}
                                </span>
                                <span>자료 입력</span>
                            </div>
                            <div className="flex-1 h-1 bg-gray-300 rounded">
                                <div className={`h-full bg-blue-500 rounded transition-all duration-500 ${currentStep === 'reservation' ? 'w-full' : 'w-0'}`}></div>
                            </div>
                            <div className={`flex items-center space-x-2 ${currentStep === 'reservation' ? 'text-blue-600 font-semibold' : 'text-gray-400'}`}>
                                <span className={`w-8 h-8 rounded-full flex items-center justify-center text-white ${currentStep === 'reservation' ? 'bg-blue-500' : 'bg-gray-400'}`}>
                                    2
                                </span>
                                <span>예약 진행</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* 메인 컨텐츠 */}
            <div className="container mx-auto px-4 py-8">
                <div className="max-w-4xl mx-auto">

                    {/* 자료 입력 단계 */}
                    {currentStep === 'quote' && (
                        <form onSubmit={handleQuoteSubmit} className="bg-white rounded-xl shadow-lg p-8">
                            <h2 className="text-2xl font-bold text-gray-800 mb-6">📝 1단계: 자료 입력</h2>

                            {/* 크루즈 안내 카드 */}
                            <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg p-6 mb-6">
                                <h3 className="text-white text-lg font-semibold mb-2">🚢 크루즈 예약 안내</h3>
                                <p className="text-white/90 text-sm">
                                    원하시는 크루즈 여행 일정과 객실, 차량을 선택하여 견적을 요청하세요.<br />
                                    날짜와 일정을 먼저 선택하시면 단계별로 옵션이 제공됩니다.
                                </p>
                            </div>

                            {/* 기본 정보 */}
                            <div className="space-y-6">
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">📅 체크인 날짜</label>
                                    <input
                                        type="date"
                                        value={quoteForm.checkin}
                                        onChange={e => setQuoteForm({ ...quoteForm, checkin: e.target.value })}
                                        className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                        required
                                    />
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">🗓 일정 선택</label>
                                    <div className="grid grid-cols-3 gap-2">
                                        {scheduleOptions.map((option) => (
                                            <button
                                                key={option}
                                                type="button"
                                                onClick={() => setQuoteForm({ ...quoteForm, schedule: option })}
                                                className={`border p-3 rounded-lg transition-colors ${quoteForm.schedule === option ? 'bg-blue-500 text-white' : 'bg-blue-50 text-blue-700 hover:bg-blue-100'
                                                    }`}
                                            >
                                                {option}
                                            </button>
                                        ))}
                                    </div>
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">🚢 크루즈 선택</label>
                                    <select
                                        value={quoteForm.cruise_code}
                                        onChange={e => setQuoteForm({ ...quoteForm, cruise_code: e.target.value })}
                                        className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                        required
                                    >
                                        <option value="">크루즈를 선택하세요</option>
                                        {cruiseOptions.map(cruise => (
                                            <option key={cruise} value={cruise}>{cruise}</option>
                                        ))}
                                    </select>
                                </div>

                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">💳 결제 방식</label>
                                    <div className="grid grid-cols-2 gap-2">
                                        {paymentOptions.map(payment => (
                                            <button
                                                key={payment}
                                                type="button"
                                                onClick={() => setQuoteForm({ ...quoteForm, payment_code: payment })}
                                                className={`border p-3 rounded-lg transition-colors ${quoteForm.payment_code === payment ? 'bg-blue-500 text-white' : 'bg-blue-50 text-blue-700 hover:bg-blue-100'
                                                    }`}
                                            >
                                                {payment}
                                            </button>
                                        ))}
                                    </div>
                                </div>

                                {/* 객실 선택 영역 */}
                                <div className="space-y-4">
                                    <h3 className="text-lg font-semibold text-gray-800">🛏 객실 선택</h3>
                                    {quoteForm.rooms.map((room, roomIdx) => (
                                        <div key={roomIdx} className="border border-blue-200 rounded-lg p-4 bg-blue-50">
                                            <div className="flex items-center justify-between mb-3">

                                                {quoteForm.rooms.length > 1 && (
                                                    <button
                                                        type="button"
                                                        onClick={() => {
                                                            setQuoteForm(prev => ({
                                                                ...prev,
                                                                rooms: prev.rooms.filter((_, i) => i !== roomIdx)
                                                            }));
                                                        }}
                                                        className="text-red-600 hover:text-red-800 text-sm"
                                                    >
                                                        삭제
                                                    </button>
                                                )}
                                            </div>

                                            {/* 객실 타입 선택 */}
                                            <div className="mb-4">
                                                <label className="block text-sm font-medium text-gray-700 mb-2">🛏 객실 타입</label>
                                                <select
                                                    value={room.room_type}
                                                    onChange={e => {
                                                        const newRooms = [...quoteForm.rooms];
                                                        newRooms[roomIdx].room_type = e.target.value;
                                                        newRooms[roomIdx].categories = [{ room_category: '', adult_count: 0, room_code: '' }];
                                                        setQuoteForm({ ...quoteForm, rooms: newRooms });
                                                        if (e.target.value) {
                                                            loadRoomCategoryOptions(e.target.value);
                                                        }
                                                    }}
                                                    className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                                    required
                                                >
                                                    <option value="">객실 타입을 선택하세요</option>
                                                    {roomTypeOptions.map(roomType => (
                                                        <option key={roomType} value={roomType}>{roomType}</option>
                                                    ))}
                                                </select>
                                            </div>

                                            {/* 카테고리별 객실 선택 */}
                                            {room.categories.map((category, catIdx) => {
                                                const usedCategories = room.categories
                                                    .filter((_, i) => i !== catIdx)
                                                    .map(cat => cat.room_category)
                                                    .filter(Boolean);
                                                const availableCategories = roomCategoryOptions.filter(cat => !usedCategories.includes(cat));

                                                return (
                                                    <div key={catIdx} className="border border-gray-200 rounded-lg p-3 mb-3 bg-white">
                                                        <div className="flex items-center justify-between mb-2">

                                                            {room.categories.length > 1 && (
                                                                <button
                                                                    type="button"
                                                                    onClick={() => {
                                                                        const newRooms = [...quoteForm.rooms];
                                                                        newRooms[roomIdx].categories = newRooms[roomIdx].categories.filter((_, i) => i !== catIdx);
                                                                        setQuoteForm({ ...quoteForm, rooms: newRooms });
                                                                    }}
                                                                    className="text-red-600 hover:text-red-800 text-xs"
                                                                >
                                                                    삭제
                                                                </button>
                                                            )}
                                                        </div>

                                                        <div className="grid grid-cols-2 gap-3">
                                                            <div>
                                                                <label className="block text-xs font-medium text-gray-600 mb-1">구분</label>
                                                                <select
                                                                    value={category.room_category}
                                                                    onChange={async (e) => {
                                                                        const roomCategory = e.target.value;
                                                                        const roomCode = await getRoomCode(room.room_type, roomCategory);
                                                                        const newRooms = [...quoteForm.rooms];
                                                                        newRooms[roomIdx].categories[catIdx].room_category = roomCategory;
                                                                        newRooms[roomIdx].categories[catIdx].room_code = roomCode;
                                                                        setQuoteForm({ ...quoteForm, rooms: newRooms });
                                                                    }}
                                                                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500 bg-white text-sm"
                                                                >
                                                                    <option value="">성인 아동 선택</option>
                                                                    {availableCategories.map(cat => (
                                                                        <option key={cat} value={cat}>{cat}</option>
                                                                    ))}
                                                                </select>
                                                            </div>

                                                            <div>
                                                                <label className="block text-xs font-medium text-gray-600 mb-1">인원수</label>
                                                                <input
                                                                    type="number"
                                                                    min="0"
                                                                    value={category.adult_count || ''}
                                                                    placeholder="인원수"
                                                                    onChange={(e) => {
                                                                        const inputValue = parseInt(e.target.value);
                                                                        if (e.target.value === '' || inputValue >= 0) {
                                                                            const newRooms = [...quoteForm.rooms];
                                                                            newRooms[roomIdx].categories[catIdx].adult_count = inputValue || 0;
                                                                            setQuoteForm({ ...quoteForm, rooms: newRooms });

                                                                            if (inputValue > 0 && category.room_category && catIdx === room.categories.length - 1) {
                                                                                addNewCategory(roomIdx);
                                                                            }
                                                                        }
                                                                    }}
                                                                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500 text-sm [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-auto [&::-webkit-inner-spin-button]:appearance-auto"
                                                                    style={{ WebkitAppearance: 'auto' as any, MozAppearance: 'textfield' }}
                                                                />
                                                            </div>
                                                        </div>
                                                    </div>
                                                );
                                            })}
                                        </div>
                                    ))}

                                    {quoteForm.rooms.length < 3 && (
                                        <button
                                            type="button"
                                            onClick={addNewRoom}
                                            className="w-full border-2 border-dashed border-blue-300 rounded-lg p-4 text-blue-600 hover:border-blue-400 hover:text-blue-700 transition-colors"
                                        >
                                            + 객실 추가 (최대 3개)
                                        </button>
                                    )}
                                </div>

                                {/* 차량 선택 영역 */}
                                <div className="space-y-4">
                                    <h3 className="text-lg font-semibold text-gray-800">🚗 차량 선택</h3>

                                    {/* 스하차량 버튼 - 차량 선택 섹션 상단에 추가 */}
                                    <div className="mb-4 flex justify-between items-center">
                                        <h4 className="text-sm font-medium text-gray-700">차량 선택 정보</h4>
                                        <button
                                            type="button"
                                            onClick={() => setIsShtCarModalOpen(true)}
                                            className="px-3 py-1 bg-blue-50 text-blue-600 rounded border border-blue-200 text-sm hover:bg-blue-100 transition-colors"
                                            disabled={!quoteForm.checkin}
                                        >
                                            🚐 스하차량 좌석도 보기
                                        </button>
                                    </div>

                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-2">차량구분</label>
                                        <div className="flex gap-2">
                                            {carCategoryOptions.map(category => (
                                                <button
                                                    key={category}
                                                    type="button"
                                                    onClick={() => setSelectedCarCategory(category)}
                                                    className={`px-4 py-2 border rounded-lg transition-colors ${selectedCarCategory === category
                                                        ? 'bg-green-500 text-white border-green-500'
                                                        : 'bg-gray-50 border-gray-300 hover:bg-gray-100 text-gray-700'
                                                        }`}
                                                >
                                                    {category}
                                                </button>
                                            ))}
                                        </div>
                                        {selectedCarCategory && (
                                            <p className="text-sm text-green-600 mt-2">
                                                선택된 차량구분: <span className="font-semibold">{selectedCarCategory}</span>
                                            </p>
                                        )}
                                        {/* 스테이하롱 셔틀 안내 문구 */}
                                        {selectedCarCategory && selectedCarCategory.includes('스테이하롱 셔틀') && (
                                            <div className="mt-3 p-3 bg-blue-50 border border-blue-200 rounded-lg">
                                                <p className="text-sm text-blue-800">
                                                    💡 <strong>좌석 배정 안내:</strong> 좌석도를 확인하시고 요청사항에 차량번호 좌석번호를 적어주시면 최대한 원하시는 좌석에 배정하도록 하겠습니다. ^^
                                                </p>
                                            </div>
                                        )}
                                    </div>

                                    {vehicleForm.map((vehicle, vehicleIndex) => (
                                        <div key={vehicleIndex} className="border border-green-200 rounded-lg p-4 bg-green-50">
                                            <div className="flex items-center justify-between mb-3">

                                                {vehicleForm.length > 1 && (
                                                    <button
                                                        type="button"
                                                        onClick={() => handleRemoveVehicle(vehicleIndex)}
                                                        className="text-red-600 hover:text-red-800 text-sm"
                                                    >
                                                        삭제
                                                    </button>
                                                )}
                                            </div>

                                            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                                                <div>
                                                    <label className="block text-sm font-medium text-gray-600 mb-1">차량타입</label>
                                                    <select
                                                        value={vehicle.car_type}
                                                        onChange={async (e) => {
                                                            const carType = e.target.value;
                                                            const carCode = await getCarCode(carType, selectedCarCategory);
                                                            handleVehicleChange(vehicleIndex, 'car_type', carType);
                                                            handleVehicleChange(vehicleIndex, 'car_category', selectedCarCategory);
                                                            handleVehicleChange(vehicleIndex, 'car_code', carCode);
                                                        }}
                                                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-green-500 bg-white"
                                                        disabled={!selectedCarCategory}
                                                    >
                                                        <option value="">
                                                            {selectedCarCategory ? '차량타입 선택' : '먼저 차량구분을 선택하세요'}
                                                        </option>
                                                        {carTypeOptions.map(carType => (
                                                            <option key={carType} value={carType}>{carType}</option>
                                                        ))}
                                                    </select>
                                                </div>

                                                <div>
                                                    <label className="block text-sm font-medium text-gray-600 mb-1">
                                                        {vehicle.car_type && ((vehicle.car_type.includes('셔틀') || vehicle.car_type.includes('크루즈 셔틀 리무진')) && !vehicle.car_type.includes('스테이하롱 셔틀 리무진 단독'))
                                                            ? '인원수'
                                                            : '차량 및 인원수'
                                                        }
                                                    </label>
                                                    <input
                                                        type="number"
                                                        min="0"
                                                        value={vehicle.count || ''}
                                                        placeholder={vehicle.car_type && ((vehicle.car_type.includes('셔틀') || vehicle.car_type.includes('크루즈 셔틀 리무진')) && !vehicle.car_type.includes('스테이하롱 셔틀 리무진 단독')) ? '인원수 입력' : '차량 및 인원수 입력'}
                                                        onChange={(e) => {
                                                            const inputValue = parseInt(e.target.value);
                                                            if (e.target.value === '' || inputValue >= 0) {
                                                                handleVehicleChange(vehicleIndex, 'count', inputValue || 0);
                                                            }
                                                        }}
                                                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-green-500 [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-auto [&::-webkit-inner-spin-button]:appearance-auto"
                                                        style={{ WebkitAppearance: 'auto' as any, MozAppearance: 'textfield' }}
                                                    />
                                                    {vehicle.car_type && (
                                                        <p className="mt-1 text-xs text-gray-500">
                                                            {((vehicle.car_type.includes('셔틀') || vehicle.car_type.includes('크루즈 셔틀 리무진')) && !vehicle.car_type.includes('스테이하롱 셔틀 리무진 단독'))
                                                                ? '💡 셔틀은 인원수로 저장됩니다'
                                                                : '💡 차량수로 저장됩니다'
                                                            }
                                                        </p>
                                                    )}
                                                </div>
                                            </div>

                                            {/* 차량타입별 스테이하롱 셔틀 안내 문구 */}
                                            {vehicle.car_type && vehicle.car_type.includes('스테이하롱 셔틀') && (
                                                <div className="mt-3 p-3 bg-blue-50 border border-blue-200 rounded-lg">
                                                    <p className="text-sm text-blue-800">
                                                        💡 <strong>좌석 배정 안내:</strong> 좌석도를 확인하시고 요청사항에 차량번호 좌석번호를 적어주시면 최대한 원하시는 좌석에 배정하도록 하겠습니다. ^^
                                                    </p>
                                                </div>
                                            )}
                                        </div>
                                    ))}

                                    {vehicleForm.length < 3 && (
                                        <button
                                            type="button"
                                            onClick={handleAddVehicle}
                                            className="w-full border-2 border-dashed border-green-300 rounded-lg p-4 text-green-600 hover:border-green-400 hover:text-green-700 transition-colors"
                                        >
                                            + 차량 추가 (최대 3개)
                                        </button>
                                    )}
                                </div>

                                {/* 특별 요청사항 */}
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">특별 요청사항</label>
                                    <textarea
                                        value={quoteForm.special_requests}
                                        onChange={(e) => setQuoteForm({ ...quoteForm, special_requests: e.target.value })}
                                        rows={3}
                                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500"
                                        placeholder="특별한 요청사항이 있으시면 입력해주세요..."
                                    />
                                </div>
                            </div>

                            {/* 제출 버튼 */}
                            <div className="flex justify-end space-x-4 mt-8">
                                <button
                                    type="button"
                                    onClick={() => router.back()}
                                    className="px-6 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors"
                                >
                                    취소
                                </button>
                                <button
                                    type="submit"
                                    disabled={loading}
                                    className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 transition-colors"
                                >
                                    {loading ? '저장 중...' : '다음'}
                                </button>
                            </div>
                        </form>
                    )}

                    {/* 예약 진행 단계 */}
                    {currentStep === 'reservation' && quote && (
                        <div className="bg-white rounded-xl shadow-lg p-8">
                            <h2 className="text-2xl font-bold text-gray-800 mb-6">🎯 2단계: 예약 진행</h2>

                            {/* 견적 정보 */}
                            <div className="bg-green-50 border border-green-200 rounded-lg p-4 mb-6">
                                <h3 className="font-semibold text-green-800 mb-2">✅ 가격 정보가 저장 되었습니다.  !</h3>
                                <div className="text-sm text-green-700">
                                    <p>명칭: <span className="font-semibold">{quote.title}</span></p>
                                    <p>이제 예약 정보를 입력해주세요.</p>
                                </div>
                            </div>

                            {/* 객실 정보 */}
                            {roomPriceInfo.length > 0 && (
                                <div className="mb-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
                                    <h4 className="text-sm font-medium text-blue-800 mb-3">🏨 객실 정보</h4>
                                    {roomPriceInfo.map((priceInfo, index) => {
                                        const roomData = roomsData.find(room => room.room_code === priceInfo.room_code);
                                        const totalGuests = roomData?.person_count || 0;
                                        return (
                                            <div key={index} className="bg-white p-3 rounded border mb-2">
                                                <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-1 text-sm">
                                                    <span className="text-gray-600">일정: <span className="font-medium text-gray-800">{priceInfo.schedule || '-'}</span></span>
                                                    <span className="text-gray-600">크루즈: <span className="font-medium text-gray-800">{priceInfo.cruise || '-'}</span></span>
                                                    <span className="text-gray-600">룸 타입: <span className="font-medium text-gray-800">{priceInfo.room_type || '-'}</span></span>
                                                    <span className="text-gray-600">결제: <span className="font-medium text-gray-800">{priceInfo.payment || '-'}</span></span>
                                                    <span className="text-gray-600">카테고리: <span className="font-medium text-gray-800">{priceInfo.room_category || '-'}</span></span>
                                                    <span className="text-gray-600">인원수: <span className="font-medium text-gray-800">{totalGuests}명</span></span>
                                                </div>
                                            </div>
                                        );
                                    })}
                                </div>
                            )}

                            {/* 차량 가격 정보 */}
                            {/* 차량 정보 */}
                            {carPriceInfo && (
                                <div className="mb-6 p-4 bg-green-50 rounded-lg border border-green-200">
                                    <h4 className="text-sm font-medium text-green-800 mb-3">🚗 차량 정보</h4>
                                    <div className="bg-white p-3 rounded border">
                                        <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-1 text-sm">
                                            <span className="text-gray-600">일정: <span className="font-medium text-gray-800">{carPriceInfo.schedule || '-'}</span></span>
                                            <span className="text-gray-600">크루즈: <span className="font-medium text-gray-800">{carPriceInfo.cruise || '-'}</span></span>
                                            <span className="text-gray-600">차량 타입: <span className="font-medium text-gray-800">{carPriceInfo.car_type || '-'}</span></span>
                                            <span className="text-gray-600">카테고리: <span className="font-medium text-gray-800">{carPriceInfo.car_category || '-'}</span></span>
                                        </div>
                                    </div>
                                </div>
                            )}

                            {/* 예약 세부 정보 입력 */}
                            <div className="space-y-6">
                                <div>
                                    <h3 className="text-lg font-semibold text-gray-800 mb-4">🚗 차량 관련 정보</h3>
                                    {/* 스하차량 버튼 - 차량 정보 섹션 상단에 추가 */}
                                    <div className="mb-4 flex justify-between items-center">
                                        <h4 className="text-sm font-medium text-gray-700">차량 예약 정보</h4>
                                        <button
                                            type="button"
                                            onClick={() => setIsShtCarModalOpen(true)}
                                            className="px-3 py-1 bg-blue-50 text-blue-600 rounded border border-blue-200 text-sm hover:bg-blue-100 transition-colors"
                                        >
                                            🚐 스하차량 좌석도 보기
                                        </button>
                                    </div>
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                                        <div>
                                            <label className="block text-sm font-medium text-gray-700 mb-2">픽업 장소</label>
                                            <input
                                                type="text"
                                                value={reservationForm.pickup_location}
                                                onChange={(e) => setReservationForm({ ...reservationForm, pickup_location: e.target.value })}
                                                placeholder="픽업 장소를 입력하세요"
                                                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
                                            />
                                        </div>
                                        <div>
                                            <label className="block text-sm font-medium text-gray-700 mb-2">드롭오프 장소</label>
                                            <input
                                                type="text"
                                                value={reservationForm.dropoff_location}
                                                onChange={(e) => setReservationForm({ ...reservationForm, dropoff_location: e.target.value })}
                                                placeholder="드롭오프 장소를 입력하세요"
                                                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
                                            />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {/* 예약 완료 버튼 */}
                            <div className="flex justify-end space-x-4 mt-8">
                                <button
                                    type="button"
                                    onClick={() => setCurrentStep('quote')}
                                    className="px-6 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors"
                                >
                                    이전 단계
                                </button>
                                <button
                                    onClick={handleReservationSubmit}
                                    disabled={loading}
                                    className="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:opacity-50 transition-colors"
                                >
                                    {loading ? '예약 중...' : '예약 완료'}
                                </button>
                            </div>
                        </div>
                    )}
                </div>
            </div>

            {/* SHT 차량 좌석도 모달 */}
            {isShtCarModalOpen && (
                <ShtCarSeatMap
                    isOpen={isShtCarModalOpen}
                    onClose={() => setIsShtCarModalOpen(false)}
                    usageDate={quoteForm.checkin} // 체크인 날짜를 사용일로 전달
                />
            )}
        </div>
    );
}

export default function DirectBookingCruisePage() {
    return (
        <Suspense fallback={<div className="flex justify-center items-center h-64">로딩 중...</div>}>
            <DirectBookingCruiseContent />
        </Suspense>
    );
}
