'use client';
import React from 'react';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import supabase from '@/lib/supabase';
import { upsertUserProfile } from '@/lib/userUtils';

export default function SignupPage() {
  const router = useRouter();
  const [form, setForm] = useState({
    email: '',
    password: '',
    displayName: '',
  });
  const [loading, setLoading] = useState(false);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      // 1. Supabase Auth 회원가입
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: form.email,
        password: form.password,
        options: {
          data: {
            display_name: form.displayName,
          },
        },
      });

      if (authError) {
        // Auth 오류 구체적으로 처리
        if (authError.message.includes('already registered') || authError.message.includes('User already registered')) {
          throw new Error('이미 가입된 이메일입니다. 로그인하거나 비밀번호 재설정을 이용해주세요.');
        }
        throw authError;
      }

      if (!authData.user) {
        throw new Error('사용자 생성에 실패했습니다. 다시 시도해주세요.');
      }

      console.log('✅ Auth 회원가입 성공:', authData.user.id);

      // 2. users 테이블에 기본 정보 저장 (프로젝트 패턴 준수)
      const result = await upsertUserProfile(authData.user.id, form.email, {
        name: form.displayName,
        role: 'guest',  // 기본 게스트 역할 (견적만 가능)
      });

      if (!result.success) {
        console.error('⚠️ users 테이블 저장 실패:', result.error);

        // 이메일 중복 오류 특별 처리
        if (result.error?.code === 'EMAIL_DUPLICATE') {
          alert('⚠️ ' + (result.error.message || '이미 사용 중인 이메일입니다.'));
          router.push('/login');
          return;
        }

        // 다른 오류의 경우 경고만 표시하고 진행
        alert('⚠️ 프로필 저장에 문제가 있습니다.\n로그인 후 프로필을 업데이트해주세요.\n\n오류: ' + (result.error?.message || '알 수 없는 오류'));
      } else {
        console.log('✅ Users 테이블 프로필 저장 성공');
        alert('✅ 회원가입이 완료되었습니다!\n내 정보 페이지에서 추가 정보를 입력해주세요.');
      }

      // 회원가입 성공 후 바로 내 정보 페이지로 이동
      router.push('/mypage/profile');
    } catch (error: any) {
      console.error('❌ 회원가입 실패:', error);

      // 사용자 친화적인 에러 메시지
      let errorMessage = '회원가입 실패:\n';
      if (error.message) {
        errorMessage += error.message;
      } else if (error.error_description) {
        errorMessage += error.error_description;
      } else {
        errorMessage += '알 수 없는 오류가 발생했습니다.';
      }

      alert(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-md mx-auto p-6">
      <h1 className="text-xl font-bold mb-4">회원가입</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <input
          type="text"
          name="displayName"
          placeholder="닉네임을 입력하세요"
          value={form.displayName}
          onChange={handleChange}
          required
          className="w-full border rounded px-3 py-2"
        />
        <input
          type="email"
          name="email"
          placeholder="이메일을 입력하세요"
          value={form.email}
          onChange={handleChange}
          required
          className="w-full border rounded px-3 py-2"
        />
        <input
          type="password"
          name="password"
          placeholder="비밀번호는 6자리 이상 입력"
          value={form.password}
          onChange={handleChange}
          required
          minLength={6}
          className="w-full border rounded px-3 py-2"
        />

        <button
          type="submit"
          disabled={loading}
          className="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600 disabled:opacity-50"
        >
          {loading ? '가입 중...' : '회원가입'}
        </button>
      </form>

      <div className="text-center mt-4">
        <button
          onClick={() => router.push('/login')}
          className="text-blue-500 hover:text-blue-700"
        >
          이미 계정이 있으신가요? 로그인하기
        </button>
      </div>

      <div className="mt-6 p-4 bg-blue-50 rounded-lg">
        <p className="text-sm text-blue-700">
          💡 가입 후 견적 작성이 가능합니다. 예약 완료 시 정회원으로 승급됩니다.
        </p>
      </div>
    </div>
  );
}
