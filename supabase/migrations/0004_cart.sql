-- 0004_cart.sql
-- Sprint 3 — Tables carts et cart_items.
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