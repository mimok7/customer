-- Open read access (SELECT) for vehicle-related reservation detail tables
-- Roles: member (own rows via policies), dispatcher/manager/admin (all rows)
-- Ensure RLS is enabled and GRANTs exist for Supabase 'authenticated'

ALTER TABLE IF EXISTS reservation_car_sht ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS reservation_cruise_car ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS reservation_airport ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS reservation_rentcar ENABLE ROW LEVEL SECURITY;

GRANT SELECT ON reservation_car_sht TO authenticated;
GRANT SELECT ON reservation_cruise_car TO authenticated;
GRANT SELECT ON reservation_airport TO authenticated;
GRANT SELECT ON reservation_rentcar TO authenticated;

-- Note: Column-level UPDATE grants for dispatcher are defined in enable-dispatcher-update.sql