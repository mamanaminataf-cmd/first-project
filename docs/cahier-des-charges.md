# Cahier des charges — Bio Market

## 1. Identité du projet

| Élément | Valeur |
|---|---|
| **Nom du projet** | Bio Market |
| **Nom technique** | bio-market |
| **Type** | Application web de marketplace de produits biologiques |
| **Description courte** | Plateforme web mettant en relation des acheteurs et des vendeurs de produits biologiques, avec un espace d'administration |

## 2. Description longue

L'application permettra aux vendeurs de produits biologiques de présenter et vendre leurs produits en ligne. Les acheteurs pourront rechercher des produits, consulter leurs informations, les ajouter au panier, passer des commandes, effectuer des paiements et suivre leurs commandes.

La plateforme comprendra trois types principaux d'utilisateurs :
- Acheteur
- Vendeur
- Administrateur

---

## 3. Vision du projet

Créer une marketplace moderne, simple, sécurisée et facile à utiliser pour la vente et l'achat de produits biologiques.

L'application doit permettre :
- de faciliter l'accès aux produits biologiques ;
- de faciliter la vente des produits biologiques ;
- de mettre en relation vendeurs et acheteurs ;
- de permettre aux vendeurs de gérer leurs produits et leurs stocks ;
- de permettre aux acheteurs de rechercher et commander des produits ;
- de permettre le paiement des commandes ;
- de permettre le suivi des commandes ;
- de permettre l'évaluation des produits ;
- de permettre à l'administrateur de superviser la plateforme.

---

## 4. Utilisateurs et permissions

### 4.1 Acheteur

**Peut :**
- créer un compte, se connecter, se déconnecter
- gérer son profil
- rechercher et consulter les produits
- consulter les détails d'un produit et les informations du vendeur
- ajouter un produit au panier, modifier les quantités, supprimer
- passer une commande et choisir une adresse de livraison
- effectuer un paiement
- consulter l'historique et suivre ses commandes
- annuler une commande lorsque cela est autorisé
- laisser un avis (avec note) après un achat
- ajouter des produits aux favoris
- recevoir des notifications

**Ne peut PAS :**
- modifier/supprimer les produits d'un vendeur
- gérer le stock d'un vendeur
- accéder aux données privées d'autres acheteurs
- accéder au tableau de bord administrateur

### 4.2 Vendeur

**Peut :**
- créer un compte vendeur, se connecter, gérer son profil
- ajouter, modifier, supprimer ses produits
- publier ou désactiver ses produits
- gérer ses catégories (si autorisé)
- gérer ses stocks
- consulter les commandes concernant ses produits
- mettre à jour le statut des commandes selon les permissions définies
- consulter ses ventes et ses revenus
- consulter les avis concernant ses produits
- recevoir des notifications

**Ne peut PAS :**
- modifier/supprimer les produits d'un autre vendeur
- accéder aux informations privées d'autres vendeurs
- modifier les commandes qui ne concernent pas ses produits
- modifier les comptes administrateurs

### 4.3 Administrateur

**Peut :**
- gérer les utilisateurs, vendeurs, acheteurs
- gérer les produits, catégories, commandes, avis, signalements
- gérer les contenus nécessaires à la plateforme
- consulter les statistiques
- superviser les paiements
- suspendre ou réactiver des comptes
- superviser la sécurité de la plateforme

Les actions sensibles doivent être protégées et auditées.

---

## 5. Fonctionnalités principales

1. Authentification
2. Gestion des profils
3. Gestion des rôles
4. Catalogue de produits
5. Catégories
6. Recherche
7. Filtres
8. Fiches produits
9. Gestion des images
10. Gestion du stock
11. Panier
12. Commandes
13. Paiements
14. Suivi des commandes
15. Avis et évaluations
16. Favoris
17. Notifications
18. Espace vendeur
19. Tableau de bord administrateur
20. Statistiques
21. Sécurité
22. Gestion des permissions
23. Responsive design
24. Tests
25. Déploiement

---

## 6. Données principales

Utilisateurs, profils, rôles, produits, catégories, images des produits, stocks, paniers, éléments du panier, commandes, éléments des commandes, paiements, avis, notes, favoris, notifications, adresses de livraison, historique des statuts des commandes, données statistiques.

> La structure exacte de la base de données sera définie dans le Sprint "Conception de la base de données". Aucune migration SQL n'est créée pendant cette étape.

---

## 7. Modèle de données prévisionnel

Tables envisagées (provisoires, à valider lors de la conception) :

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

Pour chaque table, définir ensuite : identifiant, colonnes, types, contraintes, clé primaire, clés étrangères, relations, index, règles de sécurité.

---

## 8. Relations principales

- Un utilisateur possède un profil
- Un vendeur peut posséder plusieurs produits
- Un produit appartient à une catégorie
- Un produit peut posséder plusieurs images
- Un acheteur possède un panier
- Un panier contient plusieurs éléments
- Un acheteur peut créer plusieurs commandes
- Une commande contient plusieurs éléments de commande
- Une commande possède un paiement
- Un acheteur peut laisser des avis sur des produits achetés
- Un utilisateur peut avoir plusieurs favoris
- Un utilisateur peut recevoir plusieurs notifications
- Une commande peut posséder plusieurs changements de statut

---

## 9. Règles de permissions

Les permissions doivent être appliquées côté backend / base de données, pas uniquement dans l'interface.

- **Acheteur :** lecture des produits publics, gestion de son panier, création et consultation de ses commandes, gestion de son profil, création d'avis autorisés
- **Vendeur :** CRUD de ses produits, gestion de ses stocks, consultation des commandes concernant ses produits, consultation de ses ventes
- **Administrateur :** gestion globale selon les règles de sécurité

Un utilisateur ne doit jamais pouvoir accéder ou modifier les données privées d'un autre utilisateur sans autorisation.

---

## 10. Sécurité

Principes obligatoires :
- authentification sécurisée
- autorisation basée sur les rôles
- contrôle des permissions côté backend
- protection des données
- validation côté serveur (et frontend si nécessaire)
- protection contre les accès non autorisés
- protection des fichiers
- protection des variables d'environnement
- absence de secrets dans Git
- politiques RLS si PostgreSQL/Supabase est utilisé
- journalisation des actions sensibles
- tests des permissions

**Interdictions :** jamais de mot de passe, clé API secrète, token privé, clé privée, credentials, données réelles de paiement ou fichier `.env` avec secrets dans GitHub.
