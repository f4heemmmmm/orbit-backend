-- Orbit App - Sample Data (Optional)
-- This file contains sample data for testing
-- DO NOT run this in production!

-- Note: You need to replace 'YOUR_USER_ID' with an actual user ID from auth.users
-- You can get this after creating a test account

-- Sample transactions
INSERT INTO transactions (user_id, title, description, amount, type, category, date) VALUES
  ('YOUR_USER_ID', 'Monthly Salary', 'January salary', 5000.00, 'income', 'Salary', NOW() - INTERVAL '1 day'),
  ('YOUR_USER_ID', 'Grocery Shopping', 'Weekly groceries at Whole Foods', 125.50, 'expense', 'Food', NOW() - INTERVAL '2 days'),
  ('YOUR_USER_ID', 'Gas Station', 'Fuel for car', 45.00, 'expense', 'Transport', NOW() - INTERVAL '3 days'),
  ('YOUR_USER_ID', 'Electric Bill', 'Monthly electricity', 89.99, 'expense', 'Bills', NOW() - INTERVAL '5 days'),
  ('YOUR_USER_ID', 'Coffee Shop', 'Morning coffee', 5.50, 'expense', 'Food', NOW() - INTERVAL '1 day'),
  ('YOUR_USER_ID', 'Movie Tickets', 'Weekend movie', 25.00, 'expense', 'Entertainment', NOW() - INTERVAL '6 days'),
  ('YOUR_USER_ID', 'Gym Membership', 'Monthly gym fee', 50.00, 'expense', 'Health', NOW() - INTERVAL '7 days'),
  ('YOUR_USER_ID', 'Online Shopping', 'New headphones', 79.99, 'expense', 'Shopping', NOW() - INTERVAL '4 days'),
  ('YOUR_USER_ID', 'Freelance Work', 'Website design project', 800.00, 'income', 'Salary', NOW() - INTERVAL '10 days'),
  ('YOUR_USER_ID', 'Restaurant', 'Dinner with friends', 65.00, 'expense', 'Food', NOW() - INTERVAL '2 days');

-- Sample tasks
INSERT INTO tasks (user_id, title, description, priority, completed) VALUES
  ('YOUR_USER_ID', 'Complete Orbit App', 'Finish building the productivity app', 'high', false),
  ('YOUR_USER_ID', 'Buy groceries', 'Get milk, eggs, bread', 'medium', false),
  ('YOUR_USER_ID', 'Call dentist', 'Schedule annual checkup', 'low', false),
  ('YOUR_USER_ID', 'Review pull requests', 'Check team code reviews', 'high', true),
  ('YOUR_USER_ID', 'Plan weekend trip', 'Research destinations', 'low', false),
  ('YOUR_USER_ID', 'Update resume', 'Add recent projects', 'medium', false),
  ('YOUR_USER_ID', 'Read documentation', 'Supabase RLS policies', 'high', true),
  ('YOUR_USER_ID', 'Exercise', '30 minutes cardio', 'medium', true);

-- Sample schedule events
INSERT INTO schedule_events (user_id, title, description, type, date, time) VALUES
  ('YOUR_USER_ID', 'Team Meeting', 'Weekly standup', 'other', CURRENT_DATE + INTERVAL '1 day', '10:00:00'),
  ('YOUR_USER_ID', 'Math Exam', 'Final exam for Calculus II', 'exam', CURRENT_DATE + INTERVAL '5 days', '14:00:00'),
  ('YOUR_USER_ID', 'React Native Class', 'Advanced mobile development', 'class', CURRENT_DATE + INTERVAL '2 days', '09:00:00'),
  ('YOUR_USER_ID', 'Gym Session', 'Leg day workout', 'activity', CURRENT_DATE + INTERVAL '1 day', '18:00:00'),
  ('YOUR_USER_ID', 'Physics Class', 'Quantum mechanics lecture', 'class', CURRENT_DATE + INTERVAL '3 days', '11:00:00'),
  ('YOUR_USER_ID', 'Yoga', 'Morning yoga session', 'activity', CURRENT_DATE + INTERVAL '2 days', '07:00:00'),
  ('YOUR_USER_ID', 'Chemistry Exam', 'Midterm examination', 'exam', CURRENT_DATE + INTERVAL '7 days', '13:00:00'),
  ('YOUR_USER_ID', 'Coffee with Sarah', 'Catch up meeting', 'other', CURRENT_DATE + INTERVAL '4 days', '15:30:00');

-- Verify data was inserted
SELECT 'Transactions inserted: ' || COUNT(*) FROM transactions WHERE user_id = 'YOUR_USER_ID';
SELECT 'Tasks inserted: ' || COUNT(*) FROM tasks WHERE user_id = 'YOUR_USER_ID';
SELECT 'Events inserted: ' || COUNT(*) FROM schedule_events WHERE user_id = 'YOUR_USER_ID';

