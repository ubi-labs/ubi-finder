-- Payment authority is separate from browser-reported usage and legacy pledges.
CREATE TABLE public.supporter_accounts (
  donor_key text PRIMARY KEY,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  total_cents bigint NOT NULL DEFAULT 0 CHECK (total_cents >= 0),
  livemode boolean NOT NULL,
  UNIQUE(user_id, livemode),
  CHECK ((user_id IS NULL AND donor_key ~ ('^' || (CASE WHEN livemode THEN 'live:' ELSE 'test:' END) || 'guest:[a-f0-9]{64}$')) OR
    (user_id IS NOT NULL AND donor_key = (CASE WHEN livemode THEN 'live:' ELSE 'test:' END) || 'user:' || user_id::text))
);
CREATE TABLE public.donation_checkouts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  donor_key text NOT NULL REFERENCES public.supporter_accounts(donor_key) ON DELETE CASCADE,
  stripe_session_id text UNIQUE,
  amount_cents integer NOT NULL CHECK (amount_cents BETWEEN 100 AND 1000000),
  livemode boolean NOT NULL,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','completed','failed','expired')),
  receipt_url text,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX donation_checkouts_donor_created ON public.donation_checkouts(donor_key, created_at);
CREATE TABLE public.stripe_payment_events (
  event_id text PRIMARY KEY,
  checkout_id uuid NOT NULL REFERENCES public.donation_checkouts(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.supporter_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.donation_checkouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stripe_payment_events ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.supporter_accounts, public.donation_checkouts, public.stripe_payment_events FROM anon, authenticated;
GRANT ALL ON public.supporter_accounts, public.donation_checkouts, public.stripe_payment_events TO service_role;
ALTER TABLE public.donations ADD COLUMN verified boolean NOT NULL DEFAULT false;
DROP POLICY "Authenticated and anon can record donations" ON public.donations;
REVOKE INSERT, UPDATE, DELETE ON public.donations FROM anon, authenticated;

-- Usage clients may still record usage, but cannot set payment-derived fields.
REVOKE INSERT, UPDATE ON public.user_usage_points FROM anon, authenticated;
GRANT INSERT (user_id, ip_hash, points_total, program_views_count, map_views_count,
  search_queries_count, encouragement_shown, last_action_at, updated_at),
  UPDATE (user_id, ip_hash, points_total, program_views_count, map_views_count,
  search_queries_count, encouragement_shown, last_action_at, updated_at)
  ON public.user_usage_points TO anon, authenticated;

CREATE FUNCTION public.protect_supporter_payment_fields() RETURNS trigger
LANGUAGE plpgsql SET search_path = '' AS $$
BEGIN
  IF current_user IN ('anon', 'authenticated') THEN
    IF TG_OP = 'INSERT' THEN
      NEW.has_donated := false;
      NEW.total_donated_usd := 0;
    ELSE
      NEW.has_donated := OLD.has_donated;
      NEW.total_donated_usd := OLD.total_donated_usd;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;
CREATE TRIGGER protect_supporter_payment_fields BEFORE INSERT OR UPDATE ON public.user_usage_points
FOR EACH ROW EXECUTE FUNCTION public.protect_supporter_payment_fields();

CREATE FUNCTION public.reserve_donation_checkout(p_donor_key text, p_user_id uuid,
  p_amount_cents integer, p_livemode boolean) RETURNS uuid
LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE v_id uuid;
BEGIN
  INSERT INTO public.supporter_accounts(donor_key, user_id, livemode) VALUES(p_donor_key, p_user_id, p_livemode)
    ON CONFLICT (donor_key) DO NOTHING;
  PERFORM 1 FROM public.supporter_accounts WHERE donor_key = p_donor_key FOR UPDATE;
  IF (SELECT count(*) FROM public.donation_checkouts WHERE donor_key = p_donor_key
      AND created_at > now() - interval '1 hour') >= 10 THEN
    RAISE EXCEPTION 'Checkout rate limit reached';
  END IF;
  INSERT INTO public.donation_checkouts(donor_key, amount_cents, livemode)
    VALUES(p_donor_key, p_amount_cents, p_livemode) RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;

CREATE FUNCTION public.fulfill_stripe_donation(p_event_id text, p_session_id text,
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
  ELSE
    -- No browser-trusted IP joins: the guest capability identifies this record.
    UPDATE public.user_usage_points SET has_donated = true, total_donated_usd = v_account.total_cents / 100.0
      WHERE user_id IS NULL AND ip_hash = v_account.donor_key;
    IF NOT FOUND THEN
      INSERT INTO public.user_usage_points(ip_hash, has_donated, total_donated_usd)
        VALUES(v_account.donor_key, true, v_account.total_cents / 100.0);
    END IF;
  END IF;
  RETURN true;
END;
$$;
REVOKE ALL ON FUNCTION public.reserve_donation_checkout(text,uuid,integer,boolean),
  public.fulfill_stripe_donation(text,text,text,integer,boolean,text) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.reserve_donation_checkout(text,uuid,integer,boolean),
  public.fulfill_stripe_donation(text,text,text,integer,boolean,text) TO service_role;
