# Sécurité — Bio Market

## 1. Principes obligatoires

- Authentification sécurisée
- Autorisation basée sur les rôles (RBAC)
- Contrôle des permissions côté backend / base de données
- Protection des données
- Validation côté serveur (et côté frontend si nécessaire)
- Protection contre les accès non autorisés
- Protection des fichiers
- Protection des variables d'environnement
- Absence de secrets dans Git
- Utilisation de politiques RLS si PostgreSQL/Supabase est utilisé
- Journalisation des actions sensibles lorsque nécessaire
- Tests des permissions

## 2. Interdictions strictes

Ne jamais enregistrer dans GitHub :
- mot de passe
- clé API secrète
- token privé
- clé privée
- credentials
- données réelles de paiement
- fichier `.env` contenant des secrets

## 3. Gestion des rôles (RBAC)

| Rôle | Permissions principales |
|---|---|
| **buyer** | lecture des produits publics, gestion de son panier, création et consultation de ses commandes, gestion de son profil, création d'avis autorisés |
| **seller** | CRUD de ses produits, gestion de ses stocks, consultation des commandes concernant ses produits, consultation de ses ventes |
| **admin** | gestion globale selon les règles de sécurité |

Principes :
- Les permissions sont appliquées côté backend / base de données (jamais uniquement côté frontend)
- Chaque endpoint doit vérifier le rôle
- Utiliser les RLS PostgreSQL/Supabase
- Un utilisateur ne doit jamais accéder ou modifier les données privées d'un autre utilisateur sans autorisation

## 4. Gestion des secrets

### Fichiers autorisés dans Git
- `.env.example` (template sans valeurs)
- `.gitignore` (exclut `.env`)

### Fichiers interdits dans Git
- `.env` (valeurs réelles)
- `*.key`
- `*.pem`
- credentials quelconques

## 5. Stratégie de tests de sécurité

- Tests des permissions (RBAC)
- Tests de validation des données
- Vérification que les secrets ne sont pas commités
- Audit des actions sensibles
