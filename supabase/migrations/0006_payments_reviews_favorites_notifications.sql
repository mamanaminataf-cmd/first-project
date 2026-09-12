-- 0006_payments_reviews_favorites_notifications.sql
-- Sprint 3 — Tables payments, reviews, favorites, notifications.
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

COMMENT ON TABLE public.notifications IS 'Notifications destinées aux utilisateurs';

COMMIT;