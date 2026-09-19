# AGENTS.MD - Bio Market

Document de référence pour les sessions OpenCode.

---

## 1. OBJECTIF DU PROJET

Bio Market est une plateforme web de marketplace de produits biologiques mettant en relation acheteurs, vendeurs et administrateurs.

---

## 2. ARCHITECTURE

**Architecture cible :**

```
Utilisateur → Frontend → Backend/API → Base de données
                                    → Storage (images)
                                    → Authentification
                                    → Paiements
                                    → Notifications
```

**Stack technique (à confirmer) :**
- Frontend : React/Next.js (développé avec OpenCode)
- Backend : Node.js / Supabase (à valider)
- Base de données : PostgreSQL / Supabase
- Auth : Supabase Auth ou custom
- Storage : Supabase Storage ou S3
- Paiements : Stripe (à valider)

---

## 3. CONVENTIONS DE CODE

### Frontend
- Composants React
- TypeScript
- Tailwind CSS
- Convention de nommage : PascalCase pour les composants

### Backend
- TypeScript / JavaScript
- Migration SQL syntaxe PostgreSQL
- Convention de nommage : snake_case pour la DB

---

## 4. CONVENTIONS GIT

### Branches
- `main` : version stable, protégée
- `develop` : branche principale de développement
- `feature/*` : nouvelles fonctionnalités
- `fix/*` : corrections
- `security/*` : corrections de sécurité
- `docs/*` : documentation
- `refactor/*` : refactorisation

### Commits (Conventional Commits)
```
feat(products): add product creation
fix(cart): correct quantity calculation
docs(database): update product relationships
security(auth): improve session validation
test(products): add product validation tests
```

---

## 5. SÉCURITÉ

### Règles obligatoires
- Authentification sécurisée
- Autorisation basée sur les rôles (RBAC)
- Contrôle des permissions côté backend/base de données
- Validation côté serveur
- Protection des variables d'environnement

### Interdictions
- **JAMAIS** de secrets dans Git
- **JAMAIS** de mots de passe en dur
- **JAMAIS** de clés API dans le code
- **JAMAIS** de données de paiement réelles
- **JAMAIS** de tokens dans le code source

---

## 6. GESTION DES SECRETS

### Fichiers autorisés dans Git
- `.env.example` (template sans valeurs)
- `.gitignore` (exclut `.env`)

### Fichiers interdits dans Git
- `.env` (valeurs réelles)
- `*.key`
- `*.pem`
- Credentials quelconques

---

## 7. STRATÉGIE DE TESTS

- Tests unitaires pour la logique métier
- Tests d'intégration pour les API
- Tests de permissions (RBAC)
- Tests de validation des données
- Tests frontend avec les outils adaptés au framework choisi

---

## 8. RÔLE D'OPENCODE

### Utiliser OpenCode pour
- Frontend / Interface utilisateur (UI/UX)
- Composants, pages et design system
- Responsive design, expérience utilisateur
- Backend / logique métier
- Base de données
- Migrations SQL
- Authentification
- Autorisation / RLS
- API
- Validation
- Tests
- Sécurité
- Optimisation
- Maintenance

---

## 9. RÔLE DE GITHUB

- Source de vérité du projet
- Versionnement
- Documentation
- Branches / PR
- Issues
- Suivi des bugs
- CI/CD

---

## 10. RÈGLES - MIGRATIONS SQL

- Pas de migrations définitives pendant Sprint 0-1
- Chaque migration doit être testée
- Chaque migration doit pouvoir être annulée (down)
- Utiliser les transactions
- Documenter chaque migration

---

## 11. RÈGLES - BASE DE DONNÉES

- Utiliser les conventions snake_case
- Clés primaires : `id` (UUID ou SERIAL)
- Clés étrangères : `table_id`
- Timestamps : `created_at`, `updated_at`
- Soft delete : `deleted_at` si nécessaire
- Index sur les colonnes fréquemment requêtées

---

## 12. RÈGLES - PERMISSIONS (RBAC)

### Rôles
- `buyer` : lecture produits, panier, commandes, avis
- `seller` : CRUD propres produits, lecture commandes
- `admin` : gestion globale

### Principes
- Permissions côté backend/base de données
- Jamais uniquement côté frontend
- Chaque endpoint doit vérifier le rôle
- Utiliser les RLS PostgreSQL/Supabase

---

## 13. RÈGLES - PULL REQUESTS

- Toute feature importante passe par une PR
- PR doit expliquer : problème, solution, fichiers, tests, risques
- Pas de merge sans tests
- Review obligatoire pour `main`
- Branches nettoyées après merge

---

## 14. DOCUMENTATION

Maintenir à jour :
- `docs/cahier-des-charges.md`
- `docs/architecture.md`
- `docs/database.md`
- `docs/security.md`
- `docs/development-workflow.md`
- `docs/sprints.md`
- `README.md`

---

## 15. STATUT DU PROJET

**Sprint actuel :** 5 - Produits et catalogue

**Phase :** Sprint 4 ✅ terminé — Supabase Auth réel branché (connexion, inscription, profil via trigger, rôles), RLS corrigée (migrations 0009-0010), pages Login/Register/Account fonctionnelles.

**À ne PAS faire maintenant :**
- Créer des APIs métier avancés hors catalogue (panier, commandes, paiement : sprints 6-8)
- Créer l'espace vendeur complet (Sprint 9)
- Créer l'administration (Sprint 10)
- Créer des policies RLS fines / RBAC avancé (Sprint 12)
- Installer des dépendances inutilement
- Pousser des secrets dans Git

---

Dernière mise à jour : Stack simplifiée — Lovable retiré
