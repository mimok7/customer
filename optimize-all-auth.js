/**
 * 모든 매니저 페이지의 권한 확인 로직을 useAuth 훅으로 교체하는 스크립트
 * 
 * 실행: node optimize-all-auth.js
 */

const fs = require('fs');
const path = require('path');

// 수정할 파일 목록
const filesToOptimize = [
    'app/manager/notifications/page.tsx',
    'app/manager/services/page.tsx',
    'app/manager/reservation-edit/main/page.tsx',
    'app/manager/quotes/[id]/page.tsx',
    'app/manager/pricing/page.tsx',
    'app/manager/quotes/[id]/view/page.tsx',
    'app/manager/payments/page.tsx',
    'app/manager/dispatch/sht-car/page.tsx',
    'app/manager/dispatch/rentcar/page.tsx',
    'app/manager/dispatch/cruise-car/page.tsx',
    'app/manager/dispatch/airport/page.tsx',
    'app/manager/customers/page.tsx'
];

console.log('🚀 권한 확인 최적화 시작...\n');

filesToOptimize.forEach((filePath) => {
    const fullPath = path.join(__dirname, filePath);

    if (!fs.existsSync(fullPath)) {
        console.log(`⚠️  파일 없음: ${filePath}`);
        return;
    }

    console.log(`📝 처리 중: ${filePath}`);

    try {
        let content = fs.readFileSync(fullPath, 'utf8');
        let modified = false;

        // 1. import 추가
        if (!content.includes('useAuth')) {
            content = content.replace(
                /import ManagerLayout from '@\/components\/ManagerLayout';/,
                `import ManagerLayout from '@/components/ManagerLayout';\nimport { useAuth } from '@/hooks/useAuth';`
            );
            modified = true;
            console.log('  ✅ import 추가');
        }

        // 2. useAuth 훅 추가 (함수 컴포넌트 시작 부분)
        if (!content.includes('useAuth(')) {
            // const router = useRouter(); 다음에 추가
            content = content.replace(
                /(const router = useRouter\(\);)/,
                `$1\n    const { loading: authLoading, isManager } = useAuth(['manager', 'admin'], '/');`
            );
            modified = true;
            console.log('  ✅ useAuth 훅 추가');
        }

        // 3. checkAuth 함수 제거 또는 주석 처리
        const checkAuthPattern = /const checkAuth = async \(\) => \{[\s\S]*?\};/g;
        if (checkAuthPattern.test(content)) {
            content = content.replace(checkAuthPattern, '// checkAuth 제거됨 - useAuth 훅 사용');
            modified = true;
            console.log('  ✅ checkAuth 함수 제거');
        }

        // 4. checkAuth() 호출 제거
        content = content.replace(/checkAuth\(\);?/g, '');

        // 5. loading 상태 수정
        content = content.replace(
            /if \(loading\) \{/g,
            'if (authLoading || loading) {'
        );

        if (modified) {
            fs.writeFileSync(fullPath, content, 'utf8');
            console.log(`  ✅ 완료: ${filePath}\n`);
        } else {
            console.log(`  ⏭️  이미 최적화됨: ${filePath}\n`);
        }

    } catch (error) {
        console.error(`  ❌ 오류: ${filePath}`, error.message, '\n');
    }
});

console.log('\n🎉 모든 파일 처리 완료!');
console.log('\n📋 수동 확인 필요:');
console.log('1. 각 파일의 로딩 상태 조건 확인');
console.log('2. useEffect 의존성 배열에 authLoading, isManager 추가');
console.log('3. 불필요한 권한 체크 코드 제거');
console.log('\n💡 테스트 후 커밋하세요!');
