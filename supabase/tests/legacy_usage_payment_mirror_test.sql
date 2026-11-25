BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;
SELECT plan(34);

CREATE TEMP TABLE captured_usage_constraints ON COMMIT DROP AS
SELECT conname, pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'public.user_usage_points'::regclass
  AND conname IN ('user_usage_points_nonnegative_counters', 'user_usage_points_bounded_hash');
SELECT is((SELECT count(*)::integer FROM captured_usage_constraints), 2, 'both staged usage constraints captured');

ALTER TABLE public.user_usage_points
  DROP CONSTRAINT user_usage_points_nonnegative_counters,
  DROP CONSTRAINT user_usage_points_bounded_hash;

INSERT INTO auth.users(id,email,email_confirmed_at,raw_user_meta_data) VALUES
  ('46000000-0000-0000-0000-000000000001','legacy-stripe@example.test',now(),'{}'),
  ('46000000-0000-0000-0000-000000000002','legacy-crypto@example.test',now(),'{}');

-- Representative pre-00044 state: invalid ordinary telemetry and an invalid
-- trusted-sentinel collision coexist with valid rows and must remain untouched.
INSERT INTO public.user_usage_points(user_id,ip_hash,points_total,map_views_count) VALUES
  ('46000000-0000-0000-0000-000000000001','legacy stripe hash',-1,0),
  ('46000000-0000-0000-0000-000000000001','anon_stripevalid',2,1),
  ('46000000-0000-0000-0000-000000000002','legacy crypto hash',0,-1),
  ('46000000-0000-0000-0000-000000000002','ip_abc123',3,1),
  ('46000000-0000-0000-0000-000000000002','verified_donor',-1,0);

DO $$
DECLARE item record;
BEGIN
  FOR item IN SELECT * FROM captured_usage_constraints ORDER BY conname LOOP
    EXECUTE format('ALTER TABLE public.user_usage_points ADD CONSTRAINT %I %s', item.conname, item.definition);
  END LOOP;
END;
$$;

SELECT ok(NOT (SELECT convalidated FROM pg_constraint WHERE conname='user_usage_points_nonnegative_counters'), 'restored counter constraint remains NOT VALID');
SELECT ok(NOT (SELECT convalidated FROM pg_constraint WHERE conname='user_usage_points_bounded_hash'), 'restored hash constraint remains NOT VALID');
SELECT ok(NOT has_function_privilege('anon','abuse_private.usage_counters_are_valid(integer,integer,integer,integer)','EXECUTE'), 'anon cannot execute counter validator');
SELECT ok(has_function_privilege('authenticated','abuse_private.usage_counters_are_valid(integer,integer,integer,integer)','EXECUTE'), 'authenticated checks can execute counter validator');
SELECT ok(has_function_privilege('authenticated','abuse_private.usage_hash_is_valid(text)','EXECUTE'), 'authenticated checks can execute hash validator');
SELECT ok(NOT has_function_privilege('service_role','abuse_private.mirror_supporter_payment(uuid,bigint)','EXECUTE'), 'service role cannot call mirror helper directly');
SELECT ok(NOT has_function_privilege('anon','public.fulfill_stripe_donation(text,text,text,integer,boolean,text)','EXECUTE'), 'anon cannot fulfill Stripe donations');
SELECT ok(NOT has_function_privilege('authenticated','public.confirm_crypto_donation(uuid,integer,boolean,text)','EXECUTE'), 'authenticated cannot confirm crypto donations');

SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT abuse_private.mirror_supporter_payment('46000000-0000-0000-0000-000000000001',500)$$,
  '42501', NULL, 'authenticated callers cannot invoke mirror helper'
);
SELECT throws_ok(
  $$SELECT public.fulfill_stripe_donation('forged','forged','forged',500,false,NULL)$$,
  '42501', NULL, 'authenticated callers cannot invoke trusted fulfillment'
);
RESET ROLE;

INSERT INTO public.supporter_accounts(donor_key,user_id,total_cents,livemode)
VALUES('test:user:46000000-0000-0000-0000-000000000001','46000000-0000-0000-0000-000000000001',0,false);
INSERT INTO public.donation_checkouts(donor_key,stripe_session_id,amount_cents,livemode)
VALUES('test:user:46000000-0000-0000-0000-000000000001','cs_test_legacy_usage',500,false);

SELECT is(public.fulfill_stripe_donation(
  'evt_legacy_usage','cs_test_legacy_usage','pi_legacy_usage',500,false,'https://pay.stripe.com/receipts/legacy'
), true, 'Stripe fulfillment succeeds around invalid legacy telemetry');
SELECT is((SELECT total_cents FROM public.supporter_accounts WHERE donor_key='test:user:46000000-0000-0000-0000-000000000001'),500::bigint,'Stripe authoritative credit succeeds');
SELECT is((SELECT status FROM public.donation_checkouts WHERE stripe_session_id='cs_test_legacy_usage'),'completed','Stripe checkout completes');
SELECT is((SELECT count(*)::integer FROM public.stripe_payment_events WHERE event_id='evt_legacy_usage'),1,'Stripe event is recorded once');
SELECT is((SELECT count(*)::integer FROM public.donations WHERE stripe_session_id='cs_test_legacy_usage'),1,'Stripe donation is recorded once');
SELECT is((SELECT points_total FROM public.user_usage_points WHERE user_id='46000000-0000-0000-0000-000000000001' AND ip_hash='legacy stripe hash'),-1,'invalid Stripe telemetry counter is unchanged');
SELECT is((SELECT has_donated FROM public.user_usage_points WHERE user_id='46000000-0000-0000-0000-000000000001' AND ip_hash='legacy stripe hash'),false,'invalid Stripe telemetry payment flag is unchanged');
SELECT is((SELECT total_donated_usd FROM public.user_usage_points WHERE user_id='46000000-0000-0000-0000-000000000001' AND ip_hash='anon_stripevalid'),5.00::numeric,'valid Stripe telemetry mirrors payment');
SELECT is((SELECT total_donated_usd FROM public.user_usage_points WHERE user_id='46000000-0000-0000-0000-000000000001' AND ip_hash='verified_donor'),5.00::numeric,'missing Stripe sentinel is created');
SELECT is(public.fulfill_stripe_donation(
  'evt_legacy_usage','cs_test_legacy_usage','pi_legacy_usage',500,false,'https://pay.stripe.com/receipts/legacy'
), false, 'Stripe replay remains idempotent');
SELECT is((SELECT total_cents FROM public.supporter_accounts WHERE donor_key='test:user:46000000-0000-0000-0000-000000000001'),500::bigint,'Stripe replay does not duplicate credit');

INSERT INTO public.supporter_accounts(donor_key,user_id,total_cents,livemode)
VALUES('test:user:46000000-0000-0000-0000-000000000002','46000000-0000-0000-0000-000000000002',0,false);
INSERT INTO public.support_donations(
  id,user_id,amount_usd,donor_name,payment_method,status,notes,public_recognition,
  crypto_donor_key,crypto_chain,transaction_hash,livemode,review_status,review_due_at
) VALUES(
  '46000000-0000-0000-0000-000000000099','46000000-0000-0000-0000-000000000002',10,
  'Legacy Crypto','crypto','pledged','Pending review',false,
  'test:user:46000000-0000-0000-0000-000000000002','ethereum',
  '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',false,
  'pending_review',now()+interval '7 days'
);

SELECT is(public.confirm_crypto_donation(
  '46000000-0000-0000-0000-000000000099',1000,false,'legacy regression'
),true,'crypto confirmation succeeds around invalid legacy telemetry');
SELECT is((SELECT total_cents FROM public.supporter_accounts WHERE donor_key='test:user:46000000-0000-0000-0000-000000000002'),1000::bigint,'crypto authoritative credit succeeds');
SELECT is((SELECT review_status FROM public.support_donations WHERE id='46000000-0000-0000-0000-000000000099'),'confirmed','crypto review completes');
SELECT is((SELECT verified_amount_cents FROM public.support_donations WHERE id='46000000-0000-0000-0000-000000000099'),1000,'crypto verified amount is retained');
SELECT is((SELECT count(*)::integer FROM public.donations WHERE support_donation_id='46000000-0000-0000-0000-000000000099'),1,'crypto donation is recorded once');
SELECT is((SELECT map_views_count FROM public.user_usage_points WHERE user_id='46000000-0000-0000-0000-000000000002' AND ip_hash='legacy crypto hash'),-1,'invalid crypto telemetry counter is unchanged');
SELECT is((SELECT has_donated FROM public.user_usage_points WHERE user_id='46000000-0000-0000-0000-000000000002' AND ip_hash='legacy crypto hash'),false,'invalid crypto telemetry payment flag is unchanged');
SELECT is((SELECT total_donated_usd FROM public.user_usage_points WHERE user_id='46000000-0000-0000-0000-000000000002' AND ip_hash='ip_abc123'),10.00::numeric,'valid crypto telemetry mirrors payment');
SELECT is((SELECT points_total FROM public.user_usage_points WHERE user_id='46000000-0000-0000-0000-000000000002' AND ip_hash='verified_donor'),-1,'invalid existing sentinel counter is preserved');
SELECT is((SELECT has_donated FROM public.user_usage_points WHERE user_id='46000000-0000-0000-0000-000000000002' AND ip_hash='verified_donor'),false,'invalid existing sentinel payment flag is preserved');
SELECT is(public.confirm_crypto_donation(
  '46000000-0000-0000-0000-000000000099',1000,false,'legacy regression'
),false,'crypto replay remains idempotent');
SELECT is((SELECT total_cents FROM public.supporter_accounts WHERE donor_key='test:user:46000000-0000-0000-0000-000000000002'),1000::bigint,'crypto replay does not duplicate credit');

SELECT * FROM finish();
ROLLBACK;
