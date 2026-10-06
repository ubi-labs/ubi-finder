-- #40: server-owned quotas; no raw IPs, Redis, or paid logging.
CREATE SCHEMA IF NOT EXISTS abuse_private;
REVOKE ALL ON SCHEMA abuse_private FROM PUBLIC, anon, authenticated;
CREATE TABLE abuse_private.secret (singleton boolean PRIMARY KEY DEFAULT true CHECK(singleton), pepper text NOT NULL);
INSERT INTO abuse_private.secret VALUES (true, encode(extensions.gen_random_bytes(32), 'hex'));
CREATE TABLE abuse_private.buckets (
  key text NOT NULL, window_start timestamptz NOT NULL, expires_at timestamptz NOT NULL,
  hits integer NOT NULL CHECK(hits > 0), PRIMARY KEY(key, window_start)
);
CREATE INDEX ON abuse_private.buckets(expires_at);
CREATE TABLE abuse_private.detail_reads (
  key text NOT NULL, program_id integer NOT NULL, seen_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY(key, program_id)
);
CREATE INDEX ON abuse_private.detail_reads(seen_at);
CREATE TABLE abuse_private.signup_events (
  user_id uuid PRIMARY KEY, ip_key text NOT NULL, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON abuse_private.signup_events(created_at);
ALTER TABLE abuse_private.signup_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE abuse_private.secret ENABLE ROW LEVEL SECURITY;
ALTER TABLE abuse_private.buckets ENABLE ROW LEVEL SECURITY;
ALTER TABLE abuse_private.detail_reads ENABLE ROW LEVEL SECURITY;

CREATE FUNCTION abuse_private.ip_key(p_ip text) RETURNS text
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = '' AS $$
  SELECT encode(extensions.hmac(CASE WHEN family(p_ip::inet)=6 THEN host(network(set_masklen(p_ip::inet,64))) ELSE host(p_ip::inet) END, pepper, 'sha256'), 'hex') FROM abuse_private.secret
$$;
-- Atomic check-and-increment under ordered transaction locks. Rejected transactions consume no quota.
CREATE FUNCTION abuse_private.consume(p_key text, p_seconds integer, p_limit integer) RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE t timestamptz := to_timestamp(floor(extract(epoch FROM now()) / p_seconds) * p_seconds); n integer;
BEGIN
  INSERT INTO abuse_private.buckets(key,window_start,expires_at,hits)
    VALUES(p_key,t,t+make_interval(secs=>p_seconds),1)
    ON CONFLICT(key,window_start) DO UPDATE SET hits=abuse_private.buckets.hits+1 RETURNING hits INTO n;
  IF n > p_limit THEN RAISE EXCEPTION 'Request quota exceeded' USING ERRCODE='P0001'; END IF;
END $$;
CREATE FUNCTION public.before_user_created_abuse_check(event jsonb) RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE k text; ip text := event->'metadata'->>'ip_address';
BEGIN
  -- Admin-created users do not always carry an end-user IP; this hook is for network signups.
  IF ip IS NULL OR ip='' THEN
    RETURN jsonb_build_object('error',jsonb_build_object('http_code',429,'message','Unable to validate signup source. Please try again later.'));
  END IF;
  k := abuse_private.ip_key(ip);
  PERFORM pg_advisory_xact_lock(hashtextextended('signup:'||k,0));
  PERFORM abuse_private.consume('signup-day:'||k,86400,10);
  PERFORM abuse_private.consume('signup-hour:'||k,3600,5);
  IF event->'user'->>'id' IS NOT NULL THEN
    INSERT INTO abuse_private.signup_events(user_id,ip_key) VALUES((event->'user'->>'id')::uuid,k);
  END IF;
  RETURN '{}'::jsonb;
EXCEPTION WHEN SQLSTATE 'P0001' THEN
  RETURN jsonb_build_object('error',jsonb_build_object('http_code',429,'message','Too many accounts created from this network. Please try again later.'));
END $$;
REVOKE ALL ON FUNCTION public.before_user_created_abuse_check(jsonb) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.before_user_created_abuse_check(jsonb) TO supabase_auth_admin;

CREATE FUNCTION abuse_private.can_manage_program(p_id integer) RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = '' AS $$
 SELECT EXISTS(SELECT 1 FROM public.program_managers m JOIN auth.users u ON u.id=auth.uid()
 WHERE m.program_id=p_id AND m.user_email=u.email AND m.role IN ('owner','admin'))
$$;
GRANT USAGE ON SCHEMA abuse_private TO authenticated;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA abuse_private FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION abuse_private.can_manage_program(integer) TO authenticated;
DROP POLICY IF EXISTS programs_select_all ON public.programs;
CREATE POLICY programs_select_managed ON public.programs FOR SELECT TO authenticated
 USING (public.is_admin() OR created_by_id=auth.uid() OR abuse_private.can_manage_program(program_id));
REVOKE SELECT ON public.programs FROM anon;
-- authenticated retains SELECT only for management/own submissions via RLS; general reads use the gateway.

CREATE FUNCTION public.read_program_catalog(p_ip text, p_user_id uuid DEFAULT NULL,
 p_program_id integer DEFAULT NULL, p_after integer DEFAULT 0, p_limit integer DEFAULT 20) RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
DECLARE ipkey text; userkey text; result jsonb; confirmed boolean;
BEGIN
 IF p_limit IS NULL OR p_after IS NULL OR p_limit NOT BETWEEN 1 AND 20 OR p_after < 0 OR (p_program_id IS NOT NULL AND p_program_id<1) THEN
   RAISE EXCEPTION 'Invalid catalog request';
 END IF;
 ipkey := abuse_private.ip_key(p_ip);
 PERFORM abuse_private.consume('catalog-global',60,600);
 -- Canonical order prevents concurrent requests from deadlocking.
 PERFORM pg_advisory_xact_lock(hashtextextended('catalog-ip:'||ipkey,0));
 IF p_user_id IS NOT NULL THEN
   SELECT email_confirmed_at IS NOT NULL OR phone_confirmed_at IS NOT NULL INTO confirmed FROM auth.users WHERE id=p_user_id;
   IF confirmed IS DISTINCT FROM true THEN RAISE EXCEPTION 'Verified sign-in required' USING ERRCODE='28000'; END IF;
   userkey := 'user:'||p_user_id;
   PERFORM pg_advisory_xact_lock(hashtextextended('catalog-user:'||userkey,0));
   PERFORM abuse_private.consume('catalog-user:'||userkey,60,60);
 END IF;
 PERFORM abuse_private.consume('catalog-ip:'||ipkey,60,120);
 IF p_program_id IS NOT NULL THEN
   IF p_user_id IS NULL THEN RAISE EXCEPTION 'Verified sign-in required' USING ERRCODE='28000'; END IF;
   PERFORM abuse_private.consume('detail-user:'||userkey,60,30);
   PERFORM abuse_private.consume('detail-ip:'||ipkey,60,60);
   DELETE FROM abuse_private.detail_reads WHERE seen_at <= now()-interval '1 day' AND key IN(userkey,'ip:'||ipkey);
   IF NOT EXISTS(SELECT 1 FROM public.programs WHERE program_id=p_program_id AND internal_status='active') THEN RETURN jsonb_build_object('program',NULL); END IF;
   IF NOT EXISTS(SELECT 1 FROM abuse_private.detail_reads WHERE key=userkey AND program_id=p_program_id)
     AND (SELECT count(*) FROM abuse_private.detail_reads WHERE key=userkey)>=100 THEN RAISE EXCEPTION 'Request quota exceeded'; END IF;
   IF NOT EXISTS(SELECT 1 FROM abuse_private.detail_reads WHERE key='ip:'||ipkey AND program_id=p_program_id)
     AND (SELECT count(*) FROM abuse_private.detail_reads WHERE key='ip:'||ipkey)>=150 THEN RAISE EXCEPTION 'Request quota exceeded'; END IF;
   INSERT INTO abuse_private.detail_reads(key,program_id) VALUES(userkey,p_program_id),('ip:'||ipkey,p_program_id) ON CONFLICT DO NOTHING;
   SELECT (SELECT jsonb_object_agg(key,value) FROM jsonb_each(to_jsonb(p)) WHERE key=ANY(ARRAY['id','program_id','name','organization','monthly_amount_usd','currency','available_regions','required_states','municipalities','state_province','latitude','longitude','gender_requirement','min_age','max_age','max_household_income_usd','payment_method','payout_rail','distribution_type','funding_source','application_status','payout_status','status','verified','internal_status','amount_description','parent_program_id','program_group_id','involvement_level','custom_claim_path','managed_requirements','is_auto_participation','is_rct','stanford_experiment_id','data_source','targeting_details','description','eligibility','website','apply_url','sources','created_date','updated_date'])) INTO result FROM public.programs p WHERE p.program_id=p_program_id AND p.internal_status='active';
   RETURN jsonb_build_object('program',result);
 END IF;
 SELECT coalesce(jsonb_agg(rowdata ORDER BY pid),'[]'::jsonb) INTO result FROM (
   SELECT p.program_id AS pid, jsonb_build_object(
      'id', to_jsonb(p)->'id',
      'program_id', to_jsonb(p)->'program_id',
      'name', to_jsonb(p)->'name',
      'organization', to_jsonb(p)->'organization',
      'monthly_amount_usd', to_jsonb(p)->'monthly_amount_usd',
      'currency', to_jsonb(p)->'currency',
      'available_regions', to_jsonb(p)->'available_regions',
      'required_states', to_jsonb(p)->'required_states',
      'municipalities', to_jsonb(p)->'municipalities',
      'state_province', to_jsonb(p)->'state_province',
      'latitude', to_jsonb(p)->'latitude',
      'longitude', to_jsonb(p)->'longitude',
      'gender_requirement', to_jsonb(p)->'gender_requirement',
      'min_age', to_jsonb(p)->'min_age',
      'max_age', to_jsonb(p)->'max_age',
      'max_household_income_usd', to_jsonb(p)->'max_household_income_usd',
      'payment_method', to_jsonb(p)->'payment_method',
      'payout_rail', to_jsonb(p)->'payout_rail',
      'distribution_type', to_jsonb(p)->'distribution_type',
      'funding_source', to_jsonb(p)->'funding_source',
      'application_status', to_jsonb(p)->'application_status',
      'payout_status', to_jsonb(p)->'payout_status',
      'status', to_jsonb(p)->'status',
      'verified', to_jsonb(p)->'verified',
      'internal_status', to_jsonb(p)->'internal_status',
      'amount_description', to_jsonb(p)->'amount_description',
      'parent_program_id', to_jsonb(p)->'parent_program_id',
      'program_group_id', to_jsonb(p)->'program_group_id',
      'involvement_level', to_jsonb(p)->'involvement_level',
      'custom_claim_path', to_jsonb(p)->'custom_claim_path',
      'managed_requirements', to_jsonb(p)->'managed_requirements',
      'is_auto_participation', to_jsonb(p)->'is_auto_participation',
      'is_rct', to_jsonb(p)->'is_rct',
      'stanford_experiment_id', to_jsonb(p)->'stanford_experiment_id',
      'data_source', to_jsonb(p)->'data_source',
      'targeting_details', left(to_jsonb(p)->>'targeting_details',150),
      'description',left(p.description,300)
   ) AS rowdata FROM public.programs p WHERE p.internal_status='active' AND p.program_id>p_after ORDER BY p.program_id LIMIT p_limit
 ) rows;
 RETURN jsonb_build_object('programs',result,'next',CASE WHEN jsonb_array_length(result)=p_limit THEN (result->(p_limit-1)->>'program_id')::integer ELSE NULL END);
END $$;
REVOKE ALL ON FUNCTION public.read_program_catalog(text,uuid,integer,integer,integer) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.read_program_catalog(text,uuid,integer,integer,integer) TO service_role;

-- Replace the browser's max(id)+1 allocation with an atomic sequence.
CREATE SEQUENCE IF NOT EXISTS public.program_number_seq;
SELECT setval('public.program_number_seq',greatest(coalesce(max(program_id),0)+1,1),false) FROM public.programs;
CREATE FUNCTION public.next_program_number() RETURNS integer
LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE n integer;
BEGIN
 PERFORM pg_advisory_xact_lock(hashtextextended('program-number',0));
 n := greatest(nextval('public.program_number_seq'),coalesce((SELECT max(program_id) FROM public.programs),0)+1);
 PERFORM setval('public.program_number_seq',n,true);
 RETURN n;
END $$;
REVOKE ALL ON FUNCTION public.next_program_number() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.next_program_number() TO authenticated, service_role;
ALTER TABLE public.programs ALTER COLUMN program_id SET DEFAULT public.next_program_number();

-- Only short-lived operational counters are retained; no longer-retention log service.
CREATE FUNCTION abuse_private.cleanup() RETURNS void LANGUAGE sql SECURITY DEFINER SET search_path='' AS $$
 DELETE FROM abuse_private.buckets WHERE expires_at<=now();
 DELETE FROM abuse_private.detail_reads WHERE seen_at<=now()-interval '1 day';
 DELETE FROM abuse_private.signup_events WHERE created_at<=now()-interval '1 day';
$$;
REVOKE ALL ON FUNCTION abuse_private.cleanup() FROM PUBLIC, anon, authenticated;
CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA pg_catalog;
SELECT cron.schedule('ubi-abuse-one-day-cleanup','* * * * *','SELECT abuse_private.cleanup()');
