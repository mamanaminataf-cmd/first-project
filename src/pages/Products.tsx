import { useEffect, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import ProductCard from '../components/ProductCard'
import { supabase } from '../lib/supabase'
import type { Category, Product } from '../types'

export default function Products() {
  const [params, setParams] = useSearchParams()
  const [products, setProducts] = useState<Product[]>([])
  const [categories, setCategories] = useState<Category[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const query = params.get('q')?.toLowerCase() ?? ''
  const cat = params.get('cat') ?? ''
  const sort = params.get('sort') ?? 'newest'

  useEffect(() => {
    let active = true

    async function load() {
      setLoading(true)
      setError(null)

      const [{ data, error }, cats] = await Promise.all([
        supabase
          .from('products')
          .select('*, category:categories(id, name, slug), images:product_images(id, url, position)')
          .eq('status', 'active')
          .is('deleted_at', null)
          .order('created_at', { ascending: false }),
        supabase.from('categories').select('id, name, slug').order('name'),
      ])

      if (!active) return

      if (error) {
        setError(error.message)
      } else {
        setProducts((data ?? []) as Product[])
      }
      setCategories((cats.data ?? []) as Category[])
      setLoading(false)
    }

    load()
    return () => {
      active = false
    }
  }, [])

  let list = products.filter(
    (p) =>
      (!query || p.name.toLowerCase().includes(query)) &&
      (!cat || p.category?.name === cat),
  )

  if (sort === 'price-asc') list = [...list].sort((a, b) => Number(a.price) - Number(b.price))
  else if (sort === 'price-desc') list = [...list].sort((a, b) => Number(b.price) - Number(a.price))
  else if (sort === 'name') list = [...list].sort((a, b) => a.name.localeCompare(b.name))

  const updateParam = (key: string, value: string) => {
    const next = new URLSearchParams(params)
    if (value) next.set(key, value)
    else next.delete(key)
    setParams(next)
  }

  return (
    <main className="max-w-7xl mx-auto px-4 py-8">
      <nav className="text-sm text-gray-500 mb-6">
        <Link to="/" className="hover:text-green-700">Accueil</Link> / Catalogue
      </nav>

      <div className="bg-white border border-gray-200 rounded-xl p-5 mb-6 flex flex-wrap gap-4 items-end">
        <div className="flex flex-col gap-1 flex-1 min-w-[150px]">
          <label className="text-xs font-semibold text-gray-500">Recherche</label>
          <input
            type="text"
            value={query}
            onChange={(e) => updateParam('q', e.target.value)}
            placeholder="Nom du produit..."
            className="border border-gray-300 rounded-lg px-3 py-2 text-sm"
          />
        </div>
        <div className="flex flex-col gap-1 flex-1 min-w-[150px]">
          <label className="text-xs font-semibold text-gray-500">Catégorie</label>
          <select
            value={cat}
            onChange={(e) => updateParam('cat', e.target.value)}
            className="border border-gray-300 rounded-lg px-3 py-2 text-sm bg-white"
          >
            <option value="">Toutes</option>
            {categories.map((c) => (
              <option key={c.id} value={c.name}>{c.name}</option>
            ))}
          </select>
        </div>
        <div className="flex flex-col gap-1 flex-1 min-w-[150px]">
          <label className="text-xs font-semibold text-gray-500">Trier par</label>
          <select
            value={sort}
            onChange={(e) => updateParam('sort', e.target.value)}
            className="border border-gray-300 rounded-lg px-3 py-2 text-sm bg-white"
          >
            <option value="newest">Plus récents</option>
            <option value="price-asc">Prix croissant</option>
            <option value="price-desc">Prix décroissant</option>
            <option value="name">Nom A-Z</option>
          </select>
        </div>
        <button
          onClick={() => setParams({})}
          className="border border-green-700 text-green-700 rounded-lg px-4 py-2 text-sm font-semibold hover:bg-green-50"
        >
          Réinitialiser
        </button>
      </div>

      <div className="flex justify-between items-center mb-4">
        <h1 className="text-xl font-bold">Tous les produits</h1>
        <span className="text-sm text-gray-500">{list.length} produit(s)</span>
      </div>

      {loading ? (
        <p className="text-gray-500">Chargement du catalogue...</p>
      ) : error ? (
        <p className="text-red-600">Erreur de chargement : {error}</p>
      ) : list.length === 0 ? (
        <p className="text-gray-500">
          Aucun produit trouvé. Le catalogue est vide — connecte-toi en vendeur pour ajouter des produits.
        </p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {list.map((p) => (
            <ProductCard key={p.id} product={p} />
          ))}
        </div>
      )}
    </main>
  )
}