# Setup notes

## Supabase features used
- PostgreSQL
- Auth (`auth.users`)
- Row Level Security
- RPC functions
- Storage (optional, for audio/image assets)

## Why this schema
The original framework defines:
- blocks and sentences as the core curriculum model
- review scheduling based on forgetting-curve intervals
- active speech as part of the lesson loop
- `memory_items` as the evolved memory model
- session priority order: due review, fluency work, then new content

The expanded 120-block curriculum adds:
- four-phase progression
- a larger launch curriculum
- a path to multilingual expansion

This database combines both into a production-oriented relational model.

## Main design choices
- `languages` and `language_pairs` support source-language-first onboarding
- `blocks` + `block_versions` and `sentences` + `sentence_versions` provide versioning
- `sentence_translations` allows the same target sentence to be explained from multiple source languages
- `memory_items` stores memory + speech state
- `sessions` and `session_events` support observability and analytics
- `user_block_progress` is a view, not a source-of-truth table

## Seed strategy
Keep the schema separate from the content seed.
- First apply this package
- Then load curriculum seeds for 120 blocks
- Then load TTS / image assets
