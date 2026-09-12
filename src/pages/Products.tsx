import { useSearchParams } from 'react-router-dom'
import ProductCard from '../components/ProductCard'
import type { Product } from '../types'

const SAMPLE_PRODUCTS: Product[] = [
  { id: '1', seller_id: '1', category_id: 'Légumes', name: 'Tomates cerises bio', description: '', price: 3.5, stock: 12, status: 'active', created_at: '', updated_at: '' },
  { id: '2', seller_id: '1', category_id: 'Fruits', name: 'Pommes Gala bio', description: '', price: 2.9, stock: 8, status: 'active', created_at: '', updated_at: '' },
  { id: '3', seller_id: '2', category_id: 'Légumes', name: 'Carottes des sables', description: '', price: 1.9, stock: 25, status: 'active', created_at: '', updated_at: '' },
  { id: '4', seller_id: '2', category_id: 'Ferme', name: 'Œufs plein air', description: '', price: 4.2, stock: 0, status: 'active', created_at: '', updated_at: '' },
  { id: '5', seller_id: '3', category_id: 'Épicerie', name: 'Miel de lavande', description: '', price: 8.9, stock: 6, status: 'active', created_at: '', updated_at: '' },
]

const CATEGORIES = ['Légumes', 'Fruits', 'Ferme', 'Céréales', 'Boissons', 'Épicerie']

export default function Products() {
  const [params, setParams] = useSearchParams()
  const query = params.get('q')?.toLowerCase() ?? ''
  const cat = params.get('cat') ?? ''
  const sort = params.get('sort') ?? 'popular'

  let list = SAMPLE_PRODUCTS.filter(
    (p) =>
      (!query || p.name.toLowerCase().includes(query)) &&
      (!cat || p.category_id === cat),
  )

  if (sort === 'price-asc') list = [...list].sort((a, b) => a.price - b.price)
  else if (sort === 'price-desc') list = [...list].sort((a, b) => b.price - a.price)

  const updateParam = (key: string, value: string) => {
    const next = new URLSearchParams(params)
    if (value) next.set(key, value)
    else next.delete(key)
    setParams(next)
  }

  return (
    <main className="max-w-7xl mx-auto px-4 py-8">
      <nav className="text-sm text-gray-500 mb-6">
        <a href="." className="hover:text-green-700">Accueil</a> / Catalogue
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
            {CATEGORIES.map((c) => (
              <option key={c} value={c}>{c}</option>
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
            <option value="popular">Popularité</option>
            <option value="price-asc">Prix croissant</option>
            <option value="price-desc">Prix décroissant</option>
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

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {list.map((p) => (
          <ProductCard key={p.id} product={p} />
        ))}
      </div>
    </main>
  )
}