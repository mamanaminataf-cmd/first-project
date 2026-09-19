export type Role = 'buyer' | 'seller' | 'admin'

export interface Profile {
  id: string
  email: string
  full_name: string | null
  role: Role
  status: 'active' | 'suspended' | 'pending_verification'
  shop_name?: string | null
  shop_description?: string | null
  avatar_url?: string | null
  created_at: string
  updated_at: string
}

export interface Category {
  id: string
  name: string
  slug: string
}

export interface Product {
  id: string
  seller_id: string
  category_id: string
  name: string
  description: string
  price: number
  stock: number
  status: 'draft' | 'active' | 'inactive'
  created_at: string
  updated_at: string
}

export interface CartItem {
  id: string
  product_id: string
  quantity: number
}

export interface Order {
  id: string
  buyer_id: string
  status: 'pending' | 'paid' | 'processing' | 'shipped' | 'delivered' | 'cancelled' | 'refunded'
  total: number
  created_at: string
}