# Plan des sprints — Bio Market

## Statut actuel

**Sprint actuel :** Sprint 0 — Audit et cadrage

## Liste des sprints

| Sprint | Intitulé | Outils principaux |
|---|---|---|
| 0 | Audit et cadrage | GitHub + documentation |
| 1 | Conception fonctionnelle | GitHub + documentation |
| 2 | Architecture technique | OpenCode + GitHub |
| 3 | Conception et création de la base de données | OpenCode + GitHub |
| 4 | Authentification et profils | OpenCode (logique) + Lovable (UI) |
| 5 | Produits et catalogue | OpenCode (backend/db) + Lovable (UI) |
| 6 | Panier | OpenCode (logique) + Lovable (UI) |
| 7 | Commandes | OpenCode + Lovable |
| 8 | Paiement | OpenCode + Lovable |
| 9 | Espace vendeur | OpenCode (logique) + Lovable (dashboard) |
| 10 | Administration | OpenCode (permissions/logique) + Lovable (UI admin) |
| 11 | Recherche, filtres et UX | Lovable (UX/UI) + OpenCode (recherche/backend) |
| 12 | Sécurité et permissions | OpenCode principalement |
| 13 | Notifications et fonctionnalités avancées | OpenCode (logique) + Lovable (UI) |
| 14 | Tests complets | OpenCode + GitHub |
| 15 | Correction et optimisation | OpenCode principalement, Lovable (bugs UI/UX) |
| 16 | Audit final | OpenCode + GitHub |
| 17 | Déploiement | GitHub + infrastructure choisie |

## État par phase

- **Sprint 0 (en cours) :** configuration initiale. Uniquement préparation et documentation, pas de développement métier.

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
