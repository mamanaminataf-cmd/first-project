import { useState } from 'react'
import { Link } from 'react-router-dom'

type Role = 'buyer' | 'seller'

export default function Register() {
  const [role, setRole] = useState<Role>('buyer')

  return (
    <main className="max-w-md mx-auto px-4 py-12">
      <div className="bg-white border border-gray-200 rounded-xl p-8">
        <h1 className="text-2xl font-bold mb-1">Créer un compte</h1>
        <p className="text-sm text-gray-500 mb-6">Rejoignez Bio Market</p>

        <div className="flex border-b border-gray-200 mb-6">
          <button
            className={`flex-1 py-3 font-semibold text-sm ${
              role === 'buyer'
                ? 'text-green-700 border-b-2 border-green-700'
                : 'text-gray-500'
            }`}
            onClick={() => setRole('buyer')}
          >
            🛍️ Acheteur
          </button>
          <button
            className={`flex-1 py-3 font-semibold text-sm ${
              role === 'seller'
                ? 'text-green-700 border-b-2 border-green-700'
                : 'text-gray-500'
            }`}
            onClick={() => setRole('seller')}
          >
            🏪 Vendeur
          </button>
        </div>

        <div className="mb-4">
          <label className="block text-xs font-semibold text-gray-500 mb-1">
            Nom complet
          </label>
          <input
            type="text"
            placeholder="Votre nom"
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm"
          />
        </div>
        <div className="mb-4">
          <label className="block text-xs font-semibold text-gray-500 mb-1">
            Adresse email
          </label>
          <input
            type="email"
            placeholder="vous@exemple.com"
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm"
          />
        </div>
        {role === 'seller' && (
          <div className="mb-4">
            <label className="block text-xs font-semibold text-gray-500 mb-1">
              Nom de la boutique
            </label>
            <input
              type="text"
              placeholder="Ma boutique bio"
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm"
            />
          </div>
        )}
        <div className="mb-4">
          <label className="block text-xs font-semibold text-gray-500 mb-1">
            Mot de passe
          </label>
          <input
            type="password"
            placeholder="8+ caractères"
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm"
          />
        </div>
        <div className="mb-6">
          <label className="block text-xs font-semibold text-gray-500 mb-1">
            Confirmer le mot de passe
          </label>
          <input
            type="password"
            placeholder="••••••••"
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm"
          />
        </div>

        <button className="w-full bg-green-700 text-white font-semibold py-3 rounded-xl hover:bg-green-800">
          Créer mon compte
        </button>

        <p className="text-sm text-center mt-4">
          Déjà inscrit ?{' '}
          <Link to="/login" className="text-green-700 font-semibold">
            Se connecter
          </Link>
        </p>
      </div>
    </main>
  )
}