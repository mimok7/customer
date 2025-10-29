'use client';

import React, { useCallback, useEffect, useMemo, useState } from 'react';
import supabase from '@/lib/supabase';

type Props = {
    quoteId: string;
    onSuccess?: (payload: { itemId: string; serviceRefId: string }) => void;
};

export default function HotelFormLite({ quoteId, onSuccess }: Props) {
    const [loading, setLoading] = useState(false);

    const [hotelNameOptions, setHotelNameOptions] = useState<string[]>([]);
    const [roomNameOptions, setRoomNameOptions] = useState<string[]>([]);
    const [roomTypeOptions, setRoomTypeOptions] = useState<string[]>([]);
    const [filteredHotels, setFilteredHotels] = useState<any[]>([]);

    const [selectedHotelName, setSelectedHotelName] = useState('');
    const [selectedRoomName, setSelectedRoomName] = useState('');
    const [selectedRoomType, setSelectedRoomType] = useState('');
    const [selectedHotel, setSelectedHotel] = useState<any>(null);
    const [selectedHotelCode, setSelectedHotelCode] = useState('');

    const [formData, setFormData] = useState({
        checkin_date: '',
        checkout_date: '',
        special_requests: ''
    });

    const getWeekdayFromDate = useCallback((dateString: string) => {
        const date = new Date(dateString);
        const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
        return weekdays[date.getDay()];
    }, []);

    const loadHotelNameOptions = useCallback(async () => {
        try {
            const checkinWeekday = getWeekdayFromDate(formData.checkin_date);
            const { data, error } = await supabase
                .from('hotel_price')
                .select('hotel_name')
                .lte('start_date', formData.checkin_date)
                .gte('end_date', formData.checkout_date)
                .like('weekday_type', `%${checkinWeekday}%`)
                .order('hotel_name');
            if (error) throw error;
            const uniqueHotelNames = [...new Set((data || []).map((item: any) => item.hotel_name).filter(Boolean))] as string[];
            setHotelNameOptions(uniqueHotelNames);
        } catch (e) {
            console.error('호텔명 옵션 로드 실패:', e);
        }
    }, [formData.checkin_date, formData.checkout_date, getWeekdayFromDate]);

    const loadRoomNameOptions = useCallback(async (hotelName: string) => {
        try {
            const checkinWeekday = getWeekdayFromDate(formData.checkin_date);
            const { data, error } = await supabase
                .from('hotel_price')
                .select('room_name')
                .eq('hotel_name', hotelName)
                .lte('start_date', formData.checkin_date)
                .gte('end_date', formData.checkout_date)
                .like('weekday_type', `%${checkinWeekday}%`)
                .order('room_name');
            if (error) throw error;
            const uniqueRoomNames = [...new Set((data || []).map((item: any) => item.room_name).filter(Boolean))] as string[];
            setRoomNameOptions(uniqueRoomNames);
        } catch (e) {
            console.error('객실명 옵션 로드 실패:', e);
        }
    }, [formData.checkin_date, formData.checkout_date, getWeekdayFromDate]);

    const loadRoomTypeOptions = useCallback(async (hotelName: string, roomName: string) => {
        try {
            const checkinWeekday = getWeekdayFromDate(formData.checkin_date);
            const { data, error } = await supabase
                .from('hotel_price')
                .select('room_type')
                .eq('hotel_name', hotelName)
                .eq('room_name', roomName)
                .lte('start_date', formData.checkin_date)
                .gte('end_date', formData.checkout_date)
                .like('weekday_type', `%${checkinWeekday}%`)
                .order('room_type');
            if (error) throw error;
            const uniqueRoomTypes = [...new Set((data || []).map((item: any) => item.room_type).filter(Boolean))] as string[];
            setRoomTypeOptions(uniqueRoomTypes);
        } catch (e) {
            console.error('객실 타입 옵션 로드 실패:', e);
        }
    }, [formData.checkin_date, formData.checkout_date, getWeekdayFromDate]);

    const searchFinalHotels = useCallback(async () => {
        try {
            const checkinWeekday = getWeekdayFromDate(formData.checkin_date);
            const { data, error } = await supabase
                .from('hotel_price')
                .select('hotel_code, hotel_name, room_name, room_type, price, weekday_type')
                .eq('hotel_name', selectedHotelName)
                .eq('room_name', selectedRoomName)
                .eq('room_type', selectedRoomType)
                .lte('start_date', formData.checkin_date)
                .gte('end_date', formData.checkout_date)
                .like('weekday_type', `%${checkinWeekday}%`)
                .order('hotel_code');
            if (error) throw error;
            const filtered = (data || []).filter((h: any) => h.weekday_type && h.weekday_type.includes(checkinWeekday));
            setFilteredHotels(filtered);
            if (filtered.length > 0) {
                setSelectedHotel(filtered[0]);
                setSelectedHotelCode(filtered[0].hotel_code);
            } else {
                setSelectedHotel(null);
                setSelectedHotelCode('');
            }
        } catch (e) {
            console.error('최종 호텔 검색 실패:', e);
            setFilteredHotels([]);
            setSelectedHotel(null);
            setSelectedHotelCode('');
        }
    }, [formData.checkin_date, formData.checkout_date, selectedHotelName, selectedRoomName, selectedRoomType, getWeekdayFromDate]);

    // 의존 체인
    useEffect(() => {
        if (formData.checkin_date && formData.checkout_date) {
            loadHotelNameOptions();
        } else {
            setHotelNameOptions([]);
            setSelectedHotelName('');
        }
    }, [formData.checkin_date, formData.checkout_date, loadHotelNameOptions]);

    useEffect(() => {
        if (selectedHotelName && formData.checkin_date && formData.checkout_date) {
            loadRoomNameOptions(selectedHotelName);
        } else {
            setRoomNameOptions([]);
            setSelectedRoomName('');
        }
    }, [selectedHotelName, formData.checkin_date, formData.checkout_date, loadRoomNameOptions]);

    useEffect(() => {
        if (selectedHotelName && selectedRoomName && formData.checkin_date && formData.checkout_date) {
            loadRoomTypeOptions(selectedHotelName, selectedRoomName);
        } else {
            setRoomTypeOptions([]);
            setSelectedRoomType('');
        }
    }, [selectedHotelName, selectedRoomName, formData.checkin_date, formData.checkout_date, loadRoomTypeOptions]);

    useEffect(() => {
        if (selectedHotelName && selectedRoomName && selectedRoomType && formData.checkin_date && formData.checkout_date) {
            searchFinalHotels();
        } else {
            setFilteredHotels([]);
            setSelectedHotel(null);
            setSelectedHotelCode('');
        }
    }, [selectedHotelName, selectedRoomName, selectedRoomType, formData.checkin_date, formData.checkout_date, searchFinalHotels]);

    const isFormValid = useMemo(() => !!(formData.checkin_date && formData.checkout_date && selectedHotel), [formData.checkin_date, formData.checkout_date, selectedHotel]);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!quoteId) return alert('견적 ID가 필요합니다.');
        if (!isFormValid) return;
        setLoading(true);
        try {
            const hotelData = {
                hotel_code: selectedHotel.hotel_code,
                checkin_date: formData.checkin_date,
                checkout_date: formData.checkout_date,
                base_price: 0,
                ...(formData.special_requests && { special_requests: formData.special_requests })
            };
            const { data: hotelServiceData, error: hotelError } = await supabase
                .from('hotel')
                .insert([hotelData])
                .select()
                .single();
            if (hotelError || !hotelServiceData?.id) throw hotelError || new Error('호텔 서비스 생성 실패');

            const unit = parseInt(selectedHotel.price) || 0;
            const { data: itemData, error: itemError } = await supabase
                .from('quote_item')
                .insert({
                    quote_id: quoteId,
                    service_type: 'hotel',
                    service_ref_id: hotelServiceData.id,
                    quantity: 1,
                    unit_price: unit,
                    total_price: unit,
                    usage_date: formData.checkin_date || null
                })
                .select()
                .single();
            if (itemError || !itemData?.id) throw itemError || new Error('견적 아이템 생성 실패');

            onSuccess?.({ itemId: itemData.id, serviceRefId: hotelServiceData.id });
            alert('호텔이 견적에 추가되었습니다!');
        } catch (err: any) {
            console.error('호텔 생성 오류:', err);
            alert(`오류가 발생했습니다: ${err?.message || '알 수 없는 오류'}`);
        } finally {
            setLoading(false);
        }
    };

    return (
        <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm border border-gray-200 p-4">
            <h2 className="text-lg font-semibold text-gray-800 mb-4">호텔 정보 입력</h2>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label className="block text-xs font-medium text-gray-700 mb-1">체크인 *</label>
                    <input
                        type="date"
                        value={formData.checkin_date}
                        onChange={(e) => setFormData({ ...formData, checkin_date: e.target.value })}
                        className="w-full p-2 border border-gray-300 rounded text-sm"
                        required
                    />
                </div>
                <div>
                    <label className="block text-xs font-medium text-gray-700 mb-1">체크아웃 *</label>
                    <input
                        type="date"
                        value={formData.checkout_date}
                        onChange={(e) => setFormData({ ...formData, checkout_date: e.target.value })}
                        min={formData.checkin_date}
                        className="w-full p-2 border border-gray-300 rounded text-sm"
                        required
                    />
                </div>
            </div>

            {hotelNameOptions.length > 0 && (
                <div className="mt-3">
                    <label className="block text-xs font-medium text-gray-700 mb-1">호텔명 *</label>
                    <select
                        value={selectedHotelName}
                        onChange={(e) => setSelectedHotelName(e.target.value)}
                        className="w-full p-2 border border-gray-300 rounded text-sm"
                        required
                    >
                        <option value="">호텔을 선택하세요</option>
                        {hotelNameOptions.map((hotel) => (
                            <option key={hotel} value={hotel}>{hotel}</option>
                        ))}
                    </select>
                </div>
            )}

            {selectedHotelName && roomNameOptions.length > 0 && (
                <div className="mt-3">
                    <label className="block text-xs font-medium text-gray-700 mb-1">객실명 *</label>
                    <select
                        value={selectedRoomName}
                        onChange={(e) => setSelectedRoomName(e.target.value)}
                        className="w-full p-2 border border-gray-300 rounded text-sm"
                        required
                    >
                        <option value="">객실을 선택하세요</option>
                        {roomNameOptions.map((room) => (
                            <option key={room} value={room}>{room}</option>
                        ))}
                    </select>
                </div>
            )}

            {selectedHotelName && selectedRoomName && roomTypeOptions.length > 0 && (
                <div className="mt-3">
                    <label className="block text-xs font-medium text-gray-700 mb-1">객실 타입 *</label>
                    <select
                        value={selectedRoomType}
                        onChange={(e) => setSelectedRoomType(e.target.value)}
                        className="w-full p-2 border border-gray-300 rounded text-sm"
                        required
                    >
                        <option value="">객실 타입을 선택하세요</option>
                        {roomTypeOptions.map((type) => (
                            <option key={type} value={type}>{type}</option>
                        ))}
                    </select>
                    {filteredHotels.length > 0 && filteredHotels[0].weekday_type && (
                        <div className="mt-1 text-xs text-blue-600">적용 요일: {filteredHotels[0].weekday_type}</div>
                    )}
                </div>
            )}

            <div className="mt-3">
                <label className="block text-xs font-medium text-gray-700 mb-1">특별 요청사항</label>
                <textarea
                    value={formData.special_requests}
                    onChange={(e) => setFormData({ ...formData, special_requests: e.target.value })}
                    className="w-full p-2 border border-gray-300 rounded text-sm"
                    rows={3}
                    placeholder="특별한 요청사항이 있으시면 입력해주세요"
                />
            </div>

            {selectedHotelCode ? (
                <div className="mt-3 bg-yellow-50 border border-yellow-200 rounded p-2 text-xs text-yellow-800">
                    선택된 호텔 코드: <span className="font-mono">{selectedHotelCode}</span>
                </div>
            ) : null}

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
