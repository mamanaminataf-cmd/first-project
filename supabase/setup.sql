-- ============================================================
-- Bio Market — Script d'installation complet (Sprint 3 + 4)
-- Exécuter ce script DANS LE SQL EDITOR de Supabase :
--   Dashboard > SQL Editor > New query > Coller > Run
-- (= migrations 0001 à 0009 concaténées)
-- ============================================================


-- ########## (0001_extensions.sql) ##########

-- 0001_extensions.sql
-- Sprint 3 â€” Extensions requises.
-- ============================================================
-- Migration: activer les extensions nÃ©cessaires.
-- DOWN:
--   DROP EXTENSION IF EXISTS pgcrypto;

BEGIN;

-- Active pgcrypto si disponible (Supabase). Son absence n'est pas bloquante :
-- gen_random_uuid() est nativement disponible en PostgreSQL >= 13.
DO $$
BEGIN
    CREATE EXTENSION IF NOT EXISTS pgcrypto;
EXCEPTION
    WHEN feature_not_supported THEN
        RAISE NOTICE 'pgcrypto non disponible - gen_random_uuid() natif utilisÃ©';
END $$;

COMMIT;

-- ########## (0002_profiles_categories.sql) ##########

-- 0002_profiles_categories.sql
-- Sprint 3 â€” Table profiles (1:1 avec auth.users) et table categories.
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

COMMENT ON TABLE public.categories IS 'CatÃ©gories de produits';

COMMIT;

-- ########## (0003_products.sql) ##########

-- 0003_products.sql
-- Sprint 3 â€” Tables products et product_images.
-- ============================================================
-- DOWN:
--   DROP TABLE IF EXISTS public.product_images;
--   DROP TABLE IF EXISTS public.products;

BEGIN;

CREATE TABLE public.products (
    id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    seller_id    uuid NOT NULL REFERENCES public.profiles (id) ON DELETE RESTRICT,
    category_id  uuid NOT NULL REFERENCES public.categories (id) ON DELETE RESTRICT,
    name         text NOT NULL,
    description  text NOT NULL,
    price        numeric(10, 2) NOT NULL CHECK (price > 0),
    stock        integer NOT NULL DEFAULT 0 CHECK (stock >= 0),
    status       text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'inactive', 'deleted')),
    deleted_at   timestamptz,
    created_at   timestamptz NOT NULL DEFAULT now(),
    updated_at   timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.products IS 'Produits vendus par les vendeurs';

CREATE TABLE public.product_images (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id  uuid NOT NULL REFERENCES public.products (id) ON DELETE CASCADE,
    url         text NOT NULL,
    position    integer NOT NULL DEFAULT 0,
    created_at  timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.product_images IS 'Images d''un produit (1 Ã  5)';

COMMIT;

-- ########## (0004_cart.sql) ##########

-- 0004_cart.sql
-- Sprint 3 â€” Tables carts et cart_items.
-- ============================================================
-- DOWN:
--   DROP TABLE IF EXISTS public.cart_items;
--   DROP TABLE IF EXISTS public.carts;

BEGIN;

CREATE TABLE public.carts (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL UNIQUE REFERENCES public.profiles (id) ON DELETE CASCADE,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.carts IS 'Panier (1 seul par utilisateur)';

CREATE TABLE public.cart_items (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id     uuid NOT NULL REFERENCES public.carts (id) ON DELETE CASCADE,
    product_id  uuid NOT NULL REFERENCES public.products (id) ON DELETE CASCADE,
    quantity    integer NOT NULL CHECK (quantity > 0),
    created_at  timestamptz NOT NULL DEFAULT now(),
    UNIQUE (cart_id, product_id)
);

COMMENT ON TABLE public.cart_items IS 'Articles d''un panier';

COMMIT;

-- ########## (0005_addresses_orders.sql) ##########

-- 0005_addresses_orders.sql
-- Sprint 3 â€” Tables addresses, orders, order_items, order_status_history.
-- ============================================================
-- DOWN:
--   DROP TABLE IF EXISTS public.order_status_history;
--   DROP TABLE IF EXISTS public.order_items;
--   DROP TABLE IF EXISTS public.orders;
--   DROP TABLE IF EXISTS public.addresses;

BEGIN;

CREATE TABLE public.addresses (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
    label       text NOT NULL,
    street      text NOT NULL,
    city        text NOT NULL,
    postal_code text NOT NULL,
    country     text NOT NULL DEFAULT 'France',
    is_default  boolean NOT NULL DEFAULT false,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.addresses IS 'Adresses de livraison des acheteurs';

CREATE TABLE public.orders (
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_id      uuid NOT NULL REFERENCES public.profiles (id) ON DELETE RESTRICT,
    address_id    uuid REFERENCES public.addresses (id) ON DELETE SET NULL,
    status        text NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending', 'paid', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded')),
    subtotal      numeric(10, 2) NOT NULL CHECK (subtotal >= 0),
    shipping_fee  numeric(10, 2) NOT NULL DEFAULT 0 CHECK (shipping_fee >= 0),
    total         numeric(10, 2) NOT NULL CHECK (total >= 0),
    created_at    timestamptz NOT NULL DEFAULT now(),
    updated_at    timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.orders IS 'Commandes passÃ©es par les acheteurs';

CREATE TABLE public.order_items (
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id      uuid NOT NULL REFERENCES public.orders (id) ON DELETE CASCADE,
    product_id    uuid REFERENCES public.products (id) ON DELETE SET NULL,
    seller_id     uuid NOT NULL REFERENCES public.profiles (id) ON DELETE RESTRICT,
    product_name  text NOT NULL,
    unit_price    numeric(10, 2) NOT NULL CHECK (unit_price > 0),
    quantity      integer NOT NULL CHECK (quantity > 0),
    subtotal      numeric(10, 2) NOT NULL CHECK (subtotal >= 0)
);

COMMENT ON TABLE public.order_items IS 'Articles d''une commande (snapshot du produit)';

CREATE TABLE public.order_status_history (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id    uuid NOT NULL REFERENCES public.orders (id) ON DELETE CASCADE,
    status      text NOT NULL,
    changed_by  uuid REFERENCES public.profiles (id) ON DELETE SET NULL,
    note        text,
    created_at  timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.order_status_history IS 'Historique des changements de statut d''une commande';

COMMIT;

-- ########## (0006_payments_reviews_favorites_notifications.sql) ##########

-- 0006_payments_reviews_favorites_notifications.sql
-- Sprint 3 â€” Tables payments, reviews, favorites, notifications.
-- ============================================================
-- DOWN:
--   DROP TABLE IF EXISTS public.notifications;
--   DROP TABLE IF EXISTS public.favorites;
--   DROP TABLE IF EXISTS public.reviews;
--   DROP TABLE IF EXISTS public.payments;

BEGIN;

CREATE TABLE public.payments (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id            uuid NOT NULL UNIQUE REFERENCES public.orders (id) ON DELETE CASCADE,
    provider            text NOT NULL,
    amount              numeric(10, 2) NOT NULL CHECK (amount > 0),
    status              text NOT NULL DEFAULT 'pending'
                          CHECK (status IN ('pending', 'succeeded', 'failed', 'refunded')),
    provider_payment_id text,
    created_at          timestamptz NOT NULL DEFAULT now(),
    updated_at          timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.payments IS 'Paiements (1 par commande)';

CREATE TABLE public.reviews (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id  uuid NOT NULL REFERENCES public.products (id) ON DELETE CASCADE,
    buyer_id    uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
    rating      integer NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title       text,
    comment     text NOT NULL CHECK (char_length(comment) >= 10),
    status      text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'hidden')),
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),
    UNIQUE (product_id, buyer_id)
);

COMMENT ON TABLE public.reviews IS 'Avis des acheteurs sur les produits';

CREATE TABLE public.favorites (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
    product_id  uuid NOT NULL REFERENCES public.products (id) ON DELETE CASCADE,
    created_at  timestamptz NOT NULL DEFAULT now(),
    UNIQUE (user_id, product_id)
);

COMMENT ON TABLE public.favorites IS 'Favoris des utilisateurs';

CREATE TABLE public.notifications (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
    type        text NOT NULL,
    title       text NOT NULL,
    body        text NOT NULL,
    is_read     boolean NOT NULL DEFAULT false,
    created_at  timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.notifications IS 'Notifications destinÃ©es aux utilisateurs';

COMMIT;

-- ########## (0007_indexes_triggers.sql) ##########

-- 0007_indexes_triggers.sql
-- Sprint 3 â€” Index de performance + trigger set_updated_at.
-- ============================================================
-- DOWN:
--   DROP TRIGGER IF EXISTS products_set_updated_at ON public.products;
--   DROP TRIGGER IF EXISTS product_images_set_updated_at ON public.product_images;
--   DROP TRIGGER IF EXISTS profiles_set_updated_at ON public.profiles;
--   DROP TRIGGER IF EXISTS categories_set_updated_at ON public.categories;
--   DROP TRIGGER IF EXISTS carts_set_updated_at ON public.carts;
--   DROP TRIGGER IF EXISTS addresses_set_updated_at ON public.addresses;
--   DROP TRIGGER IF EXISTS orders_set_updated_at ON public.orders;
--   DROP TRIGGER IF EXISTS payments_set_updated_at ON public.payments;
--   DROP TRIGGER IF EXISTS reviews_set_updated_at ON public.reviews;
--   DROP FUNCTION IF EXISTS public.set_updated_at();
--   (plus suppression des index crÃ©Ã©s)

BEGIN;

-- ---------- Index ----------

CREATE INDEX idx_products_seller_id          ON public.products (seller_id);
CREATE INDEX idx_products_category_status    ON public.products (category_id, status);
CREATE INDEX idx_products_status             ON public.products (status);
CREATE INDEX idx_product_images_product      ON public.product_images (product_id, position);
CREATE INDEX idx_cart_items_cart             ON public.cart_items (cart_id);
CREATE INDEX idx_cart_items_product          ON public.cart_items (product_id);
CREATE INDEX idx_orders_buyer_created        ON public.orders (buyer_id, created_at DESC);
CREATE INDEX idx_orders_status               ON public.orders (status);
CREATE INDEX idx_order_items_order           ON public.order_items (order_id);
CREATE INDEX idx_order_items_seller          ON public.order_items (seller_id);
CREATE INDEX idx_order_status_history_order  ON public.order_status_history (order_id);
CREATE INDEX idx_reviews_product             ON public.reviews (product_id);
CREATE INDEX idx_reviews_buyer               ON public.reviews (buyer_id);
CREATE INDEX idx_favorites_user              ON public.favorites (user_id);
CREATE INDEX idx_notifications_user_read     ON public.notifications (user_id, is_read);

-- ---------- Trigger updated_at ----------

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;

CREATE TRIGGER profiles_set_updated_at             BEFORE UPDATE ON public.profiles            FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER categories_set_updated_at           BEFORE UPDATE ON public.categories          FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER products_set_updated_at             BEFORE UPDATE ON public.products            FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER product_images_set_updated_at       BEFORE UPDATE ON public.product_images      FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER carts_set_updated_at                BEFORE UPDATE ON public.carts               FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER addresses_set_updated_at            BEFORE UPDATE ON public.addresses           FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER orders_set_updated_at               BEFORE UPDATE ON public.orders              FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER payments_set_updated_at             BEFORE UPDATE ON public.payments            FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
CREATE TRIGGER reviews_set_updated_at              BEFORE UPDATE ON public.reviews             FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

COMMIT;

-- ########## (0008_rls_policies.sql) ##########

-- 0008_rls_policies.sql
-- Sprint 3 â€” Activation RLS + politiques de base.
-- ============================================================
-- Politiques RBAC fines (with admin_is, seller checks, etc.) â†’ Sprint 12.
-- DOWN:
--   (drop policies per table â€” listÃ©es en commentaire)

BEGIN;

ALTER TABLE public.profiles        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.product_images  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.carts           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cart_items      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.addresses       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications   ENABLE ROW LEVEL SECURITY;

-- ---------- categories : lecture publique, Ã©criture admin ----------

CREATE POLICY "categories_select_public" ON public.categories
    FOR SELECT TO authenticated, anon  USING (true);

CREATE POLICY "categories_insert_admin" ON public.categories
    FOR INSERT TO authenticated WITH CHECK (
        EXISTS (SELECT 1 FROM public.profiles
                WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

CREATE POLICY "categories_update_admin" ON public.categories
    FOR UPDATE TO authenticated USING (
        EXISTS (SELECT 1 FROM public.profiles
                WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

CREATE POLICY "categories_delete_admin" ON public.categories
    FOR DELETE TO authenticated USING (
        EXISTS (SELECT 1 FROM public.profiles
                WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

-- ---------- products : lecture produits actifs, Ã©criture vendeur/admin ----------

CREATE POLICY "products_select_active_public" ON public.products
    FOR SELECT TO authenticated, anon  USING (status = 'active' AND deleted_at IS NULL);

CREATE POLICY "products_insert_owner_admin" ON public.products
    FOR INSERT TO authenticated WITH CHECK (
        EXISTS (SELECT 1 FROM public.profiles
                WHERE profiles.id = auth.uid()
                  AND profiles.role IN ('seller', 'admin'))
        AND seller_id = auth.uid());

CREATE POLICY "products_update_owner_admin" ON public.products
    FOR UPDATE TO authenticated USING (
        seller_id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

CREATE POLICY "products_delete_owner_admin" ON public.products
    FOR DELETE TO authenticated USING (
        seller_id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

-- ---------- product_images : lecture publique (produits actifs), Ã©criture vendeur ----------

CREATE POLICY "product_images_select_public" ON public.product_images
    FOR SELECT TO authenticated, anon  USING (
        EXISTS (SELECT 1 FROM public.products
                WHERE products.id = product_images.product_id
                  AND products.status = 'active'));

CREATE POLICY "product_images_manage_seller" ON public.product_images
    FOR ALL TO authenticated USING (
        EXISTS (SELECT 1 FROM public.products
                WHERE products.id = product_images.product_id
                  AND products.seller_id = auth.uid()))
    WITH CHECK (
        EXISTS (SELECT 1 FROM public.products
                WHERE products.id = product_images.product_id
                  AND products.seller_id = auth.uid()));

-- ---------- profiles : lecture/Ã©criture de son propre profil, admin tout ----------

CREATE POLICY "profiles_select_own_admin" ON public.profiles
    FOR SELECT TO authenticated USING (
        id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

CREATE POLICY "profiles_insert_own" ON public.profiles
    FOR INSERT TO authenticated WITH CHECK (id = auth.uid());

CREATE POLICY "profiles_update_own_admin" ON public.profiles
    FOR UPDATE TO authenticated USING (
        id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

-- ---------- carts : propriÃ©taire ----------

CREATE POLICY "carts_select_owner" ON public.carts
    FOR SELECT TO authenticated USING (user_id = auth.uid());

CREATE POLICY "carts_insert_owner" ON public.carts
    FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

CREATE POLICY "carts_update_owner" ON public.carts
    FOR UPDATE TO authenticated USING (user_id = auth.uid());

CREATE POLICY "carts_delete_owner" ON public.carts
    FOR DELETE TO authenticated USING (user_id = auth.uid());

-- ---------- cart_items : via le panier du propriÃ©taire ----------

CREATE POLICY "cart_items_manage_owner" ON public.cart_items
    FOR ALL TO authenticated USING (
        EXISTS (SELECT 1 FROM public.carts
                WHERE carts.id = cart_items.cart_id AND carts.user_id = auth.uid()))
    WITH CHECK (
        EXISTS (SELECT 1 FROM public.carts
                WHERE carts.id = cart_items.cart_id AND carts.user_id = auth.uid()));

-- ---------- addresses : propriÃ©taire ----------

CREATE POLICY "addresses_manage_owner" ON public.addresses
    FOR ALL TO authenticated USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- ---------- orders : buyer, admin ; vue vendeur via order_items (Sprint 12) ----------

CREATE POLICY "orders_select_buyer_admin" ON public.orders
    FOR SELECT TO authenticated USING (
        buyer_id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

CREATE POLICY "orders_insert_buyer" ON public.orders
    FOR INSERT TO authenticated WITH CHECK (buyer_id = auth.uid());

CREATE POLICY "orders_update_admin" ON public.orders
    FOR UPDATE TO authenticated USING (
        EXISTS (SELECT 1 FROM public.profiles
                WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

-- ---------- order_items : buyer, admin, vendeur (ses articles) ----------

CREATE POLICY "order_items_select_owner" ON public.order_items
    FOR SELECT TO authenticated USING (
        EXISTS (SELECT 1 FROM public.orders
                WHERE orders.id = order_items.order_id AND orders.buyer_id = auth.uid())
        OR seller_id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

-- ---------- order_status_history : buyer, vendeur (commandes liÃ©es), admin ----------

CREATE POLICY "order_status_history_select_owner" ON public.order_status_history
    FOR SELECT TO authenticated USING (
        EXISTS (SELECT 1 FROM public.orders
                WHERE orders.id = order_status_history.order_id AND orders.buyer_id = auth.uid())
        OR EXISTS (SELECT 1 FROM public.order_items
                   WHERE order_items.order_id = order_status_history.order_id
                     AND order_items.seller_id = auth.uid())
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

-- ---------- payments : buyer, admin ----------

CREATE POLICY "payments_select_buyer_admin" ON public.payments
    FOR SELECT TO authenticated USING (
        EXISTS (SELECT 1 FROM public.orders
                WHERE orders.id = payments.order_id AND orders.buyer_id = auth.uid())
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

-- ---------- reviews : lecture active publique, Ã©criture auteur, admin ----------

CREATE POLICY "reviews_select_active_public" ON public.reviews
    FOR SELECT TO authenticated, anon  USING (status = 'active');

CREATE POLICY "reviews_insert_buyer" ON public.reviews
    FOR INSERT TO authenticated WITH CHECK (buyer_id = auth.uid());

CREATE POLICY "reviews_update_author_admin" ON public.reviews
    FOR UPDATE TO authenticated USING (
        buyer_id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

CREATE POLICY "reviews_delete_author_admin" ON public.reviews
    FOR DELETE TO authenticated USING (
        buyer_id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'));

-- ---------- favorites : propriÃ©taire ----------

CREATE POLICY "favorites_manage_owner" ON public.favorites
    FOR ALL TO authenticated USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- ---------- notifications : propriÃ©taire ----------

CREATE POLICY "notifications_select_owner" ON public.notifications
    FOR SELECT TO authenticated USING (user_id = auth.uid());

CREATE POLICY "notifications_update_owner" ON public.notifications
    FOR UPDATE TO authenticated USING (user_id = auth.uid());

CREATE POLICY "notifications_delete_owner" ON public.notifications
    FOR DELETE TO authenticated USING (user_id = auth.uid());

COMMIT;

-- ########## (0009_auth_profiles.sql) ##########

-- 0009_auth_profiles.sql
-- Sprint 4 â€” Auto-crÃ©ation du profil Ã  l'inscription + sÃ©curisation du rÃ´le.
-- ============================================================
-- But :
--   1. AprÃ¨s signUp Supabase (auth.users), crÃ©er automatiquement la ligne profiles
--      avec le rÃ´le choisi Ã  l'inscription (via raw_user_meta_data.role).
--   2. Restreindre la polymise profiles_insert_own (le client ne doit PAS insÃ©rer
--      directement ; seul le trigger le fait) â€” Ã©vite qu'un utilisateur crÃ©e un
--      profil admin arbitraire.
--   3. Interdire le changement de rÃ´le par l'utilisateur lui-mÃªme (admin requis
--      pour changer un rÃ´le).
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

-- 1. Fonction trigger : crÃ©e le profil Ã  partir des mÃ©tadonnÃ©es d'inscription.
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

-- 2. Le client ne doit plus insÃ©rer directement dans profiles (rÃ´le trop risquÃ©).
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;

-- 3. L'utilisateur peut modifier son profil (nom, avatar, boutique...) mais PAS son rÃ´le.
DROP POLICY IF EXISTS "profiles_update_own_admin" ON public.profiles;

CREATE POLICY "profiles_update_own_admin" ON public.profiles
    FOR UPDATE TO authenticated
    USING (
        id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.profiles
                   WHERE profiles.id = auth.uid() AND profiles.role = 'admin'))
    WITH CHECK (
        -- admin : libre ; utilisateur : son propre profil et rÃ´le inchangÃ©
        EXISTS (SELECT 1 FROM public.profiles
                WHERE profiles.id = auth.uid() AND profiles.role = 'admin')
        OR (
            id = auth.uid()
            AND role = (SELECT role FROM public.profiles WHERE profiles.id = auth.uid())
        )
    );

COMMIT;
