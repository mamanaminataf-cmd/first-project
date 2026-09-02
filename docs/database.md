# Base de données — Bio Market

> **STATUT :** Document prévisionnel. La conception détaillée et les migrations seront réalisées dans le Sprint "Conception de la base de données". Aucune migration SQL définitive n'est créée pendant la phase de configuration initiale.

## 1. Conventions

- Conventions de nommage : `snake_case`
- Clés primaires : `id` (UUID ou SERIAL)
- Clés étrangères : `table_id`
- Timestamps : `created_at`, `updated_at`
- Soft delete : `deleted_at` si nécessaire
- Index sur les colonnes fréquemment requêtées

## 2. Modèle de données prévisionnel

Liste des tables envisagées (noms provisoires) :

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
payments
reviews
favorites
notifications
order_status_history
```

> Ces noms sont provisoires et pourront être modifiés après la conception détaillée.

## 3. Relations principales (prévues)

- **profile :** un utilisateur possède un profil
- **products :** un vendeur peut posséder plusieurs produits
- **categories :** un produit appartient à une catégorie
- **product_images :** un produit peut posséder plusieurs images
- **carts :** un acheteur possède un panier
- **cart_items :** un panier contient plusieurs éléments
- **orders :** un acheteur peut créer plusieurs commandes
- **order_items :** une commande contient plusieurs éléments
- **payments :** une commande possède un paiement
- **reviews :** un acheteur peut laisser des avis sur des produits achetés
- **favorites :** un utilisateur peut avoir plusieurs favoris
- **notifications :** un utilisateur peut recevoir plusieurs notifications
- **order_status_history :** une commande peut posséder plusieurs changements de statut

## 4. Pour chaque table, définir ensuite

- identifiant
- colonnes
- types
- contraintes
- clé primaire
- clés étrangères
- relations
- index
- règles de sécurité (RLS)

## 5. Règles de sécurité (planifiées)

Les permissions doivent être appliquées côté base de données (RLS PostgreSQL/Supabase) :
- **Acheteur :** lecture des produits publics, gestion de son panier, création/consultation de ses commandes
- **Vendeur :** CRUD de ses propres produits, gestion de ses stocks, consultation des commandes concernant ses produits
- **Administrateur :** gestion globale

Un utilisateur ne doit jamais pouvoir accéder ou modifier les données privées d'un autre utilisateur sans autorisation.
