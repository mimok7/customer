-- Slow query and index diagnostics for Supabase/Postgres
-- Usage: Run in Supabase SQL editor or psql

-- 1) Ensure pg_stat_statements is available
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- 2) Top slow queries (by mean time)
SELECT
  queryid,
  calls,
  round(total_exec_time::numeric, 2) AS total_ms,
  round(mean_exec_time::numeric, 2)  AS mean_ms,
  rows,
  query
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 50;

-- 3) Most time-consuming queries (by total time)
SELECT
  queryid,
  calls,
  round(total_exec_time::numeric, 2) AS total_ms,
  round(mean_exec_time::numeric, 2)  AS mean_ms,
  rows,
  query
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 50;

-- 4) Tables with heavy sequential scans (candidates for indexing)
SELECT
  relname AS table,
  seq_scan,
  idx_scan,
  n_live_tup AS rows_live
FROM pg_stat_user_tables
ORDER BY seq_scan DESC
LIMIT 50;

-- 5) Index usage stats
SELECT
  schemaname,
  relname   AS table,
  indexrelname AS index,
  idx_scan,
  idx_tup_read,
  idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC
LIMIT 50;

-- 6) Reset stats (optional; run, then reproduce workload and re-check)
-- SELECT pg_stat_statements_reset();

-- 7) EXPLAIN template examples (replace placeholders and run separately)
-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT * FROM reservation
-- WHERE re_user_id = '<USER_ID>'
-- ORDER BY re_created_at DESC
-- LIMIT 50;

-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT r.*
-- FROM reservation_airport ra
-- JOIN reservation r ON r.re_id = ra.reservation_id
-- WHERE r.re_user_id = '<USER_ID>'
--   AND ra.ra_datetime >= now() - interval '30 days';
