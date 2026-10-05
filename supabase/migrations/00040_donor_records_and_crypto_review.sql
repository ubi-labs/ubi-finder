-- Names and recognition consent remain private until a future opt-in leaderboard exists.
ALTER TABLE public.donation_checkouts
  ADD COLUMN donor_name text CHECK (char_length(donor_name) <= 100),
  ADD COLUMN public_recognition boolean NOT NULL DEFAULT false,
  ADD CONSTRAINT checkout_recognition_requires_name CHECK (NOT public_recognition OR nullif(btrim(donor_name), '') IS NOT NULL);
ALTER TABLE public.support_donations
  ADD COLUMN public_recognition boolean NOT NULL DEFAULT false,
  ADD COLUMN crypto_donor_key text REFERENCES public.supporter_accounts(donor_key) ON DELETE CASCADE,
  ADD COLUMN crypto_chain text CHECK (crypto_chain IN ('ethereum','celo')),
  ADD COLUMN transaction_hash text CHECK (transaction_hash ~ '^0x[a-f0-9]{64}$'),
  ADD COLUMN livemode boolean NOT NULL DEFAULT false,
  ADD COLUMN review_status text NOT NULL DEFAULT 'not_requested' CHECK (review_status IN ('not_requested','pending_review','confirmed','rejected')),
  ADD COLUMN review_due_at timestamptz,
  ADD COLUMN reviewed_at timestamptz,
  ADD COLUMN reviewed_by text,
  ADD COLUMN verified_amount_cents integer CHECK (verified_amount_cents BETWEEN 100 AND 1000000),
  ADD CONSTRAINT crypto_review_requires_transaction CHECK (review_status = 'not_requested' OR (crypto_donor_key IS NOT NULL AND crypto_chain IS NOT NULL AND transaction_hash IS NOT NULL AND review_due_at IS NOT NULL)),
  ADD CONSTRAINT crypto_recognition_requires_name CHECK (NOT public_recognition OR nullif(btrim(donor_name), '') IS NOT NULL);
CREATE UNIQUE INDEX crypto_transaction_once ON public.support_donations(livemode, crypto_chain, transaction_hash) WHERE transaction_hash IS NOT NULL;
CREATE INDEX crypto_review_queue ON public.support_donations(review_due_at) WHERE review_status = 'pending_review';
CREATE INDEX crypto_donor_created ON public.support_donations(crypto_donor_key, created_at);
-- Submit only through the identity-validating Edge Function. Existing owner/admin reads remain.
DROP POLICY "Allow public insert to support_donations" ON public.support_donations;
DROP POLICY "Allow admin to select all support_donations" ON public.support_donations;
REVOKE INSERT, UPDATE, DELETE ON public.support_donations FROM anon, authenticated;
GRANT ALL ON public.support_donations TO service_role;
ALTER TABLE public.donations ADD COLUMN support_donation_id uuid UNIQUE REFERENCES public.support_donations(id) ON DELETE SET NULL;

CREATE FUNCTION public.submit_crypto_donation(p_donor_key text, p_user_id uuid, p_amount_cents integer,
  p_livemode boolean, p_chain text, p_transaction_hash text, p_donor_name text, p_public_recognition boolean)
RETURNS uuid LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE v_id uuid;
BEGIN
  IF p_amount_cents IS NULL OR p_amount_cents NOT BETWEEN 100 AND 1000000 OR char_length(p_donor_name) > 100 THEN RAISE EXCEPTION 'Invalid donation details'; END IF;
  INSERT INTO public.supporter_accounts(donor_key, user_id, livemode) VALUES(p_donor_key, p_user_id, p_livemode) ON CONFLICT DO NOTHING;
  PERFORM 1 FROM public.supporter_accounts WHERE donor_key = p_donor_key AND user_id IS NOT DISTINCT FROM p_user_id AND livemode = p_livemode FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'Donation owner mismatch'; END IF;
  IF (SELECT count(*) FROM public.support_donations WHERE crypto_donor_key = p_donor_key AND created_at > now() - interval '1 hour') >= 10 THEN RAISE EXCEPTION 'Crypto submission rate limit reached'; END IF;
  INSERT INTO public.support_donations(user_id, amount_usd, donor_name, payment_method, status, notes,
    public_recognition, crypto_donor_key, crypto_chain, transaction_hash, livemode, review_status, review_due_at)
  VALUES(p_user_id, p_amount_cents / 100.0, p_donor_name, 'crypto', 'pledged', 'Self-reported transfer; pending manual confirmation.',
    p_public_recognition, p_donor_key, p_chain, p_transaction_hash, p_livemode, 'pending_review', now() + interval '7 days') RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;

-- Operator-only: verify recipient, chain, finality and USD value externally before calling.
CREATE FUNCTION public.confirm_crypto_donation(p_donation_id uuid, p_verified_amount_cents integer,
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
    UPDATE public.user_usage_points SET has_donated = true, total_donated_usd = v_account.total_cents / 100.0 WHERE user_id = v_account.user_id;
    INSERT INTO public.user_usage_points(user_id, ip_hash, has_donated, total_donated_usd)
      VALUES(v_account.user_id, 'verified_donor', true, v_account.total_cents / 100.0)
      ON CONFLICT(user_id, ip_hash) DO UPDATE SET has_donated = true, total_donated_usd = EXCLUDED.total_donated_usd;
  END IF;
  RETURN true;
END;
$$;
REVOKE ALL ON FUNCTION public.submit_crypto_donation(text,uuid,integer,boolean,text,text,text,boolean),
  public.confirm_crypto_donation(uuid,integer,boolean,text) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.submit_crypto_donation(text,uuid,integer,boolean,text,text,text,boolean),
  public.confirm_crypto_donation(uuid,integer,boolean,text) TO service_role;

-- Guest donation records remain valid, but account credits require signing in before donation.
UPDATE public.user_usage_points SET has_donated = false, total_donated_usd = 0 WHERE user_id IS NULL AND ip_hash ~ '^(test|live):guest:[a-f0-9]{64}$';

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
    UPDATE public.user_usage_points SET has_donated = true, total_donated_usd = v_account.total_cents / 100.0
      WHERE user_id = v_account.user_id;
    INSERT INTO public.user_usage_points(user_id, ip_hash, has_donated, total_donated_usd)
      VALUES(v_account.user_id, 'verified_donor', true, v_account.total_cents / 100.0)
      ON CONFLICT(user_id, ip_hash) DO UPDATE SET has_donated = true, total_donated_usd = EXCLUDED.total_donated_usd;
  END IF;
  RETURN true;
END;
$$;
