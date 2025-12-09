# Database Schema Documentation

## Overview

The Orbit backend uses PostgreSQL (via Supabase) with four main tables to support the app's functionality.

## Tables

### 1. Profiles

Stores user profile information, linked to Supabase Auth.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| `id` | UUID | User ID (from auth.users) | PRIMARY KEY, REFERENCES auth.users |
| `email` | TEXT | User email | UNIQUE, NOT NULL |
| `full_name` | TEXT | User's full name | NULL |
| `avatar_url` | TEXT | Profile picture URL | NULL |
| `created_at` | TIMESTAMPTZ | Creation timestamp | DEFAULT NOW() |
| `updated_at` | TIMESTAMPTZ | Last update timestamp | DEFAULT NOW() |

**Indexes:**
- Primary key on `id`
- Unique index on `email`

**Triggers:**
- Auto-creates profile when user signs up
- Auto-updates `updated_at` on changes

---

### 2. Transactions

Stores financial transactions (income and expenses).

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| `id` | UUID | Transaction ID | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| `user_id` | UUID | Owner of transaction | REFERENCES profiles(id) ON DELETE CASCADE |
| `title` | TEXT | Transaction title | NOT NULL |
| `description` | TEXT | Additional details | NULL |
| `amount` | DECIMAL(10,2) | Transaction amount | NOT NULL, CHECK (amount > 0) |
| `type` | TEXT | Income or expense | CHECK IN ('income', 'expense') |
| `category` | TEXT | Transaction category | CHECK IN (see categories below) |
| `date` | TIMESTAMPTZ | Transaction date | NOT NULL, DEFAULT NOW() |
| `created_at` | TIMESTAMPTZ | Creation timestamp | DEFAULT NOW() |
| `updated_at` | TIMESTAMPTZ | Last update timestamp | DEFAULT NOW() |

**Categories:**
- Food
- Transport
- Bills
- Salary
- Shopping
- Entertainment
- Health
- Other

**Indexes:**
- Primary key on `id`
- Index on `user_id`
- Index on `date` (DESC)
- Index on `type`
- Index on `category`

**Triggers:**
- Auto-updates `updated_at` on changes

---

### 3. Tasks

Stores user tasks with priority levels.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| `id` | UUID | Task ID | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| `user_id` | UUID | Owner of task | REFERENCES profiles(id) ON DELETE CASCADE |
| `title` | TEXT | Task title | NOT NULL |
| `description` | TEXT | Task details | NULL |
| `priority` | TEXT | Task priority | CHECK IN ('low', 'medium', 'high') |
| `completed` | BOOLEAN | Completion status | DEFAULT FALSE |
| `created_at` | TIMESTAMPTZ | Creation timestamp | DEFAULT NOW() |
| `updated_at` | TIMESTAMPTZ | Last update timestamp | DEFAULT NOW() |

**Indexes:**
- Primary key on `id`
- Index on `user_id`
- Index on `completed`
- Index on `priority`

**Triggers:**
- Auto-updates `updated_at` on changes

---

### 4. Schedule Events

Stores calendar events.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| `id` | UUID | Event ID | PRIMARY KEY, DEFAULT uuid_generate_v4() |
| `user_id` | UUID | Owner of event | REFERENCES profiles(id) ON DELETE CASCADE |
| `title` | TEXT | Event title | NOT NULL |
| `description` | TEXT | Event details | NULL |
| `type` | TEXT | Event type | CHECK IN ('activity', 'exam', 'class', 'other') |
| `date` | DATE | Event date | NOT NULL |
| `time` | TIME | Event time | NOT NULL |
| `created_at` | TIMESTAMPTZ | Creation timestamp | DEFAULT NOW() |
| `updated_at` | TIMESTAMPTZ | Last update timestamp | DEFAULT NOW() |

**Indexes:**
- Primary key on `id`
- Index on `user_id`
- Index on `date` (DESC)
- Index on `type`

**Triggers:**
- Auto-updates `updated_at` on changes

---

## Relationships

```
auth.users (Supabase Auth)
    ↓
profiles (1:1)
    ↓
    ├── transactions (1:many)
    ├── tasks (1:many)
    └── schedule_events (1:many)
```

## Data Integrity

- All user data tables use `ON DELETE CASCADE` to automatically clean up when a user is deleted
- All tables have `updated_at` triggers for automatic timestamp management
- Check constraints ensure data validity (e.g., positive amounts, valid categories)
- Indexes optimize common query patterns

## Security

All tables use Row Level Security (RLS). See [SECURITY.md](SECURITY.md) for details.

