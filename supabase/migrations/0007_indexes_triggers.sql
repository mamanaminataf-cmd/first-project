-- 0007_indexes_triggers.sql
-- Sprint 3 — Index de performance + trigger set_updated_at.
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
--   (plus suppression des index créés)

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