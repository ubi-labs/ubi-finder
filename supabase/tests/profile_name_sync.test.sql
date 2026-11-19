BEGIN;

CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;
SET LOCAL search_path = public, extensions;
SELECT plan(21);

INSERT INTO auth.users (id, email, raw_user_meta_data)
VALUES
  ('41000000-0000-4000-8000-000000000001', 'name-sync-one@example.test',
    '{"full_name":"Signup name","name":"Secondary signup name"}'),
  ('41000000-0000-4000-8000-000000000002', 'name-sync-two@example.test',
    '{"name":"Fallback signup name"}'),
  ('41000000-0000-4000-8000-000000000003', 'name-sync-three@example.test', '{}');

SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'Signup name', 'creation initializes the public name from full_name');
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000002'),
  'Fallback signup name', 'creation falls back to name metadata');
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000003'),
  'Member', 'creation without name metadata retains the Member fallback');

UPDATE public.users SET full_name = 'Chosen public name'
WHERE id = '41000000-0000-4000-8000-000000000001';
UPDATE auth.users SET last_sign_in_at = now()
WHERE id = '41000000-0000-4000-8000-000000000001';
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'Chosen public name', 'sign-in updates do not restore stale signup names');

UPDATE auth.users SET email = 'name-sync-updated@example.test'
WHERE id = '41000000-0000-4000-8000-000000000001';
SELECT is((SELECT email FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'name-sync-updated@example.test', 'email continues to synchronize');
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'Chosen public name', 'email changes preserve the public name');

UPDATE auth.users SET raw_user_meta_data = raw_user_meta_data || '{"profile_id":"unrelated-profile-reference"}'
WHERE id = '41000000-0000-4000-8000-000000000001';
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'Chosen public name', 'unrelated metadata updates preserve the public name');

UPDATE auth.users SET raw_user_meta_data = '{"full_name":"Different Auth name","name":"Different fallback name"}'
WHERE id = '41000000-0000-4000-8000-000000000001';
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'Chosen public name', 'Auth name changes do not implicitly edit the public profile');

UPDATE auth.users SET raw_user_meta_data = NULL
WHERE id = '41000000-0000-4000-8000-000000000001';
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'Chosen public name', 'missing metadata cannot replace a chosen name with Member');

UPDATE auth.users SET raw_user_meta_data = '{"full_name":null,"name":null}'
WHERE id = '41000000-0000-4000-8000-000000000001';
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'Chosen public name', 'null metadata name fields preserve the public name');

UPDATE public.users SET full_name = 'New intentional public name'
WHERE id = '41000000-0000-4000-8000-000000000001';
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'New intentional public name', 'an intentional public name edit still succeeds');
UPDATE auth.users SET last_sign_in_at = now()
WHERE id = '41000000-0000-4000-8000-000000000001';
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'New intentional public name', 'later Auth updates preserve the intentional edit');

UPDATE public.users SET role = 'admin'
WHERE id = '41000000-0000-4000-8000-000000000001';
UPDATE auth.users SET raw_user_meta_data = '{"full_name":"Another stale name"}'
WHERE id = '41000000-0000-4000-8000-000000000001';
SELECT is((SELECT role::text FROM public.users WHERE id = '41000000-0000-4000-8000-000000000001'),
  'admin', 'Auth sync preserves existing roles');

INSERT INTO public.users (id, email, full_name, role)
VALUES ('41000000-0000-4000-8000-000000000004', 'legacy-before@example.test', 'Legacy chosen name', 'admin');
INSERT INTO auth.users (id, email, raw_user_meta_data)
VALUES ('41000000-0000-4000-8000-000000000004', 'legacy-after@example.test', '{"full_name":"Stale legacy metadata"}');
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000004'),
  'Legacy chosen name', 'an insert conflict preserves a pre-existing public name');
SELECT is((SELECT role::text FROM public.users WHERE id = '41000000-0000-4000-8000-000000000004'),
  'admin', 'an insert conflict preserves the existing role');
SELECT is((SELECT email FROM public.users WHERE id = '41000000-0000-4000-8000-000000000004'),
  'legacy-after@example.test', 'an insert conflict still synchronizes email');

DELETE FROM public.users WHERE id = '41000000-0000-4000-8000-000000000003';
UPDATE auth.users SET raw_user_meta_data = '{"full_name":"Recovered initial name"}'
WHERE id = '41000000-0000-4000-8000-000000000003';
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000003'),
  'Recovered initial name', 'an Auth update initializes a missing public row');

UPDATE public.users SET full_name = ''
WHERE id = '41000000-0000-4000-8000-000000000002';
UPDATE auth.users SET raw_user_meta_data = '{}'
WHERE id = '41000000-0000-4000-8000-000000000002';
SELECT is((SELECT full_name FROM public.users WHERE id = '41000000-0000-4000-8000-000000000002'),
  '', 'an existing blank public name is not silently rewritten');

INSERT INTO public.user_profiles (id, name, gender, country, household_size, income_range, created_by_id)
VALUES ('41000000-0000-4000-8000-000000000005', 'Chosen editable profile name', 'abstain',
  'Canada', 1, '0-20k', '41000000-0000-4000-8000-000000000002');
UPDATE auth.users SET last_sign_in_at = now()
WHERE id = '41000000-0000-4000-8000-000000000002';
SELECT is((SELECT name FROM public.user_profiles WHERE id = '41000000-0000-4000-8000-000000000005'),
  'Chosen editable profile name', 'Auth updates preserve the editable public profile');

SET LOCAL request.jwt.claim.sub = '41000000-0000-4000-8000-000000000002';
SET LOCAL ROLE authenticated;
UPDATE public.user_profiles SET name = 'Explicit own profile edit'
WHERE id = '41000000-0000-4000-8000-000000000005';
RESET ROLE;
SELECT is((SELECT name FROM public.user_profiles WHERE id = '41000000-0000-4000-8000-000000000005'),
  'Explicit own profile edit', 'the signed-in owner can still edit the profile name');
UPDATE auth.users SET raw_user_meta_data = '{"full_name":"Stale after explicit edit"}'
WHERE id = '41000000-0000-4000-8000-000000000002';
SELECT is((SELECT name FROM public.user_profiles WHERE id = '41000000-0000-4000-8000-000000000005'),
  'Explicit own profile edit', 'an intentional profile edit survives the next Auth update');

SELECT * FROM finish();
ROLLBACK;
