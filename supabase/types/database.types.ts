/**
 * Orbit App - Database Types
 * TypeScript types generated from Supabase schema
 * These types match the database schema exactly
 */

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          email: string
          full_name: string | null
          avatar_url: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          email: string
          full_name?: string | null
          avatar_url?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          full_name?: string | null
          avatar_url?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      transactions: {
        Row: {
          id: string
          user_id: string
          title: string
          description: string | null
          amount: number
          type: 'income' | 'expense'
          category: 'Food' | 'Transport' | 'Bills' | 'Salary' | 'Shopping' | 'Entertainment' | 'Health' | 'Other'
          date: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          title: string
          description?: string | null
          amount: number
          type: 'income' | 'expense'
          category: 'Food' | 'Transport' | 'Bills' | 'Salary' | 'Shopping' | 'Entertainment' | 'Health' | 'Other'
          date?: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          title?: string
          description?: string | null
          amount?: number
          type?: 'income' | 'expense'
          category?: 'Food' | 'Transport' | 'Bills' | 'Salary' | 'Shopping' | 'Entertainment' | 'Health' | 'Other'
          date?: string
          created_at?: string
          updated_at?: string
        }
      }
      tasks: {
        Row: {
          id: string
          user_id: string
          title: string
          description: string | null
          priority: 'low' | 'medium' | 'high'
          completed: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          title: string
          description?: string | null
          priority: 'low' | 'medium' | 'high'
          completed?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          title?: string
          description?: string | null
          priority?: 'low' | 'medium' | 'high'
          completed?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      schedule_events: {
        Row: {
          id: string
          user_id: string
          title: string
          description: string | null
          type: 'activity' | 'exam' | 'class' | 'other'
          date: string
          time: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          title: string
          description?: string | null
          type: 'activity' | 'exam' | 'class' | 'other'
          date: string
          time: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          title?: string
          description?: string | null
          type?: 'activity' | 'exam' | 'class' | 'other'
          date?: string
          time?: string
          created_at?: string
          updated_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      get_user_balance: {
        Args: { user_uuid: string }
        Returns: number
      }
      get_spending_by_category: {
        Args: { user_uuid: string }
        Returns: { category: string; total: number }[]
      }
      get_income_by_category: {
        Args: { user_uuid: string }
        Returns: { category: string; total: number }[]
      }
      get_task_stats: {
        Args: { user_uuid: string }
        Returns: {
          total_tasks: number
          completed_tasks: number
          pending_tasks: number
          high_priority: number
          medium_priority: number
          low_priority: number
        }[]
      }
      get_upcoming_events: {
        Args: { user_uuid: string; days_ahead?: number }
        Returns: Database['public']['Tables']['schedule_events']['Row'][]
      }
      get_event_stats: {
        Args: { user_uuid: string }
        Returns: { event_type: string; count: number }[]
      }
    }
    Enums: {
      [_ in never]: never
    }
  }
}

