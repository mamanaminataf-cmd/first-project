-- 0012_repair_catalog.sql
-- Sprint 5 - Correction des donnees seedees (encodage + image miel).
-- ============================================================
-- Le seed 0011 a ete colle dans le SQL Editor avec un encodage casse
-- (UTF-8 lu en ANSI) produisant des noms mojibakes (accents deformes).
-- Cette migration reecrit les valeurs correctes en ASCII pur (echappement
-- Unicode U&'' : independant de l'encodage).
-- DOWN: sans objet (correction de donnees).
BEGIN;

-- Le trigger set_updated_at (0007) couvre product_images mais cette table
-- n'avait pas de colonne updated_at (lacune de 0003) : on la cree ici
-- (IF NOT EXISTS : sans effet sur une base fraiche).
ALTER TABLE public.product_images
    ADD COLUMN IF NOT EXISTS updated_at timestamptz NOT NULL DEFAULT now();

-- ---------- Categories ----------

UPDATE public.categories
   SET name = U&'L\00e9gumes', description = U&'L\00e9gumes frais et de saison'
 WHERE slug = 'legumes';

UPDATE public.categories
   SET name = 'Fruits', description = U&'Fruits m\00fbrs, cueillis \00e0 maturit\00e9'
 WHERE slug = 'fruits';

UPDATE public.categories
   SET name = 'Ferme', description = U&'\0152ufs, produits laitiers et fermiers'
 WHERE slug = 'ferme';

UPDATE public.categories
   SET name = U&'C\00e9r\00e9ales', description = U&'C\00e9r\00e9ales, farines et pain'
 WHERE slug = 'cereales';

UPDATE public.categories
   SET name = 'Boissons', description = 'Jus et boissons saines'
 WHERE slug = 'boissons';

UPDATE public.categories
   SET name = U&'\00c9picerie', description = U&'\00c9picerie s\00e8che et sucrante'
 WHERE slug = 'epicerie';

-- ---------- Produits ----------

UPDATE public.products
   SET description = U&'Tomates cerises cultiv\00e9es sous serre, r\00e9colt\00e9es \00e0 maturit\00e9 pour un go\00fbt bien sucr\00e9.'
 WHERE id = 'd7973563-1ea1-4a35-8407-399e32368e90';

UPDATE public.products
   SET description = U&'Carottes cultiv\00e9es en sol sableux, naturellement sucr\00e9es et croquantes.'
 WHERE id = '84a5c06e-fd85-47cf-9ccb-dbdaf816ffae';

UPDATE public.products
   SET description = U&'Pommes Gala croquantes et sucr\00e9es, cueillies \00e0 la main dans nos vergers.'
 WHERE id = 'ca1f4c38-2ee2-498f-8757-f75c1f94f519';

UPDATE public.products
   SET description = U&'Fraises gariguette parfum\00e9es, r\00e9colt\00e9es du jour.'
 WHERE id = '752e613f-1b69-46b7-bd04-a3456be84767';

UPDATE public.products
   SET name = U&'\0152ufs plein air',
       description = U&'\0152ufs frais de poules \00e9lev\00e9es en plein air, calibre moyen.'
 WHERE id = 'd9f00378-e0a2-496a-bd1a-290e2eab1fa9';

UPDATE public.products
   SET description = U&'Miel de lavande 100% fran\00e7ais, r\00e9colt\00e9 en Provence. Pot de 500 g.'
 WHERE id = '41436854-29eb-4c34-9ee5-b3a944f83687';

-- ---------- Image du miel (Wikimedia Commons, URL stable) ----------

UPDATE public.product_images
   SET url = 'https://thumb.wikimedia.org/wikipedia/commons/thumb/2/24/Three_French_monofloral_honey_jars.jpg/960px-Three_French_monofloral_honey_jars.jpg'
 WHERE product_id = '41436854-29eb-4c34-9ee5-b3a944f83687'
   AND position = 0;

COMMIT;