-- 0013_products_select_owner.sql
-- Sprint 5 - Un vendeur voit TOUJOURS ses propres produits (meme inactifs/drafts).
-- ============================================================
-- Sans cette politique, products_select_active_public (0008) n'expose
-- que les produits actifs : un vendeur ne pourrait pas gérer ses
-- produits inactifs dans "Ma boutique".
-- DOWN:
--   DROP POLICY IF EXISTS "products_select_owner" ON public.products;

BEGIN;

-- Redondant sans etre destructif (permet de relancer la migration).
DROP POLICY IF EXISTS "products_select_owner" ON public.products;

CREATE POLICY "products_select_owner" ON public.products
    FOR SELECT TO authenticated
    USING (seller_id = auth.uid());

COMMIT;