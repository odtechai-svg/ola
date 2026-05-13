# OLA Live Starter Docs

## Routes

- `/` marketing landing
- `/auth/login` magic-link authentication
- `/auth/callback` Supabase auth callback
- `/onboarding` source/target language selection
- `/home` Today dashboard from live data
- `/blocks` block map from live enrollment
- `/session/live` real session creation and queue loading
- `/progress` memory snapshot from live `memory_items`
- `/settings` current language pair and profile

## Database

The full Supabase setup lives inside `supabase/database_pack`.
Use `migrations/000_master_setup.sql` as the single run-all setup script.
