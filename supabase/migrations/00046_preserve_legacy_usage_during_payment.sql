-- Pure validators keep the staged constraints and trusted payment mirroring on
-- one definition without granting any data or identity authority.
CREATE FUNCTION abuse_private.usage_counters_are_valid(
  p_points integer,
  p_program_views integer,
  p_map_views integer,
  p_search_queries integer
) RETURNS boolean
LANGUAGE sql IMMUTABLE STRICT SET search_path = '' AS $$
  SELECT p_points >= 0
    AND p_program_views >= 0
    AND p_map_views >= 0
    AND p_search_queries >= 0
$$;

CREATE FUNCTION abuse_private.usage_hash_is_valid(p_hash text) RETURNS boolean
LANGUAGE sql IMMUTABLE STRICT SET search_path = '' AS $$
  SELECT p_hash ~ '^(ip_[a-z0-9]{1,64}|anon_[a-z0-9]{1,64}|verified_donor|(test|live):guest:[a-f0-9]{64})$'
$$;

REVOKE ALL ON FUNCTION
  abuse_private.usage_counters_are_valid(integer,integer,integer,integer),
  abuse_private.usage_hash_is_valid(text)
  FROM PUBLIC, anon, authenticated, service_role;
GRANT USAGE ON SCHEMA abuse_private TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION
  abuse_private.usage_counters_are_valid(integer,integer,integer,integer),
  abuse_private.usage_hash_is_valid(text)
  TO authenticated, service_role;

-- Preserve the constraint names, expressions, NOT VALID staging, and new-row
-- enforcement from 00044. Existing rows are not scanned or rewritten.
ALTER TABLE public.user_usage_points
  DROP CONSTRAINT user_usage_points_nonnegative_counters,
  DROP CONSTRAINT user_usage_points_bounded_hash;
ALTER TABLE public.user_usage_points
  ADD CONSTRAINT user_usage_points_nonnegative_counters
  CHECK (abuse_private.usage_counters_are_valid(
    points_total, program_views_count, map_views_count, search_queries_count
  )) NOT VALID,
  ADD CONSTRAINT user_usage_points_bounded_hash
  CHECK (abuse_private.usage_hash_is_valid(ip_hash)) NOT VALID;

COMMENT ON CONSTRAINT user_usage_points_nonnegative_counters ON public.user_usage_points IS
  'Enforced for new/updated rows; historical rows require an explicit audit before validation.';
COMMENT ON CONSTRAINT user_usage_points_bounded_hash ON public.user_usage_points IS
  'Telemetry grammar enforced for new/updated rows; historical rows require an explicit audit before validation.';

-- Server-only, security-invoker mirror. Invalid historical telemetry rows are
-- deliberately skipped so they cannot roll back authoritative payment credit.
-- A conflicting invalid verified_donor sentinel is also preserved unchanged.
CREATE FUNCTION abuse_private.mirror_supporter_payment(
  p_user_id uuid,
  p_total_cents bigint
) RETURNS void
LANGUAGE plpgsql SET search_path = '' AS $$
BEGIN
  UPDATE public.user_usage_points
  SET has_donated = true,
      total_donated_usd = p_total_cents / 100.0
  WHERE user_id = p_user_id
    AND abuse_private.usage_counters_are_valid(
      points_total, program_views_count, map_views_count, search_queries_count
    )
    AND abuse_private.usage_hash_is_valid(ip_hash);

  INSERT INTO public.user_usage_points(user_id, ip_hash, has_donated, total_donated_usd)
  VALUES(p_user_id, 'verified_donor', true, p_total_cents / 100.0)
  ON CONFLICT(user_id, ip_hash) DO UPDATE
    SET has_donated = true,
        total_donated_usd = EXCLUDED.total_donated_usd
  WHERE abuse_private.usage_counters_are_valid(
      user_usage_points.points_total,
      user_usage_points.program_views_count,
      user_usage_points.map_views_count,
      user_usage_points.search_queries_count
    )
    AND abuse_private.usage_hash_is_valid(user_usage_points.ip_hash);
END;
$$;

REVOKE ALL ON FUNCTION abuse_private.mirror_supporter_payment(uuid,bigint)
  FROM PUBLIC, anon, authenticated, service_role;

-- Preserve the reviewed-crypto transaction exactly; replace only the usage
-- mirror block with the bounded server-only helper.
CREATE OR REPLACE FUNCTION public.confirm_crypto_donation(p_donation_id uuid, p_verified_amount_cents integer,
  p_livemode boolean, p_reviewer text) RETURNS boolean
LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE v_donation public.support_donations; v_account public.supporter_accounts;
BEGIN
  SELECT * INTO STRICT v_donation FROM public.support_donations WHERE id = p_donation_id FOR UPDATE;
  IF p_verified_amount_cents IS NULL OR p_verified_amount_cents NOT BETWEEN 100 AND 1000000 OR p_livemode IS DISTINCT FROM v_donation.livemode OR nullif(btrim(p_reviewer), '') IS NULL THEN RAISE EXCEPTION 'Invalid review details'; END IF;
  IF v_donation.review_status = 'confirmed' THEN RETURN false; END IF;
  IF v_donation.review_status <> 'pending_review' THEN RAISE EXCEPTION 'Donation is not pending review'; END IF;
  SELECT * INTO STRICT v_account FROM public.supporter_accounts WHERE donor_key = v_donation.crypto_donor_key FOR UPDATE;
  INSERT INTO public.donations(user_id, amount_usd, status, verified, support_donation_id)
    VALUES(v_donation.user_id, p_verified_amount_cents / 100.0, 'completed', true, v_donation.id);
  UPDATE public.support_donations SET review_status = 'confirmed', status = 'completed', reviewed_at = now(),
    reviewed_by = p_reviewer, verified_amount_cents = p_verified_amount_cents WHERE id = v_donation.id;
  UPDATE public.supporter_accounts SET total_cents = total_cents + p_verified_amount_cents WHERE donor_key = v_account.donor_key RETURNING * INTO v_account;
  IF v_account.user_id IS NOT NULL THEN
    PERFORM abuse_private.mirror_supporter_payment(v_account.user_id, v_account.total_cents);
  END IF;
  RETURN true;
END;
$$;

-- Preserve the Stripe transaction exactly; replace only the usage mirror block
-- with the bounded server-only helper.
CREATE OR REPLACE FUNCTION public.fulfill_stripe_donation(p_event_id text, p_session_id text,
  p_payment_intent_id text, p_amount_cents integer, p_livemode boolean, p_receipt_url text)
RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE v_checkout public.donation_checkouts; v_account public.supporter_accounts;
BEGIN
  SELECT * INTO STRICT v_checkout FROM public.donation_checkouts
    WHERE stripe_session_id = p_session_id FOR UPDATE;
  IF v_checkout.amount_cents <> p_amount_cents OR v_checkout.livemode <> p_livemode
      OR p_payment_intent_id IS NULL OR p_event_id IS NULL THEN
    RAISE EXCEPTION 'Payment does not match checkout';
  END IF;
  INSERT INTO public.stripe_payment_events(event_id, checkout_id) VALUES(p_event_id, v_checkout.id)
    ON CONFLICT DO NOTHING;
  IF NOT FOUND OR v_checkout.status = 'completed' THEN RETURN false; END IF;
  SELECT * INTO STRICT v_account FROM public.supporter_accounts
    WHERE donor_key = v_checkout.donor_key FOR UPDATE;
  INSERT INTO public.donations(user_id, stripe_session_id, stripe_payment_intent_id, amount_usd, status, verified)
    VALUES(v_account.user_id, p_session_id, p_payment_intent_id, p_amount_cents / 100.0, 'completed', true);
  UPDATE public.supporter_accounts SET total_cents = total_cents + p_amount_cents
    WHERE donor_key = v_account.donor_key RETURNING * INTO v_account;
  UPDATE public.donation_checkouts SET status = 'completed', receipt_url = p_receipt_url WHERE id = v_checkout.id;
  IF v_account.user_id IS NOT NULL THEN
    PERFORM abuse_private.mirror_supporter_payment(v_account.user_id, v_account.total_cents);
  END IF;
  RETURN true;
END;
$$;

REVOKE ALL ON FUNCTION
  public.confirm_crypto_donation(uuid,integer,boolean,text),
  public.fulfill_stripe_donation(text,text,text,integer,boolean,text)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION
  public.confirm_crypto_donation(uuid,integer,boolean,text),
  public.fulfill_stripe_donation(text,text,text,integer,boolean,text)
  TO service_role;
