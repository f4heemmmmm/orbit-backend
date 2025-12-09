-- Orbit App - Database Functions
-- Useful functions for analytics and data aggregation

-- =====================================================
-- FINANCIAL ANALYTICS FUNCTIONS
-- =====================================================

-- Get total balance (income - expenses)
CREATE OR REPLACE FUNCTION get_user_balance(user_uuid UUID)
RETURNS DECIMAL AS $$
DECLARE
  total_income DECIMAL;
  total_expenses DECIMAL;
BEGIN
  SELECT COALESCE(SUM(amount), 0) INTO total_income
  FROM transactions
  WHERE user_id = user_uuid AND type = 'income';
  
  SELECT COALESCE(SUM(amount), 0) INTO total_expenses
  FROM transactions
  WHERE user_id = user_uuid AND type = 'expense';
  
  RETURN total_income - total_expenses;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get spending by category
CREATE OR REPLACE FUNCTION get_spending_by_category(user_uuid UUID)
RETURNS TABLE(category TEXT, total DECIMAL) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.category,
    SUM(t.amount) as total
  FROM transactions t
  WHERE t.user_id = user_uuid AND t.type = 'expense'
  GROUP BY t.category
  ORDER BY total DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get income by category
CREATE OR REPLACE FUNCTION get_income_by_category(user_uuid UUID)
RETURNS TABLE(category TEXT, total DECIMAL) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.category,
    SUM(t.amount) as total
  FROM transactions t
  WHERE t.user_id = user_uuid AND t.type = 'income'
  GROUP BY t.category
  ORDER BY total DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get transactions for a date range
CREATE OR REPLACE FUNCTION get_transactions_by_date_range(
  user_uuid UUID,
  start_date TIMESTAMPTZ,
  end_date TIMESTAMPTZ
)
RETURNS TABLE(
  id UUID,
  title TEXT,
  description TEXT,
  amount DECIMAL,
  type TEXT,
  category TEXT,
  date TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.id,
    t.title,
    t.description,
    t.amount,
    t.type,
    t.category,
    t.date
  FROM transactions t
  WHERE t.user_id = user_uuid 
    AND t.date >= start_date 
    AND t.date <= end_date
  ORDER BY t.date DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- TASK ANALYTICS FUNCTIONS
-- =====================================================

-- Get task statistics
CREATE OR REPLACE FUNCTION get_task_stats(user_uuid UUID)
RETURNS TABLE(
  total_tasks BIGINT,
  completed_tasks BIGINT,
  pending_tasks BIGINT,
  high_priority BIGINT,
  medium_priority BIGINT,
  low_priority BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(*) as total_tasks,
    COUNT(*) FILTER (WHERE completed = true) as completed_tasks,
    COUNT(*) FILTER (WHERE completed = false) as pending_tasks,
    COUNT(*) FILTER (WHERE priority = 'high') as high_priority,
    COUNT(*) FILTER (WHERE priority = 'medium') as medium_priority,
    COUNT(*) FILTER (WHERE priority = 'low') as low_priority
  FROM tasks
  WHERE user_id = user_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- SCHEDULE ANALYTICS FUNCTIONS
-- =====================================================

-- Get upcoming events
CREATE OR REPLACE FUNCTION get_upcoming_events(
  user_uuid UUID,
  days_ahead INTEGER DEFAULT 7
)
RETURNS TABLE(
  id UUID,
  title TEXT,
  description TEXT,
  type TEXT,
  date DATE,
  "time" TIME
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.id,
    e.title,
    e.description,
    e.type,
    e.date,
    e.time
  FROM schedule_events e
  WHERE e.user_id = user_uuid
    AND e.date >= CURRENT_DATE
    AND e.date <= CURRENT_DATE + days_ahead
  ORDER BY e.date ASC, e.time ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get event statistics by type
CREATE OR REPLACE FUNCTION get_event_stats(user_uuid UUID)
RETURNS TABLE(event_type TEXT, count BIGINT) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    e.type as event_type,
    COUNT(*) as count
  FROM schedule_events e
  WHERE e.user_id = user_uuid
  GROUP BY e.type
  ORDER BY count DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

