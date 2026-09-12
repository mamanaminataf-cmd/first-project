import { Link } from 'react-router-dom'

export default function Footer() {
  return (
    <footer className="bg-green-900 text-white mt-16">
      <div className="max-w-7xl mx-auto px-4 py-12 grid grid-cols-1 sm:grid-cols-3 gap-8">
        <div>
          <div className="text-lg font-bold mb-3">🌿 Bio Market</div>
          <p className="text-sm text-green-200">
            Des produits biologiques, du producteur au panier.
          </p>
        </div>
        <div>
          <h4 className="font-semibold mb-3">Aide</h4>
          <Link to="/login" className="block text-sm text-green-200 hover:text-white mb-2">
            Connexion
          </Link>
          <Link to="/register" className="block text-sm text-green-200 hover:text-white mb-2">
            Inscription
          </Link>
          <Link to="/cart" className="block text-sm text-green-200 hover:text-white">
            Panier
          </Link>
        </div>
        <div>
          <h4 className="font-semibold mb-3">Contact</h4>
          <p className="text-sm text-green-200">contact@biomarket.fr</p>
          <p className="text-sm text-green-200">© 2026 Bio Market</p>
        </div>
      </div>
    </footer>
  )
}