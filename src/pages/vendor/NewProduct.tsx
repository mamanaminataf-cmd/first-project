import { useEffect, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../../contexts/AuthContext'
import { supabase } from '../../lib/supabase'
import type { Category } from '../../types'

export default function NewProduct() {
  const { status, user, isSeller, isAdmin } = useAuth()
  const navigate = useNavigate()

  const [categories, setCategories] = useState<Category[]>([])
  const [name, setName] = useState('')
  const [description, setDescription] = useState('')
  const [price, setPrice] = useState('')
  const [stock, setStock] = useState('')
  const [categoryId, setCategoryId] = useState('')
  const [imageUrls, setImageUrls] = useState<string[]>([''])
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    if (status !== 'authenticated' || (!isSeller && !isAdmin)) {
      navigate('/login')
      return
    }
    supabase
      .from('categories')
      .select('id, name, slug')
      .order('name')
      .then(({ data, error }) => {
        if (!error) setCategories((data ?? []) as Category[])
        if (data?.[0]) setCategoryId(data[0].id)
      })
  }, [status, isSeller, isAdmin, navigate])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!user) return
    setError(null)

    const priceNum = Number(price.replace(',', '.'))
    const stockNum = Number(stock)

    if (!name.trim()) {
      setError('Le nom du produit est obligatoire.')
      return
    }
    if (isNaN(priceNum) || priceNum <= 0) {
      setError('Le prix doit être un nombre supérieur à 0.')
      return
    }
    if (isNaN(stockNum) || stockNum < 0) {
      setError('Le stock doit être un nombre positif ou nul.')
      return
    }
    if (!categoryId) {
      setError('Choisis une catégorie.')
      return
    }

    setSubmitting(true)
    const { data, error: insertError } = await supabase
      .from('products')
      .insert({ seller_id: user.id, category_id: categoryId, name: name.trim(), description: description.trim(), price: priceNum, stock: stockNum, status: 'active' })
      .select('id')
      .single()

    if (insertError || !data) {
      setError(insertError?.message ?? 'Échec de la création du produit.')
      setSubmitting(false)
      return
    }

    const urls = imageUrls
      .map((u) => u.trim())
      .filter((u) => u.length > 0)

    if (urls.length > 0) {
      const rows = urls.map((url, i) => ({ product_id: data.id, url, position: i }))
      const { error: imgError } = await supabase
        .from('product_images')
        .insert(rows)
      if (imgError) {
        setError('Produit créé mais les images n\'ont pas pu être ajoutées : ' + imgError.message)
      }
    }

    setSubmitting(false)
    navigate(`/products/${data.id}`)
  }

  const inputClass =
    'border border-gray-300 rounded-lg px-3 py-2 text-sm w-full focus:outline-none focus:ring-2 focus:ring-green-700/30 focus:border-green-700'

  return (
    <main className="max-w-2xl mx-auto px-4 py-8">
      <nav className="text-sm text-gray-500 mb-6">
        <Link to="/" className="hover:text-green-700">Accueil</Link> /{' '}
        <Link to="/products" className="hover:text-green-700">Catalogue</Link> / Vendre un produit
      </nav>

      <h1 className="text-2xl font-bold mb-6">Publier un nouveau produit</h1>

      <form onSubmit={handleSubmit} className="bg-white border border-gray-200 rounded-xl p-6 flex flex-col gap-4">
        <div className="flex flex-col gap-1">
          <label className="text-xs font-semibold text-gray-500">Nom du produit *</label>
          <input className={inputClass} value={name} onChange={(e) => setName(e.target.value)} placeholder="Ex. Tomates cerises bio" />
        </div>

        <div className="flex flex-col gap-1">
          <label className="text-xs font-semibold text-gray-500">Description</label>
          <textarea
            className={inputClass + ' min-h-24'}
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            placeholder="Origine, mode de culture, goût, contenance..."
          />
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <div className="flex flex-col gap-1">
            <label className="text-xs font-semibold text-gray-500">Prix (€) *</label>
            <input className={inputClass} type="number" step="0.01" min="0.01" value={price} onChange={(e) => setPrice(e.target.value)} placeholder="3.50" />
          </div>
          <div className="flex flex-col gap-1">
            <label className="text-xs font-semibold text-gray-500">Stock *</label>
            <input className={inputClass} type="number" step="1" min="0" value={stock} onChange={(e) => setStock(e.target.value)} placeholder="12" />
          </div>
          <div className="flex flex-col gap-1">
            <label className="text-xs font-semibold text-gray-500">Catégorie *</label>
            <select className={inputClass} value={categoryId} onChange={(e) => setCategoryId(e.target.value)}>
              {categories.map((c) => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </select>
          </div>
        </div>

        <div className="flex flex-col gap-2">
          <label className="text-xs font-semibold text-gray-500">Images (URL) — jusqu'à 5</label>
          {imageUrls.map((url, i) => (
            <div key={i} className="flex gap-2">
              <input
                className={inputClass}
                value={url}
                onChange={(e) => {
                  const next = [...imageUrls]
                  next[i] = e.target.value
                  setImageUrls(next)
                }}
                placeholder={`Image ${i + 1} (https://...)`}
              />
              {imageUrls.length > 1 && (
                <button
                  type="button"
                  onClick={() => setImageUrls(imageUrls.filter((_, j) => j !== i))}
                  className="text-gray-400 hover:text-red-600 px-2 text-sm"
                  title="Retirer cette image"
                >
                  ✕
                </button>
              )}
            </div>
          ))}
          {imageUrls.length < 5 && (
            <button
              type="button"
              onClick={() => setImageUrls([...imageUrls, ''])}
              className="self-start text-sm text-green-700 font-semibold hover:underline"
            >
              + Ajouter une autre image
            </button>
          )}
          <span className="text-xs text-gray-400">Optionnel — laisse vide pour afficher le pictogramme bio. La première image est affichée en grand sur la fiche produit.</span>
        </div>

        {error && <p className="text-sm text-red-600">{error}</p>}

        <div className="flex gap-3">
          <button
            type="submit"
            disabled={submitting}
            className="flex-1 bg-green-700 text-white font-semibold px-6 py-3 rounded-xl hover:bg-green-800 disabled:opacity-50"
          >
            {submitting ? 'Publication...' : 'Publier le produit'}
          </button>
          <Link
            to="/products"
            className="border border-gray-300 text-gray-700 font-semibold px-6 py-3 rounded-xl hover:bg-gray-50"
          >
            Annuler
          </Link>
        </div>
      </form>
    </main>
  )
}