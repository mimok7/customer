"use client";
import { useEffect } from 'react';
import { setupAuthListener, getCurrentUserInfo } from '@/lib/userUtils';

export default function AuthInitializer() {
    useEffect(() => {
        let unsub: any = null;
        const start = async () => {
            // Warm up current user (optional)
            try { await getCurrentUserInfo(); } catch { }
            const subscription = setupAuthListener((user, userData) => {
                // no-op here; other components may also query getCurrentUserInfo when needed
                try { console.debug('AuthInitializer: onUserChange', !!user); } catch { }
            });
            unsub = subscription;
        };
        start();

        return () => {
            try { unsub?.unsubscribe?.(); } catch { }
        };
    }, []);

    return null;
}
