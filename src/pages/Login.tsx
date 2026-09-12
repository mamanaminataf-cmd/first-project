import { Link } from 'react-router-dom'

export default function Login() {
  return (
    <main className="max-w-md mx-auto px-4 py-12">
      <div className="bg-white border border-gray-200 rounded-xl p-8">
        <h1 className="text-2xl font-bold mb-1">Bienvenue 👋</h1>
        <p className="text-sm text-gray-500 mb-6">Connectez-vous pour continuer</p>

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
        <div className="mb-6">
          <label className="block text-xs font-semibold text-gray-500 mb-1">
            Mot de passe
          </label>
          <input
            type="password"
            placeholder="••••••••"
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm"
          />
        </div>

        <button className="w-full bg-green-700 text-white font-semibold py-3 rounded-xl hover:bg-green-800">
          Se connecter
        </button>

        <p className="text-sm text-center mt-4">
          Pas de compte ?{' '}
          <Link to="/register" className="text-green-700 font-semibold">
            S'inscrire
          </Link>
        </p>
      </div>
    </main>
  )
}