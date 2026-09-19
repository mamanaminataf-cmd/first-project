import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'

const ROLE_LABELS: Record<string, string> = {
  buyer: 'Acheteur',
  seller: 'Vendeur',
  admin: 'Administrateur',
}

export default function Account() {
  const { user, status, refreshProfile } = useAuth()
  const navigate = useNavigate()

  const [fullName, setFullName] = useState('')
  const [shopName, setShopName] = useState('')
  const [shopDescription, setShopDescription] = useState('')
  const [saving, setSaving] = useState(false)
  const [message, setMessage] = useState('')

  useEffect(() => {
    if (user) {
      setFullName(user.full_name ?? '')
      setShopName(user.shop_name ?? '')
      setShopDescription(user.shop_description ?? '')
    }
  }, [user])

  useEffect(() => {
    if (status === 'unauthenticated') navigate('/login')
  }, [status, navigate])

  if (status !== 'authenticated' || !user) {
    return null
  }

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault()
    setSaving(true)
    setMessage('')

    const update: Record<string, string> = { full_name: fullName }
    if (user.role === 'seller') {
      update.shop_name = shopName
      update.shop_description = shopDescription
    }

    const { error } = await supabase.from('profiles').update(update).eq('id', user.id)
    setSaving(false)

    if (error) {
      setMessage(`Erreur : ${error.message}`)
      return
    }
    setMessage('Profil mis à jour ✓')
    refreshProfile()
  }

  return (
    <main className="max-w-2xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold mb-6">Mon profil</h1>

      <div className="bg-white border border-gray-200 rounded-xl p-6 mb-6 flex items-center gap-4">
        <div className="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center text-2xl">
          {user.full_name?.[0]?.toUpperCase() ?? '👤'}
        </div>
        <div>
          <div className="font-semibold">{user.full_name ?? user.email}</div>
          <div className="text-sm text-gray-500">{user.email}</div>
          <span className="inline-block mt-1 text-xs font-semibold text-green-800 bg-green-100 px-2 py-0.5 rounded-full">
            {ROLE_LABELS[user.role]}
          </span>
        </div>
      </div>

      <form onSubmit={handleSave} className="bg-white border border-gray-200 rounded-xl p-6">
        <h2 className="font-semibold mb-4">Informations</h2>

        <div className="mb-4">
          <label className="block text-xs font-semibold text-gray-500 mb-1">Nom complet</label>
          <input
            type="text"
            value={fullName}
            onChange={(e) => setFullName(e.target.value)}
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm"
          />
        </div>

        {user.role === 'seller' && (
          <>
            <div className="mb-4">
              <label className="block text-xs font-semibold text-gray-500 mb-1">Nom de la boutique</label>
              <input
                type="text"
                value={shopName}
                onChange={(e) => setShopName(e.target.value)}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm"
              />
            </div>
            <div className="mb-4">
              <label className="block text-xs font-semibold text-gray-500 mb-1">Description de la boutique</label>
              <textarea
                value={shopDescription}
                onChange={(e) => setShopDescription(e.target.value)}
                rows={3}
                className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm"
              />
            </div>
          </>
        )}

        {message && (
          <p className={`text-sm mb-4 px-3 py-2 rounded-lg ${
            message.startsWith('Erreur')
              ? 'text-red-600 bg-red-50 border border-red-200'
              : 'text-green-700 bg-green-50 border border-green-200'
          }`}>
            {message}
          </p>
        )}

        <button
          type="submit"
          disabled={saving}
          className="bg-green-700 text-white font-semibold px-6 py-2.5 rounded-xl hover:bg-green-800 disabled:opacity-60"
        >
          {saving ? 'Enregistrement...' : 'Enregistrer'}
        </button>
      </form>
    </main>
  )
}