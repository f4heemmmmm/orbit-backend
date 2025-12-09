-- Orbit App - Row Level Security (RLS) Policies
-- This migration sets up security policies to ensure users can only access their own data

-- =====================================================
-- ENABLE ROW LEVEL SECURITY
-- =====================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedule_events ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- PROFILES POLICIES
-- =====================================================

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON profiles
  FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON profiles
  FOR UPDATE
  USING (auth.uid() = id);

-- Users can insert their own profile (handled by trigger, but allow for manual creation)
CREATE POLICY "Users can insert own profile"
  ON profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- =====================================================
-- TRANSACTIONS POLICIES
-- =====================================================

-- Users can view their own transactions
CREATE POLICY "Users can view own transactions"
  ON transactions
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own transactions
CREATE POLICY "Users can insert own transactions"
  ON transactions
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own transactions
CREATE POLICY "Users can update own transactions"
  ON transactions
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can delete their own transactions
CREATE POLICY "Users can delete own transactions"
  ON transactions
  FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- TASKS POLICIES
-- =====================================================

-- Users can view their own tasks
CREATE POLICY "Users can view own tasks"
  ON tasks
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own tasks
CREATE POLICY "Users can insert own tasks"
  ON tasks
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own tasks
CREATE POLICY "Users can update own tasks"
  ON tasks
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can delete their own tasks
CREATE POLICY "Users can delete own tasks"
  ON tasks
  FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- SCHEDULE_EVENTS POLICIES
-- =====================================================

-- Users can view their own schedule events
CREATE POLICY "Users can view own schedule events"
  ON schedule_events
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own schedule events
CREATE POLICY "Users can insert own schedule events"
  ON schedule_events
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own schedule events
CREATE POLICY "Users can update own schedule events"
  ON schedule_events
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can delete their own schedule events
CREATE POLICY "Users can delete own schedule events"
  ON schedule_events
  FOR DELETE
  USING (auth.uid() = user_id);

