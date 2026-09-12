# Base de données — Bio Market

> **Sprint 3** — Conception détaillée et migrations SQL. PostgreSQL géré par Supabase.

## 1. Conventions

- Convention de nommage : `snake_case`
- Clés primaires : `id UUID DEFAULT gen_random_uuid()` (extension `pgcrypto`)
- Clés étrangères : `table_id`
- Timestamps : `created_at`, `updated_at` (`updated_at` mis à jour par trigger)
- Soft delete : `deleted_at` pour `products`
- Index sur les colonnes fréquemment requêtées
- Mots-clés d'état : type `text` + contrainte `CHECK`
- Chaque migration : transaction, testée, documentée, avec rollback (`-- DOWN`)

## 2. Modèle de données (v1)

```
profiles
categories
products
product_images
carts
cart_items
addresses
orders
order_items
order_status_history
payments
reviews
favorites
notifications
```

## 3. Détail des tables

### 3.1 profiles

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK, FK → `auth.users(id)` | Identifiant utilisateur |
| role | text | `CHECK (role IN ('buyer','seller','admin'))`, défaut `buyer` | Rôle RBAC |
| full_name | text | NOT NULL | Nom complet |
| email | text | NOT NULL, UNIQUE | Email |
| shop_name | text | NULL | Nom de boutique (vendeur) |
| shop_description | text | NULL | Description boutique (vendeur) |
| avatar_url | text | NULL | Photo de profil |
| status | text | `CHECK (status IN ('active','suspended','pending_verification'))`, défaut `active` | État du compte |
| created_at | timestamptz | défaut `now()` | |
| updated_at | timestamptz | défaut `now()` | |

### 3.2 categories

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| name | text | NOT NULL, UNIQUE | Nom (ex. "Légumes") |
| slug | text | NOT NULL, UNIQUE | Identifiant URL |
| description | text | NULL | Description |
| created_at | timestamptz | défaut `now()` | |
| updated_at | timestamptz | défaut `now()` | |

### 3.3 products

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| seller_id | uuid | FK → `profiles(id)`, NOT NULL | Vendeur |
| category_id | uuid | FK → `categories(id)`, NOT NULL | Catégorie |
| name | text | NOT NULL | Nom du produit |
| description | text | NOT NULL | Description |
| price | numeric(10,2) | CHECK `price > 0`, NOT NULL | Prix unitaire |
| stock | integer | CHECK `stock >= 0`, défaut 0 | Quantité disponible |
| status | text | `CHECK (status IN ('draft','active','inactive','deleted'))`, défaut `draft` | État |
| deleted_at | timestamptz | NULL | Soft delete |
| created_at | timestamptz | défaut `now()` | |
| updated_at | timestamptz | défaut `now()` | |

### 3.4 product_images

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| product_id | uuid | FK → `products(id)`, NOT NULL | Produit |
| url | text | NOT NULL | URL de l'image |
| position | integer | défaut 0 | Ordre d'affichage |
| created_at | timestamptz | défaut `now()` | |

### 3.5 carts

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK → `profiles(id)`, NOT NULL, UNIQUE | Acheteur (1 panier / compte) |
| created_at | timestamptz | défaut `now()` | |
| updated_at | timestamptz | défaut `now()` | |

### 3.6 cart_items

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| cart_id | uuid | FK → `carts(id)`, NOT NULL | Panier |
| product_id | uuid | FK → `products(id)`, NOT NULL | Produit |
| quantity | integer | CHECK `quantity > 0`, NOT NULL | Quantité |
| created_at | timestamptz | défaut `now()` | |

UNIQUE `(cart_id, product_id)` — un produit n'apparaît qu'une fois par panier.

### 3.7 addresses

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK → `profiles(id)`, NOT NULL | Propriétaire |
| label | text | NOT NULL | Libellé (ex. "Maison") |
| street | text | NOT NULL | Adresse |
| city | text | NOT NULL | Ville |
| postal_code | text | NOT NULL | Code postal |
| country | text | NOT NULL, défaut `'France'` | Pays |
| is_default | boolean | défaut `false` | Adresse par défaut |
| created_at | timestamptz | défaut `now()` | |
| updated_at | timestamptz | défaut `now()` | |

### 3.8 orders

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| buyer_id | uuid | FK → `profiles(id)`, NOT NULL | Acheteur |
| address_id | uuid | FK → `addresses(id)`, NULL | Adresse de livraison (snapshot) |
| status | text | `CHECK (status IN ('pending','paid','processing','shipped','delivered','cancelled','refunded'))`, défaut `pending` | État |
| subtotal | numeric(10,2) | CHECK `subtotal >= 0`, NOT NULL | Sous-total produits |
| shipping_fee | numeric(10,2) | CHECK `shipping_fee >= 0`, défaut 0 | Frais livraison |
| total | numeric(10,2) | CHECK `total >= 0`, NOT NULL | Total |
| created_at | timestamptz | défaut `now()` | |
| updated_at | timestamptz | défaut `now()` | |

### 3.9 order_items

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| order_id | uuid | FK → `orders(id)`, NOT NULL | Commande |
| product_id | uuid | FK → `products(id)`, NULL (null si produit supprimé) | Produit |
| seller_id | uuid | FK → `profiles(id)`, NOT NULL | Vendeur |
| product_name | text | NOT NULL | Snapshot du nom |
| unit_price | numeric(10,2) | CHECK `unit_price > 0`, NOT NULL | Prix unitaire (snapshot) |
| quantity | integer | CHECK `quantity > 0`, NOT NULL | Quantité |
| subtotal | numeric(10,2) | NOT NULL | Prix × quantité |

### 3.10 order_status_history

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| order_id | uuid | FK → `orders(id)`, NOT NULL | Commande |
| status | text | NOT NULL | Nouveau statut |
| changed_by | uuid | FK → `profiles(id)`, NULL | Auteur du changement |
| note | text | NULL | Commentaire |
| created_at | timestamptz | défaut `now()` | |

### 3.11 payments

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| order_id | uuid | FK → `orders(id)`, NOT NULL, UNIQUE | Commande (1 paiement) |
| provider | text | NOT NULL | Ex. `stripe` |
| amount | numeric(10,2) | CHECK `amount > 0`, NOT NULL | Montant |
| status | text | `CHECK (status IN ('pending','succeeded','failed','refunded'))`, défaut `pending` | État |
| provider_payment_id | text | NULL | Référence externe |
| created_at | timestamptz | défaut `now()` | |
| updated_at | timestamptz | défaut `now()` | |

### 3.12 reviews

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| product_id | uuid | FK → `products(id)`, NOT NULL | Produit |
| buyer_id | uuid | FK → `profiles(id)`, NOT NULL | Acheteur |
| rating | integer | CHECK `rating BETWEEN 1 AND 5`, NOT NULL | Note |
| title | text | NULL | Titre |
| comment | text | NOT NULL | Commentaire (min 10) |
| status | text | `CHECK (status IN ('active','hidden'))`, défaut `active` | Modération |
| created_at | timestamptz | défaut `now()` | |
| updated_at | timestamptz | défaut `now()` | |

UNIQUE `(product_id, buyer_id)` — un seul avis par acheteur et produit.

### 3.13 favorites

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK → `profiles(id)`, NOT NULL | Utilisateur |
| product_id | uuid | FK → `products(id)`, NOT NULL | Produit |
| created_at | timestamptz | défaut `now()` | |

UNIQUE `(user_id, product_id)`.

### 3.14 notifications

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK → `profiles(id)`, NOT NULL | Destinataire |
| type | text | NOT NULL | Ex. `order_status`, `review`, `admin` |
| title | text | NOT NULL | Titre |
| body | text | NOT NULL | Contenu |
| is_read | boolean | défaut `false` | Lue / non lue |
| created_at | timestamptz | défaut `now()` | |

## 4. Relations

- profiles 1—∞ products (seller) ; 1—1 avec auth.users
- categories 1—∞ products
- products 1—∞ product_images
- profiles 1—1 carts ; carts 1—∞ cart_items ; products 1—∞ cart_items
- profiles 1—∞ addresses
- profiles 1—∞ orders (buyer) ; orders 1—∞ order_items ; products 1—∞ order_items ; profiles 1—∞ order_items (seller)
- orders 1—∞ order_status_history ; orders 1—1 payments
- products 1—∞ reviews ; profiles 1—∞ reviews
- profiles 1—∞ favorites ; products 1—∞ favorites
- profiles 1—∞ notifications

## 5. Index

| Table | Index | Type |
|---|---|---|
| products | (seller_id) | btree |
| products | (category_id, status) | btree |
| products | (status) | btree |
| product_images | (product_id, position) | btree |
| cart_items | (cart_id) | btree |
| cart_items | (product_id) | btree |
| orders | (buyer_id, created_at) | btree |
| orders | (status) | btree |
| order_items | (order_id) | btree |
| order_items | (seller_id, status) | btree |
| order_status_history | (order_id) | btree |
| reviews | (product_id) | btree |
| revisions | (buyer_id) | btree |
| favorites | (user_id) | btree |
| notifications | (user_id, is_read) | btree |

> Index trigrammes (recherche plein texte) ajoutés au Sprint 11.

## 6. Triggers

- `set_updated_at()` : met à jour `updated_at` sur UPDATE pour toutes les tables avec cette colonne.

## 7. Règles de sécurité (RLS) — baseline Sprint 3

Activé sur toutes les tables. Politiques de base posées lors de la migration `0007` :

| Table | Politique |
|---|---|
| categories | SELECT public ; INSERT/UPDATE/DELETE admin |
| products | SELECT status='active' (public) ; INSERT/UPDATE/DELETE seller propriétaire ; admin tout |
| product_images | SELECT (produits actifs, public) ; INSERT/UPDATE/DELETE seller propriétaire |
| profiles | SELECT son propre profil ; UPDATE son propre profil ; admin tout |
| carts | SELECT/INSERT/UPDATE/DELETE propriétaire |
| cart_items | via le panier du propriétaire |
| addresses | propriétaire |
| orders | SELECT/INSERT propriétaire (buyer) ; UPDATE admin ; vendeur voit ses articles |
| order_items | buyer propriétaire ; seller ses articles ; admin |
| order_status_history | buyer propriétaire ; seller (ses commandes) ; admin |
| payments | buyer propriétaire ; admin |
| reviews | SELECT public (status='active') ; INSERT/UPDATE/DELETE auteur ; admin |
| favorites | propriétaire |
| notifications | propriétaire |

> Politiques RBAC fines (avec fonctions d'aide `is_admin()`, `is_seller()`, validation rôles) : Sprint 12 — Sécurité et permissions. La baseline ici est posée pour sécurité immédiate.

## 8. Fichiers de migration

| Fichier | Contenu |
|---|---|
| `0001_extensions.sql` | Extension `pgcrypto` |
| `0002_profiles_categories.sql` | `profiles`, `categories` |
| `0003_products.sql` | `products`, `product_images` |
| `0004_cart.sql` | `carts`, `cart_items` |
| `0005_addresses_orders.sql` | `addresses`, `orders`, `order_items`, `order_status_history` |
| `0006_payments_reviews_favorites_notifications.sql` | `payments`, `reviews`, `favorites`, `notifications` |
| `0007_indexes_triggers.sql` | Index + trigger `set_updated_at` |
| `0008_rls_policies.sql` | Activation RLS + politiques de base |

Chaque fichier est transactionnel et contient en commentaire le rollback (`-- DOWN ...`).

---
Dernière mise à jour : Sprint 3 — Conception et création de la base de données.