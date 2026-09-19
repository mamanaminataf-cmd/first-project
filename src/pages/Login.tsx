import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { useNavigate } from 'react-router-dom'

export default function Login() {
  const { signIn } = useAuth()
  const navigate = useNavigate()

  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [submitting, setSubmitting] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
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
    setSubmitting(true)
    const { error: loginError } = await signIn(email, password)
    setSubmitting(false)

    if (loginError) {
      setError(loginError)
      return
    }

    navigate('/')
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
            disabled={submitting}
            className="w-full bg-green-700 text-white font-semibold py-3 rounded-xl hover:bg-green-800 disabled:opacity-60"
          >
            {submitting ? 'Connexion...' : 'Se connecter'}
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