'use client';

import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import PageWrapper from '@/components/PageWrapper';
import SectionBox from '@/components/SectionBox';
import supabase from '@/lib/supabase';

interface UserProfile {
    id: string;
    email: string | null;
    name: string | null;
    english_name?: string | null;
    nickname?: string | null;
    phone_number?: string | null;
    role?: string | null;
    birth_date?: string | null;
    passport_number?: string | null;
    passport_expiry?: string | null;
    notifications?: boolean; // UI 전용 토글 (실제 컬럼 여부에 따라 저장 스킵)
}

export default function ProfilePage() {
    const router = useRouter();
    const [authUser, setAuthUser] = useState<any>(null);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [profile, setProfile] = useState<UserProfile | null>(null);

    const handleGoHome = () => {
        router.push('/mypage');
    };

    useEffect(() => {
        init();
    }, []);

    const init = async () => {
        try {
            const { data: { user }, error } = await supabase.auth.getUser();
            if (error || !user) {
                router.push('/login');
                return;
            }
            setAuthUser(user);

            // users 테이블에서 프로필 로드 (없으면 기본 생성 X, 조회만)
            const { data: urow, error: uerr } = await supabase
                .from('users')
                .select('id, email, name, english_name, nickname, phone_number, role, birth_date, passport_number, passport_expiry')
                .eq('id', user.id)
                .single();

            if (uerr) {
                console.warn('users 조회 실패 또는 미존재:', uerr?.message);
                setProfile({
                    id: user.id,
                    email: user.email ?? null,
                    name: null,
                    english_name: null,
                    nickname: null,
                    phone_number: null,
                    role: 'member',
                    birth_date: null,
                    passport_number: null,
                    passport_expiry: null,
                    notifications: true,
                });
            } else if (urow) {
                setProfile({ ...urow, notifications: true });
            }
        } catch (e) {
            console.error('프로필 초기화 오류:', e);
        } finally {
            setLoading(false);
        }
    };

    const handleSave = async () => {
        if (!authUser || !profile) return;
        setSaving(true);
        try {
            // users 레코드가 없을 수도 있으므로 upsert 사용 (id pk)
            const payload: any = {
                id: profile.id,
                email: profile.email,
                name: profile.name,
                english_name: profile.english_name,
                nickname: profile.nickname,
                phone_number: profile.phone_number,
                role: profile.role ?? 'member',
                birth_date: profile.birth_date,
                passport_number: profile.passport_number,
                passport_expiry: profile.passport_expiry,
                updated_at: new Date().toISOString(),
            };

            const { error } = await supabase
                .from('users')
                .upsert(payload, { onConflict: 'id' });

            if (error) throw error;

            alert('프로필이 저장되었습니다.');
        } catch (e: any) {
            console.error('프로필 저장 오류:', e);
            alert(`저장 실패: ${e?.message || '알 수 없는 오류'}`);
        } finally {
            setSaving(false);
        }
    };

    if (loading || !profile) {
        return (
            <PageWrapper title="내 정보">
                <div className="flex justify-center items-center h-64">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
                    <p className="ml-4 text-gray-600">프로필을 불러오는 중...</p>
                </div>
            </PageWrapper>
        );
    }

    return (
        <PageWrapper title="👤 내 정보">
            <div className="space-y-6">
                {/* 홈 버튼 - 페이지 상단 */}
                <div className="flex justify-start">
                    <button
                        type="button"
                        onClick={handleGoHome}
                        className="px-4 py-2 rounded border border-gray-300 text-gray-700 hover:bg-gray-50 transition-colors"
                    >
                        🏠 홈으로
                    </button>
                </div>

                {/* 회원가입 후 안내 메시지 */}
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                    <p className="text-sm text-blue-700">
                        💡 <strong>환영합니다!</strong> 아래 정보를 입력하시면 더 편리하게 서비스를 이용하실 수 있습니다.
                    </p>
                </div>

                <SectionBox title="기본 정보">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label className="block text-sm text-gray-600 mb-1">이메일</label>
                            <input
                                type="email"
                                value={profile.email ?? ''}
                                readOnly
                                className="w-full px-3 py-2 border border-gray-200 rounded bg-gray-50 text-gray-700 cursor-not-allowed"
                                placeholder="email@example.com"
                            />
                        </div>
                        <div>
                            <label className="block text-sm text-gray-600 mb-1">이름</label>
                            <input
                                type="text"
                                value={profile.name ?? ''}
                                onChange={(e) => setProfile({ ...profile, name: e.target.value })}
                                className="w-full px-3 py-2 border border-gray-200 rounded"
                                placeholder="홍길동"
                            />
                        </div>
                        <div>
                            <label className="block text-sm text-gray-600 mb-1">영문 이름</label>
                            <input
                                type="text"
                                value={profile.english_name ?? ''}
                                onChange={(e) => setProfile({ ...profile, english_name: e.target.value })}
                                className="w-full px-3 py-2 border border-gray-200 rounded"
                                placeholder="GILDONG HONG"
                            />
                        </div>
                        <div>
                            <label className="block text-sm text-gray-600 mb-1">닉네임</label>
                            <input
                                type="text"
                                value={profile.nickname ?? ''}
                                onChange={(e) => setProfile({ ...profile, nickname: e.target.value })}
                                className="w-full px-3 py-2 border border-gray-200 rounded"
                            />
                        </div>
                        <div>
                            <label className="block text-sm text-gray-600 mb-1">휴대폰 번호</label>
                            <input
                                type="tel"
                                value={profile.phone_number ?? ''}
                                onChange={(e) => setProfile({ ...profile, phone_number: e.target.value })}
                                className="w-full px-3 py-2 border border-gray-200 rounded"
                                placeholder="010-0000-0000"
                            />
                        </div>
                        <div>
                            <label className="block text-sm text-gray-600 mb-1">생년월일</label>
                            <input
                                type="date"
                                value={profile.birth_date ?? ''}
                                onChange={(e) => setProfile({ ...profile, birth_date: e.target.value })}
                                className="w-full px-3 py-2 border border-gray-200 rounded"
                            />
                        </div>
                    </div>
                </SectionBox>

                <SectionBox title="여권 정보">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label className="block text-sm text-gray-600 mb-1">여권번호</label>
                            <input
                                type="text"
                                value={profile.passport_number ?? ''}
                                onChange={(e) => setProfile({ ...profile, passport_number: e.target.value })}
                                className="w-full px-3 py-2 border border-gray-200 rounded"
                            />
                        </div>
                        <div>
                            <label className="block text-sm text-gray-600 mb-1">여권만료일</label>
                            <input
                                type="date"
                                value={profile.passport_expiry ?? ''}
                                onChange={(e) => setProfile({ ...profile, passport_expiry: e.target.value })}
                                className="w-full px-3 py-2 border border-gray-200 rounded"
                            />
                        </div>
                    </div>
                </SectionBox>

                <div className="flex justify-end">
                    <button
                        type="button"
                        onClick={handleSave}
                        disabled={saving}
                        className={`px-6 py-2 rounded text-white ${saving ? 'bg-gray-400' : 'bg-blue-500 hover:bg-blue-600'}`}
                    >
                        {saving ? '저장 중...' : '저장하기'}
                    </button>
                </div>
            </div>
        </PageWrapper>
    );
}
