# Architecture — Bio Market

## 1. Vue d'ensemble

```
Utilisateur
    ↓
Interface utilisateur
    ↓
Frontend
    ↓
Backend / API
    ↓
Base de données
    ↓
Sécurité / permissions
```

## 2. Services supplémentaires

```
Frontend → Storage (images/fichiers)
Backend  → Authentification
Backend  → Paiement
Backend  → Notifications
```

## 3. Stack technique (à confirmer)

> Cette section sera mise à jour lorsque la stack sera validée.

| Couche | Technologie pressentie | Statut |
|---|---|---|
| Frontend | React / Next.js (développé avec OpenCode) | À valider |
| Backend | Node.js / Supabase | À valider |
| Base de données | PostgreSQL / Supabase | À valider |
| Auth | Supabase Auth ou custom | À valider |
| Storage | Supabase Storage ou S3 | À valider |
| Paiements | Stripe | À valider |
| Versionnement | GitHub | Confirmé |

## 4. Outils du projet

### GitHub
Source de vérité du projet : versionnement, code source, documentation, branches, commits, Pull Requests, Issues, suivi des bugs, GitHub Projects, Milestones, CI/CD, historique.

### OpenCode
Développement de la stack complète : frontend (UI/UX, composants, pages, design system, responsive design), backend, logique métier, base de données, migrations, authentification, autorisation, rôles, permissions, RLS, API, stockage, validation, tests, sécurité, correction des bugs, optimisation, maintenance.

## 5. Compatibilité et choix des services

Avant de choisir définitivement l'architecture backend, vérifier la compatibilité entre : GitHub, OpenCode, backend, base de données, authentification, déploiement.

> Ne pas créer automatiquement une architecture backend définitive sans validation.

## 6. Structure du repository

```
bio-market/
│
├── README.md
├── AGENTS.md
├── .gitignore
├── .env.example
│
├── docs/
│   ├── cahier-des-charges.md
│   ├── architecture.md
│   ├── database.md
│   ├── security.md
│   ├── development-workflow.md
│   └── sprints.md
│
├── src/
│
├── public/
│
├── tests/
│
├── supabase/
│
└── .github/
    ├── workflows/
    └── ISSUE_TEMPLATE/
```

> Ne pas créer artificiellement des dossiers techniques qui ne sont pas nécessaires au framework finalement choisi.

## 7. Décisions à venir

- Choix définitif du backend (Supabase, Node.js, autre)
- Choix du système d'authentification
- Choix du système de paiement
- Stratégie de déploiement
- Structure finale de `src/`
