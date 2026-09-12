import { useState } from 'react'
import { Link } from 'react-router-dom'

export default function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [submitted, setSubmitted] = useState(false)

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (!/^\S+@\S+\.\S+$/.test(email)) {
      setError('Adresse email invalide')
      return
    }
    if (!password) {
      setError('Mot de passe requis')
      return
    }
    setError('')
    setSubmitted(true)
  }

  if (submitted) {
    return (
      <main className="max-w-md mx-auto px-4 py-12">
        <div className="bg-white border border-green-200 rounded-xl p-8 text-center">
          <div className="text-6xl mb-4">🔓</div>
          <h1 className="text-2xl font-bold mb-2">Connexion (démo)</h1>
          <p className="text-sm text-gray-500 mb-6">
            Bienvenue ! La connexion réelle avec Supabase sera connectée au Sprint 4.
          </p>
          <Link
            to="/products"
            className="inline-block bg-green-700 text-white font-semibold px-6 py-3 rounded-xl hover:bg-green-800"
          >
            Explorer le catalogue
          </Link>
        </div>
      </main>
    )
  }

  return (
    <main className="max-w-md mx-auto px-4 py-12">
      <form onSubmit={handleSubmit}>
        <div className="bg-white border border-gray-200 rounded-xl p-8">
          <h1 className="text-2xl font-bold mb-1">Bienvenue 👋</h1>
          <p className="text-sm text-gray-500 mb-6">Connectez-vous pour continuer</p>

          <div className="mb-4">
            <label className="block text-xs font-semibold text-gray-500 mb-1">
              Adresse email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
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
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm"
            />
          </div>

          {error && (
            <p className="text-sm text-red-600 bg-red-50 border border-red-200 rounded-lg px-3 py-2 mb-4">
              {error}
            </p>
          )}

          <button
            type="submit"
            className="w-full bg-green-700 text-white font-semibold py-3 rounded-xl hover:bg-green-800"
          >
            Se connecter
          </button>

          <p className="text-sm text-center mt-4">
            Pas de compte ?{' '}
            <Link to="/register" className="text-green-700 font-semibold">
              S'inscrire
            </Link>
          </p>
        </div>
      </form>
    </main>
  )
}