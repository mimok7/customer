-- Dispatcher 역할 권한 설정 SQL
-- 배차 담당자(dispatcher)가 배차 정보만 열람할 수 있도록 RLS 정책 설정

-- 1. 기존 dispatcher 관련 정책 삭제 (있다면)
DROP POLICY IF EXISTS reservation_dispatcher_policy ON reservation;
DROP POLICY IF EXISTS reservation_car_sht_dispatcher_policy ON reservation_car_sht;
DROP POLICY IF EXISTS reservation_cruise_car_dispatcher_policy ON reservation_cruise_car;
DROP POLICY IF EXISTS users_dispatcher_read_policy ON users;

ALTER TABLE reservation_car_sht ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_cruise_car ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_airport ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation_rentcar ENABLE ROW LEVEL SECURITY;

-- 3. Dispatcher 역할 권한 정책 생성

-- reservation 테이블: dispatcher는 배차 관련 예약만 조회 가능
CREATE POLICY reservation_dispatcher_policy ON reservation
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id::text = auth.uid()::text
      AND u.role = 'dispatcher'
    )
    AND (
      -- 스하 차량 예약
      re_type = 'car_sht' OR
      -- 크루즈 차량 예약
      re_type = 'cruise_car'
    )
  );

DROP POLICY IF EXISTS reservation_car_sht_dispatcher_policy ON reservation_car_sht;
CREATE POLICY reservation_car_sht_dispatcher_policy ON reservation_car_sht
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id::text = auth.uid()::text
      AND u.role IN ('dispatcher', 'manager', 'admin')
    )
  );

-- reservation_car_sht: 회원(member)은 본인 예약 건만 조회 가능
DROP POLICY IF EXISTS reservation_car_sht_member_policy ON reservation_car_sht;
CREATE POLICY reservation_car_sht_member_policy ON reservation_car_sht
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM reservation r
      WHERE r.re_id = reservation_car_sht.reservation_id
        AND r.re_user_id::text = auth.uid()::text
    )
  );

GRANT SELECT ON reservation_car_sht TO authenticated;

DROP POLICY IF EXISTS reservation_cruise_car_dispatcher_policy ON reservation_cruise_car;
CREATE POLICY reservation_cruise_car_dispatcher_policy ON reservation_cruise_car
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id::text = auth.uid()::text
      AND u.role IN ('dispatcher', 'manager', 'admin')
    )
  );

-- reservation_cruise_car: 회원(member)은 본인 예약 건만 조회 가능
DROP POLICY IF EXISTS reservation_cruise_car_member_policy ON reservation_cruise_car;
CREATE POLICY reservation_cruise_car_member_policy ON reservation_cruise_car
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM reservation r
      WHERE r.re_id = reservation_cruise_car.reservation_id
        AND r.re_user_id::text = auth.uid()::text
    )
  );

GRANT SELECT ON reservation_cruise_car TO authenticated;

-- reservation_airport: SELECT 정책 (staff + member)
DROP POLICY IF EXISTS reservation_airport_staff_policy ON reservation_airport;
CREATE POLICY reservation_airport_staff_policy ON reservation_airport
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id::text = auth.uid()::text
        AND u.role IN ('dispatcher', 'manager', 'admin')
    )
  );

DROP POLICY IF EXISTS reservation_airport_member_policy_select ON reservation_airport;
CREATE POLICY reservation_airport_member_policy_select ON reservation_airport
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM reservation r
      WHERE r.re_id = reservation_airport.reservation_id
        AND r.re_user_id::text = auth.uid()::text
    )
  );

GRANT SELECT ON reservation_airport TO authenticated;

-- reservation_rentcar: SELECT 정책 (staff + member)
DROP POLICY IF EXISTS reservation_rentcar_staff_policy ON reservation_rentcar;
CREATE POLICY reservation_rentcar_staff_policy ON reservation_rentcar
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id::text = auth.uid()::text
        AND u.role IN ('dispatcher', 'manager', 'admin')
    )
  );

DROP POLICY IF EXISTS reservation_rentcar_member_policy_select ON reservation_rentcar;
CREATE POLICY reservation_rentcar_member_policy_select ON reservation_rentcar
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM reservation r
      WHERE r.re_id = reservation_rentcar.reservation_id
        AND r.re_user_id::text = auth.uid()::text
    )
  );

GRANT SELECT ON reservation_rentcar TO authenticated;

-- users 테이블: dispatcher는 예약자 정보 조회 가능 (배차 정보에 예약자 이름 표시용)
CREATE POLICY users_dispatcher_read_policy ON users
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id::text = auth.uid()::text
      AND u.role = 'dispatcher'
    )
  );

-- 4. 배차 리포트 뷰 권한 설정
-- vw_manager_sht_car_report 뷰가 존재한다면
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'vw_manager_sht_car_report') THEN
    GRANT SELECT ON vw_manager_sht_car_report TO authenticated;
  END IF;
END $$;

-- vw_manager_cruise_car_report 뷰가 존재한다면
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'vw_manager_cruise_car_report') THEN
    GRANT SELECT ON vw_manager_cruise_car_report TO authenticated;
  END IF;
END $$;

-- 5. Dispatcher 전용 뷰 생성 (필요시)
-- 배차 담당자가 볼 수 있는 제한된 예약자 정보 뷰
CREATE OR REPLACE VIEW dispatcher_users AS
SELECT
  id,
  name,
  email
FROM users
WHERE EXISTS (
  SELECT 1 FROM users u
  WHERE u.id::text = auth.uid()::text
  AND u.role = 'dispatcher'
);

-- 뷰 권한 부여
GRANT SELECT ON dispatcher_users TO authenticated;

-- 6. Dispatcher 역할 사용자 생성 예시
-- 실제 적용시 주석 해제하고 사용자 ID 입력
/*
-- 특정 사용자에게 dispatcher 역할 부여 예시
UPDATE users
SET role = 'dispatcher'
WHERE email = 'dispatcher@example.com';
*/