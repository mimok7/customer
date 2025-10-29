-- Enable dispatcher to update pickup_confirmed_at and dispatch_memo on dispatch-related tables
-- Run after add-dispatch-columns.sql

-- Ensure RLS is enabled
alter table if exists reservation_car_sht enable row level security;
alter table if exists reservation_cruise_car enable row level security;
alter table if exists reservation_rentcar enable row level security;
alter table if exists reservation_airport enable row level security;

-- Limit column-level updates to only the two dispatch columns
grant update (pickup_confirmed_at, dispatch_memo) on reservation_car_sht to authenticated;
grant update (pickup_confirmed_at, dispatch_memo) on reservation_cruise_car to authenticated;
grant update (pickup_confirmed_at, dispatch_memo) on reservation_rentcar to authenticated;
grant update (pickup_confirmed_at, dispatch_memo) on reservation_airport to authenticated;

drop policy if exists dispatcher_update_car_sht on reservation_car_sht;
create policy dispatcher_update_car_sht on reservation_car_sht
  for update to authenticated
  using (exists (select 1 from users u where u.id = auth.uid() and u.role = 'dispatcher'))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.role = 'dispatcher'));

drop policy if exists dispatcher_update_cruise_car on reservation_cruise_car;
create policy dispatcher_update_cruise_car on reservation_cruise_car
  for update to authenticated
  using (exists (select 1 from users u where u.id = auth.uid() and u.role = 'dispatcher'))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.role = 'dispatcher'));

drop policy if exists dispatcher_update_rentcar on reservation_rentcar;
create policy dispatcher_update_rentcar on reservation_rentcar
  for update to authenticated
  using (exists (select 1 from users u where u.id = auth.uid() and u.role = 'dispatcher'))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.role = 'dispatcher'));

drop policy if exists dispatcher_update_airport on reservation_airport;
create policy dispatcher_update_airport on reservation_airport
  for update to authenticated
  using (exists (select 1 from users u where u.id = auth.uid() and u.role = 'dispatcher'))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.role = 'dispatcher'));
