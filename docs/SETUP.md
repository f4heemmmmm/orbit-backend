# Setup Guide

Complete guide to setting up the Orbit backend with Supabase.

## Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Click "Start your project"
3. Sign in with GitHub (recommended) or email
4. Click "New Project"
5. Fill in:
   - **Name**: orbit-backend
   - **Database Password**: Generate a strong password (save it!)
   - **Region**: Choose closest to your users
   - **Pricing Plan**: Free (perfect for development)
6. Click "Create new project"
7. Wait 2-3 minutes for setup to complete

## Step 2: Run Database Migrations

### Option A: Using Supabase Dashboard (Recommended for beginners)

1. In your Supabase project, go to **SQL Editor** (left sidebar)
2. Click "New query"
3. Copy the contents of `supabase/migrations/001_initial_schema.sql`
4. Paste into the SQL editor
5. Click "Run" (or press Cmd/Ctrl + Enter)
6. Verify success (should see "Success. No rows returned")
7. Repeat for `002_rls_policies.sql`
8. Repeat for `003_functions.sql`

### Option B: Using Supabase CLI (Advanced)

```bash
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Push migrations
supabase db push
```

## Step 3: Verify Database Setup

1. Go to **Table Editor** in Supabase Dashboard
2. You should see 4 tables:
   - `profiles`
   - `transactions`
   - `tasks`
   - `schedule_events`
3. Click on each table to verify structure

## Step 4: Configure Authentication

1. Go to **Authentication** → **Providers** in Supabase Dashboard
2. Enable **Email** provider (enabled by default)
3. Optional: Enable other providers (Google, GitHub, etc.)
4. Go to **Authentication** → **URL Configuration**
5. Add your app's redirect URLs (for production later)

## Step 5: Get API Credentials

1. Go to **Settings** → **API** in Supabase Dashboard
2. Copy these values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon public** key (safe to use in your app)
3. **NEVER use the service_role key in your app!**

## Step 6: Configure Your Orbit App

1. In your Orbit app directory, create `.env` file:

```bash
cd /path/to/orbit
cp ../orbit-backend/.env.example .env
```

2. Edit `.env` and add your credentials:

```env
EXPO_PUBLIC_SUPABASE_URL=https://your-project-ref.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```

3. Install Supabase client:

```bash
npm install @supabase/supabase-js
```

4. Create Supabase client file `src/lib/supabase.ts`:

```typescript
import 'react-native-url-polyfill/auto';
import { createClient } from '@supabase/supabase-js';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Database } from '../../orbit-backend/supabase/types/database.types';

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

5. Install required dependencies:

```bash
npm install @react-native-async-storage/async-storage react-native-url-polyfill
```

## Step 7: Test the Connection

Create a test file `src/test-supabase.ts`:

```typescript
import { supabase } from './lib/supabase';

async function testConnection() {
  // Test 1: Check connection
  const { data, error } = await supabase.from('profiles').select('count');
  
  if (error) {
    console.error('❌ Connection failed:', error.message);
  } else {
    console.log('✅ Connected to Supabase!');
  }

  // Test 2: Sign up a test user
  const { data: authData, error: authError } = await supabase.auth.signUp({
    email: 'test@example.com',
    password: 'test123456',
    options: {
      data: {
        full_name: 'Test User',
      },
    },
  });

  if (authError) {
    console.error('❌ Auth failed:', authError.message);
  } else {
    console.log('✅ User created!', authData.user?.email);
  }
}

testConnection();
```

## Step 8: Optional - Add Sample Data

1. Go to **SQL Editor** in Supabase Dashboard
2. Create a test account first (through your app or SQL)
3. Get the user ID from **Authentication** → **Users**
4. Open `supabase/seed.sql`
5. Replace `YOUR_USER_ID` with your actual user ID
6. Run the SQL in the SQL Editor

## Troubleshooting

### "relation does not exist" error
- Make sure you ran all migrations in order
- Check **Table Editor** to verify tables exist

### "JWT expired" error
- Your session expired, sign in again
- Check that `autoRefreshToken: true` is set

### "Row Level Security" error
- Make sure you ran `002_rls_policies.sql`
- Verify you're authenticated before making queries

### Can't connect from app
- Check your `.env` file has correct values
- Make sure you're using `EXPO_PUBLIC_` prefix
- Restart your Expo dev server after changing `.env`

## Next Steps

1. Read [API.md](API.md) for API usage examples
2. Read [SECURITY.md](SECURITY.md) to understand RLS
3. Start building your app features!

## Production Checklist

Before deploying to production:

- [ ] Change database password
- [ ] Enable email confirmations
- [ ] Set up custom SMTP (optional)
- [ ] Configure redirect URLs
- [ ] Set up database backups
- [ ] Monitor usage in Supabase Dashboard
- [ ] Consider upgrading to Pro tier if needed

## Support

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Discord](https://discord.supabase.com)
- [GitHub Issues](https://github.com/f4heemmmmm/orbit-backend/issues)

