# Security Documentation

## Row Level Security (RLS)

All tables in the Orbit database use PostgreSQL Row Level Security (RLS) to ensure users can only access their own data.

## How RLS Works

RLS policies are automatically enforced at the database level. When a user makes a query, PostgreSQL checks:
1. Is the user authenticated? (`auth.uid()` returns their user ID)
2. Does the RLS policy allow this operation?
3. If yes, execute the query; if no, return empty results or error

This means **even if someone gets your API keys**, they cannot access other users' data.

## Policies by Table

### Profiles

| Operation | Policy | Rule |
|-----------|--------|------|
| SELECT | Users can view own profile | `auth.uid() = id` |
| INSERT | Users can insert own profile | `auth.uid() = id` |
| UPDATE | Users can update own profile | `auth.uid() = id` |
| DELETE | Not allowed | - |

**Note:** Profile creation is handled automatically by a trigger when users sign up.

---

### Transactions

| Operation | Policy | Rule |
|-----------|--------|------|
| SELECT | Users can view own transactions | `auth.uid() = user_id` |
| INSERT | Users can insert own transactions | `auth.uid() = user_id` |
| UPDATE | Users can update own transactions | `auth.uid() = user_id` |
| DELETE | Users can delete own transactions | `auth.uid() = user_id` |

**Security guarantee:** Users can only see, create, update, or delete their own financial transactions.

---

### Tasks

| Operation | Policy | Rule |
|-----------|--------|------|
| SELECT | Users can view own tasks | `auth.uid() = user_id` |
| INSERT | Users can insert own tasks | `auth.uid() = user_id` |
| UPDATE | Users can update own tasks | `auth.uid() = user_id` |
| DELETE | Users can delete own tasks | `auth.uid() = user_id` |

**Security guarantee:** Users can only see, create, update, or delete their own tasks.

---

### Schedule Events

| Operation | Policy | Rule |
|-----------|--------|------|
| SELECT | Users can view own schedule events | `auth.uid() = user_id` |
| INSERT | Users can insert own schedule events | `auth.uid() = user_id` |
| UPDATE | Users can update own schedule events | `auth.uid() = user_id` |
| DELETE | Users can delete own schedule events | `auth.uid() = user_id` |

**Security guarantee:** Users can only see, create, update, or delete their own calendar events.

---

## Authentication

### Supabase Auth

The app uses Supabase Authentication, which provides:
- Email/password authentication
- OAuth providers (Google, GitHub, etc.)
- Magic link authentication
- JWT tokens for API access
- Automatic session management

### How It Works

1. User signs up or logs in through the app
2. Supabase Auth creates a session and returns a JWT token
3. The app includes this token in all API requests
4. Supabase validates the token and sets `auth.uid()` to the user's ID
5. RLS policies use `auth.uid()` to filter data

## Best Practices

### In Your App

1. **Never expose service_role key** - Only use the `anon` key in your app
2. **Always use authenticated requests** - Don't make unauthenticated queries
3. **Validate user input** - Even though RLS protects data, validate inputs client-side
4. **Use TypeScript types** - Ensure type safety with the provided database types

### Example: Safe Query

```typescript
// ✅ SAFE - RLS automatically filters to current user's data
const { data, error } = await supabase
  .from('transactions')
  .select('*')
  .order('date', { ascending: false });

// User only sees their own transactions, even without a filter!
```

### Example: Unsafe Pattern (Don't Do This)

```typescript
// ❌ UNSAFE - Never disable RLS or use service_role key in client
// This is only for server-side admin operations
```

## Testing RLS

You can test RLS policies in the Supabase SQL Editor:

```sql
-- Test as a specific user
SET request.jwt.claim.sub = 'user-uuid-here';

-- Try to query data
SELECT * FROM transactions;

-- Should only return that user's transactions
```

## Additional Security Features

### Cascade Deletes

When a user account is deleted:
- Their profile is automatically deleted
- All their transactions are deleted
- All their tasks are deleted
- All their schedule events are deleted

This is handled by `ON DELETE CASCADE` foreign key constraints.

### Automatic Timestamps

All tables track:
- `created_at` - When the record was created
- `updated_at` - When the record was last modified

These are managed by database triggers and cannot be manipulated by users.

## Emergency Procedures

If you suspect a security breach:

1. **Rotate your Supabase keys** in the Supabase Dashboard
2. **Review RLS policies** to ensure they're still correct
3. **Check audit logs** in Supabase Dashboard
4. **Force logout all users** by resetting JWT secret (extreme measure)

## Questions?

For more information, see:
- [Supabase RLS Documentation](https://supabase.com/docs/guides/auth/row-level-security)
- [PostgreSQL RLS Documentation](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)

