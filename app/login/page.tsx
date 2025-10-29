"use client";
import React from 'react';
import Image from 'next/image';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import supabase from '@/lib/supabase';
import { upsertUserProfile } from '@/lib/userUtils';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const { error } = await supabase.auth.signInWithPassword({ email, password });

      if (error) {
        alert('❌ 로그인 실패: ' + error.message);
        setLoading(false);
        return;
      }

      // ✅ 로그인 후 세션 재확인
      const { data: { user }, error: userError } = await supabase.auth.getUser();

      if (userError || !user) {
        console.error('❌ 사용자 정보 조회 실패:', userError);
        alert('로그인은 성공했으나 사용자 정보를 가져올 수 없습니다.');
        setLoading(false);
        return;
      }

      console.log('✅ 로그인된 유저:', user.id, user.email);

      // 사용자가 'users' 테이블에 존재하는지 확인
      const { data: existingUser, error: fetchError } = await supabase
        .from('users')
        .select('id, role, status')
        .eq('id', user.id)
        .single();

      // 프로필이 존재하지 않을 경우에만 'guest'로 생성
      if (fetchError) {
        if (fetchError.code === 'PGRST116') {
          // 프로필이 없음 - 새로 생성
          console.log('ℹ️  프로필 없음, 신규 생성 시도');

          const profileResult = await upsertUserProfile(user.id, user.email || '', {
            name: user.user_metadata?.display_name || user.email?.split('@')[0] || '사용자',
            role: 'guest',
          });

          if (!profileResult.success) {
            console.error('❌ 프로필 생성 오류:', profileResult.error);
            alert('프로필 생성 중 오류가 발생했습니다.\n' + (profileResult.error?.message || '알 수 없는 오류'));
            setLoading(false);
            return;
          }

          console.log('✅ 프로필 생성 성공');
        } else {
          // 다른 오류
          console.error('❌ 프로필 조회 오류:', fetchError);
          alert('사용자 정보를 확인하는 중 오류가 발생했습니다.\n' + fetchError.message);
          setLoading(false);
          return;
        }
      } else {
        console.log('✅ 기존 프로필 확인:', existingUser.role, existingUser.status);
        // 기존 사용자의 경우 역할을 변경하지 않음
      }

      alert('✅ 로그인 성공!');
      router.push('/'); // 홈 메뉴 페이지로 이동
      router.refresh(); // 세션 반영

    } catch (error) {
      console.error('로그인 처리 오류:', error);
      alert('로그인 처리 중 오류가 발생했습니다.');
      setLoading(false);
    }
  };

  const getDashboardPath = (role: string | null) => {
    switch (role) {
      case 'member': return '/customer/dashboard';
      case 'manager': return '/manager/dashboard';
      case 'admin': return '/admin/dashboard';
      default: return '/user/dashboard';
    }
  };

  return (
    <div className="max-w-sm mx-auto mt-12 p-4 bg-white shadow rounded">
      <div className="flex justify-center mb-4">
        <Image src="/logo-full.png" alt="스테이하롱 전체 로고" width={320} height={80} unoptimized />
      </div>
      <h2 className="text-2xl font-bold mb-6 text-center">🔐 로그인</h2>
      <form onSubmit={handleLogin} className="space-y-4">
        <input
          type="email"
          placeholder="이메일"
          className="w-full border p-2 rounded"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
        <p className="text-sm text-gray-500 mt-1">
          견적 신청시 입력하신 이메일과 비밀번호를 입력해주세요.
        </p>
        <input
          type="password"
          placeholder="비밀번호"
          className="w-full border p-2 rounded"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
        <p className="text-sm text-gray-500 mt-1">비밀번호는 6자 이상 입력해주세요.</p>
        <button
          type="submit"
          className="bg-blue-500 text-white w-full py-2 rounded hover:bg-blue-600 transition disabled:opacity-50"
          disabled={loading}
        >
          {loading ? '로그인 중...' : '로그인'}
        </button>
      </form>
    </div>
  );
}
