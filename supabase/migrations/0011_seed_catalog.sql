-- 0011_seed_catalog.sql
-- Sprint 5 -- Donnees de demonstration (categories + produits + images).
-- ============================================================
-- Idempotent : peut etre relance sans creer de doublons.
-- Si aucun vendeur n'existe, les produits sont ignores (RAISE NOTICE)
-- pour ne pas violer la FK profiles.
-- NOTE : tous les accents sont ecrits en echantillon Unicode (U&'')
-- pour rester independant de l'encodage du fichier/presse-papiers.
-- DOWN:
--   DELETE FROM public.product_images;
--   DELETE FROM public.products;
--   DELETE FROM public.categories;

BEGIN;

INSERT INTO public.categories (name, slug, description) VALUES
  (U&'L\00e9gumes',  'legumes',   U&'L\00e9gumes frais et de saison'),
  ('Fruits',         'fruits',    U&'Fruits m\00fbrs, cueillis \00e0 maturit\00e9'),
  ('Ferme',          'ferme',     U&'\0152ufs, produits laitiers et fermiers'),
  (U&'C\00e9r\00e9ales', 'cereales', U&'C\00e9r\00e9ales, farines et pain'),
  ('Boissons',       'boissons',  'Jus et boissons saines'),
  (U&'\00c9picerie', 'epicerie',  U&'\00c9picerie s\00e8che et sucrante')
ON CONFLICT (slug) DO NOTHING;

DO $$
DECLARE
  v_seller uuid;
  v_legumes uuid;
  v_fruits  uuid;
  v_ferme   uuid;
  v_epicerie uuid;
  v_prod    uuid;
BEGIN
  SELECT id INTO v_seller
    FROM public.profiles
   WHERE role = 'seller'
   ORDER BY created_at
   LIMIT 1;

  IF v_seller IS NULL THEN
    RAISE NOTICE '0011_seed_catalog: aucun vendeur trouve, produits non crees';
    RETURN;
  END IF;

  SELECT id INTO v_legumes  FROM public.categories WHERE slug = 'legumes';
  SELECT id INTO v_fruits   FROM public.categories WHERE slug = 'fruits';
  SELECT id INTO v_ferme    FROM public.categories WHERE slug = 'ferme';
  SELECT id INTO v_epicerie FROM public.categories WHERE slug = 'epicerie';

  IF NOT EXISTS (SELECT 1 FROM public.products WHERE name = 'Tomates cerises bio') THEN
    INSERT INTO public.products (seller_id, category_id, name, description, price, stock, status)
    VALUES (v_seller, v_legumes, 'Tomates cerises bio',
            U&'Tomates cerises cultiv\00e9es sous serre, r\00e9colt\00e9es \00e0 maturit\00e9 pour un go\00fbt bien sucr\00e9.',
            3.50, 12, 'active')
    RETURNING id INTO v_prod;
    INSERT INTO public.product_images (product_id, url, position)
    VALUES (v_prod, 'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?auto=format&fit=crop&w=600&q=80', 0);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.products WHERE name = 'Carottes des sables') THEN
    INSERT INTO public.products (seller_id, category_id, name, description, price, stock, status)
    VALUES (v_seller, v_legumes, 'Carottes des sables',
            U&'Carottes cultiv\00e9es en sol sableux, naturellement sucr\00e9es et croquantes.',
            1.90, 25, 'active')
    RETURNING id INTO v_prod;
    INSERT INTO public.product_images (product_id, url, position)
    VALUES (v_prod, 'https://images.unsplash.com/photo-1447175008436-054170c2e979?auto=format&fit=crop&w=600&q=80', 0);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.products WHERE name = 'Pommes Gala bio') THEN
    INSERT INTO public.products (seller_id, category_id, name, description, price, stock, status)
    VALUES (v_seller, v_fruits, 'Pommes Gala bio',
            U&'Pommes Gala croquantes et sucr\00e9es, cueillies \00e0 la main dans nos vergers.',
            2.90, 8, 'active')
    RETURNING id INTO v_prod;
    INSERT INTO public.product_images (product_id, url, position)
    VALUES (v_prod, 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80', 0);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.products WHERE name = 'Fraises gariguette') THEN
    INSERT INTO public.products (seller_id, category_id, name, description, price, stock, status)
    VALUES (v_seller, v_fruits, 'Fraises gariguette',
            U&'Fraises gariguette parfum\00e9es, r\00e9colt\00e9es du jour.',
            4.50, 0, 'active')
    RETURNING id INTO v_prod;
    INSERT INTO public.product_images (product_id, url, position)
    VALUES (v_prod, 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=600&q=80', 0);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.products WHERE name = U&'\0152ufs plein air') THEN
    INSERT INTO public.products (seller_id, category_id, name, description, price, stock, status)
    VALUES (v_seller, v_ferme, U&'\0152ufs plein air',
            U&'\0152ufs frais de poules \00e9lev\00e9es en plein air, calibre moyen.',
            4.20, 18, 'active')
    RETURNING id INTO v_prod;
    INSERT INTO public.product_images (product_id, url, position)
    VALUES (v_prod, 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?auto=format&fit=crop&w=600&q=80', 0);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.products WHERE name = 'Miel de lavande') THEN
    INSERT INTO public.products (seller_id, category_id, name, description, price, stock, status)
    VALUES (v_seller, v_epicerie, 'Miel de lavande',
            U&'Miel de lavande 100% fran\00e7ais, r\00e9colt\00e9 en Provence. Pot de 500 g.',
            8.90, 6, 'active')
    RETURNING id INTO v_prod;
    INSERT INTO public.product_images (product_id, url, position)
    VALUES (v_prod, 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?auto=format&fit=crop&w=600&q=80', 0);
  END IF;

  RAISE NOTICE '0011_seed_catalog: % produit(s) verifie(s) pour le vendeur %',
    (SELECT count(*) FROM public.products WHERE seller_id = v_seller), v_seller;
END $$;

COMMIT;