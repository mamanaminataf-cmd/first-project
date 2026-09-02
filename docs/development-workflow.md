# Workflow de développement — Bio Market

## 1. Git

### Branches principales
- `main` : version stable, protégée, aucune modification directe si possible
- `develop` : branche principale de développement

### Branches de fonctionnalités
- `feature/*` : nouvelles fonctionnalités
- `fix/*` : corrections
- `security/*` : corrections liées à la sécurité
- `docs/*` : documentation
- `refactor/*` : refactorisation

### Règles
- `main` : version stable, protégée, aucune modification directe
- `develop` : branche principale de développement
- Toute feature importante passe par une Pull Request
- Branches nettoyées après merge

## 2. Convention des commits (Conventional Commits)

Préfixes :
- `feat:` — nouvelle fonctionnalité
- `fix:` — correction de bug
- `docs:` — documentation
- `refactor:` — refactorisation
- `test:` — tests
- `security:` — sécurité
- `chore:` — tâches techniques

Exemples :
```
feat(products): add product creation
fix(cart): correct quantity calculation
docs(database): update product relationships
security(auth): improve session validation
test(products): add product validation tests
```

## 3. Pull Request

Toute fonctionnalité importante passe par une Pull Request. Une PR doit expliquer :
- problème résolu
- solution utilisée
- fichiers importants modifiés
- tests réalisés
- éventuels risques
- éventuelles migrations
- éventuels changements de sécurité

Ne pas fusionner une fonctionnalité non testée. Review obligatoire pour `main`.

## 4. Issues

Utiliser GitHub Issues pour : fonctionnalités, bugs, sécurité, documentation, tâches techniques, amélioration UX, dette technique.

### Labels prévus
```
feature, bug, security, database, frontend, backend,
authentication, testing, documentation, performance, urgent
```

## 5. GitHub Project — Bio Market Development

Colonnes :
```
BACKLOG
À FAIRE
EN COURS
EN REVUE
TEST
TERMINÉ
```

Chaque fonctionnalité importante doit être représentée par une tâche.

## 6. Milestones
```
MVP
Marketplace
Paiement
Sécurité
Production
```

Ajustables selon l'évolution du projet.

## 7. Répartition des outils

| Outil | Rôle |
|---|---|
| **GitHub** | versionnement, code, documentation, branches, PR, issues, CI/CD |
| **Lovable** | interface utilisateur, UI/UX, composants, design system, responsive |
| **OpenCode** | backend, logique métier, base de données, migrations, auth, permissions, API, tests, sécurité |
