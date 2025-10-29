import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import supabase from '@/lib/supabase';

interface AuthState {
    user: any | null;
    role: string | null;
    loading: boolean;
    error: Error | null;
}

// 권한 캐시 (메모리에 저장)
let authCache: {
    user: any | null;
    role: string | null;
    timestamp: number;
} | null = null;

const CACHE_DURATION = 5 * 60 * 1000; // 5분 캐시

/**
 * 인증 및 권한 확인 커스텀 훅
 * @param requiredRoles - 필요한 역할 배열 (예: ['manager', 'admin'])
 * @param redirectOnFail - 권한 없을 시 리다이렉트할 경로
 */
export function useAuth(requiredRoles?: string[], redirectOnFail: string = '/login') {
    const router = useRouter();
    const [authState, setAuthState] = useState<AuthState>({
        user: null,
        role: null,
        loading: true,
        error: null
    });

    useEffect(() => {
        checkAuth();
    }, []);

    const checkAuth = async () => {
        try {
            // 1. 캐시 확인 (5분 이내)
            const now = Date.now();
            if (authCache && (now - authCache.timestamp) < CACHE_DURATION) {
                console.log('✅ 캐시된 권한 사용:', authCache.role);
                setAuthState({
                    user: authCache.user,
                    role: authCache.role,
                    loading: false,
                    error: null
                });

                // 권한 체크
                if (requiredRoles && authCache.role && !requiredRoles.includes(authCache.role)) {
                    console.warn('⚠️ 권한 부족 (캐시):', authCache.role);
                    router.push(redirectOnFail);
                }
                return;
            }

            // 2. Supabase 인증 확인
            const { data: { user }, error: userError } = await supabase.auth.getUser();

            if (userError || !user) {
                console.log('❌ 인증 실패:', userError?.message);
                setAuthState({ user: null, role: null, loading: false, error: userError });
                router.push('/login');
                return;
            }

            // 3. 사용자 역할 조회
            const { data: userData, error: roleError } = await supabase
                .from('users')
                .select('role')
                .eq('id', user.id)
                .maybeSingle(); // single 대신 maybeSingle 사용 (견적자는 users 테이블에 없을 수 있음)

            let userRole = 'guest'; // 기본값

            if (!roleError && userData?.role) {
                userRole = userData.role;
            } else if (roleError) {
                console.warn('⚠️ 역할 조회 실패 (guest로 간주):', roleError.message);
            } else {
                console.log('ℹ️ users 테이블에 없음 (guest)');
            }

            // 4. 캐시 업데이트
            authCache = {
                user,
                role: userRole,
                timestamp: now
            };

            console.log('✅ 인증 완료:', { email: user.email, role: userRole });

            // 5. 상태 업데이트
            setAuthState({
                user,
                role: userRole,
                loading: false,
                error: null
            });

            // 6. 권한 체크
            if (requiredRoles && !requiredRoles.includes(userRole)) {
                console.warn('⚠️ 권한 부족:', { required: requiredRoles, actual: userRole });
                alert('접근 권한이 없습니다.');
                router.push(redirectOnFail);
            }

        } catch (error) {
            console.error('❌ 인증 확인 오류:', error);
            setAuthState({
                user: null,
                role: null,
                loading: false,
                error: error as Error
            });
            router.push('/login');
        }
    };

    // 캐시 무효화 함수
    const invalidateCache = () => {
        authCache = null;
        checkAuth();
    };

    return {
        ...authState,
        isAuthenticated: !!authState.user,
        isManager: authState.role === 'manager' || authState.role === 'admin',
        isAdmin: authState.role === 'admin',
        isMember: authState.role === 'member',
        isGuest: authState.role === 'guest',
        refetch: invalidateCache
    };
}

/**
 * 캐시 수동 무효화 (로그아웃 시 사용)
 */
export function clearAuthCache() {
    authCache = null;
    console.log('🗑️ 인증 캐시 삭제');
}
