# Orbit Backend 🚀

Supabase backend for the Orbit productivity app. This repository contains database schemas, migrations, Row Level Security (RLS) policies, and TypeScript types for the Orbit mobile application.

## Features

- 🔐 **Authentication** - Supabase Auth integration
- 💾 **PostgreSQL Database** - Structured data storage
- 🔒 **Row Level Security** - User-specific data protection
- 📊 **Real-time Subscriptions** - Live data updates
- 🌐 **RESTful API** - Auto-generated from schema
- 📝 **TypeScript Types** - Type-safe database operations

## Database Schema

### Tables

1. **profiles** - User profile information
2. **transactions** - Financial transactions (income/expenses)
3. **tasks** - Task management
4. **schedule_events** - Calendar events

## Quick Start

### Prerequisites

- Supabase account (free tier)
- Supabase CLI (optional, for local development)

### Setup

1. **Create a Supabase Project**
   - Go to [supabase.com](https://supabase.com)
   - Create a new project
   - Note your project URL and anon key

2. **Run Migrations**
   - Go to SQL Editor in Supabase Dashboard
   - Run migrations in order:
     1. `supabase/migrations/001_initial_schema.sql`
     2. `supabase/migrations/002_rls_policies.sql`
     3. `supabase/migrations/003_functions.sql`

3. **Configure Your App**
   - Copy `.env.example` to `.env` in your Orbit app
   - Add your Supabase URL and anon key

### Environment Variables

```env
EXPO_PUBLIC_SUPABASE_URL=your-project-url
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

## Project Structure

```
orbit-backend/
├── supabase/
│   ├── migrations/           # Database migrations
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_rls_policies.sql
│   │   └── 003_functions.sql
│   ├── types/                # TypeScript types
│   │   └── database.types.ts
│   └── seed.sql              # Sample data (optional)
├── docs/
│   ├── API.md                # API documentation
│   ├── SCHEMA.md             # Database schema details
│   └── SECURITY.md           # RLS policies explanation
└── README.md
```

## Database Schema Overview

### Profiles
- User profile data
- Linked to Supabase Auth

### Transactions
- Financial tracking
- Categories: Food, Transport, Bills, Salary, Shopping, Entertainment, Health, Other
- Types: Income, Expense

### Tasks
- Task management
- Priorities: Low, Medium, High
- Status: Completed/Pending

### Schedule Events
- Calendar events
- Types: Activity, Exam, Class, Other
- Date and time tracking

## Security

All tables use Row Level Security (RLS) to ensure users can only access their own data. See [SECURITY.md](docs/SECURITY.md) for details.

## API Usage

See [API.md](docs/API.md) for detailed API documentation and examples.

## Local Development

### Using Supabase CLI

```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Pull remote changes
supabase db pull

# Push local changes
supabase db push
```

## Contributing

This backend is designed to work with the [Orbit mobile app](https://github.com/f4heemmmmm/orbit).

## License

MIT

