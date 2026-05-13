# OLA Frontend Live + Production Seed

This package extends the live Supabase starter with a production-structured seed for the uploaded 120-block curriculum.

## What is seeded
- 120 curriculum blocks
- 3 sentence levels per block
- phases mapped to:
  - 1-30 Survival
  - 31-60 Expansion
  - 61-90 Conversation
  - 91-120 Fluency
- language pair loaded: `pt-BR -> en`

## Important note
The source 120-block file provides English target sentences and image/context hints, but it does **not** include a full editorial Portuguese gloss layer. For that reason, this package seeds PT-BR translations as placeholders equal to the target sentence. The schema is ready; editorial localization should replace those placeholder glosses before public launch.

## Run order
1. Run `supabase/database_pack/migrations/000_master_setup.sql`
2. Run `supabase/seeds/010_curriculum_ptbr_en.sql`
3. Start the app and complete onboarding with source `pt-BR` and target `en`

## Included source exports
- `supabase/seeds/curriculum_blocks_en.json`
- `supabase/seeds/curriculum_blocks_en.csv`
- `supabase/seeds/010_curriculum_ptbr_en.sql`
