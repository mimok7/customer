'use client';

import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { useRouter } from 'next/navigation';

export default function Header() {
  const router = useRouter();

  return (
    <header className="bg-blue-300 shadow-sm border-b">
      <div className="w-full px-4">
        <div className="flex items-center h-16">
          {/* 로고만 좌측 정렬 */}
          <div className="flex">
            <Link href="/" className="flex items-center space-x-2">
              <Image
                src="/logo.png"
                alt="스테이하롱 트레블"
                width={40}
                height={40}
                style={{ width: 'auto', height: 'auto' }} // 비율 유지
                className="object-contain"
                unoptimized
              />
              <span className="text-xl font-bold text-black-600">
                스테이하롱 트레블
              </span>
            </Link>
          </div>
        </div>
      </div>
    </header>
  );
}
