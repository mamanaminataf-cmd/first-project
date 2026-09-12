import { Link } from 'react-router-dom'

export default function Cart() {
  return (
    <main className="max-w-7xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold mb-6">Mon panier</h1>
      <div className="bg-white border border-gray-200 rounded-xl p-12 text-center">
        <div className="text-6xl mb-4">🛒</div>
        <h2 className="text-lg font-semibold mb-2">Votre panier est vide</h2>
        <p className="text-sm text-gray-500 mb-6">
          Le panier sera connecté à la base de données au Sprint 6.
        </p>
        <Link
          to="/products"
          className="inline-block bg-green-700 text-white font-semibold px-6 py-3 rounded-xl hover:bg-green-800"
        >
          Voir le catalogue
        </Link>
      </div>
    </main>
  )
}