-- New Supabase projects require explicit Data API grants. Existing row-level
-- policies still determine which rows each role can read or change.
GRANT SELECT ON public.programs, public.program_groups, public.program_group_members,
  public.stanford_experiments, public.blog_posts, public.comments,
  public.community_announcements, public.community_discussions, public.user_profiles
  TO anon, authenticated;

GRANT INSERT (name, email, organization, message) ON public.services_intake TO anon, authenticated;

GRANT SELECT ON public.users, public.applications, public.donations, public.support_donations TO authenticated;
GRANT UPDATE (role) ON public.users TO authenticated;
GRANT INSERT, UPDATE ON public.programs, public.user_profiles, public.user_self_applications TO authenticated;
GRANT SELECT ON public.user_self_applications TO authenticated;
GRANT SELECT, INSERT ON public.managed_applications, public.user_match_snapshots TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.admin_notifications, public.user_notifications TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.bank_accounts, public.crypto_wallets,
  public.program_managers TO authenticated;
GRANT INSERT ON public.comments, public.community_discussions TO authenticated;

-- Usage writes remain restricted to the columns granted in migration 00039.
GRANT SELECT (user_id, ip_hash, points_total) ON public.user_usage_points TO anon, authenticated;

-- The submission notification function reads users as service_role.
-- These grants also support isolated acceptance setup and donation test cleanup.
GRANT SELECT ON public.users TO service_role;
GRANT INSERT ON public.user_profiles TO service_role;
GRANT SELECT, DELETE ON public.donations, public.user_usage_points TO service_role;
