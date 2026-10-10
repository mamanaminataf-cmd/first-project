import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import type { Product } from '../types'

export default function ProductDetail() {
  const { id } = useParams()
  const [product, setProduct] = useState<Product | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [imageFailed, setImageFailed] = useState(false)
  const [activeImage, setActiveImage] = useState(0)

  useEffect(() => {
    let active = true

    async function load() {
      setLoading(true)
      setError(null)
      const { data, error } = await supabase
        .from('products')
        .select('*, category:categories(id, name, slug), images:product_images(id, url, position), seller:profiles(id, full_name, shop_name)')
        .eq('id', id!)
        .maybeSingle()

      if (!active) return
      if (error) {
        setError(error.message)
      } else {
        setProduct((data ?? null) as Product | null)
      }
      setLoading(false)
    }

    load()
    return () => {
      active = false
    }
  }, [id])

  if (loading) {
    return (
      <main className="max-w-7xl mx-auto px-4 py-16 text-center">
        <p className="text-gray-500">Chargement du produit...</p>
      </main>
    )
  }

  if (error || !product) {
    return (
      <main className="max-w-7xl mx-auto px-4 py-16 text-center">
        <h1 className="text-2xl font-bold mb-4">Produit introuvable</h1>
        <p className="text-gray-500 mb-6">{error ?? 'Ce produit n\'existe pas ou n\'est plus disponible.'}</p>
        <Link to="/products" className="text-green-700 font-semibold">
          ← Retour au catalogue
        </Link>
      </main>
    )
  }

  const soldOut = product.stock <= 0
  const images = product.images?.sort((a, b) => a.position - b.position) ?? []
  const image = images[activeImage]?.url

  return (
    <main className="max-w-7xl mx-auto px-4 py-8">
      <nav className="text-sm text-gray-500 mb-6">
        <Link to="/" className="hover:text-green-700">Accueil</Link> /{' '}
        <Link to="/products" className="hover:text-green-700">Catalogue</Link> /{' '}
        {product.category?.name ?? 'Bio'} / {product.name}
      </nav>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-10">
        <div>
          <div className="h-96 bg-gradient-to-br from-green-100 to-green-50 rounded-xl flex items-center justify-center overflow-hidden">
            {image && !imageFailed ? (
              <img
                src={image}
                alt={product.name}
                className="w-full h-full object-cover"
                onError={() => setImageFailed(true)}
              />
            ) : (
              <span className="text-8xl">🌿</span>
            )}
          </div>
          {images.length > 1 && (
            <div className="flex gap-2 mt-3">
              {images.map((img, i) => (
                <button
                  key={img.id}
                  onClick={() => setActiveImage(i)}
                  className={`h-16 w-16 rounded-lg overflow-hidden border-2 ${i === activeImage ? 'border-green-700' : 'border-transparent'}`}
                >
                  <img src={img.url} alt="" className="w-full h-full object-cover" />
                </button>
              ))}
            </div>
          )}
        </div>

        <div>
          <div className="flex gap-2 mb-4 flex-wrap">
            <span className="text-xs font-semibold text-green-800 bg-green-100 px-3 py-1 rounded-full">
              Certifié bio
            </span>
            <span className={`text-xs font-semibold px-3 py-1 rounded-full ${soldOut ? 'text-red-600 bg-red-50' : 'text-green-800 bg-green-100'}`}>
              {soldOut ? 'Rupture de stock' : `En stock (${product.stock})`}
            </span>
            <span className="text-xs font-semibold text-gray-600 bg-gray-100 px-3 py-1 rounded-full">
              {product.category?.name ?? 'Bio'}
            </span>
          </div>

          <h1 className="text-3xl font-bold mb-2">{product.name}</h1>
          <div className="text-2xl font-bold text-green-700 mb-4">
            {Number(product.price).toFixed(2)} €
          </div>
          <p className="text-gray-600 mb-6">{product.description}</p>

          {product.seller?.shop_name && (
            <p className="text-sm text-gray-500 mb-6">
              Vendu par <span className="font-semibold text-gray-700">{product.seller.shop_name}</span>
            </p>
          )}

          <button
            disabled={soldOut}
            className={`px-6 py-3 rounded-xl font-semibold ${
              soldOut ? 'bg-gray-200 text-gray-400 cursor-not-allowed' : 'bg-green-700 text-white hover:bg-green-800'
            }`}
          >
            🛒 {soldOut ? 'Rupture de stock' : 'Ajouter au panier'}
          </button>
        </div>
      </div>
    </main>
  )
}