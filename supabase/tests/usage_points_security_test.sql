BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;
SELECT plan(29);

SELECT ok(NOT has_table_privilege('anon','public.user_usage_points','SELECT'), 'anon has no table SELECT');
SELECT ok(NOT has_column_privilege('anon','public.user_usage_points','user_id','SELECT'), 'anon user_id SELECT revoked');
SELECT ok(NOT has_column_privilege('anon','public.user_usage_points','ip_hash','SELECT'), 'anon ip_hash SELECT revoked');
SELECT ok(NOT has_column_privilege('anon','public.user_usage_points','points_total','SELECT'), 'anon points SELECT revoked');
SELECT ok(NOT has_table_privilege('anon','public.user_usage_points','INSERT'), 'anon has no table INSERT');
SELECT ok(NOT has_column_privilege('anon','public.user_usage_points','points_total','INSERT'), 'anon points INSERT revoked');
SELECT ok(NOT has_column_privilege('anon','public.user_usage_points','points_total','UPDATE'), 'anon points UPDATE revoked');
SELECT ok(has_column_privilege('authenticated','public.user_usage_points','points_total','SELECT'), 'authenticated own-row points remain readable');
SELECT ok(has_column_privilege('authenticated','public.user_usage_points','points_total','INSERT'), 'authenticated points remain insertable');
SELECT ok(has_column_privilege('authenticated','public.user_usage_points','points_total','UPDATE'), 'authenticated points remain updateable');
SELECT ok(NOT (SELECT convalidated FROM pg_constraint WHERE conname = 'user_usage_points_nonnegative_counters'), 'counter constraint is staged NOT VALID');
SELECT ok(NOT (SELECT convalidated FROM pg_constraint WHERE conname = 'user_usage_points_bounded_hash'), 'hash constraint is staged NOT VALID');

INSERT INTO auth.users(id,email,email_confirmed_at,raw_user_meta_data) VALUES
  ('30000000-0000-0000-0000-000000000001','usage-owner@example.test',now(),'{}'),
  ('30000000-0000-0000-0000-000000000002','usage-other@example.test',now(),'{}');

SET LOCAL ROLE anon;
SELECT throws_ok($$SELECT points_total FROM public.user_usage_points$$, '42501', 'anon REST-equivalent read denied');
SELECT throws_ok($$INSERT INTO public.user_usage_points(ip_hash) VALUES('anon_denied')$$, '42501', 'anon REST-equivalent write denied');
RESET ROLE;

SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":"30000000-0000-0000-0000-000000000001","role":"authenticated"}';
SELECT lives_ok($$INSERT INTO public.user_usage_points(user_id,ip_hash,points_total,program_views_count)
  VALUES('30000000-0000-0000-0000-000000000001','anon_owner1',10,1)$$, 'owner can insert valid telemetry');
SELECT is((SELECT points_total FROM public.user_usage_points WHERE ip_hash='anon_owner1'), 10, 'owner can read own telemetry');
SELECT lives_ok($$INSERT INTO public.user_usage_points(user_id,ip_hash,points_total)
  VALUES('30000000-0000-0000-0000-000000000001','anon_owner1',20)
  ON CONFLICT(user_id,ip_hash) DO UPDATE SET points_total=EXCLUDED.points_total$$, 'owner upsert remains valid');
SELECT is((SELECT points_total FROM public.user_usage_points WHERE ip_hash='anon_owner1'), 20, 'owner upsert changes own telemetry');
SELECT is((SELECT count(*)::integer FROM public.user_usage_points WHERE user_id='30000000-0000-0000-0000-000000000002'), 0, 'cross-user rows are unreadable');
SELECT lives_ok($$UPDATE public.user_usage_points SET points_total=99 WHERE user_id='30000000-0000-0000-0000-000000000002'$$, 'cross-user update reveals no row');
SELECT throws_ok($$UPDATE public.user_usage_points SET user_id='30000000-0000-0000-0000-000000000002' WHERE ip_hash='anon_owner1'$$, '42501', 'ownership transfer denied');
SELECT throws_ok($$INSERT INTO public.user_usage_points(user_id,ip_hash) VALUES('30000000-0000-0000-0000-000000000002','anon_cross')$$, '42501', 'cross-user insert denied');
SELECT throws_ok($$INSERT INTO public.user_usage_points(user_id,ip_hash,points_total) VALUES('30000000-0000-0000-0000-000000000001','anon_negative',-1)$$, '23514', 'negative points denied');
SELECT throws_ok($$INSERT INTO public.user_usage_points(user_id,ip_hash,map_views_count) VALUES('30000000-0000-0000-0000-000000000001','anon_negative2',-1)$$, '23514', 'negative counters denied');
SELECT throws_ok($$INSERT INTO public.user_usage_points(user_id,ip_hash) VALUES('30000000-0000-0000-0000-000000000001','forged')$$, '23514', 'malformed telemetry hash denied');
SELECT lives_ok($$UPDATE public.user_usage_points SET points_total=0 WHERE ip_hash='anon_owner1'$$, 'legitimate zero reset succeeds');
SELECT is((SELECT points_total FROM public.user_usage_points WHERE ip_hash='anon_owner1'), 0, 'zero reset is retained');
SELECT throws_ok($$INSERT INTO public.user_usage_points(user_id,ip_hash,has_donated) VALUES('30000000-0000-0000-0000-000000000001','anon_forgedpaid',true)$$, '42501', 'browser cannot forge paid status');
SELECT throws_ok($$UPDATE public.user_usage_points SET total_donated_usd=999 WHERE ip_hash='anon_owner1'$$, '42501', 'browser cannot forge donated amount');

SELECT * FROM finish();
ROLLBACK;
