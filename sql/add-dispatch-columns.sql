-- Add pickup confirmation timestamp and dispatch memo columns to dispatch-related tables
-- Run this in Supabase SQL Editor

alter table if exists reservation_car_sht
  add column if not exists pickup_confirmed_at timestamptz null,
  add column if not exists dispatch_memo text null;

alter table if exists reservation_cruise_car
  add column if not exists pickup_confirmed_at timestamptz null,
  add column if not exists dispatch_memo text null;

alter table if exists reservation_rentcar
  add column if not exists pickup_confirmed_at timestamptz null,
  add column if not exists dispatch_memo text null;

alter table if exists reservation_airport
  add column if not exists pickup_confirmed_at timestamptz null,
  add column if not exists dispatch_memo text null;
