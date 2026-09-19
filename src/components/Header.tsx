import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

interface HeaderProps {
  cartCount?: number
}

export default function Header({ cartCount = 0 }: HeaderProps) {
  const { status, user, isSeller, isAdmin, signOut } = useAuth()
  const navigate = useNavigate()

  const handleSignOut = async () => {
    await signOut()
    navigate('/')
  }

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

        {status === 'authenticated' && user ? (
          <>
            {isSeller && (
              <Link
                to="/vendor/dashboard"
                className="text-sm text-gray-700 hover:text-green-700"
              >
                🏪 Ma boutique
              </Link>
            )}
            {isAdmin && (
              <Link
                to="/admin/dashboard"
                className="text-sm text-gray-700 hover:text-green-700"
              >
                ⚙️ Admin
              </Link>
            )}
            <Link to="/cart" className="text-sm text-gray-700 hover:text-green-700 relative">
              🛒 Panier
              {cartCount > 0 && (
                <span className="absolute -top-2 -right-3 bg-red-600 text-white text-xs w-5 h-5 rounded-full flex items-center justify-center">
                  {cartCount}
                </span>
              )}
            </Link>
            <Link to="/account" className="text-sm text-gray-700 hover:text-green-700">
              👤 {user.full_name ?? user.email}
            </Link>
            <button
              onClick={handleSignOut}
              className="text-sm text-gray-500 hover:text-red-600 border border-gray-300 px-3 py-1.5 rounded-lg"
            >
              Déconnexion
            </button>
          </>
        ) : (
          <>
            <Link to="/cart" className="text-sm text-gray-700 hover:text-green-700 relative">
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
          </>
        )}
      </nav>
    </header>
  )
}