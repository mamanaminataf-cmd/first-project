# Architecture technique — Bio Market

> **Sprint 2** — Décisions techniques validées.

---

## 1. Décision : Stack définitive

| Couche | Choix | Justification |
|---|---|---|
| **Frontend** | React + Vite + TypeScript + Tailwind CSS | Rapide, moderne, simple à maintenir |
| **Backend** | Supabase (hébergé) | Auth + DB + Storage + RLS inclus, gratuit pour démarrer |
| **Base de données** | PostgreSQL géré par Supabase | Relationnel, robuste |
| **Authentification** | Supabase Auth (email/mot de passe) | Sécurisé, gère sessions |
| **Autorisation** | RLS PostgreSQL (Row Level Security) | Permissions côté base |
| **Storage** | Supabase Storage | Images produits |
| **Paiements** | Stripe (à activer en fin de projet) | Standard du marché |
| **Routing** | React Router | SPA classique |
| **Versionnement** | GitHub | Source de vérité |

## 2. Structure du projet (Sprint 2+)

```
bio-market/
│
├── src/                    # Frontend React
│   ├── components/         # Composants réutilisables
│   ├── pages/              # Pages (Accueil, Catalogue, Panier...)
│   ├── contexts/           # Contexte React (auth, panier)
│   ├── hooks/              # Hooks personnalisés
│   ├── lib/                # Clients (supabase, api)
│   ├── types/              # Types TypeScript
│   └── utils/              # Fonctions utilitaires
│
├── supabase/               # Config Supabase
│   └── migrations/         # Migrations SQL (Sprint 3)
│
├── docs/                   # Documentation
├── prototype/              # Prototype statique (Sprint 1)
├── tests/                  # Tests (Sprint 14)
├── .env.example            # Variables d'environnement
└── ...
```

## 3. Flux d'authentification (Supabase Auth)

- Inscription email/mot de passe via `supabase.auth.signUp()`
- Connexion via `supabase.auth.signInWithPassword()`
- Session gérée par Supabase (JWT)
- `role` dans la table `profiles` : `buyer`, `seller`, `admin`

## 4. Règles de sécurité

- **RLS activé sur toutes les tables**
- Politiques : acheteur = lecture produits + ses propres données ; vendeur = CRUD ses produits ; admin = tout
- Variables d'environnement dans `.env`, jamais dans Git

## 5. Variables d'environnement `.env.example`

```
VITE_SUPABASE_URL=           # URL du projet Supabase
VITE_SUPABASE_ANON_KEY=      # Clé publique anon
```

> Les clés réelles seront fournies lorsque le projet Supabase sera créé (Sprint 3).

---

## 6. Étapes du Sprint 2

- [x] Choix de la stack (Supabase validé)
- [x] Installation de Node.js (v24)
- [x] Document d'architecture technique
- [x] Initialisation du projet React + Vite + Tailwind
- [x] Configuration des routes
- [x] Composants de base (Header, Footer, Card produit, etc.)
- [x] Test et vérification
- [x] Commit + push

Dernière mise à jour : Sprint 3 — Base de données (voir `docs/database.md`)