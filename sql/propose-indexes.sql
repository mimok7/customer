-- Index recommendations for sht project (reservation & service tables)

-- 1) reservation lookups by user and quote
CREATE INDEX IF NOT EXISTS idx_reservation_user ON reservation (re_user_id);
CREATE INDEX IF NOT EXISTS idx_reservation_quote ON reservation (re_quote_id);
CREATE INDEX IF NOT EXISTS idx_reservation_type ON reservation (re_type);
CREATE INDEX IF NOT EXISTS idx_reservation_created_at ON reservation (re_created_at DESC);

-- 2) Join keys on service reservation tables
CREATE INDEX IF NOT EXISTS idx_res_airport_reservation_id ON reservation_airport (reservation_id);
CREATE INDEX IF NOT EXISTS idx_res_cruise_reservation_id ON reservation_cruise (reservation_id);
CREATE INDEX IF NOT EXISTS idx_res_hotel_reservation_id ON reservation_hotel (reservation_id);
CREATE INDEX IF NOT EXISTS idx_res_rentcar_reservation_id ON reservation_rentcar (reservation_id);
CREATE INDEX IF NOT EXISTS idx_res_tour_reservation_id ON reservation_tour (reservation_id);
CREATE INDEX IF NOT EXISTS idx_res_car_sht_reservation_id ON reservation_car_sht (reservation_id);

-- 3) Frequent filters per service
-- Airport
CREATE INDEX IF NOT EXISTS idx_res_airport_datetime ON reservation_airport (ra_datetime);
CREATE INDEX IF NOT EXISTS idx_res_airport_price_code ON reservation_airport (airport_price_code);

-- Cruise
CREATE INDEX IF NOT EXISTS idx_res_cruise_checkin ON reservation_cruise (checkin);
-- checkout, car_type 컬럼은 reservation_cruise에 존재하지 않으므로 제거
CREATE INDEX IF NOT EXISTS idx_res_cruise_room_price_code ON reservation_cruise (room_price_code);

-- Cruise Car (차량 상세는 별도 테이블)
CREATE INDEX IF NOT EXISTS idx_res_cruise_car_reservation_id ON reservation_cruise_car (reservation_id);
CREATE INDEX IF NOT EXISTS idx_res_cruise_car_pickup_datetime ON reservation_cruise_car (pickup_datetime);
CREATE INDEX IF NOT EXISTS idx_res_cruise_car_price_code ON reservation_cruise_car (car_price_code);

-- Hotel
CREATE INDEX IF NOT EXISTS idx_res_hotel_checkin_date ON reservation_hotel (checkin_date);
CREATE INDEX IF NOT EXISTS idx_res_hotel_price_code ON reservation_hotel (hotel_price_code);

-- Rentcar
CREATE INDEX IF NOT EXISTS idx_res_rentcar_pickup_datetime ON reservation_rentcar (pickup_datetime);
CREATE INDEX IF NOT EXISTS idx_res_rentcar_price_code ON reservation_rentcar (rentcar_price_code);

-- Tour
CREATE INDEX IF NOT EXISTS idx_res_tour_usage_date ON reservation_tour (usage_date);
CREATE INDEX IF NOT EXISTS idx_res_tour_price_code ON reservation_tour (tour_price_code);

-- SHT Car
CREATE INDEX IF NOT EXISTS idx_res_car_sht_usage_date ON reservation_car_sht (usage_date);
CREATE INDEX IF NOT EXISTS idx_res_car_sht_pickup_datetime ON reservation_car_sht (pickup_datetime);
CREATE INDEX IF NOT EXISTS idx_res_car_sht_price_code ON reservation_car_sht (car_price_code);

-- 4) Price tables lookups by code
CREATE INDEX IF NOT EXISTS idx_airport_price_code ON airport_price (airport_code);
CREATE INDEX IF NOT EXISTS idx_rent_price_code ON rent_price (rent_code);
CREATE INDEX IF NOT EXISTS idx_car_price_code ON car_price (car_code);
CREATE INDEX IF NOT EXISTS idx_hotel_price_code ON hotel_price (hotel_code);
CREATE INDEX IF NOT EXISTS idx_tour_price_code ON tour_price (tour_code);

-- 5) Quote and quote_item access paths
CREATE INDEX IF NOT EXISTS idx_quote_owner ON quote (user_id);
CREATE INDEX IF NOT EXISTS idx_quote_created_at ON quote (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_quote_item_quote ON quote_item (quote_id);
CREATE INDEX IF NOT EXISTS idx_quote_item_service_ref ON quote_item (service_type, service_ref_id);

-- 6) Users table frequent lookups
CREATE INDEX IF NOT EXISTS idx_users_role ON users (role);

-- Note:
-- Before creating many indexes in production, validate with EXPLAIN (ANALYZE)
-- and monitor pg_stat_statements to ensure net benefit. Too many indexes can
-- slow down writes.
