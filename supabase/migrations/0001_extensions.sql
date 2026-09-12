-- 0001_extensions.sql
-- Sprint 3 — Extensions requises.
-- ============================================================
-- Migration: activer les extensions nécessaires.
-- DOWN:
--   DROP EXTENSION IF EXISTS pgcrypto;

BEGIN;

-- Active pgcrypto si disponible (Supabase). Son absence n'est pas bloquante :
-- gen_random_uuid() est nativement disponible en PostgreSQL >= 13.
DO $$
BEGIN
    CREATE EXTENSION IF NOT EXISTS pgcrypto;
EXCEPTION
    WHEN feature_not_supported THEN
        RAISE NOTICE 'pgcrypto non disponible - gen_random_uuid() natif utilisé';
END $$;

COMMIT;