'use client';

import React, { useState, useEffect } from 'react';
import { X, Car } from 'lucide-react';
import supabase from '@/lib/supabase';

interface SeatReservation {
    id: string;
    vehicle_number: string;
    seat_number: string;
    sht_category: string;
    usage_date: string;
    pickup_datetime?: string;
}

interface ShtCarSeatMapProps {
    isOpen: boolean;
    onClose: () => void;
    selectedDate?: Date;
    usageDate?: string;
    vehicleNumber?: string;
    onSeatSelect?: (seatInfo: { vehicle: string; seat: string; category: string }) => void;
}

export default function ShtCarSeatMap({
    isOpen,
    onClose,
    selectedDate,
    usageDate,
    vehicleNumber,
    onSeatSelect
}: ShtCarSeatMapProps) {
    const [selectedSeats, setSelectedSeats] = useState<string[]>([]); // 복수 선택 가능
    const [loading, setLoading] = useState(false);
    const [reservations, setReservations] = useState<SeatReservation[]>([]);
    const [currentVehicle, setCurrentVehicle] = useState('차량1'); // 기본 차량1
    const [currentDate, setCurrentDate] = useState(() => {
        if (usageDate) return usageDate;
        if (selectedDate) return selectedDate.toISOString().split('T')[0];
        return new Date().toISOString().split('T')[0];
    });
    const [category, setCategory] = useState<'pickup' | 'dropoff'>('pickup'); // 기본 픽업
    const [allData, setAllData] = useState<SeatReservation[]>([]);

    // 좌석 배치 정의
    const seatLayout = {
        driver: { id: 'DRIVER', x: 54, y: 82, label: 'D' },
        topRow: [
            { id: 'X', x: 116, y: 78, label: 'X', disabled: true },
            { id: 'C1', x: 168, y: 78, label: 'C1' }
        ],
        middleRows: [
            [
                { id: 'A1', x: 80, y: 144, label: 'A1' },
                { id: 'A2', x: 168, y: 144, label: 'A2' }
            ],
            [
                { id: 'A3', x: 80, y: 208, label: 'A3' },
                { id: 'A4', x: 168, y: 208, label: 'A4' }
            ],
            [
                { id: 'A5', x: 80, y: 272, label: 'A5' },
                { id: 'A6', x: 168, y: 272, label: 'A6' }
            ]
        ],
        bottomRow: [
            { id: 'B1', x: 80, y: 354, label: 'B1' },
            { id: 'B2', x: 132, y: 354, label: 'B2' },
            { id: 'B3', x: 184, y: 354, label: 'B3' }
        ]
    };

    const allSeats = [
        ...seatLayout.topRow.filter(s => !s.disabled).map(s => s.id),
        ...seatLayout.middleRows.flat().map(s => s.id),
        ...seatLayout.bottomRow.map(s => s.id)
    ];

    // 차량 목록 및 예약 정보 로드
    useEffect(() => {
        if (isOpen) {
            loadAllData();
        }
    }, [isOpen]);

    // 날짜/차량/카테고리 변경시 필터링
    useEffect(() => {
        if (allData.length > 0) {
            filterData();
        }
    }, [currentDate, currentVehicle, category, allData]);

    const loadAllData = async () => {
        setLoading(true);
        try {
            console.log('🔍 전체 데이터 로드 시작');

            // 모든 예약 정보 조회
            const { data, error } = await supabase
                .from('reservation_car_sht')
                .select('id, vehicle_number, seat_number, sht_category, usage_date, pickup_datetime')
                .not('vehicle_number', 'is', null)
                .order('usage_date', { ascending: true });

            if (error) {
                console.error('❌ Supabase 조회 오류:', error);
                throw error;
            }

            console.log('✅ 전체 데이터 로드 완료:', data?.length || 0, '건');
            setAllData(data as SeatReservation[] || []);
        } catch (error) {
            console.error('❌ 데이터 로드 오류:', error);
        } finally {
            setLoading(false);
        }
    };

    const filterData = () => {
        console.log('🔍 필터링 시작:', { currentDate, currentVehicle, category });

        // 날짜별로 필터링
        let dateFiltered = allData;
        if (currentDate) {
            dateFiltered = allData.filter(r => {
                // usage_date 확인 (timestamp)
                if (r.usage_date) {
                    const usageDate = new Date(r.usage_date).toISOString().split('T')[0];
                    if (usageDate === currentDate) return true;
                }
                // pickup_datetime 확인 (date)
                if (r.pickup_datetime) {
                    const pickupDate = typeof r.pickup_datetime === 'string'
                        ? r.pickup_datetime.split('T')[0]
                        : new Date(r.pickup_datetime).toISOString().split('T')[0];
                    if (pickupDate === currentDate) return true;
                }
                return false;
            });
        }

        console.log('📅 날짜 필터링 후:', dateFiltered.length, '건');

        // 차량 목록 추출
        const vehicleSet = new Set<string>();
        dateFiltered.forEach(r => {
            if (r.vehicle_number) vehicleSet.add(r.vehicle_number);
        });
        const vehicleList = Array.from(vehicleSet).sort();
        setVehicles(vehicleList);

        console.log('🚗 차량 목록:', vehicleList);

        // 차량 및 카테고리 필터링
        const filtered = dateFiltered.filter(r => {
            const matchVehicle = !currentVehicle || r.vehicle_number === currentVehicle;
            const matchCategory = category === 'all' ||
                (category === 'pickup' && r.sht_category?.toLowerCase() === 'pickup') ||
                (category === 'dropoff' && (r.sht_category?.toLowerCase() === 'dropoff' || r.sht_category?.toLowerCase() === 'drop-off'));
            return matchVehicle && matchCategory;
        });

        console.log('🎯 최종 필터링 결과:', filtered.length, '건');
        setReservations(filtered);
    };

    const getSeatStatus = (seatId: string) => {
        // 해당 좌석을 포함하는 예약 찾기
        const seatReservations = reservations.filter(r => {
            const seats = r.seat_number?.split(',').map(s => s.trim().toUpperCase()) || [];
            return seats.includes(seatId.toUpperCase()) || seats.includes('ALL');
        });

        if (seatReservations.length === 0) {
            return { reserved: false, category: null, count: 0 };
        }

        return {
            reserved: true,
            category: seatReservations[0].sht_category,
            count: seatReservations.length
        };
    };

    const handleSeatClick = (seatId: string, disabled?: boolean) => {
        if (!disabled && seatId !== 'DRIVER') {
            setSelectedSeat(seatId);
        }
    };

    const getSeatColor = (seatId: string, disabled?: boolean) => {
        if (seatId === 'DRIVER') return '#6a6a6a';
        if (disabled) return '#6a6a6a';

        const status = getSeatStatus(seatId);

        if (selectedSeat === seatId) return '#4ade80'; // 선택됨 - 초록색
        if (status.reserved) {
            if (status.count > 1) return '#f3d36b'; // 중복 예약 - 노란색
            if (status.category?.toLowerCase() === 'pickup') return '#ff6b6b'; // 픽업 - 빨간색
            if (status.category?.toLowerCase() === 'dropoff' || status.category?.toLowerCase() === 'drop-off') {
                return '#4dabf7'; // 드롭오프 - 파란색
            }
            return '#c86262'; // 기타 예약 - 어두운 빨간색
        }

        return '#8ecae6'; // 빈 좌석 - 연한 파란색
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div className="bg-white rounded-lg shadow-xl max-w-4xl w-full mx-4 max-h-[90vh] overflow-y-auto">
                <div className="flex items-center justify-between p-6 border-b">
                    <h2 className="text-xl font-semibold flex items-center gap-2">
                        <Car className="w-6 h-6 text-blue-600" />
                        스하차량 좌석 배치도
                    </h2>
                    <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-full">
                        <X className="w-6 h-6" />
                    </button>
                </div>

                {/* 필터 */}
                <div className="p-4 bg-gray-50 border-b">
                    {/* 데이터 통계 */}
                    {allData.length > 0 && (
                        <div className="mb-4 p-3 bg-blue-50 rounded-lg border border-blue-200">
                            <p className="text-sm text-blue-800">
                                📊 전체 예약: <strong>{allData.length}건</strong>
                                {currentDate && ` | 선택 날짜: ${currentDate}`}
                                {vehicles.length > 0 && ` | 차량: ${vehicles.length}대`}
                            </p>
                        </div>
                    )}

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                날짜 {vehicles.length === 0 && currentDate && <span className="text-red-500">(해당 날짜에 예약 없음)</span>}
                            </label>
                            <input
                                type="date"
                                value={currentDate}
                                onChange={(e) => setCurrentDate(e.target.value)}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                차량번호 {vehicles.length > 0 && <span className="text-green-600">({vehicles.length}대)</span>}
                            </label>
                            <select
                                value={currentVehicle}
                                onChange={(e) => setCurrentVehicle(e.target.value)}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                                disabled={vehicles.length === 0}
                            >
                                <option value="">전체 차량 ({vehicles.length}대)</option>
                                {vehicles.map(v => (
                                    <option key={v} value={v}>{v}</option>
                                ))}
                            </select>
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                카테고리 {reservations.length > 0 && <span className="text-blue-600">({reservations.length}건)</span>}
                            </label>
                            <select
                                value={category}
                                onChange={(e) => setCategory(e.target.value as 'all' | 'pickup' | 'dropoff')}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                            >
                                <option value="all">전체</option>
                                <option value="pickup">픽업</option>
                                <option value="dropoff">드롭오프</option>
                            </select>
                        </div>
                    </div>
                </div>

                {/* 좌석 배치도 */}
                <div className="p-6">
                    {loading ? (
                        <div className="flex items-center justify-center py-12">
                            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
                            <p className="ml-4 text-gray-600">데이터 로딩 중...</p>
                        </div>
                    ) : allData.length === 0 ? (
                        <div className="text-center py-12">
                            <p className="text-gray-500 mb-2">📭 예약 데이터가 없습니다.</p>
                            <p className="text-sm text-gray-400">reservation_car_sht 테이블에 데이터를 확인해주세요.</p>
                        </div>
                    ) : vehicles.length === 0 ? (
                        <div className="text-center py-12">
                            <p className="text-gray-500 mb-2">� 선택한 날짜 ({currentDate})에 예약된 차량이 없습니다.</p>
                            <p className="text-sm text-gray-400">다른 날짜를 선택해보세요.</p>
                            <p className="text-xs text-blue-500 mt-2">💡 전체 예약: {allData.length}건</p>
                        </div>
                    ) : (
                        <div className="relative">
                            {/* 예약 정보 표시 */}
                            <div className="mb-4 text-sm text-gray-600 text-center bg-yellow-50 p-3 rounded-lg">
                                <p className="font-semibold">📊 {currentDate} / {currentVehicle || `전체 차량 (${vehicles.length}대)`}</p>
                                <p className="text-xs mt-1">
                                    총 <strong className="text-blue-600">{reservations.length}건</strong>의 예약
                                    {category !== 'all' && ` (${category === 'pickup' ? '픽업' : '드롭오프'})`}
                                </p>
                            </div>
                            <svg viewBox="0 0 280 440" className="w-full max-w-md mx-auto">
                                {/* 차량 외곽 */}
                                <rect
                                    x="20"
                                    y="40"
                                    width="240"
                                    height="380"
                                    rx="20"
                                    fill="#f0f0f0"
                                    stroke="#333"
                                    strokeWidth="2"
                                />

                                {/* 운전석 */}
                                <g>
                                    <rect
                                        x={seatLayout.driver.x}
                                        y={seatLayout.driver.y}
                                        width="40"
                                        height="40"
                                        rx="8"
                                        fill={getSeatColor(seatLayout.driver.id)}
                                        stroke="#333"
                                        strokeWidth="1"
                                    />
                                    <text
                                        x={seatLayout.driver.x + 20}
                                        y={seatLayout.driver.y + 25}
                                        textAnchor="middle"
                                        fill="#fff"
                                        fontSize="12"
                                        fontWeight="bold"
                                    >
                                        {seatLayout.driver.label}
                                    </text>
                                </g>

                                {/* 상단 행 */}
                                {seatLayout.topRow.map(seat => (
                                    <g
                                        key={seat.id}
                                        onClick={() => handleSeatClick(seat.id, seat.disabled)}
                                        style={{ cursor: seat.disabled ? 'default' : 'pointer' }}
                                    >
                                        <rect
                                            x={seat.x}
                                            y={seat.y}
                                            width="40"
                                            height="40"
                                            rx="8"
                                            fill={getSeatColor(seat.id, seat.disabled)}
                                            stroke="#333"
                                            strokeWidth="1"
                                        />
                                        <text
                                            x={seat.x + 20}
                                            y={seat.y + 25}
                                            textAnchor="middle"
                                            fill="#fff"
                                            fontSize="12"
                                            fontWeight="bold"
                                        >
                                            {seat.label}
                                        </text>
                                    </g>
                                ))}

                                {/* 중간 행들 */}
                                {seatLayout.middleRows.map((row, rowIndex) => (
                                    <g key={rowIndex}>
                                        {row.map(seat => (
                                            <g
                                                key={seat.id}
                                                onClick={() => handleSeatClick(seat.id)}
                                                style={{ cursor: 'pointer' }}
                                            >
                                                <rect
                                                    x={seat.x}
                                                    y={seat.y}
                                                    width="40"
                                                    height="40"
                                                    rx="8"
                                                    fill={getSeatColor(seat.id)}
                                                    stroke="#333"
                                                    strokeWidth="1"
                                                />
                                                <text
                                                    x={seat.x + 20}
                                                    y={seat.y + 25}
                                                    textAnchor="middle"
                                                    fill="#fff"
                                                    fontSize="12"
                                                    fontWeight="bold"
                                                >
                                                    {seat.label}
                                                </text>
                                            </g>
                                        ))}
                                    </g>
                                ))}

                                {/* 하단 행 */}
                                {seatLayout.bottomRow.map(seat => (
                                    <g
                                        key={seat.id}
                                        onClick={() => handleSeatClick(seat.id)}
                                        style={{ cursor: 'pointer' }}
                                    >
                                        <rect
                                            x={seat.x}
                                            y={seat.y}
                                            width="40"
                                            height="40"
                                            rx="8"
                                            fill={getSeatColor(seat.id)}
                                            stroke="#333"
                                            strokeWidth="1"
                                        />
                                        <text
                                            x={seat.x + 20}
                                            y={seat.y + 25}
                                            textAnchor="middle"
                                            fill="#fff"
                                            fontSize="12"
                                            fontWeight="bold"
                                        >
                                            {seat.label}
                                        </text>
                                    </g>
                                ))}
                            </svg>

                            {/* 범례 */}
                            <div className="mt-6 flex flex-wrap gap-4 justify-center text-sm">
                                <div className="flex items-center gap-2">
                                    <div className="w-4 h-4 rounded" style={{ backgroundColor: '#8ecae6' }}></div>
                                    <span className="text-gray-700">빈 좌석</span>
                                </div>
                                <div className="flex items-center gap-2">
                                    <div className="w-4 h-4 rounded" style={{ backgroundColor: '#ff6b6b' }}></div>
                                    <span className="text-gray-700">픽업</span>
                                </div>
                                <div className="flex items-center gap-2">
                                    <div className="w-4 h-4 rounded" style={{ backgroundColor: '#4dabf7' }}></div>
                                    <span className="text-gray-700">드롭오프</span>
                                </div>
                                <div className="flex items-center gap-2">
                                    <div className="w-4 h-4 rounded" style={{ backgroundColor: '#f3d36b' }}></div>
                                    <span className="text-gray-700">중복 예약</span>
                                </div>
                                <div className="flex items-center gap-2">
                                    <div className="w-4 h-4 rounded" style={{ backgroundColor: '#4ade80' }}></div>
                                    <span className="text-gray-700">선택됨</span>
                                </div>
                            </div>
                        </div>
                    )}
                </div>

                {/* 선택된 좌석 정보 */}
                {selectedSeat && (
                    <div className="p-6 bg-green-50 border-t">
                        <h3 className="text-lg font-semibold text-gray-800 mb-2">
                            선택된 좌석: {selectedSeat}
                        </h3>
                        {(() => {
                            const status = getSeatStatus(selectedSeat);
                            if (status.reserved) {
                                return (
                                    <div className="text-sm space-y-1">
                                        <p className="text-red-600 font-semibold">⚠️ 이미 예약된 좌석입니다</p>
                                        <p className="text-gray-600">카테고리: {status.category}</p>
                                        {status.count > 1 && (
                                            <p className="text-yellow-600">중복 예약: {status.count}건</p>
                                        )}
                                    </div>
                                );
                            }
                            return (
                                <p className="text-sm text-gray-600">
                                    요청사항에 차량번호와 함께 "{selectedSeat}" 좌석을 원한다고 작성해주세요.
                                </p>
                            );
                        })()}
                    </div>
                )}

                {/* 안내 문구 */}
                <div className="p-4 bg-yellow-50 border-t">
                    <p className="text-sm text-gray-700">
                        💡 <strong>좌석 배정 안내:</strong> 좌석도를 확인하시고 요청사항에 차량번호와 좌석번호를 적어주시면
                        최대한 원하시는 좌석에 배정하도록 하겠습니다.
                    </p>
                </div>
            </div>
        </div>
    );
}
