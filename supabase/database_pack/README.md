# OLA Supabase Database Pack

This package contains the database setup for **OLA (Open Language Acquisition)**.

## What this includes
- Full Supabase SQL setup script
- Split migration files
- Row Level Security policies
- Core SQL functions for the learning engine
- Notes on deployment order

## Recommended execution order in Supabase
1. Run `migrations/000_master_setup.sql`
   - or run the numbered migration files in order.
2. Verify Auth is enabled in Supabase.
3. Add your content seed afterward (blocks, sentences, translations, audio/image assets).
4. Point the frontend to the RPCs included here for queue building and memory updates.

## Core product assumptions implemented here
- `memory_items` is the learning source of truth
- `progress` is replaced by views / aggregations
- users choose a **source language** and a **target language**
- curriculum is versioned for editorial safety
- speech and memory are tracked separately

## Included SQL functions
- `ola_compute_performance_score`
- `ola_calculate_next_review`
- `ola_upsert_memory_item`
- `ola_build_session_queue`
- `ola_can_unlock_block`

## Notes
- This schema is designed for a **web-first** product.
- `speech_logs.audio_path` is stored as a storage path, not a binary blob.
- Optional bucket creation statements are included and commented.
