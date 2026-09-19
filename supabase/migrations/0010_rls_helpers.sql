-- 0010_rls_helpers.sql
-- Sprint 4 — Correction récursion RLS + fonctions d'aide (SECURITY DEFINER).
-- ============================================================
-- Problème : les politiques sur `profiles` (et autres) font un sous-SELECT sur
-- `profiles` pour vérifier le rôle → "infinite recursion detected in policy
-- for relation profiles".
-- Solution officielle Supabase : des fonctions SECURITY DEFINER qui lisent le
-- rôle en contournant la RLS, utilisées dans les politiques.
-- DOWN :
--   (recréer les politiques précédentes de 0008 / 0009)
--   DROP FUNCTION IF EXISTS public.current_role();
--   DROP FUNCTION IF EXISTS public.is_admin();
--   DROP FUNCTION IF EXISTS public.can_sell();

BEGIN;

-- ---------- Fonctions d'aide (contournent la RLS) ----------

CREATE OR REPLACE FUNCTION public.current_role()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT role FROM public.profiles WHERE id = auth.uid();
$$;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT COALESCE(public.current_role() = 'admin', false);
$$;

CREATE OR REPLACE FUNCTION public.can_sell()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT COALESCE(public.current_role() IN ('seller', 'admin'), false);
$$;

-- ---------- categories ----------

DROP POLICY IF EXISTS "categories_insert_admin" ON public.categories;
CREATE POLICY "categories_insert_admin" ON public.categories
    FOR INSERT TO authenticated WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "categories_update_admin" ON public.categories;
CREATE POLICY "categories_update_admin" ON public.categories
    FOR UPDATE TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS "categories_delete_admin" ON public.categories;
CREATE POLICY "categories_delete_admin" ON public.categories
    FOR DELETE TO authenticated USING (public.is_admin());

-- ---------- products ----------

DROP POLICY IF EXISTS "products_insert_owner_admin" ON public.products;
CREATE POLICY "products_insert_owner_admin" ON public.products
    FOR INSERT TO authenticated
    WITH CHECK (public.can_sell() AND seller_id = auth.uid());

DROP POLICY IF EXISTS "products_update_owner_admin" ON public.products;
CREATE POLICY "products_update_owner_admin" ON public.products
    FOR UPDATE TO authenticated
    USING (seller_id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS "products_delete_owner_admin" ON public.products;
CREATE POLICY "products_delete_owner_admin" ON public.products
    FOR DELETE TO authenticated
    USING (seller_id = auth.uid() OR public.is_admin());

-- ---------- profiles (fin de la récursion) ----------

DROP POLICY IF EXISTS "profiles_select_own_admin" ON public.profiles;
CREATE POLICY "profiles_select_own_admin" ON public.profiles
    FOR SELECT TO authenticated
    USING (id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS "profiles_update_own_admin" ON public.profiles;
CREATE POLICY "profiles_update_own_admin" ON public.profiles
    FOR UPDATE TO authenticated
    USING (id = auth.uid() OR public.is_admin())
    WITH CHECK (
        public.is_admin()
        OR (id = auth.uid() AND role = public.current_role())
    );

-- ---------- orders ----------

DROP POLICY IF EXISTS "orders_select_buyer_admin" ON public.orders;
CREATE POLICY "orders_select_buyer_admin" ON public.orders
    FOR SELECT TO authenticated
    USING (buyer_id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS "orders_update_admin" ON public.orders;
CREATE POLICY "orders_update_admin" ON public.orders
    FOR UPDATE TO authenticated USING (public.is_admin());

-- ---------- order_items ----------

DROP POLICY IF EXISTS "order_items_select_owner" ON public.order_items;
CREATE POLICY "order_items_select_owner" ON public.order_items
    FOR SELECT TO authenticated
    USING (
        seller_id = auth.uid()
        OR public.is_admin()
        OR EXISTS (SELECT 1 FROM public.orders
                   WHERE orders.id = order_items.order_id AND orders.buyer_id = auth.uid())
    );

-- ---------- order_status_history ----------

DROP POLICY IF EXISTS "order_status_history_select_owner" ON public.order_status_history;
CREATE POLICY "order_status_history_select_owner" ON public.order_status_history
    FOR SELECT TO authenticated
    USING (
        public.is_admin()
        OR EXISTS (SELECT 1 FROM public.orders
                   WHERE orders.id = order_status_history.order_id AND orders.buyer_id = auth.uid())
        OR EXISTS (SELECT 1 FROM public.order_items
                   WHERE order_items.order_id = order_status_history.order_id
                     AND order_items.seller_id = auth.uid())
    );

-- ---------- payments ----------

DROP POLICY IF EXISTS "payments_select_buyer_admin" ON public.payments;
CREATE POLICY "payments_select_buyer_admin" ON public.payments
    FOR SELECT TO authenticated
    USING (
        public.is_admin()
        OR EXISTS (SELECT 1 FROM public.orders
                   WHERE orders.id = payments.order_id AND orders.buyer_id = auth.uid())
    );

-- ---------- reviews ----------

DROP POLICY IF EXISTS "reviews_update_author_admin" ON public.reviews;
CREATE POLICY "reviews_update_author_admin" ON public.reviews
    FOR UPDATE TO authenticated
    USING (buyer_id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS "reviews_delete_author_admin" ON public.reviews;
CREATE POLICY "reviews_delete_author_admin" ON public.reviews
    FOR DELETE TO authenticated
    USING (buyer_id = auth.uid() OR public.is_admin());

COMMIT;