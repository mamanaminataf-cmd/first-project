import { Link } from 'react-router-dom'
import type { Product } from '../types'

interface ProductCardProps {
  product: Product
  onAddToCart?: (product: Product) => void
}

export default function ProductCard({ product, onAddToCart }: ProductCardProps) {
  const soldOut = product.stock <= 0

  return (
    <div className="bg-white border border-gray-200 rounded-xl overflow-hidden transition hover:shadow-lg">
      <Link to={`/products/${product.id}`}>
        <div className="h-40 bg-gradient-to-br from-green-100 to-green-50 flex items-center justify-center text-5xl">
          🌿
        </div>
      </Link>
      <div className="p-4">
        <div className="text-xs text-gray-500 uppercase tracking-wide">{product.category_id}</div>
        <Link
          to={`/products/${product.id}`}
          className="font-semibold text-gray-900 hover:text-green-700"
        >
          {product.name}
        </Link>
        <div className="flex items-center justify-between mt-3">
          <span className="font-bold text-green-700">{product.price.toFixed(2)} €</span>
          {soldOut ? (
            <span className="text-xs font-semibold text-red-600 bg-red-50 px-3 py-1 rounded-full">
              Rupture
            </span>
          ) : onAddToCart ? (
            <button
              onClick={() => onAddToCart(product)}
              className="text-xs font-semibold text-white bg-green-700 px-3 py-1.5 rounded-lg hover:bg-green-800"
            >
              Ajouter
            </button>
          ) : null}
        </div>
      </div>
    </div>
  )
}