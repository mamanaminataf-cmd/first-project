-- 0009_auth_profiles.sql
-- Sprint 4 — Auto-création du profil à l'inscription + sécurisation du rôle.
-- ============================================================
-- But :
--   1. Après signUp Supabase (auth.users), créer automatiquement la ligne profiles
--      avec le rôle choisi à l'inscription (via raw_user_meta_data.role).
--   2. Restreindre la polymise profiles_insert_own (le client ne doit PAS insérer
--      directement ; seul le trigger le fait) — évite qu'un utilisateur crée un
--      profil admin arbitraire.
--   3. Interdire le changement de rôle par l'utilisateur lui-même (admin requis
--      pour changer un rôle).
-- DOWN:
--   DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
--   DROP FUNCTION IF EXISTS public.handle_new_user();
--   CREATE POLICY "profiles_insert_own" ON public.profiles
--       FOR INSERT TO authenticated WITH CHECK (id = auth.uid());
--   DROP POLICY IF EXISTS "profiles_update_own_admin" ON public.profiles;
--   CREATE POLICY "profiles_update_own_admin" ON public.profiles
--       FOR UPDATE TO authenticated USING (
--           id = auth.uid()
--           OR EXISTS (SELECT 1 FROM public.profiles
--                      WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

BEGIN;

-- 1. Fonction trigger : crée le profil à partir des métadonnées d'inscription.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    INSERT INTO public.profiles (id, role, full_name, email, status)
    VALUES (
        new.id,
        COALESCE(new.raw_user_meta_data->>'role', 'buyer'),
        COALESCE(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
        new.email,
        'active'
    )
    ON CONFLICT (id) DO NOTHING;
    RETURN new;
END;
$$;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 2. Le client ne doit plus insérer directement dans profiles (rôle trop risqué).
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;

-- 3. L'utilisateur peut modifier son profil (nom, avatar, boutique...) mais PAS son rôle.
DROP POLICY IF EXISTS "profiles_update_own_admin" ON public.profiles;

CREATE POLICY "profiles_update_own_admin" ON public.profiles
    FOR UPDATE TO authenticated
    USING (
        id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'))
    WITH CHECK (
        -- admin : libre ; utilisateur : son propre profil et rôle inchangé
        EXISTS (SELECT 1 FROM public.profiles
                WHERE profiles.id = auth.uid() AND profiles.role = 'admin')
        OR (
            id = auth.uid()
            AND role = (SELECT role FROM public.profiles WHERE profiles.id = auth.uid())
        )
    );

COMMIT;