-- 0008_rls_policies.sql
-- Sprint 3 — Activation RLS + politiques de base.
-- ============================================================
-- Politiques RBAC fines (with admin_is, seller checks, etc.) → Sprint 12.
-- DOWN:
--   (drop policies per table — listées en commentaire)

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

-- ---------- categories : lecture publique, écriture admin ----------

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

-- ---------- products : lecture produits actifs, écriture vendeur/admin ----------

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

-- ---------- product_images : lecture publique (produits actifs), écriture vendeur ----------

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

-- ---------- profiles : lecture/écriture de son propre profil, admin tout ----------

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

-- ---------- carts : propriétaire ----------

CREATE POLICY "carts_select_owner" ON public.carts
    FOR SELECT TO authenticated USING (user_id = auth.uid());

CREATE POLICY "carts_insert_owner" ON public.carts
    FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

CREATE POLICY "carts_update_owner" ON public.carts
    FOR UPDATE TO authenticated USING (user_id = auth.uid());

CREATE POLICY "carts_delete_owner" ON public.carts
    FOR DELETE TO authenticated USING (user_id = auth.uid());

-- ---------- cart_items : via le panier du propriétaire ----------

CREATE POLICY "cart_items_manage_owner" ON public.cart_items
    FOR ALL TO authenticated USING (
        EXISTS (SELECT 1 FROM public.carts
                WHERE carts.id = cart_items.cart_id AND carts.user_id = auth.uid()))
    WITH CHECK (
        EXISTS (SELECT 1 FROM public.carts
                WHERE carts.id = cart_items.cart_id AND carts.user_id = auth.uid()));

-- ---------- addresses : propriétaire ----------

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

-- ---------- order_status_history : buyer, vendeur (commandes liées), admin ----------

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

-- ---------- reviews : lecture active publique, écriture auteur, admin ----------

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

-- ---------- favorites : propriétaire ----------

CREATE POLICY "favorites_manage_owner" ON public.favorites
    FOR ALL TO authenticated USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- ---------- notifications : propriétaire ----------

CREATE POLICY "notifications_select_owner" ON public.notifications
    FOR SELECT TO authenticated USING (user_id = auth.uid());

CREATE POLICY "notifications_update_owner" ON public.notifications
    FOR UPDATE TO authenticated USING (user_id = auth.uid());

CREATE POLICY "notifications_delete_owner" ON public.notifications
    FOR DELETE TO authenticated USING (user_id = auth.uid());

COMMIT;