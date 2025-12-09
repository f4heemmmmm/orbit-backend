# Integration Guide

How to integrate the Orbit mobile app with the Supabase backend.

## Overview

This guide shows you how to replace the local state management in your Orbit app with Supabase backend calls.

## Prerequisites

- Completed [SETUP.md](SETUP.md)
- Supabase client configured in your app
- User authentication working

## Step-by-Step Integration

### 1. Install Dependencies

```bash
cd /path/to/orbit
npm install @supabase/supabase-js @react-native-async-storage/async-storage react-native-url-polyfill
```

### 2. Create Supabase Client

Create `src/lib/supabase.ts`:

```typescript
import 'react-native-url-polyfill/auto';
import { createClient } from '@supabase/supabase-js';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Database } from '../../../orbit-backend/supabase/types/database.types';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: AsyncStorage,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
  },
});
```

### 3. Create Auth Context

Create `src/contexts/AuthContext.tsx`:

```typescript
import React, { createContext, useContext, useEffect, useState } from 'react';
import { Session } from '@supabase/supabase-js';
import { supabase } from '../lib/supabase';

interface AuthContextType {
  session: Session | null;
  user: Session['user'] | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string, fullName: string) => Promise<void>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setLoading(false);
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
    });

    return () => subscription.unsubscribe();
  }, []);

  const signIn = async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) throw error;
  };

  const signUp = async (email: string, password: string, fullName: string) => {
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: fullName } },
    });
    if (error) throw error;
  };

  const signOut = async () => {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
  };

  return (
    <AuthContext.Provider value={{
      session,
      user: session?.user ?? null,
      loading,
      signIn,
      signUp,
      signOut,
    }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within AuthProvider');
  return context;
};
```

### 4. Create Data Hooks

Create `src/hooks/useTransactions.ts`:

```typescript
import { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { Database } from '../../../orbit-backend/supabase/types/database.types';

type Transaction = Database['public']['Tables']['transactions']['Row'];
type TransactionInsert = Database['public']['Tables']['transactions']['Insert'];

export function useTransactions() {
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchTransactions();

    // Subscribe to real-time changes
    const channel = supabase
      .channel('transactions-changes')
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'transactions',
      }, () => {
        fetchTransactions();
      })
      .subscribe();

    return () => {
      channel.unsubscribe();
    };
  }, []);

  const fetchTransactions = async () => {
    const { data, error } = await supabase
      .from('transactions')
      .select('*')
      .order('date', { ascending: false });

    if (!error && data) {
      setTransactions(data);
    }
    setLoading(false);
  };

  const addTransaction = async (transaction: Omit<TransactionInsert, 'user_id'>) => {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) throw new Error('Not authenticated');

    const { error } = await supabase
      .from('transactions')
      .insert({ ...transaction, user_id: user.id });

    if (error) throw error;
  };

  const deleteTransaction = async (id: string) => {
    const { error } = await supabase
      .from('transactions')
      .delete()
      .eq('id', id);

    if (error) throw error;
  };

  return { transactions, loading, addTransaction, deleteTransaction };
}
```

Create similar hooks for tasks and events:
- `src/hooks/useTasks.ts`
- `src/hooks/useScheduleEvents.ts`

### 5. Update App.tsx

Wrap your app with AuthProvider:

```typescript
import { AuthProvider } from './src/contexts/AuthContext';

export default function App() {
  return (
    <AuthProvider>
      <NavigationContainer>
        {/* Your existing navigation */}
      </NavigationContainer>
    </AuthProvider>
  );
}
```

### 6. Update Screens

Replace local state with hooks. Example for FinancialsScreen:

```typescript
import { useTransactions } from '../hooks/useTransactions';
import { useAuth } from '../contexts/AuthContext';

export default function FinancialsScreen() {
  const { user } = useAuth();
  const { transactions, loading, addTransaction, deleteTransaction } = useTransactions();

  // Use transactions from backend instead of local state
  // ...
}
```

## Migration Checklist

- [ ] Install dependencies
- [ ] Create Supabase client
- [ ] Create AuthContext
- [ ] Create data hooks (transactions, tasks, events)
- [ ] Update App.tsx with AuthProvider
- [ ] Update FinancialsScreen
- [ ] Update TasksScreen
- [ ] Update ScheduleScreen
- [ ] Add loading states
- [ ] Add error handling
- [ ] Test authentication flow
- [ ] Test CRUD operations
- [ ] Test real-time updates

## Next Steps

See [API.md](API.md) for complete API reference.

