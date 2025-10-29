'use client';

import { useEffect, useState } from 'react';
import supabase from '@/lib/supabase';
import GlobalNotificationPopup from './GlobalNotificationPopup';

export default function GlobalNotificationWrapper() {
    const [userRole, setUserRole] = useState<string | null>(null);

    useEffect(() => {
        const getUserRole = async () => {
            try {
                const { data: { user } } = await supabase.auth.getUser();
                if (!user) return;

                const { data: userData } = await supabase
                    .from('users')
                    .select('role')
                    .eq('id', user.id)
                    .single();

                setUserRole(userData?.role || null);
            } catch (error) {
                console.error('사용자 역할 조회 실패:', error);
            }
        };

        getUserRole();
    }, []);

    return <GlobalNotificationPopup userRole={userRole || undefined} />;
}
