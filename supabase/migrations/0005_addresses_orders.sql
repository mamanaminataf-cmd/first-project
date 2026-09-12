-- 0005_addresses_orders.sql
-- Sprint 3 — Tables addresses, orders, order_items, order_status_history.
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

COMMENT ON TABLE public.orders IS 'Commandes passées par les acheteurs';

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