-- Analytics RPC functions to aggregate full datasets server-side (avoid 1000-row limit)
-- Run this file in Supabase SQL editor or psql once to create the functions.

-- 1) Quotes summary
create or replace function public.analytics_quotes_summary()
returns jsonb
language sql
stable
as $$
with q as (
  select created_at, status, total_price from public.quote
),
total_count as (
  select count(*)::bigint as c from q
),
recent30 as (
  select count(*)::bigint as c from q where created_at >= now() - interval '30 days'
),
by_status as (
  select jsonb_build_object(
    'approved', coalesce(sum((status = 'approved')::int), 0),
    'pending',  coalesce(sum((status = 'pending')::int), 0),
    'draft',    coalesce(sum((status = 'draft')::int), 0),
    'rejected', coalesce(sum((status = 'rejected')::int), 0)
  ) as obj
  from q
),
sum_price as (
  select coalesce(sum(total_price), 0)::numeric as total_value from q
),
avg_value as (
  select case when (select c from total_count) > 0
              then round((select total_value from sum_price) / (select c from total_count))::bigint
              else 0 end as avg_value
),
trend as (
  select jsonb_agg(jsonb_build_object('date', to_char(d, 'YYYY-MM-DD'), 'count', coalesce(s.cnt, 0)) order by d) as arr
  from (
    select g::date as d
    from generate_series(current_date - interval '6 days', current_date, interval '1 day') g
  ) days
  left join (
    select date_trunc('day', created_at)::date as d, count(*)::bigint as cnt
    from q
    where created_at >= current_date - interval '6 days'
    group by 1
  ) s using (d)
)
select jsonb_build_object(
  'total',       (select c from total_count),
  'recent30',    (select c from recent30),
  'byStatus',    (select obj from by_status),
  'totalValue',  (select total_value from sum_price),
  'avgValue',    (select avg_value from avg_value),
  'trend7d',     (select arr from trend)
);
$$;

-- 2) Reservations summary
create or replace function public.analytics_reservations_summary()
returns jsonb
language sql
stable
as $$
with r as (
  select re_id, re_status, re_type, re_created_at, re_user_id from public.reservation
),
total_count as (
  select count(*)::bigint as c from r
),
recent30 as (
  select count(*)::bigint as c from r where re_created_at >= now() - interval '30 days'
),
customers as (
  select count(distinct re_user_id)::bigint as c from r
),
by_status as (
  select jsonb_build_object(
    'confirmed', coalesce(sum((re_status = 'confirmed')::int), 0),
    'pending',   coalesce(sum((re_status = 'pending')::int), 0),
    'cancelled', coalesce(sum((re_status = 'cancelled')::int), 0)
  ) as obj
  from r
),
by_type as (
  select coalesce(jsonb_object_agg(re_type, cnt), '{}'::jsonb) as obj
  from (
    select re_type, count(*)::bigint as cnt from r group by re_type
  ) s
),
trend as (
  select jsonb_agg(jsonb_build_object('date', to_char(d, 'YYYY-MM-DD'), 'count', coalesce(s.cnt, 0)) order by d) as arr
  from (
    select g::date as d
    from generate_series(current_date - interval '6 days', current_date, interval '1 day') g
  ) days
  left join (
    select date_trunc('day', re_created_at)::date as d, count(*)::bigint as cnt
    from r
    where re_created_at >= current_date - interval '6 days'
    group by 1
  ) s using (d)
),
monthly as (
  with months as (
    select date_trunc('month', dd)::date as m
    from generate_series(date_trunc('year', current_date)::date, (date_trunc('year', current_date) + interval '11 months')::date, interval '1 month') dd
  ),
  counts as (
    select date_trunc('month', re_created_at)::date as m, count(*)::bigint as cnt
    from r
    where date_trunc('year', re_created_at) = date_trunc('year', current_date)
    group by 1
  )
  select jsonb_agg(
           jsonb_build_object('month', (extract(month from m)::int)::text || '월', 'count', coalesce(cnt, 0))
           order by m
         ) as arr,
         coalesce(max(coalesce(cnt, 0)), 0) as maxcnt
  from months
  left join counts using (m)
)
select jsonb_build_object(
  'total',        (select c from total_count),
  'recent30',     (select c from recent30),
  'customers',    (select c from customers),
  'byStatus',     (select obj from by_status),
  'byType',       (select obj from by_type),
  'trend7d',      (select arr from trend),
  'monthlyTrend', (select arr from monthly),
  'maxMonthlyCount', (select maxcnt from monthly)
);
$$;

-- 3) Payments summary
create or replace function public.analytics_payments_summary()
returns jsonb
language sql
stable
as $$
with p as (
  select id, amount, payment_status, payment_method, created_at from public.reservation_payment
),
total as (
  select count(*)::bigint as c from p
),
sum_amount as (
  select coalesce(sum(amount), 0)::numeric as s from p
),
avg_amount as (
  select case when (select c from total) > 0 then round((select s from sum_amount) / (select c from total))::bigint else 0 end as a
),
recent30 as (
  select count(*)::bigint as c from p where created_at >= now() - interval '30 days'
),
by_status as (
  select jsonb_build_object(
    'completed', coalesce(sum((payment_status = 'completed')::int), 0),
    'pending',   coalesce(sum((payment_status = 'pending')::int), 0),
    'failed',    coalesce(sum((payment_status = 'failed')::int), 0)
  ) as obj
  from p
),
by_method as (
  -- include common methods explicitly with zero defaults
  select (
    coalesce(jsonb_object_agg(payment_method, cnt), '{}'::jsonb)
    || jsonb_build_object('card', 0, 'transfer', 0, 'cash', 0)
  ) as obj
  from (
    select payment_method, count(*)::bigint as cnt from p group by payment_method
  ) s
),
trend as (
  select jsonb_agg(jsonb_build_object('date', to_char(d, 'YYYY-MM-DD'), 'count', coalesce(s.cnt, 0)) order by d) as arr
  from (
    select g::date as d
    from generate_series(current_date - interval '6 days', current_date, interval '1 day') g
  ) days
  left join (
    select date_trunc('day', created_at)::date as d, count(*)::bigint as cnt
    from p
    where created_at >= current_date - interval '6 days'
    group by 1
  ) s using (d)
)
select jsonb_build_object(
  'total',       (select c from total),
  'totalAmount', (select s from sum_amount),
  'avgAmount',   (select a from avg_amount),
  'recent30',    (select c from recent30),
  'byStatus',    (select obj from by_status),
  'byMethod',    (select obj from by_method),
  'trend7d',     (select arr from trend)
);
$$;

-- 4) Confirmations summary (based on completed/paid payments as proxy)
create or replace function public.analytics_confirmations_summary()
returns jsonb
language sql
stable
as $$
with pc as (
  select id, reservation_id, payment_status, created_at
  from public.reservation_payment
  where payment_status in ('completed', 'paid')
),
total as (
  select count(*)::bigint as c from pc
),
recent30 as (
  select count(*)::bigint as c from pc where created_at >= now() - interval '30 days'
),
by_type as (
  select coalesce(jsonb_object_agg(re_type, cnt), '{}'::jsonb) as obj
  from (
    select r.re_type, count(*)::bigint as cnt
    from pc
    join public.reservation r on r.re_id = pc.reservation_id
    group by r.re_type
  ) s
),
by_status as (
  select jsonb_build_object('sent', (select c from total), 'pending', 0) as obj
),
trend as (
  select jsonb_agg(jsonb_build_object('date', to_char(d, 'YYYY-MM-DD'), 'count', coalesce(s.cnt, 0)) order by d) as arr
  from (
    select g::date as d
    from generate_series(current_date - interval '6 days', current_date, interval '1 day') g
  ) days
  left join (
    select date_trunc('day', created_at)::date as d, count(*)::bigint as cnt
    from pc
    where created_at >= current_date - interval '6 days'
    group by 1
  ) s using (d)
)
select jsonb_build_object(
  'total',     (select c from total),
  'recent30',  (select c from recent30),
  'byType',    (select obj from by_type),
  'byStatus',  (select obj from by_status),
  'trend7d',   (select arr from trend)
);
$$;
