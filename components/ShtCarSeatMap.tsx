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
}

interface ShtCarSeatMapProps {
    isOpen: boolean;
    onClose: () => void;
    selectedDate?: Date;
    usageDate?: string;
    vehicleNumber?: string;
}

export default function ShtCarSeatMap({
    isOpen,
    onClose,
    selectedDate,
    usageDate,
    vehicleNumber
}: ShtCarSeatMapProps) {
    const [selectedSeat, setSelectedSeat] = useState<string | null>(null);
    const [loading, setLoading] = useState(false);
    const [reservations, setReservations] = useState<SeatReservation[]>([]);
    const [vehicles, setVehicles] = useState<string[]>([]);
    const [currentVehicle, setCurrentVehicle] = useState(vehicleNumber || '');
    const [currentDate, setCurrentDate] = useState(usageDate || selectedDate?.toISOString().split('T')[0] || new Date().toISOString().split('T')[0]);
    const [category, setCategory] = useState<'all' | 'pickup' | 'dropoff'>('all');

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
        if (isOpen && currentDate) {
            loadData();
        }
    }, [isOpen, currentDate, currentVehicle, category]);

    const loadData = async () => {
        setLoading(true);
        try {
            // 예약 정보 조회
            const { data, error } = await supabase
                .from('reservation_car_sht')
                .select('id, vehicle_number, seat_number, sht_category, usage_date')
                .gte('usage_date', `${currentDate}T00:00:00`)
                .lte('usage_date', `${currentDate}T23:59:59`);

            if (error) throw error;

            // 차량 목록 추출
            const vehicleSet = new Set<string>();
            (data || []).forEach(r => {
                if (r.vehicle_number) vehicleSet.add(r.vehicle_number);
            });
            const vehicleList = Array.from(vehicleSet).sort();
            setVehicles(vehicleList);

            // 첫 차량 자동 선택
            if (!currentVehicle && vehicleList.length > 0) {
                setCurrentVehicle(vehicleList[0]);
            }

            // 현재 차량 및 카테고리에 맞는 예약만 필터링
            const filtered = (data || []).filter(r => {
                const matchVehicle = !currentVehicle || r.vehicle_number === currentVehicle;
                const matchCategory = category === 'all' ||
                    (category === 'pickup' && r.sht_category?.toLowerCase() === 'pickup') ||
                    (category === 'dropoff' && (r.sht_category?.toLowerCase() === 'dropoff' || r.sht_category?.toLowerCase() === 'drop-off'));
                return matchVehicle && matchCategory;
            });

            setReservations(filtered as SeatReservation[]);
        } catch (error) {
            console.error('데이터 로드 오류:', error);
        } finally {
            setLoading(false);
        }
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
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">날짜</label>
                            <input
                                type="date"
                                value={currentDate}
                                onChange={(e) => setCurrentDate(e.target.value)}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">차량번호</label>
                            <select
                                value={currentVehicle}
                                onChange={(e) => setCurrentVehicle(e.target.value)}
                                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                            >
                                <option value="">차량 선택</option>
                                {vehicles.map(v => (
                                    <option key={v} value={v}>{v}</option>
                                ))}
                            </select>
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-2">카테고리</label>
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
                        </div>
                    ) : (
                        <div className="relative">
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
