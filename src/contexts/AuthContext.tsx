import { createContext, useContext, useEffect, useState, type ReactNode } from 'react'
import { supabase } from '../lib/supabase'
import type { Profile, Role } from '../types'

type AuthStatus = 'loading' | 'authenticated' | 'unauthenticated'

interface AuthContextValue {
  status: AuthStatus
  user: Profile | null
  role: Role | null
  isAdmin: boolean
  isSeller: boolean
  isBuyer: boolean
  signUp: (email: string, password: string, role: Role, fullName: string, shopName?: string) => Promise<{ error: string | null }>
  signIn: (email: string, password: string) => Promise<{ error: string | null }>
  signOut: () => Promise<void>
  refreshProfile: () => Promise<void>
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined)

async function fetchProfile(userId: string): Promise<Profile | null> {
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .maybeSingle()
  if (error || !data) return null
  return data as Profile
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [status, setStatus] = useState<AuthStatus>('loading')
  const [user, setUser] = useState<Profile | null>(null)

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => {
      const session = data.session
      if (session?.user) {
        fetchProfile(session.user.id).then((profile) => {
          setUser(profile)
          setStatus(profile ? 'authenticated' : 'unauthenticated')
        })
      } else {
        setStatus('unauthenticated')
      }
    })

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user) {
        fetchProfile(session.user.id).then((profile) => {
          setUser(profile)
          setStatus(profile ? 'authenticated' : 'unauthenticated')
        })
      } else {
        setUser(null)
        setStatus('unauthenticated')
      }
    })

    return () => subscription.unsubscribe()
  }, [])

  const refreshProfile = async () => {
    if (!user) return
    const profile = await fetchProfile(user.id)
    setUser(profile)
  }

  const signUp = async (
    email: string,
    password: string,
    role: Role,
    fullName: string,
    shopName?: string,
  ) => {
    const meta: Record<string, string> = { role, full_name: fullName }
    if (shopName) meta.shop_name = shopName

    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: meta },
    })

    if (error) return { error: error.message }
    if (!data.user) return { error: 'Inscription impossible' }

    // Le profil est créé par le trigger DB. S'il n'existe pas encore (cas du
    // provider à confirmation email), on rafraîchit quand la session arrive.
    return { error: null }
  }

  const signIn = async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) return { error: error.message }
    return { error: null }
  }

  const signOut = async () => {
    await supabase.auth.signOut()
  }

  const role = user?.role ?? null

  return (
    <AuthContext.Provider
      value={{
        status,
        user,
        role,
        isAdmin: role === 'admin',
        isSeller: role === 'seller',
        isBuyer: role === 'buyer',
        signUp,
        signIn,
        signOut,
        refreshProfile,
      }}
    >
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within an AuthProvider')
  return ctx
}