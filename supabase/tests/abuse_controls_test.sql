BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;
SELECT plan(19);
SELECT ok(NOT has_table_privilege('anon','public.programs','SELECT'),'anonymous table reads revoked');
SELECT ok(NOT has_function_privilege('anon','public.read_program_catalog(text,uuid,integer,integer,integer)','EXECUTE'),'anonymous cannot invoke service RPC');
SELECT ok(NOT has_function_privilege('authenticated','public.read_program_catalog(text,uuid,integer,integer,integer)','EXECUTE'),'authenticated cannot bypass gateway quotas');
SELECT ok(NOT has_function_privilege('anon','public.before_user_created_abuse_check(jsonb)','EXECUTE'),'signup hook cannot be forged');
SELECT ok(has_function_privilege('supabase_auth_admin','public.before_user_created_abuse_check(jsonb)','EXECUTE'),'Auth service can run hook');
SELECT is(public.before_user_created_abuse_check('{"metadata":{"ip_address":"192.0.2.1"}}')->>'error',NULL,'first creation allowed');
DO $$ BEGIN FOR i IN 1..4 LOOP PERFORM public.before_user_created_abuse_check('{"metadata":{"ip_address":"192.0.2.1"}}'); END LOOP; END $$;
SELECT is((public.before_user_created_abuse_check('{"metadata":{"ip_address":"192.0.2.1"}}')->'error'->>'http_code')::integer,429,'sixth signup throttled');
SELECT is((public.before_user_created_abuse_check('{"metadata":{}}')->'error'->>'http_code')::integer,429,'missing signup source fails closed');
SELECT throws_ok($$SELECT public.read_program_catalog('192.0.2.2',NULL,1)$$,'28000','Verified sign-in required','guest cannot read full detail');
SELECT throws_ok($$SELECT public.read_program_catalog('192.0.2.2',NULL,NULL,0,21)$$,'P0001','Invalid catalog request','page size bounded');
SELECT ok(jsonb_array_length(public.read_program_catalog('192.0.2.2')->'programs')<=20,'public page bounded');
SELECT ok(NOT ((public.read_program_catalog('192.0.2.2')->'programs'->0) ? 'submitter_email'),'summary excludes submitter data');
INSERT INTO abuse_private.buckets VALUES ('expired-test',now()-interval '2 days',now()-interval '1 second',1);
SELECT abuse_private.cleanup();
SELECT is((SELECT count(*)::integer FROM abuse_private.buckets WHERE key='expired-test'),0,'expired counters cleaned');
SELECT ok(EXISTS(SELECT 1 FROM cron.job WHERE jobname='ubi-abuse-one-day-cleanup' AND schedule='* * * * *'),'minute cleanup scheduled');
SELECT is(abuse_private.ip_key('2001:db8::1'),abuse_private.ip_key('2001:db8::2'),'IPv6 address rotation within a /64 shares quotas');
-- Canonical IPs share a quota even if IPv6 spelling differs.
SELECT is(abuse_private.ip_key('2001:db8::1'),abuse_private.ip_key('2001:0db8:0:0:0:0:0:1'),'IPv6 canonicalization');
INSERT INTO auth.users(id,email,email_confirmed_at,raw_user_meta_data)
 VALUES('12345678-1234-1234-1234-123456789abc','sql-abuse@example.test',now(),'{}');
INSERT INTO abuse_private.detail_reads(key,program_id)
 SELECT 'user:12345678-1234-1234-1234-123456789abc',-i FROM generate_series(1,100) i;
SELECT throws_ok(format('SELECT public.read_program_catalog(%L,%L::uuid,%s)','192.0.2.9','12345678-1234-1234-1234-123456789abc',(SELECT min(program_id) FROM public.programs WHERE internal_status='active')),'P0001','Request quota exceeded','daily unique-program quota enforced');
SELECT ok((SELECT max(program_id) FROM public.programs)<public.next_program_number(),'new IDs do not collide with seeded/imported IDs');
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":"12345678-1234-1234-1234-123456789abc","role":"authenticated"}';
SELECT is((SELECT count(*)::integer FROM public.programs),0,'ordinary authenticated raw reads blocked');
RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
