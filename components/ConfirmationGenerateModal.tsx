'use client';
import { useEffect, useState } from 'react';
import supabase from '@/lib/supabase';

interface ReservationDetail {
    reservation_id: string;
    service_type: string;
    service_details: any;
    amount: number;
    status: string;
    price_code?: string;
    price_option?: string;
    all_service_types?: string[];
    priceDetail?: any;
}

interface QuoteData {
    quote_id: string;
    title: string;
    user_name: string;
    user_email: string;
    user_phone: string;
    total_price: number;
    payment_status: string;
    created_at: string;
    reservations: ReservationDetail[];
}

interface ConfirmationGenerateModalProps {
    isOpen: boolean;
    onClose: () => void;
    quoteId: string;
}

export default function ConfirmationGenerateModal({ isOpen, onClose, quoteId }: ConfirmationGenerateModalProps) {
    const [quoteData, setQuoteData] = useState<QuoteData | null>(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    // ESC 키로 모달 닫기 지원
    useEffect(() => {
        if (!isOpen) return;
        const onKey = (e: KeyboardEvent) => {
            if (e.key === 'Escape') onClose();
        };
        window.addEventListener('keydown', onKey);
        return () => window.removeEventListener('keydown', onKey);
    }, [isOpen, onClose]);

    useEffect(() => {
        // 모달이 처음 열릴 때만 데이터 로드 (isOpen이 true로 변경될 때 1회)
        if (!isOpen) return;
        if (!quoteId) {
            setError('올바르지 않은 접근입니다.');
            setQuoteData(null);
            return;
        }
        loadQuoteData(quoteId);
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [isOpen]);

    const loadQuoteData = async (qid: string) => {
        try {
            setLoading(true);
            setError(null);

            const [quoteResult, quoteItemResult, reservationsResult] = await Promise.all([
                supabase.from('quote').select('*').eq('id', qid).single(),
                supabase.from('quote_item').select('*').eq('quote_id', qid),
                supabase.from('reservation').select('*').eq('re_quote_id', qid),
            ]);

            if (quoteResult.error || !quoteResult.data) {
                console.error('견적 조회 실패:', quoteResult.error);
                setError('예약 정보를 찾을 수 없습니다. 견적 번호를 확인해 주세요.');
                setQuoteData(null);
                return;
            }

            const quote = quoteResult.data as any;
            const quoteItems = (quoteItemResult.data as any[]) || [];
            const reservations = (reservationsResult.data as any[]) || [];

            const userResult = await supabase
                .from('users')
                .select('name, email, phone_number')
                .eq('id', quote.user_id)
                .single();
            const user = userResult.data as any;

            const reservationIds = reservations.map((r: any) => r.re_id);
            const [
                cruiseResult,
                airportResult,
                hotelResult,
                rentcarResult,
                tourResult,
                carShtResult,
                cruiseCarResult,
            ] = await Promise.all([
                reservationIds.length > 0
                    ? supabase.from('reservation_cruise').select('*').in('reservation_id', reservationIds)
                    : Promise.resolve({ data: [] }),
                reservationIds.length > 0
                    ? supabase.from('reservation_airport').select('*').in('reservation_id', reservationIds)
                    : Promise.resolve({ data: [] }),
                reservationIds.length > 0
                    ? supabase.from('reservation_hotel').select('*').in('reservation_id', reservationIds)
                    : Promise.resolve({ data: [] }),
                reservationIds.length > 0
                    ? supabase.from('reservation_rentcar').select('*').in('reservation_id', reservationIds)
                    : Promise.resolve({ data: [] }),
                reservationIds.length > 0
                    ? supabase.from('reservation_tour').select('*').in('reservation_id', reservationIds)
                    : Promise.resolve({ data: [] }),
                reservationIds.length > 0
                    ? supabase.from('reservation_car_sht').select('*').in('reservation_id', reservationIds)
                    : Promise.resolve({ data: [] }),
                reservationIds.length > 0
                    ? supabase.from('reservation_cruise_car').select('*').in('reservation_id', reservationIds)
                    : Promise.resolve({ data: [] }),
            ]);

            const cruiseDetails = (cruiseResult.data as any[]) || [];
            const airportDetails = (airportResult.data as any[]) || [];
            const hotelDetails = (hotelResult.data as any[]) || [];
            const rentcarDetails = (rentcarResult.data as any[]) || [];
            const tourDetails = (tourResult.data as any[]) || [];
            const carDetails = (carShtResult.data as any[]) || [];
            const cruiseCarDetails = (cruiseCarResult.data as any[]) || [];

            // 크루즈 차량(car) 예약 상세에 대해 car, car_price 정보 병합
            let cruiseCarMergedDetails: any[] = [];
            if (cruiseCarDetails.length > 0) {
                const carPriceCodes = cruiseCarDetails.map((c: any) => c.car_price_code).filter(Boolean);
                const { data: carPriceData } = carPriceCodes.length > 0
                    ? await supabase.from('car_price').select('*').in('car_code', carPriceCodes)
                    : { data: [] as any[] };
                const { data: carData } = carPriceCodes.length > 0
                    ? await supabase.from('car').select('*').in('car_code', carPriceCodes)
                    : { data: [] as any[] };
                cruiseCarMergedDetails = cruiseCarDetails.map((detail: any) => {
                    const priceInfo = (carPriceData || []).find((p: any) => p.car_code === detail.car_price_code) || {};
                    const carInfo = (carData || []).find((c: any) => c.car_code === detail.car_price_code) || {};
                    const shtDetail = (carDetails || []).find((s: any) => s.reservation_id === detail.reservation_id) || null;
                    return { ...detail, priceInfo, carInfo, shtDetail };
                });
            }

            const pickAmount = (type: string, detail: any): number => {
                if (!detail) return 0;
                const amountFields = ['car_total_price', 'room_total_price', 'total_price', 'unit_price', 'price', 'amount'];
                for (const field of amountFields) {
                    const value = detail[field];
                    if (typeof value === 'number' && !isNaN(value) && value > 0) return value;
                }
                return 0;
            };

            const resStatusMap = new Map<string, string>();
            reservations.forEach((r: any) => resStatusMap.set(r.re_id, r.re_status || 'pending'));

            const detailMap: Record<string, any[]> = {
                cruise: cruiseDetails,
                airport: airportDetails,
                hotel: hotelDetails,
                rentcar: rentcarDetails,
                tour: tourDetails,
                car: cruiseCarMergedDetails,
            };
            const idxMap = new Map<string, number>();

            const normalizeType = (t: string) => (t === 'room' ? 'cruise' : t);
            const priceCodeFieldByType: Record<string, string | undefined> = {
                cruise: 'room_price_code',
                airport: 'airport_price_code',
                hotel: 'hotel_price_code',
                rentcar: 'rentcar_price_code',
                tour: 'tour_price_code',
                car: 'car_price_code',
            };
            const optionFieldsByType: Record<string, string[]> = {
                cruise: ['room_type'],
                airport: [],
                hotel: ['hotel_name', 'room_name', 'room_type'],
                rentcar: [],
                tour: ['tour_name'],
                car: ['sht_category'],
            };

            // 고객 확인서와 동일한 다중 행 처리 로직으로 변경
            const processedReservations: ReservationDetail[] = [];

            // 각 서비스 타입별로 실제 예약 데이터를 모두 포함
            Object.entries(detailMap).forEach(([serviceType, details]) => {
                details.forEach((detail) => {
                    const priceCodeField = priceCodeFieldByType[serviceType];
                    const optionFields = optionFieldsByType[serviceType] || [];
                    const priceCode = priceCodeField ? detail[priceCodeField] || '' : '';

                    let priceOption = '';
                    for (const k of optionFields) {
                        if (detail[k]) {
                            priceOption = detail[k];
                            break;
                        }
                    }
                    if (!priceOption && serviceType === 'car' && detail.shtDetail?.sht_category) {
                        priceOption = detail.shtDetail.sht_category;
                    }

                    const parentStatus = resStatusMap.get(detail.reservation_id) || 'pending';

                    processedReservations.push({
                        reservation_id: detail.reservation_id || quote.id,
                        service_type: serviceType,
                        service_details: detail,
                        amount: pickAmount(serviceType, detail),
                        status: parentStatus,
                        price_code: priceCode,
                        price_option: priceOption,
                    });
                });
            });

            // 총 금액을 실제 예약 데이터 합계로 계산
            const calculatedTotal = processedReservations.reduce((sum, reservation) => sum + (reservation.amount || 0), 0);

            setQuoteData({
                quote_id: quote.id,
                title: quote.title || '제목 없음',
                user_name: user?.name || '알 수 없음',
                user_email: user?.email || '',
                user_phone: user?.phone_number || '',
                total_price: calculatedTotal || quote.total_price || 0, // 계산된 총액 우선 사용
                payment_status: quote.payment_status || 'pending',
                created_at: quote.created_at,
                reservations: processedReservations,
            });
        } catch (e) {
            console.error('견적 데이터 로드 실패:', e);
            setError('예약 정보를 불러오는 중 오류가 발생했습니다.');
            setQuoteData(null);
        } finally {
            setLoading(false);
        }
    };

    async function fetchPriceDetail(serviceType: string, priceCode: string) {
        if (!priceCode) return null;
        let table = '';
        let codeField = '';
        let selectFields: string[] = [];
        switch (serviceType) {
            case 'cruise':
            case 'room':
                table = 'room_price';
                codeField = 'room_code';
                selectFields = ['room_code', 'room_category', 'room_type', 'price', 'schedule', 'cruise', 'start_date', 'end_date', 'payment'];
                break;
            case 'car':
                table = 'car_price';
                codeField = 'car_code';
                selectFields = ['car_code', 'car_category', 'car_type', 'price', 'cruise', 'schedule', 'passenger_count'];
                break;
            case 'airport':
                table = 'airport_price';
                codeField = 'airport_code';
                selectFields = ['airport_code', 'airport_category', 'airport_route', 'airport_car_type', 'price'];
                break;
            case 'hotel':
                table = 'hotel_price';
                codeField = 'hotel_code';
                selectFields = ['hotel_code', 'hotel_name', 'room_name', 'room_type', 'price', 'start_date', 'end_date', 'weekday_type'];
                break;
            case 'rentcar':
                table = 'rent_price';
                codeField = 'rent_code';
                selectFields = ['rent_code', 'rent_type', 'rent_category', 'rent_route', 'rent_car_type', 'price'];
                break;
            case 'tour':
                table = 'tour_price';
                codeField = 'tour_code';
                selectFields = ['tour_code', 'tour_name', 'tour_capacity', 'tour_vehicle', 'tour_type', 'price'];
                break;
            default:
                return null;
        }
        const { data, error } = await supabase
            .from(table)
            .select(selectFields.join(','))
            .eq(codeField, priceCode)
            .single();
        if (error || !data) return null;
        return data;
    }

    // 가격 상세 fetch는 최초 데이터 로드 시에만 처리 (불필요한 반복 fetch 방지)
    // useEffect 제거 또는 quoteData가 최초 세팅될 때만 실행되도록 변경 필요

    const getServiceTypeName = (type: string) => {
        const typeNames: Record<string, string> = {
            cruise: '크루즈',
            airport: '공항 서비스',
            hotel: '호텔',
            rentcar: '렌터카',
            tour: '투어',
            car: '차량 서비스',
        };
        return typeNames[type] || type;
    };

    const formatDate = (dateString: string) =>
        new Date(dateString).toLocaleDateString('ko-KR', { year: 'numeric', month: 'long', day: 'numeric' });

    const printConfirmation = () => {
        // 모달 컨텐츠만 인쇄하도록 설정
        const modalContent = document.querySelector('.confirmation-modal-content');
        if (modalContent) {
            const printWindow = window.open('', '_blank');
            if (printWindow) {
                printWindow.document.write(`
                    <html>
                        <head>
                            <title>예약 확인서</title>
                            <style>
                                body { font-family: Arial, sans-serif; margin: 0; padding: 20px; }
                                table { border-collapse: collapse; width: 100%; }
                                td, th { border: 1px solid #ddd; padding: 8px; text-align: left; }
                                .text-center { text-align: center; }
                                .font-bold { font-weight: bold; }
                                .text-blue-600 { color: #2563eb; }
                                .text-gray-500 { color: #6b7280; }
                                .text-gray-600 { color: #4b5563; }
                                .text-gray-700 { color: #374151; }
                                .text-gray-900 { color: #111827; }
                                .bg-blue-50 { background-color: #eff6ff; }
                                .bg-gray-50 { background-color: #f9fafb; }
                                .bg-gray-100 { background-color: #f3f4f6; }
                                @media print { @page { margin: 1cm; } }
                            </style>
                        </head>
                        <body>
                            ${modalContent.innerHTML}
                        </body>
                    </html>
                `);
                printWindow.document.close();
                printWindow.focus();
                printWindow.print();
                printWindow.close();
            }
        } else {
            // 폴백: 전체 윈도우 인쇄
            window.print();
        }
    };

    const generatePDF = () => {
        // PDF 생성을 위해 새 창에서 확인서 페이지 열기
        const modalContent = document.querySelector('.confirmation-modal-content');
        if (modalContent) {
            const pdfWindow = window.open('', '_blank');
            if (pdfWindow) {
                pdfWindow.document.write(`
                    <html>
                        <head>
                            <title>예약 확인서 - ${quoteData?.user_name || ''}</title>
                            <style>
                                body { font-family: Arial, sans-serif; margin: 0; padding: 20px; }
                                table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
                                td, th { border: 1px solid #ddd; padding: 8px; text-align: left; }
                                .text-center { text-align: center; }
                                .font-bold { font-weight: bold; }
                                .text-blue-600 { color: #2563eb; }
                                .text-gray-500 { color: #6b7280; }
                                .text-gray-600 { color: #4b5563; }
                                .text-gray-700 { color: #374151; }
                                .text-gray-900 { color: #111827; }
                                .bg-blue-50 { background-color: #eff6ff; }
                                .bg-gray-50 { background-color: #f9fafb; }
                                .bg-gray-100 { background-color: #f3f4f6; }
                                @media print { @page { margin: 1cm; } }
                            </style>
                        </head>
                        <body>
                            ${modalContent.innerHTML}
                            <script>
                                window.onload = function() {
                                    window.print();
                                    setTimeout(function() { window.close(); }, 1000);
                                };
                            </script>
                        </body>
                    </html>
                `);
                pdfWindow.document.close();
            }
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center">
            {/* 배경 오버레이 */}
            <div
                className="absolute inset-0 bg-black/40 z-40"
                onClick={(e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    onClose();
                }}
            />

            {/* 모달 컨텐츠 래퍼 */}
            <div
                className="relative bg-white w-[92vw] sm:w-[88vw] md:w-[80vw] lg:w-[62vw] xl:w-[56vw] max-w-4xl max-h-[90vh] rounded-lg shadow-xl overflow-hidden flex flex-col z-50"
                onClick={e => e.stopPropagation()}
            >
                {/* 상단 바 */}
                <div className="bg-white shadow-sm border-b sticky top-0 z-10 print:hidden">
                    <div className="px-6 py-4 flex items-center justify-between">
                        <div className="flex items-center space-x-3">
                            <div className="text-xl">🌊</div>
                            <div>
                                <h1 className="text-base font-bold text-gray-900">스테이하롱 크루즈</h1>
                                <p className="text-xs text-gray-600">예약확인서 미리보기</p>
                            </div>
                        </div>
                        <div className="flex items-center space-x-2">
                            <button
                                type="button"
                                onClick={(e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    printConfirmation();
                                }}
                                className="px-3 py-2 bg-white text-blue-600 border border-blue-500 rounded hover:bg-blue-600 hover:text-white hover:shadow-md transition-all duration-200 text-sm"
                                aria-label="인쇄"
                            >
                                🖨️ 인쇄
                            </button>
                            <button
                                type="button"
                                onClick={(e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    generatePDF();
                                }}
                                className="px-3 py-2 border border-gray-300 text-gray-700 rounded hover:bg-gray-50 hover:border-gray-400 transition-all duration-200 text-sm"
                                aria-label="PDF"
                            >
                                📄 PDF
                            </button>
                            <button
                                type="button"
                                onClick={(e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    onClose();
                                }}
                                className="px-3 py-2 border border-gray-300 text-blue-600 rounded hover:bg-blue-600 hover:text-white hover:border-blue-600 transition-all duration-200 text-sm"
                                aria-label="닫기"
                            >
                                닫기
                            </button>
                        </div>
                    </div>
                </div>

                {/* 본문 스크롤 영역 */}
                <div className="overflow-y-auto p-6 bg-gray-50">
                    {loading ? (
                        <div className="flex justify-center items-center h-40">
                            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-500 mr-4" />
                            <p className="text-gray-600">예약 정보를 불러오는 중...</p>
                        </div>
                    ) : error || !quoteData ? (
                        <div className="text-center p-12">
                            <div className="text-5xl mb-4">❌</div>
                            <h2 className="text-xl font-bold text-gray-900 mb-2">오류</h2>
                            <p className="text-gray-600 mb-4">{error || '예약 정보를 찾을 수 없습니다.'}</p>
                            <button
                                onClick={(e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    onClose();
                                }}
                                className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 hover:shadow-md transition-all duration-200"
                            >
                                닫기
                            </button>
                        </div>
                    ) : (
                        <div className="max-w-4xl mx-auto">
                            <div className="bg-white rounded-lg shadow-lg overflow-hidden">
                                <div className="p-6 confirmation-modal-content" style={{ fontFamily: 'Arial, sans-serif' }}>
                                    {/* 헤더 */}
                                    <div className="text-center mb-6 border-b-2 border-blue-600 pb-4">
                                        <div className="flex justify-between items-center mb-2">
                                            <div className="text-left">
                                                <div className="text-xs text-gray-500">RESERVATION CONFIRMATION</div>
                                                <div className="text-base font-bold text-blue-600">스테이하롱 크루즈</div>
                                            </div>
                                            <div className="text-right">
                                                <div className="text-xs text-gray-500">확인서 번호</div>
                                                <div className="text-xs font-mono text-gray-700">{quoteData.quote_id.slice(-8).toUpperCase()}</div>
                                                <div className="text-xs text-gray-400 mt-1">발행일: {formatDate(new Date().toISOString())}</div>
                                            </div>
                                        </div>
                                        <h1 className="text-2xl font-bold text-gray-900 mb-1">🎯 예약 확인서</h1>
                                        <p className="text-sm text-gray-600">베트남 하롱베이 크루즈 여행 예약이 확정되었습니다</p>
                                    </div>

                                    {/* 고객 및 예약 정보 표 */}
                                    <div className="mb-6">
                                        <table className="w-full border border-gray-300">
                                            <tbody>
                                                <tr className="bg-blue-50">
                                                    <td className="border border-gray-300 px-3 py-2 font-semibold text-gray-700 w-1/4 text-center">예약자 정보</td>
                                                    <td className="border border-gray-300 px-3 py-2 font-semibold text-gray-700 w-1/4 text-center">예약 기본 정보</td>
                                                    <td className="border border-gray-300 px-3 py-2 font-semibold text-gray-700 w-1/4 text-center">예약 내역</td>
                                                    <td className="border border-gray-300 px-3 py-2 font-semibold text-gray-700 w-1/4 text-center">결제 정보</td>
                                                </tr>
                                                <tr>
                                                    <td className="border border-gray-300 px-3 py-2 align-top">
                                                        <div className="space-y-1 text-sm">
                                                            <div><span className="text-gray-500">성명:</span> <span className="font-semibold">{quoteData.user_name}</span></div>
                                                            <div><span className="text-gray-500">📧 이메일:</span> <span>{quoteData.user_email}</span></div>
                                                            <div><span className="text-gray-500">📞 연락처:</span> <span>{quoteData.user_phone}</span></div>
                                                        </div>
                                                    </td>
                                                    <td className="border border-gray-300 px-3 py-2 align-top">
                                                        <div className="space-y-1 text-sm">
                                                            <div><span className="text-gray-500">예약번호:</span> <span className="font-mono">{quoteData.quote_id}</span></div>
                                                            <div><span className="text-gray-500">예약명:</span> <span className="font-medium">{quoteData.title}</span></div>
                                                            <div><span className="text-gray-500">예약일:</span> <span>{formatDate(quoteData.created_at)}</span></div>
                                                        </div>
                                                    </td>
                                                    <td className="border border-gray-300 px-3 py-2 align-top">
                                                        <div className="space-y-1 text-sm">
                                                            <div><span className="text-gray-500">서비스 종류:</span></div>
                                                            <div className="flex flex-wrap gap-1 mt-1">
                                                                {quoteData.reservations && quoteData.reservations.length > 0 ? (
                                                                    Array.from(new Set(quoteData.reservations.map((r) => r.service_type))).map((type) => (
                                                                        <span key={type} className="inline-block px-2 py-1 bg-blue-50 text-blue-600 rounded text-xs font-medium">
                                                                            {getServiceTypeName(type)}
                                                                        </span>
                                                                    ))
                                                                ) : (
                                                                    <span className="text-gray-400">-</span>
                                                                )}
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td className="border border-gray-300 px-3 py-2 align-top">
                                                        <div className="space-y-1 text-sm">
                                                            <div><span className="text-gray-500">결제상태:</span> <span className="inline-block px-2 py-1 bg-green-100 text-green-800 text-xs font-medium rounded">✅ 결제완료</span></div>
                                                            <div><span className="text-gray-500">총 금액:</span> <span className="text-lg font-bold text-blue-600">{quoteData.total_price.toLocaleString()}동</span></div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    {/* 예약 서비스 상세 표 */}
                                    <div className="mb-6">
                                        <h3 className="text-base font-semibold text-gray-900 mb-3 flex items-center">
                                            <span className="w-1 h-5 bg-blue-600 mr-2" />예약 서비스 상세 내역
                                        </h3>
                                        <table className="w-full border border-gray-300">
                                            <thead>
                                                <tr className="bg-gray-100">
                                                    <th className="border border-gray-300 px-2 py-2 text-center text-xs font-semibold text-gray-700">No.</th>
                                                    <th className="border border-gray-300 px-2 py-2 text-center text-xs font-semibold text-gray-700">구분</th>
                                                    <th className="border border-gray-300 px-2 py-2 text-center text-xs font-semibold text-gray-700 w-1/6">상세 정보</th>
                                                    <th className="border border-gray-300 px-2 py-2 text-center text-xs font-semibold text-gray-700">가격 정보</th>
                                                    <th className="border border-gray-300 px-2 py-2 text-center text-xs font-semibold text-gray-700">금액</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {quoteData.reservations.map((reservation, index) => (
                                                    <tr key={`${reservation.reservation_id}-${reservation.service_type}-${index}`} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                                                        <td className="border border-gray-300 px-2 py-2 text-center font-medium text-gray-700">{index + 1}</td>
                                                        <td className="border border-gray-300 px-2 py-2 text-center align-top">
                                                            <div className="font-semibold text-gray-900 mb-1">
                                                                {Array.isArray(reservation.all_service_types) && reservation.all_service_types.length > 0 ? (
                                                                    <>
                                                                        {reservation.all_service_types.map((type) => (
                                                                            <span key={type} className="inline-block mr-2 px-2 py-1 bg-blue-50 text-blue-600 rounded text-xs font-medium">{getServiceTypeName(type)}</span>
                                                                        ))}
                                                                    </>
                                                                ) : (
                                                                    <span>{getServiceTypeName(reservation.service_type)}</span>
                                                                )}
                                                            </div>
                                                            <div className="text-[10px] text-gray-500 font-mono">ID: {reservation.reservation_id.slice(-8)}</div>
                                                        </td>
                                                        <td className="border border-gray-300 px-2 py-2 text-left align-top w-1/4">
                                                            {reservation.service_type === 'cruise' && reservation.service_details && (
                                                                <div className="space-y-1 text-xs">
                                                                    <div><span className="text-gray-500">체크인:</span> <span>{(reservation.service_details as any).checkin || '-'}</span></div>
                                                                    <div><span className="text-gray-500">투숙인원:</span> <span>{(reservation.service_details as any).guest_count || 0}명</span></div>
                                                                    <div><span className="text-gray-500">요청사항:</span> <span className="text-gray-600">{(reservation.service_details as any).request_note || '없음'}</span></div>
                                                                </div>
                                                            )}
                                                            {reservation.service_type === 'airport' && reservation.service_details && (
                                                                <div className="space-y-1 text-xs">
                                                                    <div><span className="text-gray-500">공항:</span> <span>{(reservation.service_details as any).ra_airport_location || '-'}</span></div>
                                                                    <div><span className="text-gray-500">일시:</span> <span>{(reservation.service_details as any).ra_datetime || '-'}</span></div>
                                                                    <div><span className="text-gray-500">항공편:</span> <span>{(reservation.service_details as any).ra_flight_number || '-'}</span></div>
                                                                    <div><span className="text-gray-500">인원:</span> <span>{(reservation.service_details as any).ra_passenger_count || 0}명</span></div>
                                                                </div>
                                                            )}
                                                            {reservation.service_type === 'hotel' && reservation.service_details && (
                                                                <div className="space-y-1 text-xs">
                                                                    <div><span className="text-gray-500">체크인:</span> <span>{(reservation.service_details as any).checkin_date || '-'}</span></div>
                                                                    <div><span className="text-gray-500">객실수:</span> <span>{(reservation.service_details as any).room_count || 0}실</span></div>
                                                                    <div><span className="text-gray-500">투숙인원:</span> <span>{(reservation.service_details as any).guest_count || 0}명</span></div>
                                                                    <div><span className="text-gray-500">호텔구분:</span> <span>{(reservation.service_details as any).hotel_category || '-'}</span></div>
                                                                    {Boolean((reservation.service_details as any).breakfast_service) && (
                                                                        <div><span className="text-gray-500">조식:</span> <span>{(reservation.service_details as any).breakfast_service}</span></div>
                                                                    )}
                                                                </div>
                                                            )}
                                                            {reservation.service_type === 'rentcar' && reservation.service_details && (
                                                                <div className="space-y-1 text-xs">
                                                                    <div><span className="text-gray-500">픽업:</span> <span>{(reservation.service_details as any).pickup_datetime || (reservation.service_details as any).pickup_date || '-'}</span></div>
                                                                    <div><span className="text-gray-500">대여일수:</span> <span>{(reservation.service_details as any).rental_days || 0}일</span></div>
                                                                    <div><span className="text-gray-500">기사수:</span> <span>{(reservation.service_details as any).driver_count || 0}명</span></div>
                                                                    <div><span className="text-gray-500">차량정보:</span> <span>{(reservation.service_details as any).car_type || '-'}</span></div>
                                                                </div>
                                                            )}
                                                            {reservation.service_type === 'tour' && reservation.service_details && (
                                                                <div className="space-y-1 text-xs">
                                                                    <div><span className="text-gray-500">투어일:</span> <span>{(reservation.service_details as any).tour_date || '-'}</span></div>
                                                                    <div><span className="text-gray-500">참가인원:</span> <span>{(reservation.service_details as any).participant_count || 0}명</span></div>
                                                                    <div><span className="text-gray-500">투어명:</span> <span>{(reservation.service_details as any).tour_name || '-'}</span></div>
                                                                    <div><span className="text-gray-500">픽업장소:</span> <span>{(reservation.service_details as any).pickup_location || '-'}</span></div>
                                                                </div>
                                                            )}
                                                            {reservation.service_type === 'car' && reservation.service_details && (
                                                                <div className="space-y-1 text-xs">
                                                                    <div><span className="text-gray-500">픽업일시:</span> <span className="font-medium">{(reservation.service_details as any).pickup_datetime || '-'}</span></div>
                                                                    <div><span className="text-gray-500">픽업/드랍:</span> <span className="font-medium">{(reservation.service_details as any).pickup_location || '-'} → {(reservation.service_details as any).dropoff_location || '-'}</span></div>
                                                                    <div><span className="text-gray-500">차량수:</span> <span>{(reservation.service_details as any).car_count ?? 0}대</span></div>
                                                                    <div><span className="text-gray-500">승객수:</span> <span>{(reservation.service_details as any).passenger_count ?? 0}명</span></div>
                                                                    {(reservation.service_details as any).request_note && (
                                                                        <div><span className="text-gray-500">요청사항:</span> <span className="text-gray-600">{(reservation.service_details as any).request_note}</span></div>
                                                                    )}
                                                                    {(reservation.service_details as any).shtDetail && (
                                                                        <div className="pt-1 border-t border-gray-200">
                                                                            <div className="text-gray-500">스테이하롱 차량 선택</div>
                                                                            <div><span className="text-gray-500">차량번호:</span> <span>{(reservation.service_details as any).shtDetail.vehicle_number || '-'}</span></div>
                                                                            <div><span className="text-gray-500">좌석수:</span> <span>{(reservation.service_details as any).shtDetail.seat_number || 0}석</span></div>
                                                                            <div><span className="text-gray-500">카테고리:</span> <span>{(reservation.service_details as any).shtDetail.sht_category || '-'}</span></div>
                                                                            {(reservation.service_details as any).shtDetail.usage_date && (
                                                                                <div><span className="text-gray-500">사용일시:</span> <span>{new Date((reservation.service_details as any).shtDetail.usage_date).toLocaleString('ko-KR')}</span></div>
                                                                            )}
                                                                        </div>
                                                                    )}
                                                                </div>
                                                            )}
                                                            {!reservation.service_details && (
                                                                <div className="text-sm text-gray-400">상세 정보가 없습니다</div>
                                                            )}
                                                        </td>
                                                        <td className="border border-gray-300 px-2 py-2 text-left align-top">
                                                            <div className="text-xs text-gray-700">
                                                                {reservation.priceDetail ? (
                                                                    <div className="mt-1 text-[11px] text-gray-600">
                                                                        {(() => {
                                                                            const order = ['schedule', 'room_category', 'cruise', 'room_type', 'payment'];
                                                                            const fieldMap: Record<string, string> = {
                                                                                price: '가격',
                                                                                schedule: '스케줄',
                                                                                cruise: '크루즈',
                                                                                start_date: '시작일',
                                                                                end_date: '종료일',
                                                                                room_category: '구분',
                                                                                room_type: '객실타입',
                                                                                payment: '결제방식',
                                                                                car_category: '구분',
                                                                                car_type: '차량타입',
                                                                                passenger_count: '승객수',
                                                                                airport_category: '구분',
                                                                                airport_route: '공항경로',
                                                                                airport_car_type: '공항차종',
                                                                                hotel_name: '호텔명',
                                                                                room_name: '룸명',
                                                                                weekday_type: '요일구분',
                                                                                rent_type: '렌트카타입',
                                                                                rent_category: '구분',
                                                                                rent_route: '렌트카경로',
                                                                                rent_car_type: '렌트카차종',
                                                                                tour_name: '투어명',
                                                                                tour_capacity: '정원',
                                                                                tour_vehicle: '차량',
                                                                                tour_type: '투어타입',
                                                                            };
                                                                            const filtered = Object.entries(reservation.priceDetail)
                                                                                .filter(([key]) => key !== 'price_code' && key !== 'price' && !key.includes('code') && key !== 'start_date' && key !== 'end_date');
                                                                            const sorted = [
                                                                                ...order.map((k) => filtered.find(([key]) => key === k)).filter(Boolean) as any[],
                                                                                ...filtered.filter(([key]) => !order.includes(key)),
                                                                            ];
                                                                            return sorted.map(([key, value]: any) => {
                                                                                const label = key.includes('category') ? '구분' : fieldMap[key] || key;
                                                                                return (
                                                                                    <div key={key}><span className="font-semibold">{label}:</span> {String(value)}</div>
                                                                                );
                                                                            });
                                                                        })()}
                                                                    </div>
                                                                ) : (
                                                                    <div className="text-xs text-gray-400">가격 상세 정보 없음</div>
                                                                )}
                                                                {reservation.price_option && (
                                                                    <div className="text-[11px] text-gray-500 mt-1">{reservation.price_option}</div>
                                                                )}
                                                            </div>
                                                        </td>
                                                        <td className="border border-gray-300 px-2 py-2 text-center">
                                                            <div className="text-base font-bold text-blue-600">
                                                                {(() => {
                                                                    const price = reservation.priceDetail?.price ?? 0;
                                                                    let count = 1;
                                                                    let unit = '명';
                                                                    if (reservation.service_type === 'cruise') {
                                                                        count = reservation.service_details?.guest_count ?? 1;
                                                                    } else if (reservation.service_type === 'airport') {
                                                                        count = reservation.service_details?.ra_passenger_count ?? 1;
                                                                    } else if (reservation.service_type === 'hotel') {
                                                                        count = reservation.service_details?.guest_count ?? 1;
                                                                    } else if (reservation.service_type === 'rentcar') {
                                                                        count = reservation.service_details?.driver_count ?? 1;
                                                                        unit = '대';
                                                                    } else if (reservation.service_type === 'car') {
                                                                        // 차량 서비스: 차량 대수 우선, 다음 승객수, 마지막으로 차량 스펙의 좌석수
                                                                        count =
                                                                            reservation.service_details?.car_count ??
                                                                            reservation.service_details?.passenger_count ??
                                                                            (reservation.service_details as any)?.shtDetail?.seat_number ??
                                                                            (reservation.service_details as any)?.carInfo?.seat_number ??
                                                                            1;
                                                                        unit = '대';
                                                                    } else if (reservation.service_type === 'tour') {
                                                                        count = reservation.service_details?.participant_count ?? 1;
                                                                    }
                                                                    return (
                                                                        <>
                                                                            <span className="text-[11px] text-gray-500 block mb-1">{`${price.toLocaleString()} × ${count}${unit} =`}</span>
                                                                            {`${reservation.amount.toLocaleString()}동`}
                                                                        </>
                                                                    );
                                                                })()}
                                                            </div>
                                                        </td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                            <tfoot>
                                                <tr className="bg-blue-50">
                                                    <td colSpan={5} className="border border-gray-300 px-3 py-4 text-right">
                                                        <div className="text-base font-semibold text-gray-700">
                                                            총 결제 금액 : <span className="text-xl font-bold text-blue-600 ml-2">{quoteData.total_price.toLocaleString()}<span className="text-sm font-normal text-gray-500 ml-1">동</span></span>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>

                                    {/* 안내 섹션들 (간단화) */}
                                    <div className="mb-6">
                                        <h3 className="text-base font-semibold text-gray-900 mb-3 flex items-center"><span className="w-1 h-5 bg-orange-500 mr-2" />여행 준비사항 및 중요 안내</h3>
                                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                            <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
                                                <h4 className="font-semibold text-blue-800 mb-2 flex items-center"><span className="mr-2">📋</span>여행 준비물</h4>
                                                <ul className="text-xs text-blue-700 space-y-1">
                                                    <li>• 여권 (유효기간 6개월 이상)</li>
                                                    <li>• 본 예약확인서 출력본</li>
                                                    <li>• 여행자보험 가입 권장</li>
                                                    <li>• 개인 상비약 및 세면용품</li>
                                                    <li>• 편안한 복장 및 운동화</li>
                                                </ul>
                                            </div>
                                            <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3">
                                                <h4 className="font-semibold text-yellow-800 mb-2 flex items-center"><span className="mr-2">⚠️</span>주의사항</h4>
                                                <ul className="text-xs text-yellow-700 space-y-1">
                                                    <li>• 여행 3일 전까지 변경/취소 가능</li>
                                                    <li>• 날씨에 따라 일정 변경 가능</li>
                                                    <li>• 출발 30분 전 집결 완료</li>
                                                    <li>• 안전수칙 준수 필수</li>
                                                    <li>• 귀중품 분실 주의</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>

                                    {/* 고객센터 */}
                                    <div className="bg-gray-50 border border-gray-200 rounded-lg p-4 mb-6">
                                        <h3 className="text-base font-semibold text-gray-900 mb-3 flex items-center"><span className="w-1 h-5 bg-red-500 mr-2" />긴급연락처 및 고객지원</h3>
                                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                                            <div className="text-center">
                                                <div className="text-xl mb-1">📞</div>
                                                <div className="font-semibold text-gray-700">고객센터</div>
                                                <div className="text-xs text-gray-600">평일 09:00-18:00</div>
                                                <div className="font-mono text-blue-600">07045545185</div>
                                            </div>
                                            <div className="text-center">
                                                <div className="text-xl mb-1">🚨</div>
                                                <div className="font-semibold text-gray-700">24시간 긴급연락</div>
                                                <div className="text-xs text-gray-600">여행 중 응급상황</div>
                                                <div className="font-mono text-red-600">07045545185</div>
                                            </div>
                                            <div className="text-center">
                                                <div className="text-xl mb-1">📧</div>
                                                <div className="font-semibold text-gray-700">이메일 문의</div>
                                                <div className="text-xs text-gray-600">24시간 접수</div>
                                                <div className="text-blue-600">stayhalong@gmail.com</div>
                                            </div>
                                        </div>
                                    </div>

                                    {/* 푸터 */}
                                    <div className="text-center text-xs text-gray-500 border-t-2 border-blue-600 pt-4">
                                        <div className="mb-3">
                                            <div className="text-base font-bold text-blue-600 mb-1">🌊 스테이하롱 트레블과 함께하는 특별한 여행 🌊</div>
                                            <p className="text-gray-600">베트남 하롱베이에서 잊지 못할 추억을 만들어보세요!</p>
                                        </div>
                                        <div className="bg-blue-50 rounded-lg p-3 text-center">
                                            <div className="font-medium text-gray-700 mb-1">
                                                <span className="text-blue-600">🏢 스테이하롱 트레블</span> |
                                                <span className="text-gray-600"> 하롱베이 상주 한국인 베트남 전문 여행사</span>
                                            </div>
                                            <div className="text-[11px] text-gray-500 space-y-1">
                                                <div>📍 상호 : CONG TY TENPER COMMUNICATIONS</div>
                                                <div>📍 주소 : PHUONG YET KIEU, THANH PHO HA LONG</div>
                                                <div>📧 stayhalong@gmail.com | ☎️ 07045545185 | 🌐 <a href="https://cafe.naver.com/stayhalong" target="_blank" rel="noopener noreferrer" className="text-blue-600 underline">https://cafe.naver.com/stayhalong</a></div>
                                                <div>🕒 운영시간: 평일 09:00-24:00 (토요일 09:00-15:00, 일요일/공휴일 비상업무)</div>
                                                <div className="text-gray-400 mt-1">© 2024 StayHalong Travel. All rights reserved.</div>
                                            </div>
                                        </div>
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

