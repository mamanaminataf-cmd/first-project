# Conception fonctionnelle — Bio Market

> **Sprint 1** — Document de référence pour le développement UI/UX et backend.

---

## 1. Architecture des pages

### 1.1 Pages publiques (non connecté)

| Route | Page | Description |
|---|---|---|
| `/` | Accueil | Page d'accueil avec produits phares, catégories, CTA |
| `/products` | Catalogue | Liste des produits avec recherche, filtres, tri |
| `/products/:id` | Fiche produit | Détail d'un produit : images, prix, vendeur, avis |
| `/vendors/:id` | Profil vendeur | Liste des produits d'un vendeur |
| `/login` | Connexion | Formulaire email + mot de passe |
| `/register` | Inscription | Formulaire avec choix de rôle (acheteur/vendeur) |
| `/forgot-password` | Mot de passe oublié | Réinitialisation par email |

### 1.2 Pages acheteur (connecté en tant qu'acheteur)

| Route | Page | Description |
|---|---|---|
| `/account` | Mon profil | Modification du profil, adresses |
| `/account/addresses` | Adresses | Gestion des adresses de livraison |
| `/account/favorites` | Favoris | Liste des produits en favoris |
| `/cart` | Panier | Récapitulatif du panier, modification quantités |
| `/checkout` | Paiement | Choix adresse, récapitulatif, paiement |
| `/orders` | Mes commandes | Historique des commandes |
| `/orders/:id` | Détail commande | Statut, éléments, suivi |
| `/reviews` | Mes avis | Liste des avis laissés |

### 1.3 Pages vendeur (connecté en tant que vendeur)

| Route | Page | Description |
|---|---|---|
| `/vendor/dashboard` | Tableau de bord | Vue d'ensemble : ventes, revenus, commandes récentes |
| `/vendor/products` | Mes produits | Liste des produits, ajout, modification |
| `/vendor/products/new` | Ajouter produit | Formulaire de création |
| `/vendor/products/:id/edit` | Modifier produit | Formulaire d'édition |
| `/vendor/orders` | Commandes reçues | Commandes contenant ses produits |
| `/vendor/orders/:id` | Détail commande | Statut, éléments, mise à jour |
| `/vendor/reviews` | Avis reçus | Avis sur ses produits |
| `/vendor/settings` | Paramètres | Paramètres du compte vendeur |

### 1.4 Pages administrateur (connecté en tant qu'admin)

| Route | Page | Description |
|---|---|---|
| `/admin/dashboard` | Tableau de bord | Statistiques globales |
| `/admin/users` | Utilisateurs | Liste, recherche, gestion des comptes |
| `/admin/products` | Produits | Tous les produits, modération |
| `/admin/categories` | Catégories | Gestion des catégories |
| `/admin/orders` | Commandes | Toutes les commandes |
| `/admin/reviews` | Avis | Tous les avis, modération |
| `/admin/settings` | Paramètres | Paramètres de la plateforme |

---

## 2. Flux utilisateur détaillés

### 2.1 Inscription

**Rôle : Acheteur**
1. L'utilisateur clique sur "S'inscrire"
2. Remplit : nom, email, mot de passe, confirmation mot de passe
3. Coche "Je suis acheteur"
4. Soumet le formulaire
5. Vérification email (lien de confirmation)
6. Redirection vers la page d'accueil

**Rôle : Vendeur**
1. L'utilisateur clique sur "S'inscrire"
2. Remplit : nom, email, mot de passe, confirmation mot de passe
3. Coche "Je suis vendeur"
4. Remplit : nom de la boutique, description (optionnel)
5. Soumet le formulaire
6. Vérification email
7. Redirection vers le tableau de bord vendeur

**Règles :**
- Un même email ne peut être utilisé qu'une seule fois
- Le mot de passe doit contenir au minimum 8 caractères, 1 majuscule, 1 chiffre
- Le rôle est défini à l'inscription et ne peut pas être changé par l'utilisateur

### 2.2 Connexion

1. L'utilisateur saisit email + mot de passe
2. Vérification des identifiants
3. Si successful → redirection vers la page précédente ou l'accueil
4. Si erreur → message d'erreur sous le formulaire

**Règles :**
- Après 5 tentatives échouées : blocage temporaire (15 min)
- Le mot de passe est vérifié côté serveur uniquement

### 2.3 Recherche et navigation catalogue

**Éléments de recherche :**
- Barre de recherche : recherche par nom de produit, description
- Filtres : catégorie, prix (min/max), vendeur, note moyenne
- Tri : prix croissant, décroissant, plus récent, mieux noté

**Règles :**
- La recherche est insensible à la casse
- Les produits inactifs/désactivés ne sont pas affichés
- La pagination est de 20 produits par page par défaut
- Le nombre de résultats est affiché

### 2.4 Fiche produit

**Informations affichées :**
- Nom du produit
- Images (galeries, zoom)
- Prix
- Description détaillée
- Catégorie
- Nom du vendeur + lien vers profil
- Stock disponible
- Note moyenne + nombre d'avis
- Bouton "Ajouter au panier" (si en stock)
- Bouton "Ajouter aux favoris"

**Règles :**
- Si le stock est à 0 : afficher "Rupture de stock", désactiver le bouton panier
- Si le produit est inactif : rediriger vers le catalogue
- Le prix ne peut pas être négatif
- Les images sont redimensionnées côté serveur

### 2.5 Gestion du panier

**Actions :**
- Ajouter un produit au panier (quantité par défaut = 1)
- Modifier la quantité (+/-)
- Supprimer un produit du panier
- Voir le total

**Règles :**
- Un panier est associé à un seul acheteur
- Si le produit est déjà dans le panier : incrémenter la quantité
- La quantité ne peut pas dépasser le stock disponible
- Le prix est calculé en temps réel (prix unitaire × quantité)
- Le panier persiste après déconnexion (stocké en base)
- Les produits retirés du catalogue sont retirés du panier automatiquement

### 2.6 Passer une commande (Checkout)

**Étapes :**
1. Récapitulatif du panier
2. Choix de l'adresse de livraison (ou ajout d'une nouvelle)
3. Récapitulatif : produits, sous-total, frais de livraison, total
4. Choix du mode de paiement
5. Confirmation et paiement
6. Redirection vers la page de confirmation

**Règles :**
- Le panier ne peut pas être vide
- Le stock est vérifié au moment de la commande
- Si un produit n'est plus disponible : afficher un message, proposer de le retirer
- La commande est créée avec le statut "en attente de paiement"
- Après paiement réussi : statut "payée", puis "en préparation"
- Un email de confirmation est envoyé
- Le panier est vidé après commande confirmée

### 2.7 Suivi des commandes

**Statuts d'une commande :**
1. `pending` — En attente de paiement
2. `paid` — Payée
3. `processing` — En préparation (vendeur)
4. `shipped` — Expédiée
5. `delivered` — Livrée
6. `cancelled` — Annulée
7. `refunded` — Remboursée

**Règles :**
- Seul l'acheteur peut annuler une commande (avant l'expédition)
- Le vendeur peut mettre à jour : processing, shipped
- L'admin peut mettre à jour tous les statuts
- Chaque changement de statut est enregistré dans l'historique
- Un email est envoyé à chaque changement de statut

### 2.8 Avis et évaluations

**Conditions pour laisser un avis :**
- L'acheteur doit avoir acheté le produit
- L'acheteur ne peut laisser qu'un seul avis par produit
- L'avis ne peut être laissé qu'après réception de la commande (statut "delivered")

**Formulaire d'avis :**
- Note (1 à 5 étoiles, obligatoire)
- Titre (optionnel)
- Commentaire (obligatoire, min 10 caractères)

**Règles :**
- Un avis peut être modifié par son auteur
- Un avis peut être supprimé par son auteur
- L'admin peut supprimer un avis inapproprié
- La note moyenne du produit est recalculée automatiquement

### 2.9 Favoris

**Actions :**
- Ajouter un produit aux favoris (depuis la fiche produit ou le catalogue)
- Retirer un produit des favoris
- Consulter la liste des favoris

**Règles :**
- Un produit ne peut être en favori qu'une seule fois par utilisateur
- Les favoris sont persistés en base
- Le bouton favori est un cœur : rempli si en favori, vide sinon

### 2.10 Espace vendeur — Gestion des produits

**Création d'un produit :**
- Nom (obligatoire)
- Description (obligatoire, min 20 caractères)
- Prix (obligatoire, > 0)
- Catégorie (obligatoire, sélection parmi les catégories existantes)
- Stock (obligatoire, >= 0)
- Images (1 à 5, obligatoire, max 5 Mo par image)
- Statut : brouillon ou publié

**Modification :**
- Tous les champs peuvent être modifiés
- Le prix ne peut pas être modifié après une commande en cours

**Suppression :**
- Un produit avec des commandes en cours ne peut pas être supprimé
- La suppression est logique (le produit devient inactif)

**Règles :**
- Seul le propriétaire du produit peut le modifier/supprimer
- L'admin peut modérer (désactiver) tout produit
- Un produit inactif n'apparaît plus dans le catalogue

### 2.11 Espace vendeur — Commandes

**Vue :**
- Liste des commandes contenant ses produits
- Filtres : statut, date, montant
- Détail de chaque commande : acheteur, produits, montant, statut

**Actions :**
- Accepter une commande (passer à "processing")
- Marquer comme expédiée ("shipped")
- Voir les détails de l'acheteur (nom, adresse)

**Règles :**
- Le vendeur ne voit que les commandes contenant SES produits
- Le vendeur ne peut pas voir les commandes des autres vendeurs
- Le vendeur ne peut pas modifier les informations de l'acheteur

### 2.12 Espace admin — Gestion des utilisateurs

**Actions :**
- Lister tous les utilisateurs
- Rechercher par nom, email, rôle
- Voir le détail d'un utilisateur
- Suspendre / réactiver un compte
- Modifier le rôle d'un utilisateur

**Règles :**
- L'admin ne peut pas supprimer son propre compte
- La suspension empêche la connexion
- Toute action sensible est journalisée

### 2.13 Espace admin — Gestion des produits

**Actions :**
- Lister tous les produits
- Rechercher par nom, vendeur, catégorie
- Désactiver un produit (modération)
- Supprimer un produit
- Voir les détails

**Règles :**
- L'admin peut désactiver tout produit
- La suppression est logique
- Les produits désactivés n'apparaissent plus dans le catalogue

### 2.14 Notifications

**Types de notifications :**
- Confirmation de commande
- Changement de statut de commande
- Nouvel avis reçu
- Nouveau produit dans une catégorie suivie (futur)
- Alerte de stock bas (vendeur)
- Message de l'admin

**Règles :**
- Les notifications sont visibles dans l'application
- Le compteur de notifications non lues est affiché dans le header
- L'utilisateur peut marquer une notification comme lue
- L'utilisateur peut marquer toutes les notifications comme lues

---

## 3. États des entités

### 3.1 Utilisateur
- `active` — Compte actif
- `suspended` — Compte suspendu (par admin)
- `pending_verification` — En attente de vérification email

### 3.2 Produit
- `draft` — Brouillon (vendeur)
- `active` — Publié, visible dans le catalogue
- `inactive` — Désactivé (par vendeur ou admin)
- `deleted` — Supprimé logiquement

### 3.3 Commande
- `pending` — En attente de paiement
- `paid` — Payée
- `processing` — En préparation
- `shipped` — Expédiée
- `delivered` — Livrée
- `cancelled` — Annulée
- `refunded` — Remboursée

### 3.4 Avis
- `active` — Affiché
- `hidden` — Masqué (par admin)

---

## 4. Règles métier transversales

### 4.1 Validation des données
- Tous les champs obligatoires sont validés côté serveur
- Les emails sont uniques
- Les prix sont positifs
- Les stocks sont positifs ou nuls
- Les notes sont entre 1 et 5

### 4.2 Gestion des erreurs
- Les erreurs de validation affichent un message sous le champ concerné
- Les erreurs serveur affichent un message générique
- Les erreurs de permission redirigent vers la page d'accueil

### 4.3 Performance
- Les images sont redimensionnées et compressées
- La pagination est systématique
- Les recherches sont optimisées avec des index
- Le cache est utilisé pour les pages publiques

### 4.4 Accessibilité
- Navigation au clavier
- Contraste des couleurs (WCAG AA)
- Attributs ARIA
- Messages d'erreur explicites

### 4.5 Responsive design
- Mobile first
- Breakpoints : mobile (< 640px), tablette (640-1024px), desktop (> 1024px)
- Le panier et les commandes sont accessibles sur mobile

---

## 5. Matrice des permissions

| Action | Acheteur | Vendeur | Admin |
|---|---|---|---|
| Voir les produits | ✅ | ✅ | ✅ |
| Créer un produit | ❌ | ✅ | ✅ |
| Modifier un produit | ❌ | ✅ (ses produits) | ✅ (tous) |
| Supprimer un produit | ❌ | ✅ (ses produits) | ✅ (tous) |
| Ajouter au panier | ✅ | ❌ | ❌ |
| Passer une commande | ✅ | ❌ | ❌ |
| Voir ses commandes | ✅ | ✅ (ses produits) | ✅ (toutes) |
| Annuler une commande | ✅ (avant expédition) | ❌ | ✅ |
| Laisser un avis | ✅ (après achat) | ❌ | ❌ |
| Gérer les utilisateurs | ❌ | ❌ | ✅ |
| Gérer les catégories | ❌ | ❌ | ✅ |
| Voir les stats | ❌ | ✅ (ses stats) | ✅ (globales) |
| Suspendre un compte | ❌ | ❌ | ✅ |
| Modérer un avis | ❌ | ❌ | ✅ |

---

## 6. Données de démonstration (prévisionnel)

> Les données de démo seront créées lors du Sprint 4 (Authentification et profils).

Comptes de test prévus :
- `acheteur@test.com` — Acheteur
- `vendeur@test.com` — Vendeur
- `admin@test.com` — Administrateur

Produits de test : 10-15 produits biologiques avec images, catégories, prix variés.

---

Dernière mise à jour : Sprint 1 — Conception fonctionnelle
