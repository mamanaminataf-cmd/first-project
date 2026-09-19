import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import type { Role } from '../types'

type FormState = 'idle' | 'submitting' | 'success'
type Errors = Partial<Record<'name' | 'shop' | 'email' | 'password' | 'confirm' | 'general', string>>

export default function Register() {
  const { signUp } = useAuth()

  const [role, setRole] = useState<Role>('buyer')
  const [name, setName] = useState('')
  const [shop, setShop] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')
  const [errors, setErrors] = useState<Errors>({})
  const [state, setState] = useState<FormState>('idle')

  const validate = (): Errors => {
    const next: Errors = {}
    if (!name.trim()) next.name = 'Le nom est requis'
    if (role === 'seller' && !shop.trim()) next.shop = 'Le nom de la boutique est requis'
    if (!/^\S+@\S+\.\S+$/.test(email)) next.email = 'Adresse email invalide'
    if (password.length < 8) next.password = 'Au moins 8 caractères'
    if (confirm !== password) next.confirm = 'Les mots de passe ne correspondent pas'
    return next
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    const next = validate()
    setErrors(next)
    if (Object.keys(next).length > 0) return

    setState('submitting')
    const { error } = await signUp(email, password, role, name, role === 'seller' ? shop : undefined)
    setState('idle')

    if (error) {
      setErrors({ general: error })
      return
    }

    // Confirmation email requise par défaut dans Supabase
    setState('success')
  }

  if (state === 'success') {
    return (
      <main className="max-w-md mx-auto px-4 py-12">
        <div className="bg-white border border-green-200 rounded-xl p-8 text-center">
          <div className="text-6xl mb-4">📬</div>
          <h1 className="text-2xl font-bold mb-2">Vérifie ta boîte mail</h1>
          <p className="text-sm text-gray-500 mb-6">
            Un email de confirmation a été envoyé à <strong>{email}</strong>.
            Clique sur le lien pour activer ton compte {role === 'seller' ? 'vendeur' : 'acheteur'}, puis connecte-toi.
          </p>
          <Link
            to="/login"
            className="inline-block bg-green-700 text-white font-semibold px-6 py-3 rounded-xl hover:bg-green-800"
          >
            Aller à la connexion
          </Link>
        </div>
      </main>
    )
  }

  return (
    <main className="max-w-md mx-auto px-4 py-12">
      <form onSubmit={handleSubmit}>
        <div className="bg-white border border-gray-200 rounded-xl p-8">
          <h1 className="text-2xl font-bold mb-1">Créer un compte</h1>
          <p className="text-sm text-gray-500 mb-6">Rejoignez Bio Market</p>

          <div className="flex border-b border-gray-200 mb-6">
            <button
              type="button"
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
              type="button"
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

          {errors.general && (
            <p className="text-sm text-red-600 bg-red-50 border border-red-200 rounded-lg px-3 py-2 mb-4">
              {errors.general}
            </p>
          )}

          <div className="mb-4">
            <label className="block text-xs font-semibold text-gray-500 mb-1">
              Nom complet
            </label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Votre nom"
              className={`w-full border rounded-lg px-3 py-2 text-sm ${
                errors.name ? 'border-red-400' : 'border-gray-300'
              }`}
            />
            {errors.name && <p className="text-xs text-red-500 mt-1">{errors.name}</p>}
          </div>
          <div className="mb-4">
            <label className="block text-xs font-semibold text-gray-500 mb-1">
              Adresse email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="vous@exemple.com"
              className={`w-full border rounded-lg px-3 py-2 text-sm ${
                errors.email ? 'border-red-400' : 'border-gray-300'
              }`}
            />
            {errors.email && <p className="text-xs text-red-500 mt-1">{errors.email}</p>}
          </div>
          {role === 'seller' && (
            <div className="mb-4">
              <label className="block text-xs font-semibold text-gray-500 mb-1">
                Nom de la boutique
              </label>
              <input
                type="text"
                value={shop}
                onChange={(e) => setShop(e.target.value)}
                placeholder="Ma boutique bio"
                className={`w-full border rounded-lg px-3 py-2 text-sm ${
                  errors.shop ? 'border-red-400' : 'border-gray-300'
                }`}
              />
              {errors.shop && <p className="text-xs text-red-500 mt-1">{errors.shop}</p>}
            </div>
          )}
          <div className="mb-4">
            <label className="block text-xs font-semibold text-gray-500 mb-1">
              Mot de passe
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="8+ caractères"
              className={`w-full border rounded-lg px-3 py-2 text-sm ${
                errors.password ? 'border-red-400' : 'border-gray-300'
              }`}
            />
            {errors.password && <p className="text-xs text-red-500 mt-1">{errors.password}</p>}
          </div>
          <div className="mb-6">
            <label className="block text-xs font-semibold text-gray-500 mb-1">
              Confirmer le mot de passe
            </label>
            <input
              type="password"
              value={confirm}
              onChange={(e) => setConfirm(e.target.value)}
              placeholder="••••••••"
              className={`w-full border rounded-lg px-3 py-2 text-sm ${
                errors.confirm ? 'border-red-400' : 'border-gray-300'
              }`}
            />
            {errors.confirm && <p className="text-xs text-red-500 mt-1">{errors.confirm}</p>}
          </div>

          <button
            type="submit"
            disabled={state === 'submitting'}
            className="w-full bg-green-700 text-white font-semibold py-3 rounded-xl hover:bg-green-800 disabled:opacity-60"
          >
            {state === 'submitting' ? 'Création...' : 'Créer mon compte'}
          </button>

          <p className="text-sm text-center mt-4">
            Déjà inscrit ?{' '}
            <Link to="/login" className="text-green-700 font-semibold">
              Se connecter
            </Link>
          </p>
        </div>
      </form>
    </main>
  )
}