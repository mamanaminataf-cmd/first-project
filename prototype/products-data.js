const PRODUCTS = [
  { id: 1, name: "Tomates cerises bio", cat: "Légumes", emoji: "🍅", price: 3.50, unit: "/500g", seller: "Ferme du Val", rating: 4.8, reviews: 34, stock: 12 },
  { id: 2, name: "Pommes Gala bio", cat: "Fruits", emoji: "🍎", price: 2.90, unit: "/kg", seller: "Vergers Dupont", rating: 4.6, reviews: 21, stock: 8 },
  { id: 3, name: "Carottes des sables", cat: "Légumes", emoji: "🥕", price: 1.90, unit: "/kg", seller: "Ferme du Val", rating: 4.7, reviews: 45, stock: 25 },
  { id: 4, name: "Œufs plein air", cat: "Ferme", emoji: "🥚", price: 4.20, unit: "/12", seller: "La Basse-Cour Bio", rating: 4.9, reviews: 58, stock: 0 },
  { id: 5, name: "Miel de lavande", cat: "Épicerie", emoji: "🍯", price: 8.90, unit: "/250g", seller: "Rucher de Provence", rating: 5.0, reviews: 12, stock: 6 },
  { id: 6, name: "Lait entier cru", cat: "Ferme", emoji: "🥛", price: 2.40, unit: "/L", seller: "La Ferme Blanche", rating: 4.5, reviews: 18, stock: 15 },
  { id: 7, name: "Quinoa complet", cat: "Céréales", emoji: "🌾", price: 6.50, unit: "/500g", seller: "Grains du Soleil", rating: 4.4, reviews: 9, stock: 20 },
  { id: 8, name: "Jus de pomme pressé", cat: "Boissons", emoji: "🧃", price: 4.50, unit: "/75cl", seller: "Vergers Dupont", rating: 4.7, reviews: 27, stock: 10 },
  { id: 9, name: "Salade batavia", cat: "Légumes", emoji: "🥬", price: 1.60, unit: "/pièce", seller: "Ferme du Val", rating: 4.3, reviews: 14, stock: 18 },
  { id: 10, name: "Bananes équitables", cat: "Fruits", emoji: "🍌", price: 2.20, unit: "/kg", seller: "Fruits du Monde", rating: 4.2, reviews: 31, stock: 7 },
  { id: 11, name: "Yaourt au lait fermier", cat: "Ferme", emoji: "🍶", price: 3.10, unit: "/6", seller: "La Ferme Blanche", rating: 4.6, reviews: 22, stock: 14 },
  { id: 12, name: "Farine de sarrasin", cat: "Céréales", emoji: "🌾", price: 3.20, unit: "/1kg", seller: "Grains du Soleil", rating: 4.5, reviews: 11, stock: 16 }
];

function renderCard(p) {
  const soldOut = p.stock <= 0;
  return `
    <div class="card">
      <a href="product.html?id=${p.id}">
        <div class="card-img">${p.emoji}</div>
      </a>
      <div class="card-body">
        <span class="card-cat">${p.cat}</span>
        <a href="product.html?id=${p.id}" class="card-name">${p.name}</a>
        <span class="card-seller">Par ${p.seller}</span>
        <div class="rating">★ ${p.rating.toFixed(1)} <span class="count">(${p.reviews} avis)</span></div>
        <div class="card-footer">
          <span class="price">${p.price.toFixed(2)} € <span class="unit">${p.unit}</span></span>
          ${soldOut
            ? '<span class="badge badge-red">Rupture</span>'
            : `<button class="btn btn-primary btn-sm" onclick="addToCart(${p.id})">Ajouter</button>`}
        </div>
      </div>
    </div>`;
}

function addToCart(id) {
  const cart = JSON.parse(localStorage.getItem('biomarket_cart') || '[]');
  const existing = cart.find(i => i.id === id);
  if (existing) existing.qty += 1;
  else cart.push({ id, qty: 1 });
  localStorage.setItem('biomarket_cart', JSON.stringify(cart));
  alert('✅ Produit ajouté au panier');
}