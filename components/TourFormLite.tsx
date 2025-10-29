'use client';

import React, { useEffect, useMemo, useState } from 'react';
import supabase from '@/lib/supabase';

type Props = {
    quoteId: string;
    onSuccess?: (payload: { itemId: string; serviceRefId: string }) => void;
};

export default function TourFormLite({ quoteId, onSuccess }: Props) {
    const [loading, setLoading] = useState(false);

    // 옵션 리스트
    const [tourNameOptions, setTourNameOptions] = useState<string[]>([]);
    const [vehicleOptions, setVehicleOptions] = useState<string[]>([]);
    const [paymentOptions, setPaymentOptions] = useState<string[]>([]);
    const [categoryOptions, setCategoryOptions] = useState<string[]>([]);

    // 선택 값
    const [selectedTourName, setSelectedTourName] = useState('');
    const [selectedVehicle, setSelectedVehicle] = useState('');
    const [selectedPayment, setSelectedPayment] = useState('');
    const [selectedCategory, setSelectedCategory] = useState('');
    const [selectedTourCode, setSelectedTourCode] = useState('');

    const [formData, setFormData] = useState({
        tour_date: '',
        special_requests: ''
    });

    // 초기 투어명 옵션 로드
    useEffect(() => {
        const loadTourNameOptions = async () => {
            try {
                const { data, error } = await supabase
                    .from('tour_price')
                    .select('tour_name')
                    .order('tour_name');
                if (error) throw error;
                const uniqueTourNames = [...new Set((data || []).map((item: any) => item.tour_name))] as string[];
                setTourNameOptions(uniqueTourNames);
            } catch (e) {
                console.error('투어명 로드 실패:', e);
            }
        };
        loadTourNameOptions();
    }, []);

    // 선택에 따른 하위 옵션 로드
    useEffect(() => {
        const run = async () => {
            if (!selectedTourName) {
                setVehicleOptions([]);
                setSelectedVehicle('');
                return;
            }
            try {
                const { data, error } = await supabase
                    .from('tour_price')
                    .select('tour_vehicle')
                    .eq('tour_name', selectedTourName)
                    .order('tour_vehicle');
                if (error) throw error;
                const unique = [...new Set((data || []).map((d: any) => d.tour_vehicle))] as string[];
                setVehicleOptions(unique);
            } catch (e) {
                console.error('차량 옵션 로드 실패:', e);
            }
        };
        run();
    }, [selectedTourName]);

    useEffect(() => {
        const run = async () => {
            if (!selectedTourName || !selectedVehicle) {
                setPaymentOptions([]);
                setSelectedPayment('');
                return;
            }
            try {
                const { data, error } = await supabase
                    .from('tour_price')
                    .select('tour_type')
                    .eq('tour_name', selectedTourName)
                    .eq('tour_vehicle', selectedVehicle)
                    .order('tour_type');
                if (error) throw error;
                const unique = [...new Set((data || []).map((d: any) => d.tour_type))] as string[];
                setPaymentOptions(unique);
            } catch (e) {
                console.error('투어 타입 옵션 로드 실패:', e);
            }
        };
        run();
    }, [selectedTourName, selectedVehicle]);

    useEffect(() => {
        const run = async () => {
            if (!selectedTourName || !selectedVehicle || !selectedPayment) {
                setCategoryOptions([]);
                setSelectedCategory('');
                return;
            }
            try {
                const { data, error } = await supabase
                    .from('tour_price')
                    .select('tour_capacity')
                    .eq('tour_name', selectedTourName)
                    .eq('tour_vehicle', selectedVehicle)
                    .eq('tour_type', selectedPayment)
                    .order('tour_capacity');
                if (error) throw error;
                const unique = [...new Set((data || []).map((d: any) => d.tour_capacity.toString()))] as string[];
                setCategoryOptions(unique);
            } catch (e) {
                console.error('최대 참가자수 옵션 로드 실패:', e);
            }
        };
        run();
    }, [selectedTourName, selectedVehicle, selectedPayment]);

    // 4가지 조건이 모두 선택되면 tour_code 조회
    useEffect(() => {
        const run = async () => {
            if (!selectedTourName || !selectedVehicle || !selectedPayment || !selectedCategory) {
                setSelectedTourCode('');
                return;
            }
            try {
                const { data, error } = await supabase
                    .from('tour_price')
                    .select('tour_code')
                    .eq('tour_name', selectedTourName)
                    .eq('tour_vehicle', selectedVehicle)
                    .eq('tour_type', selectedPayment)
                    .eq('tour_capacity', parseInt(selectedCategory))
                    .single();
                if (error) throw error;
                setSelectedTourCode(data?.tour_code || '');
            } catch (e) {
                console.error('tour_code 조회 실패:', e);
                setSelectedTourCode('');
            }
        };
        run();
    }, [selectedTourName, selectedVehicle, selectedPayment, selectedCategory]);

    const isFormValid = useMemo(() => !!(selectedTourName && selectedVehicle && selectedPayment && selectedCategory && formData.tour_date), [selectedTourName, selectedVehicle, selectedPayment, selectedCategory, formData.tour_date]);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!quoteId) return alert('견적 ID가 필요합니다.');
        if (!isFormValid) return;
        setLoading(true);
        try {
            // tour_code 재확인
            const { data: codeRow, error: codeErr } = await supabase
                .from('tour_price')
                .select('tour_code')
                .eq('tour_name', selectedTourName)
                .eq('tour_vehicle', selectedVehicle)
                .eq('tour_type', selectedPayment)
                .eq('tour_capacity', parseInt(selectedCategory))
                .single();
            if (codeErr || !codeRow?.tour_code) throw codeErr || new Error('투어 코드 조회 실패');

            // 투어 서비스 생성
            const { data: tourServiceData, error: tourError } = await supabase
                .from('tour')
                .insert([
                    {
                        tour_code: codeRow.tour_code,
                        tour_date: formData.tour_date,
                        ...(formData.special_requests && { special_requests: formData.special_requests })
                    }
                ])
                .select()
                .single();
            if (tourError || !tourServiceData?.id) throw tourError || new Error('투어 서비스 생성 실패');

            // 견적 아이템 생성
            const { data: itemData, error: itemError } = await supabase
                .from('quote_item')
                .insert({
                    quote_id: quoteId,
                    service_type: 'tour',
                    service_ref_id: tourServiceData.id,
                    quantity: 1,
                    unit_price: 0,
                    total_price: 0,
                    usage_date: formData.tour_date || null
                })
                .select()
                .single();
            if (itemError || !itemData?.id) throw itemError || new Error('견적 아이템 생성 실패');

            // 성공 콜백 + 폼 초기화 유지
            onSuccess?.({ itemId: itemData.id, serviceRefId: tourServiceData.id });
            alert('투어가 견적에 추가되었습니다!');
        } catch (err: any) {
            console.error('투어 생성 오류:', err);
            alert(`오류가 발생했습니다: ${err?.message || '알 수 없는 오류'}`);
        } finally {
            setLoading(false);
        }
    };

    return (
        <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm border border-gray-200 p-4">
            <h2 className="text-lg font-semibold text-gray-800 mb-4">투어 정보 입력</h2>

            <div className="space-y-4">
                <div>
                    <label className="block text-xs font-medium text-gray-700 mb-1">투어명 *</label>
                    <select
                        value={selectedTourName}
                        onChange={(e) => setSelectedTourName(e.target.value)}
                        className="w-full p-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                        required
                    >
                        <option value="">투어명을 선택하세요</option>
                        {tourNameOptions.map((tour) => (
                            <option key={tour} value={tour}>{tour}</option>
                        ))}
                    </select>
                </div>

                {selectedTourName ? (
                    <div>
                        <label className="block text-xs font-medium text-gray-700 mb-1">차량 *</label>
                        <select
                            value={selectedVehicle}
                            onChange={(e) => setSelectedVehicle(e.target.value)}
                            className="w-full p-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                            required
                        >
                            <option value="">차량을 선택하세요</option>
                            {vehicleOptions.map((v) => (
                                <option key={v} value={v}>{v}</option>
                            ))}
                        </select>
                    </div>
                ) : null}

                {selectedTourName && selectedVehicle ? (
                    <div>
                        <label className="block text-xs font-medium text-gray-700 mb-1">투어 타입 *</label>
                        <select
                            value={selectedPayment}
                            onChange={(e) => setSelectedPayment(e.target.value)}
                            className="w-full p-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                            required
                        >
                            <option value="">투어 타입을 선택하세요</option>
                            {paymentOptions.map((p) => (
                                <option key={p} value={p}>{p}</option>
                            ))}
                        </select>
                    </div>
                ) : null}

                {selectedTourName && selectedVehicle && selectedPayment ? (
                    <div>
                        <label className="block text-xs font-medium text-gray-700 mb-1">최대 참가자수 *</label>
                        <select
                            value={selectedCategory}
                            onChange={(e) => setSelectedCategory(e.target.value)}
                            className="w-full p-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                            required
                        >
                            <option value="">최대 참가자수를 선택하세요</option>
                            {categoryOptions.map((c) => (
                                <option key={c} value={c}>{c}명</option>
                            ))}
                        </select>
                    </div>
                ) : null}

                <div>
                    <label className="block text-xs font-medium text-gray-700 mb-1">투어 날짜 *</label>
                    <input
                        type="date"
                        value={formData.tour_date}
                        onChange={(e) => setFormData({ ...formData, tour_date: e.target.value })}
                        className="w-full p-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                        required
                    />
                </div>

                <div>
                    <label className="block text-xs font-medium text-gray-700 mb-1">특별 요청사항</label>
                    <textarea
                        value={formData.special_requests}
                        onChange={(e) => setFormData({ ...formData, special_requests: e.target.value })}
                        className="w-full p-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
                        rows={3}
                        placeholder="특별한 요청사항이 있으시면 입력해주세요"
                    />
                </div>

                {selectedTourCode ? (
                    <div className="bg-yellow-50 border border-yellow-200 rounded p-2 text-xs text-yellow-800">
                        검색된 투어 코드: <span className="font-mono">{selectedTourCode}</span>
                    </div>
                ) : null}
            </div>

            <div className="flex justify-end gap-2 pt-4">
                <button
                    type="submit"
                    disabled={!isFormValid || loading}
                    className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:bg-gray-400 text-sm"
                >
                    {loading ? '처리 중...' : '견적에 추가'}
                </button>
            </div>
        </form>
    );
}
