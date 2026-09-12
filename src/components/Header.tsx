import { Link } from 'react-router-dom'

interface HeaderProps {
  cartCount?: number
}

export default function Header({ cartCount = 0 }: HeaderProps) {
  return (
    <header className="sticky top-0 z-50 bg-white border-b border-gray-200">
      <nav className="max-w-7xl mx-auto px-4 h-16 flex items-center gap-6">
        <Link to="/" className="font-extrabold text-xl text-green-700">
          🌿 Bio Market
        </Link>
        <Link to="/products" className="text-sm text-gray-700 hover:text-green-700">
          Catalogue
        </Link>
        <div className="flex-1" />
        <Link
          to="/cart"
          className="text-sm text-gray-700 hover:text-green-700 relative"
        >
          🛒 Panier
          {cartCount > 0 && (
            <span className="absolute -top-2 -right-3 bg-red-600 text-white text-xs w-5 h-5 rounded-full flex items-center justify-center">
              {cartCount}
            </span>
          )}
        </Link>
        <Link to="/login" className="text-sm text-gray-700 hover:text-green-700">
          Connexion
        </Link>
        <Link
          to="/register"
          className="bg-green-700 text-white text-sm font-semibold px-4 py-2 rounded-lg hover:bg-green-800"
        >
          S'inscrire
        </Link>
      </nav>
    </header>
  )
}