import { Link, useParams } from 'react-router-dom'
import type { Product } from '../types'

const SAMPLE_PRODUCTS: Product[] = [
  { id: '1', seller_id: '1', category_id: 'Légumes', name: 'Tomates cerises bio', description: 'Tomates cerises cultivées sous serre, récoltées à maturité.', price: 3.5, stock: 12, status: 'active', created_at: '', updated_at: '' },
  { id: '2', seller_id: '1', category_id: 'Fruits', name: 'Pommes Gala bio', description: 'Pommes Gala croquantes et sucrées, cueillies à la main.', price: 2.9, stock: 8, status: 'active', created_at: '', updated_at: '' },
  { id: '3', seller_id: '2', category_id: 'Légumes', name: 'Carottes des sables', description: 'Carottes cultivées en sable, légèrement sucrées.', price: 1.9, stock: 25, status: 'active', created_at: '', updated_at: '' },
  { id: '4', seller_id: '2', category_id: 'Ferme', name: 'Œufs plein air', description: 'Œufs frais de poules élevées en plein air.', price: 4.2, stock: 0, status: 'active', created_at: '', updated_at: '' },
  { id: '5', seller_id: '3', category_id: 'Épicerie', name: 'Miel de lavande', description: 'Miel de lavande 100% français, récolté en Provence.', price: 8.9, stock: 6, status: 'active', created_at: '', updated_at: '' },
]

export default function ProductDetail() {
  const { id } = useParams()
  const product: Product | undefined = SAMPLE_PRODUCTS.find((p) => p.id === id)

  if (!product) {
    return (
      <main className="max-w-7xl mx-auto px-4 py-16 text-center">
        <h1 className="text-2xl font-bold mb-4">Produit introuvable</h1>
        <Link to="/products" className="text-green-700 font-semibold">
          ← Retour au catalogue
        </Link>
      </main>
    )
  }

  const soldOut = product.stock <= 0

  return (
    <main className="max-w-7xl mx-auto px-4 py-8">
      <nav className="text-sm text-gray-500 mb-6">
        <a href="." className="hover:text-green-700">Accueil</a> /{' '}
        <Link to="/products" className="hover:text-green-700">Catalogue</Link> /{' '}
        {product.category_id} / {product.name}
      </nav>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-10">
        <div className="h-96 bg-gradient-to-br from-green-100 to-green-50 rounded-xl flex items-center justify-center text-8xl">
          🌿
        </div>

        <div>
          <div className="flex gap-2 mb-4">
            <span className="text-xs font-semibold text-green-800 bg-green-100 px-3 py-1 rounded-full">
              Certifié bio
            </span>
            <span
              className={`text-xs font-semibold px-3 py-1 rounded-full ${
                soldOut ? 'text-red-600 bg-red-50' : 'text-green-800 bg-green-100'
              }`}
            >
              {soldOut ? 'Rupture de stock' : `En stock (${product.stock})`}
            </span>
            <span className="text-xs font-semibold text-gray-600 bg-gray-100 px-3 py-1 rounded-full">
              {product.category_id}
            </span>
          </div>

          <h1 className="text-3xl font-bold mb-2">{product.name}</h1>
          <div className="text-2xl font-bold text-green-700 mb-4">
            {product.price.toFixed(2)} €
          </div>
          <p className="text-gray-600 mb-6">{product.description}</p>

          <button
            disabled={soldOut}
            className={`px-6 py-3 rounded-xl font-semibold ${
              soldOut
                ? 'bg-gray-200 text-gray-400 cursor-not-allowed'
                : 'bg-green-700 text-white hover:bg-green-800'
            }`}
          >
            🛒 {soldOut ? 'Rupture de stock' : 'Ajouter au panier'}
          </button>
        </div>
      </div>
    </main>
  )
}