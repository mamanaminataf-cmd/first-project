# Plan des sprints — Bio Market

## Statut actuel

**Sprint actuel :** Sprint 4 — Authentification et profils ✅

**Sprint précédent :** Sprint 3 — Conception et création de la base de données ✅

## Liste des sprints

| Sprint | Intitulé | Outils principaux |
|---|---|---|
| 0 | Audit et cadrage | GitHub + documentation |
| 1 | Conception fonctionnelle | GitHub + documentation |
| 2 | Architecture technique | OpenCode + GitHub |
| 3 | Conception et création de la base de données | OpenCode + GitHub |
| 4 | Authentification et profils | OpenCode |
| 5 | Produits et catalogue | OpenCode |
| 6 | Panier | OpenCode |
| 7 | Commandes | OpenCode |
| 8 | Paiement | OpenCode |
| 9 | Espace vendeur | OpenCode |
| 10 | Administration | OpenCode |
| 11 | Recherche, filtres et UX | OpenCode |
| 12 | Sécurité et permissions | OpenCode |
| 13 | Notifications et fonctionnalités avancées | OpenCode |
| 14 | Tests complets | OpenCode + GitHub |
| 15 | Correction et optimisation | OpenCode |
| 16 | Audit final | OpenCode + GitHub |
| 17 | Déploiement | GitHub + infrastructure choisie |

## État par phase

- **Sprint 0 (terminé ✅) :** Audit et cadrage. Configuration initiale du projet, documentation, structure, Git.
- **Sprint 1 (terminé ✅) :** Conception fonctionnelle. `docs/functional-design.md` : pages, flux, états, règles métier.
- **Sprint 2 (terminé ✅) :** Architecture technique. Stack choisie (React + Vite + Tailwind + Supabase), projet initialisé.
- **Sprint 3 (terminé ✅) :** Conception et création de la base de données. `docs/database.md` détaillée, migrations SQL testées (PGlite).
- **Sprint 4 (terminé ✅) :** Authentification et profils. Supabase Auth branché (connexion, inscription, profil, rôles), migrations `0009` (trigger) + `0010` (fix RLS récursion), contexte React `AuthContext`, pages Login/Register/Account. **Validé par l'utilisateur** dans le navigateur.

## À ne PAS faire pendant la configuration initiale

- Créer les tables définitives
- Créer les migrations SQL
- Créer l'authentification
- Créer les policies RLS
- Créer les API métier
- Créer le système de paiement
- Créer le panier
- Créer les commandes
- Créer les dashboards
- Installer inutilement des dépendances
- Choisir définitivement un backend sans validation
- Mettre des secrets dans GitHub
- Créer des données réelles
