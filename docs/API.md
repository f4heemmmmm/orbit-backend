# API Documentation

## Overview

The Orbit backend uses Supabase's auto-generated REST API and JavaScript client. All operations are type-safe and protected by Row Level Security.

## Setup

### Install Supabase Client

```bash
npm install @supabase/supabase-js
```

### Initialize Client

```typescript
import { createClient } from '@supabase/supabase-js';
import { Database } from './types/database.types';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey);
```

## Authentication

### Sign Up

```typescript
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'secure-password',
  options: {
    data: {
      full_name: 'John Doe',
    },
  },
});
```

### Sign In

```typescript
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'secure-password',
});
```

### Sign Out

```typescript
const { error } = await supabase.auth.signOut();
```

### Get Current User

```typescript
const { data: { user } } = await supabase.auth.getUser();
```

## Transactions API

### Get All Transactions

```typescript
const { data, error } = await supabase
  .from('transactions')
  .select('*')
  .order('date', { ascending: false });
```

### Get Transactions by Type

```typescript
// Get only expenses
const { data, error } = await supabase
  .from('transactions')
  .select('*')
  .eq('type', 'expense')
  .order('date', { ascending: false });
```

### Get Transactions by Category

```typescript
const { data, error } = await supabase
  .from('transactions')
  .select('*')
  .eq('category', 'Food')
  .order('date', { ascending: false });
```

### Create Transaction

```typescript
const { data, error } = await supabase
  .from('transactions')
  .insert({
    user_id: user.id,
    title: 'Grocery Shopping',
    description: 'Weekly groceries',
    amount: 125.50,
    type: 'expense',
    category: 'Food',
    date: new Date().toISOString(),
  })
  .select()
  .single();
```

### Update Transaction

```typescript
const { data, error } = await supabase
  .from('transactions')
  .update({
    title: 'Updated Title',
    amount: 150.00,
  })
  .eq('id', transactionId)
  .select()
  .single();
```

### Delete Transaction

```typescript
const { error } = await supabase
  .from('transactions')
  .delete()
  .eq('id', transactionId);
```

### Get User Balance

```typescript
const { data, error } = await supabase
  .rpc('get_user_balance', { user_uuid: user.id });

// Returns: number (total income - total expenses)
```

### Get Spending by Category

```typescript
const { data, error } = await supabase
  .rpc('get_spending_by_category', { user_uuid: user.id });

// Returns: [{ category: string, total: number }, ...]
```

## Tasks API

### Get All Tasks

```typescript
const { data, error } = await supabase
  .from('tasks')
  .select('*')
  .order('created_at', { ascending: false });
```

### Get Tasks by Status

```typescript
// Get pending tasks
const { data, error } = await supabase
  .from('tasks')
  .select('*')
  .eq('completed', false);

// Get completed tasks
const { data, error } = await supabase
  .from('tasks')
  .select('*')
  .eq('completed', true);
```

### Get Tasks by Priority

```typescript
const { data, error } = await supabase
  .from('tasks')
  .select('*')
  .eq('priority', 'high')
  .order('created_at', { ascending: false });
```

### Create Task

```typescript
const { data, error } = await supabase
  .from('tasks')
  .insert({
    user_id: user.id,
    title: 'Complete project',
    description: 'Finish the Orbit app',
    priority: 'high',
    completed: false,
  })
  .select()
  .single();
```

### Update Task

```typescript
const { data, error } = await supabase
  .from('tasks')
  .update({ completed: true })
  .eq('id', taskId)
  .select()
  .single();
```

### Delete Task

```typescript
const { error } = await supabase
  .from('tasks')
  .delete()
  .eq('id', taskId);
```

### Get Task Statistics

```typescript
const { data, error } = await supabase
  .rpc('get_task_stats', { user_uuid: user.id });

// Returns: {
//   total_tasks: number,
//   completed_tasks: number,
//   pending_tasks: number,
//   high_priority: number,
//   medium_priority: number,
//   low_priority: number
// }
```

## Schedule Events API

### Get All Events

```typescript
const { data, error } = await supabase
  .from('schedule_events')
  .select('*')
  .order('date', { ascending: true })
  .order('time', { ascending: true });
```

### Get Events by Type

```typescript
const { data, error } = await supabase
  .from('schedule_events')
  .select('*')
  .eq('type', 'exam')
  .order('date', { ascending: true });
```

### Get Events by Date Range

```typescript
const { data, error } = await supabase
  .from('schedule_events')
  .select('*')
  .gte('date', '2024-01-01')
  .lte('date', '2024-12-31')
  .order('date', { ascending: true });
```

### Create Event

```typescript
const { data, error } = await supabase
  .from('schedule_events')
  .insert({
    user_id: user.id,
    title: 'Math Exam',
    description: 'Final exam for Calculus',
    type: 'exam',
    date: '2024-06-15',
    time: '09:00:00',
  })
  .select()
  .single();
```

### Update Event

```typescript
const { data, error } = await supabase
  .from('schedule_events')
  .update({
    title: 'Updated Event',
    date: '2024-06-16',
  })
  .eq('id', eventId)
  .select()
  .single();
```

### Delete Event

```typescript
const { error } = await supabase
  .from('schedule_events')
  .delete()
  .eq('id', eventId);
```

### Get Upcoming Events

```typescript
const { data, error } = await supabase
  .rpc('get_upcoming_events', {
    user_uuid: user.id,
    days_ahead: 7 // Optional, defaults to 7
  });

// Returns events for the next 7 days
```

### Get Event Statistics

```typescript
const { data, error } = await supabase
  .rpc('get_event_stats', { user_uuid: user.id });

// Returns: [{ event_type: string, count: number }, ...]
```

## Real-time Subscriptions

### Subscribe to Transactions

```typescript
const channel = supabase
  .channel('transactions-changes')
  .on(
    'postgres_changes',
    {
      event: '*', // 'INSERT', 'UPDATE', 'DELETE', or '*' for all
      schema: 'public',
      table: 'transactions',
      filter: `user_id=eq.${user.id}`,
    },
    (payload) => {
      console.log('Transaction changed:', payload);
      // Update your UI here
    }
  )
  .subscribe();

// Unsubscribe when done
channel.unsubscribe();
```

### Subscribe to Tasks

```typescript
const channel = supabase
  .channel('tasks-changes')
  .on(
    'postgres_changes',
    {
      event: '*',
      schema: 'public',
      table: 'tasks',
      filter: `user_id=eq.${user.id}`,
    },
    (payload) => {
      console.log('Task changed:', payload);
    }
  )
  .subscribe();
```

### Subscribe to Schedule Events

```typescript
const channel = supabase
  .channel('events-changes')
  .on(
    'postgres_changes',
    {
      event: '*',
      schema: 'public',
      table: 'schedule_events',
      filter: `user_id=eq.${user.id}`,
    },
    (payload) => {
      console.log('Event changed:', payload);
    }
  )
  .subscribe();
```

## Error Handling

```typescript
const { data, error } = await supabase
  .from('transactions')
  .select('*');

if (error) {
  console.error('Error:', error.message);
  // Handle error appropriately
} else {
  console.log('Data:', data);
}
```

## Pagination

```typescript
// Get 10 transactions, skip first 20
const { data, error } = await supabase
  .from('transactions')
  .select('*')
  .order('date', { ascending: false })
  .range(20, 29); // 0-indexed, inclusive
```

## Filtering

```typescript
// Complex filtering
const { data, error } = await supabase
  .from('transactions')
  .select('*')
  .eq('type', 'expense')
  .gte('amount', 100)
  .lte('amount', 500)
  .in('category', ['Food', 'Shopping'])
  .order('date', { ascending: false });
```

## Best Practices

1. **Always handle errors** - Check the `error` object
2. **Use TypeScript types** - Import from `database.types.ts`
3. **Optimize queries** - Only select fields you need
4. **Use real-time sparingly** - Only subscribe when needed
5. **Unsubscribe from channels** - Prevent memory leaks
6. **Batch operations** - Use `insert([...])` for multiple records

## Rate Limits

Supabase free tier limits:
- 500 MB database size
- 2 GB bandwidth per month
- 50,000 monthly active users
- Unlimited API requests

For production, consider upgrading to Pro tier.

