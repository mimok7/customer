-- Create a consolidated view for manager SHT car report
-- This view resolves: booker (users), pickup/dropoff from reservation_car_sht directly, cruise_name (via room_price -> cruise_info), and pier_location (via cruise_location by en/kr names).

CREATE OR REPLACE VIEW public.vw_manager_sht_car_report AS
SELECT
  rcs.id,
  rcs.reservation_id,
  rcs.usage_date,
  rcs.vehicle_number,
  rcs.seat_number,
  rcs.sht_category,
  rcs.created_at,
  rcs.pickup_location,
  rcs.dropoff_location,
  rcs.pickup_datetime,
  u.name AS booker_name,
  u.email AS booker_email,
  COALESCE(loc_kr.pier_location, loc_en.pier_location) AS pier_location,
  COALESCE(ci_code.cruise_name, ci_name.cruise_name, rp.cruise) AS cruise_name
FROM reservation_car_sht rcs
LEFT JOIN reservation res_sht
  ON res_sht.re_id = rcs.reservation_id
LEFT JOIN users u
  ON u.id = res_sht.re_user_id
LEFT JOIN reservation res_cruise
  ON res_cruise.re_quote_id = res_sht.re_quote_id
 AND res_cruise.re_type = 'cruise'
LEFT JOIN reservation_cruise rc
  ON rc.reservation_id = res_cruise.re_id
LEFT JOIN room_price rp
  ON rp.room_code = rc.room_price_code
LEFT JOIN cruise_info ci_code
  ON ci_code.cruise_code = rp.cruise
LEFT JOIN cruise_info ci_name
  ON ci_name.cruise_name = rp.cruise
LEFT JOIN cruise_location loc_en
  ON loc_en.en_name = COALESCE(ci_code.cruise_name, ci_name.cruise_name, rp.cruise)
LEFT JOIN cruise_location loc_kr
  ON loc_kr.kr_name = COALESCE(ci_code.cruise_name, ci_name.cruise_name, rp.cruise);

COMMENT ON VIEW public.vw_manager_sht_car_report IS 'Manager SHT car report with enriched fields (booker, cruise, pier, pickup/dropoff)';
