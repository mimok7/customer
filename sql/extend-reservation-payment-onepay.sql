-- Extend reservation_payment to store gateway transaction details
-- Safe to run multiple times (IF NOT EXISTS guards where supported)

ALTER TABLE IF EXISTS reservation_payment
  ADD COLUMN IF NOT EXISTS transaction_id text,
  ADD COLUMN IF NOT EXISTS gateway text,
  ADD COLUMN IF NOT EXISTS raw_response jsonb;

-- Optional indexes for search/diagnostics
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'idx_reservation_payment_transaction_id' AND n.nspname = 'public'
  ) THEN
    CREATE INDEX idx_reservation_payment_transaction_id ON reservation_payment(transaction_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'idx_reservation_payment_gateway' AND n.nspname = 'public'
  ) THEN
    CREATE INDEX idx_reservation_payment_gateway ON reservation_payment(gateway);
  END IF;
END $$;

COMMENT ON COLUMN reservation_payment.transaction_id IS 'PG 거래 식별자(vpc_TransactionNo 등)';
COMMENT ON COLUMN reservation_payment.gateway IS '결제 게이트웨이 식별 (onepay, ... )';
COMMENT ON COLUMN reservation_payment.raw_response IS '게이트웨이 응답 전문(JSON)';
