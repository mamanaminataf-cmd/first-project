import { useEffect, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../../contexts/AuthContext'
import { supabase } from '../../lib/supabase'
import type { Product } from '../../types'

function ProductRow({ product, onChanged, onDeleted }: {
  product: Product
  onChanged: (p: Product) => void
  onDeleted: (id: string) => void
}) {
  const [price, setPrice] = useState(String(product.price))
  const [stock, setStock] = useState(String(product.stock))
  const [status, setStatus] = useState(product.status)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [deleting, setDeleting] = useState(false)

  const image = product.images?.[0]?.url

  const handleSave = async () => {
    setError(null)
    const priceNum = Number(price.replace(',', '.'))
    const stockNum = Number(stock)
    if (isNaN(priceNum) || priceNum <= 0) {
      setError('Prix invalide.')
      return
    }
    if (isNaN(stockNum) || stockNum < 0) {
      setError('Stock invalide.')
      return
    }
    setSaving(true)
    const { data, error: err } = await supabase
      .from('products')
      .update({ price: priceNum, stock: stockNum, status })
      .eq('id', product.id)
      .eq('seller_id', product.seller_id)
      .select('*')
      .single()
    setSaving(false)
    if (err) {
      setError(err.message)
      return
    }
    onChanged({ ...product, ...(data as Product) })
  }

  const handleDelete = async () => {
    if (!window.confirm(`Supprimer « ${product.name} » ?`)) return
    setDeleting(true)
    const { error: err } = await supabase
      .from('products')
      .update({ status: 'deleted', deleted_at: new Date().toISOString() })
      .eq('id', product.id)
      .eq('seller_id', product.seller_id)
    setDeleting(false)
    if (err) {
      setError(err.message)
      return
    }
    onDeleted(product.id)
  }

  const badge =
    status === 'active'
      ? 'text-green-700 bg-green-100'
      : status === 'inactive'
        ? 'text-amber-700 bg-amber-100'
        : 'text-gray-600 bg-gray-100'

  return (
    <div className="bg-white border border-gray-200 rounded-xl p-4 flex flex-col sm:flex-row sm:items-center gap-4">
      <div className="h-20 w-20 rounded-lg overflow-hidden bg-gradient-to-br from-green-100 to-green-50 flex items-center justify-center shrink-0">
        {image ? (
          <img src={image} alt={product.name} className="w-full h-full object-cover" />
        ) : (
          <span className="text-2xl">🌿</span>
        )}
      </div>

      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2 flex-wrap">
          <span className="font-semibold text-gray-900 truncate">{product.name}</span>
          <span className={`text-xs font-semibold px-2 py-0.5 rounded-full ${badge}`}>
            {status === 'active' ? 'En vente' : status === 'inactive' ? 'Inactif' : 'Brouillon'}
          </span>
        </div>
        <div className="text-xs text-gray-500">{product.category?.name ?? 'Bio'}</div>
        <div className="flex flex-wrap gap-3 mt-2 items-end">
          <label className="text-xs font-semibold text-gray-500 flex flex-col">
            Prix (€)
            <input
              className="border border-gray-300 rounded-lg px-2 py-1 text-sm w-20"
              type="number"
              step="0.01"
              min="0.01"
              value={price}
              onChange={(e) => setPrice(e.target.value)}
            />
          </label>
          <label className="text-xs font-semibold text-gray-500 flex flex-col">
            Stock
            <input
              className="border border-gray-300 rounded-lg px-2 py-1 text-sm w-20"
              type="number"
              step="1"
              min="0"
              value={stock}
              onChange={(e) => setStock(e.target.value)}
            />
          </label>
          <label className="text-xs font-semibold text-gray-500 flex flex-col">
            Statut
            <select
              className="border border-gray-300 rounded-lg px-2 py-1 text-sm bg-white"
              value={status}
              onChange={(e) => setStatus(e.target.value as Product['status'])}
            >
              <option value="active">En vente</option>
              <option value="inactive">Inactif</option>
              <option value="draft">Brouillon</option>
            </select>
          </label>
        </div>
        {error && <p className="text-xs text-red-600 mt-1">{error}</p>}
      </div>

      <div className="flex gap-2 shrink-0">
        <Link
          to={`/products/${product.id}`}
          className="text-sm text-green-700 hover:underline font-semibold"
        >
          Voir
        </Link>
        <button
          onClick={handleSave}
          disabled={saving}
          className="text-sm font-semibold text-white bg-green-700 px-3 py-1.5 rounded-lg hover:bg-green-800 disabled:opacity-50"
        >
          {saving ? '...' : 'Enregistrer'}
        </button>
        <button
          onClick={handleDelete}
          disabled={deleting}
          className="text-sm font-semibold text-red-600 border border-red-300 px-3 py-1.5 rounded-lg hover:bg-red-50 disabled:opacity-50"
        >
          {deleting ? '...' : 'Supprimer'}
        </button>
      </div>
    </div>
  )
}

export default function MyShop() {
  const { status, user, isSeller, isAdmin } = useAuth()
  const navigate = useNavigate()
  const [products, setProducts] = useState<Product[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (status !== 'authenticated' || (!isSeller && !isAdmin)) {
      navigate('/login')
      return
    }
  }, [status, isSeller, isAdmin, navigate])

  useEffect(() => {
    let active = true
    async function load() {
      setLoading(true)
      setError(null)
      const { data, error } = await supabase
        .from('products')
        .select('*, category:categories(id, name), images:product_images(id, url, position)')
        .eq('seller_id', user!.id)
        .is('deleted_at', null)
        .order('created_at', { ascending: false })
      if (!active) return
      if (error) {
        setError(error.message)
      } else {
        setProducts((data ?? []) as Product[])
      }
      setLoading(false)
    }
    load()
    return () => {
      active = false
    }
  }, [user])

  const handleChanged = (updated: Product) => {
    setProducts((prev) => prev.map((p) => (p.id === updated.id ? updated : p)))
  }

  const handleDeleted = (id: string) => {
    setProducts((prev) => prev.filter((p) => p.id !== id))
  }

  return (
    <main className="max-w-4xl mx-auto px-4 py-8">
      <nav className="text-sm text-gray-500 mb-6">
        <Link to="/" className="hover:text-green-700">Accueil</Link> / Ma boutique
      </nav>

      <div className="flex items-center justify-between mb-6 flex-wrap gap-3">
        <h1 className="text-2xl font-bold">🏪 Ma boutique</h1>
        <Link
          to="/seller/products/new"
          className="bg-green-700 text-white font-semibold px-4 py-2 rounded-lg hover:bg-green-800"
        >
          + Publier un produit
        </Link>
      </div>

      {loading ? (
        <p className="text-gray-500">Chargement de la boutique...</p>
      ) : error ? (
        <p className="text-red-600">Erreur de chargement : {error}</p>
      ) : products.length === 0 ? (
        <div className="bg-white border border-gray-200 rounded-xl p-10 text-center text-gray-500">
          <p className="mb-4">Tu n'as pas encore publié de produit.</p>
          <Link to="/seller/products/new" className="text-green-700 font-semibold hover:underline">
            Publier mon premier produit →
          </Link>
        </div>
      ) : (
        <div className="flex flex-col gap-3">
          {products.map((p) => (
            <ProductRow key={p.id} product={p} onChanged={handleChanged} onDeleted={handleDeleted} />
          ))}
        </div>
      )}
    </main>
  )
}