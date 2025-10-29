-- Create a consolidated view for manager Cruise car report
-- Source: reservation_cruise_car + reservation/users + car_price->cruise_info + cruise_location

CREATE OR REPLACE VIEW public.vw_manager_cruise_car_report AS
SELECT
  rcc.id,
  rcc.reservation_id,
  -- Align with SHT usage_date semantics by using pickup_datetime as usage_date
  rcc.pickup_datetime AS usage_date,
  NULL::text AS vehicle_number,
  NULL::text AS seat_number,
  -- Derive category: prefer 'pickup' when pickup_location exists else 'dropoff'
  CASE
    WHEN rcc.pickup_location IS NOT NULL AND rcc.pickup_location <> '' THEN 'pickup'
    WHEN rcc.dropoff_location IS NOT NULL AND rcc.dropoff_location <> '' THEN 'dropoff'
    ELSE NULL
  END AS sht_category,
  rcc.created_at,
  rcc.pickup_location,
  rcc.dropoff_location,
  rcc.pickup_datetime,
  u.name AS booker_name,
  u.email AS booker_email,
  COALESCE(loc_kr.pier_location, loc_en.pier_location) AS pier_location,
  COALESCE(ci_code.cruise_name, ci_name.cruise_name, cp.cruise) AS cruise_name,
  cp.car_category,
  cp.car_type,
  rcc.dispatch_code
FROM reservation_cruise_car rcc
LEFT JOIN reservation res
  ON res.re_id = rcc.reservation_id
LEFT JOIN users u
  ON u.id = res.re_user_id
LEFT JOIN car_price cp
  ON cp.car_code = rcc.car_price_code
LEFT JOIN cruise_info ci_code
  ON ci_code.cruise_code = cp.cruise
LEFT JOIN cruise_info ci_name
  ON ci_name.cruise_name = cp.cruise
LEFT JOIN cruise_location loc_en
  ON loc_en.en_name = COALESCE(ci_code.cruise_name, ci_name.cruise_name, cp.cruise)
LEFT JOIN cruise_location loc_kr
  ON loc_kr.kr_name = COALESCE(ci_code.cruise_name, ci_name.cruise_name, cp.cruise);

COMMENT ON VIEW public.vw_manager_cruise_car_report IS 'Manager Cruise car report (reservation_cruise_car) with booker, cruise, pier, pickup/dropoff';
