-- 0002_profiles_categories.sql
-- Sprint 3 — Table profiles (1:1 avec auth.users) et table categories.
-- ============================================================
-- DOWN:
--   DROP TABLE IF EXISTS public.categories;
--   DROP TABLE IF EXISTS public.profiles;

BEGIN;

CREATE TABLE public.profiles (
    id                uuid PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
    role              text NOT NULL DEFAULT 'buyer' CHECK (role IN ('buyer', 'seller', 'admin')),
    full_name         text NOT NULL,
    email             text NOT NULL UNIQUE,
    shop_name         text,
    shop_description  text,
    avatar_url        text,
    status            text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'pending_verification')),
    created_at        timestamptz NOT NULL DEFAULT now(),
    updated_at        timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.profiles IS 'Profil utilisateur (1:1 avec auth.users)';

CREATE TABLE public.categories (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text NOT NULL UNIQUE,
    slug        text NOT NULL UNIQUE,
    description text,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.categories IS 'Catégories de produits';

COMMIT;