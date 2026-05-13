# OLA Web Live Starter

This package upgrades the original OLA frontend starter into a **live Supabase-connected web app starter**.

## What is wired now

- Supabase magic-link auth
- auto-created user profile through the database trigger
- onboarding writes source language and target language
- active enrollment is stored in `user_enrollments`
- Today page reads real profile and active language pair
- live session route creates a `sessions` row
- queue loading uses the `ola_build_session_queue` RPC
- evaluation writes to:
  - `memory_items` through `ola_upsert_memory_item`
  - `speech_logs`
  - `session_events`
  - `analytics_events`

## Setup

1. Create a Supabase project.
2. In Supabase SQL Editor, run:
   - `supabase/database_pack/migrations/000_master_setup.sql`
3. Add a `.env.local` file using `.env.example`.
4. Install dependencies.
5. Run the Next.js app.

```bash
npm install
npm run dev
```

## Notes

- This is still a starter, not the full production build.
- The session page currently uses transcript text input to simulate speech capture while preserving the live scoring and persistence loop.
- The existing engine scripts are preserved in `lib/engines` and are now part of the live request flow.
