-- 견적 시스템 데이터베이스 스키마
-- 다중 서비스 견적 시스템을 위한 정규화된 테이블 구조

-- 1. quote (견적 마스터 테이블)
CREATE TABLE IF NOT EXISTS quote (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved', 'rejected', 'completed')),
  title VARCHAR(255),
  description TEXT,
  total_price DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  submitted_at TIMESTAMP WITH TIME ZONE,
  approved_at TIMESTAMP WITH TIME ZONE
);

-- 2. quote_item (견적 상세 테이블 - 여러 서비스 신청 내역)
CREATE TABLE IF NOT EXISTS quote_item (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quote_id UUID NOT NULL REFERENCES quote(id) ON DELETE CASCADE,
  service_type VARCHAR(20) NOT NULL CHECK (service_type IN ('cruise', 'airport', 'hotel', 'tour', 'rentcar')),
  service_ref_id UUID NOT NULL, -- 각 서비스별 상세 테이블의 id
  quantity INTEGER DEFAULT 1,
  unit_price DECIMAL(10,2) DEFAULT 0,
  total_price DECIMAL(10,2) DEFAULT 0,
  options JSONB, -- 서비스별 추가 옵션
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 3. cruise (크루즈 서비스 상세)
CREATE TABLE IF NOT EXISTS cruise (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cruise_name VARCHAR(255) NOT NULL,
  departure_date DATE NOT NULL,
  return_date DATE NOT NULL,
  departure_port VARCHAR(100),
  room_type VARCHAR(50),
  adult_count INTEGER DEFAULT 0,
  child_count INTEGER DEFAULT 0,
  infant_count INTEGER DEFAULT 0,
  special_requests TEXT,
  base_price DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 4. airport (공항 서비스 상세)
CREATE TABLE IF NOT EXISTS airport (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_type VARCHAR(20) NOT NULL CHECK (service_type IN ('pickup', 'dropoff', 'transfer')),
  flight_number VARCHAR(20),
  arrival_date DATE,
  departure_date DATE,
  pickup_location VARCHAR(255),
  dropoff_location VARCHAR(255),
  passenger_count INTEGER DEFAULT 1,
  vehicle_type VARCHAR(50),
  special_requests TEXT,
  base_price DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 5. hotel (호텔 서비스 상세)
CREATE TABLE IF NOT EXISTS hotel (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  hotel_name VARCHAR(255) NOT NULL,
  check_in_date DATE NOT NULL,
  check_out_date DATE NOT NULL,
  room_type VARCHAR(50),
  room_count INTEGER DEFAULT 1,
  adult_count INTEGER DEFAULT 0,
  child_count INTEGER DEFAULT 0,
  special_requests TEXT,
  base_price DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 6. tour (투어 서비스 상세)
CREATE TABLE IF NOT EXISTS tour (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tour_name VARCHAR(255) NOT NULL,
  tour_date DATE NOT NULL,
  duration_hours INTEGER,
  participant_count INTEGER DEFAULT 1,
  pickup_location VARCHAR(255),
  tour_type VARCHAR(50),
  language VARCHAR(20) DEFAULT 'korean',
  special_requests TEXT,
  base_price DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 7. rentcar (렌트카 서비스 상세)
CREATE TABLE IF NOT EXISTS rentcar (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  car_model VARCHAR(100) NOT NULL,
  pickup_date DATE NOT NULL,
  return_date DATE NOT NULL,
  pickup_location VARCHAR(255),
  return_location VARCHAR(255),
  driver_age INTEGER,
  has_driver BOOLEAN DEFAULT false,
  insurance_type VARCHAR(50),
  special_requests TEXT,
  base_price DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- room 테이블
CREATE TABLE IF NOT EXISTS room (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_code VARCHAR(50),
  base_price DECIMAL(10,2) DEFAULT 0,
  special_requests TEXT,
  adult_count INTEGER DEFAULT 0,
  child_count INTEGER DEFAULT 0,
  extra_count INTEGER DEFAULT 0,
  single_charge_count INTEGER DEFAULT 0,
  boarding_code TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- room_price 테이블
CREATE TABLE IF NOT EXISTS room_price (
  room_code TEXT NOT NULL,
  schedule TEXT,
  room_category TEXT,
  cruise TEXT,
  room_type TEXT,
  price DECIMAL(10,2),
  start_date DATE,
  end_date DATE,
  payment TEXT
);

-- car 테이블
CREATE TABLE IF NOT EXISTS car (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  car_code VARCHAR(50),
  base_price DECIMAL(10,2) DEFAULT 0,
  special_requests TEXT,
  car_count INTEGER DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- car_price 테이블
CREATE TABLE IF NOT EXISTS car_price (
  car_code TEXT NOT NULL,
  car_category TEXT,
  cruise TEXT,
  car_type TEXT,
  price DECIMAL(10,2),
  schedule TEXT,
  passenger_count TEXT
);

-- hotel_price 테이블
CREATE TABLE IF NOT EXISTS hotel_price (
  hotel_code TEXT NOT NULL,
  hotel_name TEXT,
  room_name TEXT,
  room_type TEXT,
  price DECIMAL(10,2),
  start_date DATE,
  end_date DATE,
  weekday_type TEXT
);

-- airport_price 테이블
CREATE TABLE IF NOT EXISTS airport_price (
  airport_code TEXT NOT NULL,
  airport_category TEXT,
  airport_route TEXT,
  airport_car_type TEXT,
  price DECIMAL(10,2)
);

-- rent_price 테이블
CREATE TABLE IF NOT EXISTS rent_price (
  rent_code TEXT NOT NULL,
  rent_type TEXT,
  rent_category TEXT,
  rent_route TEXT,
  rent_car_type TEXT,
  price DECIMAL(10,2)
);

-- tour_price 테이블
CREATE TABLE IF NOT EXISTS tour_price (
  tour_code TEXT NOT NULL,
  tour_name TEXT,
  tour_capacity INTEGER,
  tour_vehicle TEXT,
  tour_type TEXT,
  price DECIMAL(10,2),
  start_date DATE,
  end_date DATE
);

-- quote 테이블 컬럼 추가
ALTER TABLE quote
  ADD COLUMN IF NOT EXISTS manager_note TEXT,
  ADD COLUMN IF NOT EXISTS payment_status TEXT DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS confirmed_at TIMESTAMP WITH TIME ZONE;

-- quote_item 테이블 컬럼 추가
ALTER TABLE quote_item
  ADD COLUMN IF NOT EXISTS usage_date DATE;

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_quote_user_id ON quote(user_id);
CREATE INDEX IF NOT EXISTS idx_quote_status ON quote(status);
CREATE INDEX IF NOT EXISTS idx_quote_item_quote_id ON quote_item(quote_id);
CREATE INDEX IF NOT EXISTS idx_quote_item_service_type ON quote_item(service_type);

-- RLS (Row Level Security) 정책
ALTER TABLE quote ENABLE ROW LEVEL SECURITY;
ALTER TABLE quote_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE cruise ENABLE ROW LEVEL SECURITY;
ALTER TABLE airport ENABLE ROW LEVEL SECURITY;
ALTER TABLE hotel ENABLE ROW LEVEL SECURITY;
ALTER TABLE tour ENABLE ROW LEVEL SECURITY;
ALTER TABLE rentcar ENABLE ROW LEVEL SECURITY;

-- 정책 중복 방지: 기존 정책 삭제
DROP POLICY IF EXISTS "Users can view own quotes" ON quote;
DROP POLICY IF EXISTS "Users can insert own quotes" ON quote;
DROP POLICY IF EXISTS "Users can update own quotes" ON quote;
DROP POLICY IF EXISTS "Users can delete own quotes" ON quote;

DROP POLICY IF EXISTS "Users can view own quote items" ON quote_item;
DROP POLICY IF EXISTS "Users can insert own quote items" ON quote_item;
DROP POLICY IF EXISTS "Users can update own quote items" ON quote_item;
DROP POLICY IF EXISTS "Users can delete own quote items" ON quote_item;

DROP POLICY IF EXISTS "Users can manage cruise services" ON cruise;
DROP POLICY IF EXISTS "Users can manage airport services" ON airport;
DROP POLICY IF EXISTS "Users can manage hotel services" ON hotel;
DROP POLICY IF EXISTS "Users can manage tour services" ON tour;
DROP POLICY IF EXISTS "Users can manage rentcar services" ON rentcar;

-- 사용자는 자신의 견적만 접근 가능
CREATE POLICY "Users can view own quotes" ON quote FOR SELECT USING (auth.uid()::text = user_id::text);
CREATE POLICY "Users can insert own quotes" ON quote FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);
CREATE POLICY "Users can update own quotes" ON quote FOR UPDATE USING (auth.uid()::text = user_id::text);
CREATE POLICY "Users can delete own quotes" ON quote FOR DELETE USING (auth.uid()::text = user_id::text);

-- 견적 아이템은 해당 견적의 소유자만 접근 가능
CREATE POLICY "Users can view own quote items" ON quote_item FOR SELECT USING (
  EXISTS (SELECT 1 FROM quote WHERE quote.id = quote_item.quote_id AND quote.user_id::text = auth.uid()::text)
);
CREATE POLICY "Users can insert own quote items" ON quote_item FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM quote WHERE quote.id = quote_item.quote_id AND quote.user_id::text = auth.uid()::text)
);
CREATE POLICY "Users can update own quote items" ON quote_item FOR UPDATE USING (
  EXISTS (SELECT 1 FROM quote WHERE quote.id = quote_item.quote_id AND quote.user_id::text = auth.uid()::text)
);
CREATE POLICY "Users can delete own quote items" ON quote_item FOR DELETE USING (
  EXISTS (SELECT 1 FROM quote WHERE quote.id = quote_item.quote_id AND quote.user_id::text = auth.uid()::text)
);

-- 서비스별 테이블 정책 (공통 패턴)
CREATE POLICY "Users can manage cruise services" ON cruise FOR ALL USING (true);
CREATE POLICY "Users can manage airport services" ON airport FOR ALL USING (true);
CREATE POLICY "Users can manage hotel services" ON hotel FOR ALL USING (true);
CREATE POLICY "Users can manage tour services" ON tour FOR ALL USING (true);
CREATE POLICY "Users can manage rentcar services" ON rentcar FOR ALL USING (true);

-- 트리거 함수: updated_at 자동 업데이트
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 중복 방지: 기존 트리거 삭제
DROP TRIGGER IF EXISTS update_quote_updated_at ON quote;
DROP TRIGGER IF EXISTS update_quote_item_updated_at ON quote_item;
DROP TRIGGER IF EXISTS update_cruise_updated_at ON cruise;
DROP TRIGGER IF EXISTS update_airport_updated_at ON airport;
DROP TRIGGER IF EXISTS update_hotel_updated_at ON hotel;
DROP TRIGGER IF EXISTS update_tour_updated_at ON tour;
DROP TRIGGER IF EXISTS update_rentcar_updated_at ON rentcar;

CREATE TRIGGER update_quote_updated_at BEFORE UPDATE ON quote
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_quote_item_updated_at BEFORE UPDATE ON quote_item
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cruise_updated_at BEFORE UPDATE ON cruise
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_airport_updated_at BEFORE UPDATE ON airport
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_hotel_updated_at BEFORE UPDATE ON hotel
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tour_updated_at BEFORE UPDATE ON tour
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_rentcar_updated_at BEFORE UPDATE ON rentcar
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
