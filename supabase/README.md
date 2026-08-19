# Supabase Setup for Sahaara

This folder contains database migrations and Edge Functions for the **Sahaara (ElderGuard)** backend.

## 1. Database Migrations

You can apply the database schema in two ways:

### Option A: Via Supabase Dashboard (Easiest)
1. Go to your [Supabase Dashboard](https://supabase.com).
2. Open **SQL Editor**.
3. Copy and run `migrations/0001_init.sql`.
4. Copy and run `migrations/0002_rls.sql`.

### Option B: Via Supabase CLI
```bash
supabase link --project-ref <your-project-ref>
supabase db push
```

---

## 2. Supabase Edge Functions

Functions included:
- `risk-engine`: Calculates weighted risk scores per senior.
- `escalation-engine`: Monitors open incidents & advances caregivers when timeout expires.
- `checkin-scheduler`: Generates safety check-in prompts.
- `ai-summary`: Calls Gemini API to summarize incident signals into natural language.

### Deploying Functions
```bash
supabase functions deploy risk-engine
supabase functions deploy escalation-engine
supabase functions deploy checkin-scheduler
supabase functions deploy ai-summary
```

### Setting Environment Variables in Supabase
```bash
supabase secrets set GEMINI_API_KEY=your_gemini_key
```
