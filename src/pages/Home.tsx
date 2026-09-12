import { Link } from 'react-router-dom'
import ProductCard from '../components/ProductCard'
import type { Product } from '../types'

const SAMPLE_PRODUCTS: Product[] = [
  { id: '1', seller_id: '1', category_id: 'Légumes', name: 'Tomates cerises bio', description: '', price: 3.5, stock: 12, status: 'active', created_at: '', updated_at: '' },
  { id: '2', seller_id: '1', category_id: 'Fruits', name: 'Pommes Gala bio', description: '', price: 2.9, stock: 8, status: 'active', created_at: '', updated_at: '' },
  { id: '3', seller_id: '2', category_id: 'Légumes', name: 'Carottes des sables', description: '', price: 1.9, stock: 25, status: 'active', created_at: '', updated_at: '' },
  { id: '4', seller_id: '2', category_id: 'Ferme', name: 'Œufs plein air', description: '', price: 4.2, stock: 0, status: 'active', created_at: '', updated_at: '' },
  { id: '5', seller_id: '3', category_id: 'Épicerie', name: 'Miel de lavande', description: '', price: 8.9, stock: 6, status: 'active', created_at: '', updated_at: '' },
]

const CATEGORIES = ['Légumes', 'Fruits', 'Ferme', 'Céréales', 'Boissons', 'Épicerie']

export default function Home() {
  return (
    <div>
      <section className="bg-gradient-to-br from-green-800 to-green-600 text-white py-20 px-4 text-center">
        <h1 className="text-4xl font-extrabold mb-4">
          Des produits bio, du producteur au panier
        </h1>
        <p className="text-green-100 max-w-xl mx-auto mb-8">
          Découvrez des produits frais et certifiés bio, vendus directement par des producteurs locaux.
        </p>
        <Link
          to="/products"
          className="inline-block bg-white text-green-800 font-semibold px-6 py-3 rounded-xl hover:bg-green-50"
        >
          Explorer le catalogue →
        </Link>
      </section>

      <main className="max-w-7xl mx-auto px-4 py-10">
        <h2 className="text-xl font-bold mb-4 flex items-center justify-between">
          Catégories
          <Link to="/products" className="text-sm font-medium text-green-700">
            Tout voir →
          </Link>
        </h2>
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3 mb-10">
          {CATEGORIES.map((cat) => (
            <Link
              key={cat}
              to={`/products?cat=${encodeURIComponent(cat)}`}
              className="bg-white border border-gray-200 rounded-xl p-4 text-center font-semibold hover:border-green-600 hover:shadow"
            >
              {cat}
            </Link>
          ))}
        </div>

        <h2 className="text-xl font-bold mb-4">Produits du moment</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
          {SAMPLE_PRODUCTS.map((p) => (
            <ProductCard key={p.id} product={p} />
          ))}
        </div>

        <p className="mt-10 text-sm text-gray-500 bg-blue-50 border border-blue-200 rounded-lg p-4">
          💡 Architecture technique initialisée (Sprint 2). Les données affichées sont des exemples locaux —
          la base Supabase sera connectée au Sprint 3.
        </p>
      </main>
    </div>
  )
}