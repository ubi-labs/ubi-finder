-- Initialize the public identity name once. Auth updates may carry stale or
-- missing metadata, so they synchronize email without replacing a chosen name.
-- Intentional writes to public.users.full_name remain independent of Auth.
CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, role)
  VALUES (
    new.id,
    coalesce(new.email, new.id::text || '@ubifinder.org'),
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', 'Member'),
    'user'
  )
  ON CONFLICT (id) DO UPDATE
  SET email = coalesce(excluded.email, public.users.email);
  RETURN new;
END;
$$;
