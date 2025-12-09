# Quick Start Guide

Get your Orbit backend up and running in 10 minutes!

## 🚀 Fast Setup

### 1. Create Supabase Project (2 min)
- Go to [supabase.com](https://supabase.com) → New Project
- Name: `orbit-backend`
- Choose free tier
- Wait for setup

### 2. Run Migrations (3 min)
In Supabase Dashboard → SQL Editor:
1. Run `supabase/migrations/001_initial_schema.sql`
2. Run `supabase/migrations/002_rls_policies.sql`
3. Run `supabase/migrations/003_functions.sql`

### 3. Get API Keys (1 min)
Supabase Dashboard → Settings → API:
- Copy **Project URL**
- Copy **anon public** key

### 4. Configure Orbit App (4 min)

```bash
cd /path/to/orbit
npm install @supabase/supabase-js @react-native-async-storage/async-storage react-native-url-polyfill
```

Create `.env`:
```env
EXPO_PUBLIC_SUPABASE_URL=your-project-url
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

Create `src/lib/supabase.ts`:
```typescript
import 'react-native-url-polyfill/auto';
import { createClient } from '@supabase/supabase-js';
import AsyncStorage from '@react-native-async-storage/async-storage';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: AsyncStorage,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
  },
});
```

## ✅ Test It

```typescript
import { supabase } from './lib/supabase';

// Sign up
const { data, error } = await supabase.auth.signUp({
  email: 'test@example.com',
  password: 'password123',
});

// Create a transaction
const { data: transaction } = await supabase
  .from('transactions')
  .insert({
    user_id: data.user.id,
    title: 'Test Transaction',
    amount: 100,
    type: 'income',
    category: 'Salary',
  })
  .select()
  .single();

console.log('✅ Backend working!', transaction);
```

## 📚 Next Steps

- Read [SETUP.md](docs/SETUP.md) for detailed setup
- Read [API.md](docs/API.md) for API examples
- Read [SECURITY.md](docs/SECURITY.md) for security info

## 🆘 Common Issues

**"relation does not exist"**
→ Run all migrations in order

**"JWT expired"**
→ Sign in again

**Can't connect**
→ Check `.env` file and restart Expo

## 📖 Documentation

- [Full Setup Guide](docs/SETUP.md)
- [API Documentation](docs/API.md)
- [Database Schema](docs/SCHEMA.md)
- [Security Guide](docs/SECURITY.md)

## 🎯 What You Get

- ✅ User authentication
- ✅ Financial tracking (transactions)
- ✅ Task management
- ✅ Schedule/calendar events
- ✅ Row Level Security (RLS)
- ✅ Real-time subscriptions
- ✅ TypeScript types
- ✅ Analytics functions

All on Supabase free tier! 🎉

