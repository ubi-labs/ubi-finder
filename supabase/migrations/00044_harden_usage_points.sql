-- Remove anonymous REST access to browser usage telemetry. Guest point state is
-- browser-local; signed-in clients retain only their own RLS-protected rows.
DROP POLICY IF EXISTS "Public/Anon can view and manage points by ip_hash"
  ON public.user_usage_points;

-- Table and column privileges are independent in PostgreSQL. Revoke both so
-- migration 00039/00041 column grants cannot leave an anonymous access path.
REVOKE ALL PRIVILEGES ON TABLE public.user_usage_points FROM anon;
REVOKE SELECT (user_id, ip_hash, points_total) ON public.user_usage_points FROM anon;
REVOKE INSERT (user_id, ip_hash, points_total, program_views_count, map_views_count,
  search_queries_count, encouragement_shown, last_action_at, updated_at)
  ON public.user_usage_points FROM anon;
REVOKE UPDATE (user_id, ip_hash, points_total, program_views_count, map_views_count,
  search_queries_count, encouragement_shown, last_action_at, updated_at)
  ON public.user_usage_points FROM anon;

-- Keep authenticated access account-scoped and avoid a FOR ALL policy that
-- accidentally describes DELETE as part of the supported client contract.
DROP POLICY IF EXISTS "Users can view their own usage points" ON public.user_usage_points;
DROP POLICY IF EXISTS "Users can insert/update their own usage points" ON public.user_usage_points;

CREATE POLICY "Users can view their own usage points"
  ON public.user_usage_points FOR SELECT TO authenticated
  USING ((SELECT auth.uid()) = user_id);
CREATE POLICY "Users can insert their own usage points"
  ON public.user_usage_points FOR INSERT TO authenticated
  WITH CHECK ((SELECT auth.uid()) = user_id);
CREATE POLICY "Users can update their own usage points"
  ON public.user_usage_points FOR UPDATE TO authenticated
  USING ((SELECT auth.uid()) = user_id)
  WITH CHECK ((SELECT auth.uid()) = user_id);

-- NOT VALID preserves every historical row without assuming old browser input
-- is clean. PostgreSQL still enforces these checks for all new and changed rows.
-- Before a separately approved VALIDATE CONSTRAINT migration, audit violations
-- with service-owned read access; do not repair or delete rows implicitly.
ALTER TABLE public.user_usage_points
  ADD CONSTRAINT user_usage_points_nonnegative_counters
  CHECK (
    points_total >= 0
    AND program_views_count >= 0
    AND map_views_count >= 0
    AND search_queries_count >= 0
  ) NOT VALID,
  ADD CONSTRAINT user_usage_points_bounded_hash
  CHECK (
    ip_hash ~ '^(ip_[a-z0-9]{1,64}|anon_[a-z0-9]{1,64}|verified_donor|(test|live):guest:[a-f0-9]{64})$'
  ) NOT VALID;

COMMENT ON CONSTRAINT user_usage_points_nonnegative_counters ON public.user_usage_points IS
  'Enforced for new/updated rows; historical rows require an explicit audit before validation.';
COMMENT ON CONSTRAINT user_usage_points_bounded_hash ON public.user_usage_points IS
  'Telemetry grammar enforced for new/updated rows; historical rows require an explicit audit before validation.';
