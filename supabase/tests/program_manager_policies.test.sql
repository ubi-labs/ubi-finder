BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;
SELECT plan(16);

SELECT ok(
  NOT has_function_privilege('anon', 'abuse_private.can_access_program_manager(integer,text,boolean)', 'EXECUTE'),
  'anonymous callers cannot execute the manager authority helper'
);
SELECT ok(
  has_function_privilege('authenticated', 'abuse_private.can_access_program_manager(integer,text,boolean)', 'EXECUTE'),
  'authenticated policies can execute the manager authority helper'
);

INSERT INTO auth.users(id,email,email_confirmed_at,raw_user_meta_data) VALUES
  ('45000000-0000-0000-0000-000000000001','manager-creator@example.test',now(),'{}'),
  ('45000000-0000-0000-0000-000000000002','manager-owner@example.test',now(),'{}'),
  ('45000000-0000-0000-0000-000000000003','manager-admin@example.test',now(),'{}'),
  ('45000000-0000-0000-0000-000000000004','manager-outsider@example.test',now(),'{}'),
  ('45000000-0000-0000-0000-000000000005','other-creator@example.test',now(),'{}');

INSERT INTO public.programs(
  program_id,name,organization,description,monthly_amount_usd,currency,
  available_regions,payment_method,amount_description,status,created_by_id
) VALUES
  (45001,'Manager policy one','Test','Test program',1,'USD','{Global}','standard','Test','active_open','45000000-0000-0000-0000-000000000001'),
  (45002,'Manager policy two','Test','Test program',1,'USD','{Global}','standard','Test','active_open','45000000-0000-0000-0000-000000000005');

INSERT INTO public.program_managers(program_id,user_email,role,created_by_id) VALUES
  (45001,'manager-owner@example.test','owner','45000000-0000-0000-0000-000000000001'),
  (45001,'private-manager@example.test','admin','45000000-0000-0000-0000-000000000001'),
  (45002,'manager-admin@example.test','admin','45000000-0000-0000-0000-000000000005');

SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":"45000000-0000-0000-0000-000000000001","role":"authenticated"}';
SELECT lives_ok($$INSERT INTO public.programs(
  program_id,name,organization,description,monthly_amount_usd,currency,
  available_regions,payment_method,amount_description,status,created_by_id
) VALUES (45003,'Creator submission','Test','Test program',1,'USD','{Global}',
  'standard','Test','active_open','45000000-0000-0000-0000-000000000001')$$,
  'authenticated creator can insert a program');
SELECT lives_ok($$INSERT INTO public.program_managers(program_id,user_email,role,created_by_id)
  VALUES(45003,'manager-creator@example.test','owner','45000000-0000-0000-0000-000000000001')$$,
  'creator can create the initial owner association');
SELECT is((SELECT count(*)::integer FROM public.program_managers WHERE program_id=45003),1,
  'creator can read back the owner association');

SET LOCAL request.jwt.claims = '{"sub":"45000000-0000-0000-0000-000000000002","role":"authenticated"}';
SELECT is((SELECT count(*)::integer FROM public.program_managers WHERE program_id=45001),2,
  'existing owner can list manager rows for the managed program');
SELECT lives_ok($$INSERT INTO public.program_managers(program_id,user_email,role,created_by_id)
  VALUES(45001,'delegated-admin@example.test','admin','45000000-0000-0000-0000-000000000002')$$,
  'existing owner can add an admin manager row');
SELECT is((SELECT count(*)::integer FROM public.program_managers WHERE program_id=45001),3,
  'owner can read the newly delegated admin row');
SELECT throws_ok($$UPDATE public.program_managers SET program_id=45002
  WHERE program_id=45001 AND user_email='manager-owner@example.test'$$,
  '42501',NULL,'cross-program membership transfer is denied');
SELECT lives_ok($$DELETE FROM public.program_managers
  WHERE program_id=45001 AND user_email='delegated-admin@example.test'$$,
  'existing owner can remove a delegated admin row');

SET LOCAL request.jwt.claims = '{"sub":"45000000-0000-0000-0000-000000000003","role":"authenticated"}';
SELECT is((SELECT count(*)::integer FROM public.program_managers WHERE program_id=45002),1,
  'existing admin manager can list the managed program');
SELECT lives_ok($$INSERT INTO public.program_managers(program_id,user_email,role,created_by_id)
  VALUES(45002,'delegated-owner@example.test','owner','45000000-0000-0000-0000-000000000003')$$,
  'existing admin manager can add an owner manager row');
SELECT is((SELECT count(*)::integer FROM public.program_managers WHERE program_id=45002),2,
  'admin manager can read the delegated owner row');

SET LOCAL request.jwt.claims = '{"sub":"45000000-0000-0000-0000-000000000004","role":"authenticated"}';
SELECT is((SELECT count(*)::integer FROM public.program_managers),0,
  'unrelated users cannot enumerate another manager private rows');
SELECT throws_ok($$INSERT INTO public.program_managers(program_id,user_email,role,created_by_id)
  VALUES(45001,'manager-outsider@example.test','owner','45000000-0000-0000-0000-000000000004')$$,
  '42501',NULL,'unrelated users cannot self-appoint by email');
SELECT is((SELECT count(*)::integer FROM public.program_managers WHERE user_email='private-manager@example.test'),0,
  'unrelated users cannot read a private manager row');

SELECT * FROM finish();
ROLLBACK;
