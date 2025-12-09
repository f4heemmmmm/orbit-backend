# Database Schema Diagram

## Entity Relationship Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         auth.users                              │
│                     (Supabase Auth)                             │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ id (UUID, PK)                                            │  │
│  │ email                                                    │  │
│  │ encrypted_password                                       │  │
│  │ ...                                                      │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ 1:1
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                          profiles                               │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ id (UUID, PK, FK → auth.users.id)                       │  │
│  │ email (TEXT, UNIQUE, NOT NULL)                          │  │
│  │ full_name (TEXT)                                        │  │
│  │ avatar_url (TEXT)                                       │  │
│  │ created_at (TIMESTAMPTZ)                                │  │
│  │ updated_at (TIMESTAMPTZ)                                │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────┬────────────────┬────────────────┬──────────────────┘
             │                │                │
             │ 1:N            │ 1:N            │ 1:N
             ▼                ▼                ▼
┌──────────────────┐ ┌──────────────┐ ┌────────────────────┐
│  transactions    │ │    tasks     │ │  schedule_events   │
├──────────────────┤ ├──────────────┤ ├────────────────────┤
│ id (UUID, PK)    │ │ id (UUID, PK)│ │ id (UUID, PK)      │
│ user_id (FK)     │ │ user_id (FK) │ │ user_id (FK)       │
│ title            │ │ title        │ │ title              │
│ description      │ │ description  │ │ description        │
│ amount           │ │ priority     │ │ type               │
│ type             │ │ completed    │ │ date               │
│ category         │ │ created_at   │ │ time               │
│ date             │ │ updated_at   │ │ created_at         │
│ created_at       │ └──────────────┘ │ updated_at         │
│ updated_at       │                  └────────────────────┘
└──────────────────┘
```

## Table Details

### Transactions
**Purpose:** Track income and expenses

**Enums:**
- `type`: 'income' | 'expense'
- `category`: 'Food' | 'Transport' | 'Bills' | 'Salary' | 'Shopping' | 'Entertainment' | 'Health' | 'Other'

**Indexes:**
- `user_id` (for user queries)
- `date DESC` (for chronological listing)
- `type` (for filtering income/expense)
- `category` (for category filtering)

### Tasks
**Purpose:** Manage to-do items

**Enums:**
- `priority`: 'low' | 'medium' | 'high'

**Indexes:**
- `user_id` (for user queries)
- `completed` (for filtering)
- `priority` (for sorting)

### Schedule Events
**Purpose:** Calendar and event management

**Enums:**
- `type`: 'activity' | 'exam' | 'class' | 'other'

**Indexes:**
- `user_id` (for user queries)
- `date DESC` (for chronological listing)
- `type` (for filtering)

## Security Model

```
┌─────────────────────────────────────────────────────────┐
│              Row Level Security (RLS)                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Every table has policies that enforce:                │
│                                                         │
│  ✓ Users can only SELECT their own data                │
│  ✓ Users can only INSERT with their user_id            │
│  ✓ Users can only UPDATE their own data                │
│  ✓ Users can only DELETE their own data                │
│                                                         │
│  Policy check: auth.uid() = user_id                    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Data Flow

```
┌──────────────┐
│  Mobile App  │
└──────┬───────┘
       │
       │ 1. User signs up/in
       ▼
┌──────────────────┐
│  Supabase Auth   │ ← Creates JWT token
└──────┬───────────┘
       │
       │ 2. Auto-creates profile (trigger)
       ▼
┌──────────────────┐
│    profiles      │
└──────────────────┘
       │
       │ 3. User creates data
       ▼
┌─────────────────────────────────────┐
│  transactions / tasks / events      │
│  (RLS enforces user_id = auth.uid())│
└─────────────────────────────────────┘
```

## Cascade Deletes

When a user is deleted from `auth.users`:

```
auth.users (DELETE)
    ↓
profiles (CASCADE DELETE)
    ↓
    ├── transactions (CASCADE DELETE)
    ├── tasks (CASCADE DELETE)
    └── schedule_events (CASCADE DELETE)
```

All user data is automatically cleaned up.

## Triggers

### Auto-update timestamps
All tables have triggers that automatically update `updated_at` when a row is modified.

### Auto-create profile
When a user signs up, a trigger automatically creates their profile entry.

## Functions

### Financial Analytics
- `get_user_balance(user_uuid)` - Calculate total balance
- `get_spending_by_category(user_uuid)` - Spending breakdown
- `get_income_by_category(user_uuid)` - Income breakdown

### Task Analytics
- `get_task_stats(user_uuid)` - Task statistics

### Schedule Analytics
- `get_upcoming_events(user_uuid, days_ahead)` - Upcoming events
- `get_event_stats(user_uuid)` - Event type breakdown

