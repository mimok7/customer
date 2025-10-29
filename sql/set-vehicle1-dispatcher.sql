-- vehicle1@stayhalong.com 사용자를 배차 담당자(dispatcher)로 설정
UPDATE users
SET role = 'dispatcher'
WHERE email = 'vehicle1@stayhalong.com';

-- 설정 확인
SELECT id, email, role, name
FROM users
WHERE email = 'vehicle1@stayhalong.com';