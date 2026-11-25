-- Replace recursive manager policies without restoring email-only self-appointment.
CREATE OR REPLACE FUNCTION abuse_private.can_access_program_manager(
  p_program_id integer,
  p_row_email text,
  p_require_management boolean
) RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = '' AS $$
  SELECT coalesce((
    SELECT
      (NOT p_require_management AND p_row_email = auth_user.email)
      OR EXISTS (
        SELECT 1 FROM public.programs program
        WHERE program.program_id = p_program_id
          AND program.created_by_id = auth.uid()
      )
      OR EXISTS (
        SELECT 1 FROM public.program_managers manager
        WHERE manager.program_id = p_program_id
          AND manager.user_email = auth_user.email
          AND manager.role IN ('owner', 'admin')
      )
    FROM auth.users auth_user
    WHERE auth_user.id = auth.uid()
  ), false)
$$;

REVOKE ALL ON FUNCTION abuse_private.can_access_program_manager(integer, text, boolean)
  FROM PUBLIC, anon, authenticated;
GRANT USAGE ON SCHEMA abuse_private TO authenticated;
GRANT EXECUTE ON FUNCTION abuse_private.can_access_program_manager(integer, text, boolean)
  TO authenticated;

DROP POLICY IF EXISTS pm_select ON public.program_managers;
DROP POLICY IF EXISTS pm_all ON public.program_managers;
DROP POLICY IF EXISTS pm_insert ON public.program_managers;
DROP POLICY IF EXISTS pm_update ON public.program_managers;
DROP POLICY IF EXISTS pm_delete ON public.program_managers;

CREATE POLICY pm_select ON public.program_managers
  FOR SELECT TO authenticated
  USING (abuse_private.can_access_program_manager(program_id, user_email, false));

CREATE POLICY pm_insert ON public.program_managers
  FOR INSERT TO authenticated
  WITH CHECK (abuse_private.can_access_program_manager(program_id, NULL, true));

CREATE POLICY pm_update ON public.program_managers
  FOR UPDATE TO authenticated
  USING (abuse_private.can_access_program_manager(program_id, NULL, true))
  WITH CHECK (abuse_private.can_access_program_manager(program_id, NULL, true));

CREATE POLICY pm_delete ON public.program_managers
  FOR DELETE TO authenticated
  USING (abuse_private.can_access_program_manager(program_id, NULL, true));
