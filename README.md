# Bio Market

Plateforme web de marketplace de produits biologiques mettant en relation acheteurs, vendeurs et administrateurs.

## Description

Bio Market est une plateforme web permettant de mettre en relation des acheteurs et des vendeurs de produits biologiques, avec un espace d'administration permettant de gérer et superviser la plateforme.

L'application permet aux vendeurs de produits biologiques de présenter et vendre leurs produits en ligne. Les acheteurs peuvent rechercher des produits, consulter leurs informations, les ajouter au panier, passer des commandes, effectuer des paiements et suivre leurs commandes.

## Objectifs

- Faciliter l'accès aux produits biologiques
- Faciliter la vente des produits biologiques
- Mettre en relation vendeurs et acheteurs
- Permettre aux vendeurs de gérer leurs produits et leurs stocks
- Permettre aux acheteurs de rechercher et commander des produits
- Permettre le paiement et le suivi des commandes
- Permettre l'évaluation des produits
- Permettre à l'administrateur de superviser la plateforme

## Utilisateurs

Trois rôles principaux :

| Rôle | Description |
|---|---|
| **Acheteur** | Recherche, panier, commandes, paiements, avis, favoris |
| **Vendeur** | Gestion des produits, stocks, commandes, ventes |
| **Administrateur** | Gestion globale, statistiques, supervision, sécurité |

## Fonctionnalités principales

1. Authentification
2. Gestion des profils
3. Gestion des rôles
4. Catalogue de produits
5. Catégories
6. Recherche et filtres
7. Fiches produits
8. Gestion des images
9. Gestion du stock
10. Panier
11. Commandes
12. Paiements
13. Suivi des commandes
14. Avis et évaluations
15. Favoris
16. Notifications
17. Espace vendeur
18. Tableau de bord administrateur
19. Statistiques
20. Sécurité et permissions
21. Responsive design
22. Tests
23. Déploiement

## Technologies

- **Frontend :** React + Vite + TypeScript + Tailwind CSS (développé avec OpenCode)
- **Backend :** Supabase (Auth + PostgreSQL + Storage + RLS)
- **Base de données :** PostgreSQL (géré par Supabase)
- **Auth :** Supabase Auth (email/mot de passe)
- **Storage :** Supabase Storage
- **Paiements :** Stripe (prévu, Sprint 8)
- **Routing :** React Router

## Architecture générale

```
Utilisateur → Frontend → Backend/API → Base de données
                                    → Storage (images)
                                    → Authentification
                                    → Paiements
                                    → Notifications
```

GitHub est la source de vérité du projet (versionnement, documentation, branches, PR, CI/CD).

## Installation

```bash
npm install          # installer les dépendances
npm run dev          # lancer le serveur de développement
npm run build        # build de production
```

Voir `.env.example` puis créer `.env` avec les clés Supabase.

## Variables d'environnement

Copier le fichier `.env.example` en `.env` et remplir les valeurs.

**Ne jamais commiter le fichier `.env`.**

## Développement

- Chaque fonctionnalité est développée sur une branche dédiée
- Les commits suivent la convention [Conventional Commits](https://www.conventionalcommits.org/)
- Toute fonctionnalité importante passe par une Pull Request
- Voir `docs/development-workflow.md` pour le détail

## Tests

> Stratégie de tests à définir avec la stack finale.

- Tests unitaires pour la logique métier
- Tests d'intégration pour les API
- Tests de permissions (RBAC)
- Tests de validation des données

## Workflow Git

### Branches
- `main` : version stable, protégée
- `develop` : branche principale de développement
- `feature/*`, `fix/*`, `security/*`, `docs/*`, `refactor/*`

### Commits
```
feat(products): add product creation
fix(cart): correct quantity calculation
docs(database): update product relationships
security(auth): improve session validation
```

## Statut du projet

**Sprint en cours :** Sprint 5 — Produits et catalogue

**Précédents :** Sprints 0-4 terminés ✅ (docs, conception, architecture, base de données et migrations testées, authentification et profils fonctionnels)

Voir `docs/sprints.md` pour le plan complet des sprints.

## Documentation

- `docs/cahier-des-charges.md` — Cahier des charges
- `docs/functional-design.md` — Conception fonctionnelle
- `docs/technical-architecture.md` — Architecture technique
- `docs/architecture.md` — Architecture générale
- `docs/database.md` — Base de données
- `docs/security.md` — Sécurité
- `docs/development-workflow.md` — Workflow de développement
- `docs/sprints.md` — Plan des sprints
- `AGENTS.md` — Règles pour les sessions OpenCode
