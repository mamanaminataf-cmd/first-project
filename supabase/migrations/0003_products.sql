-- 0003_products.sql
-- Sprint 3 — Tables products et product_images.
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

COMMENT ON TABLE public.product_images IS 'Images d''un produit (1 à 5)';

COMMIT;