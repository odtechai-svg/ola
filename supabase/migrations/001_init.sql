create table if not exists public.languages (
  code text primary key,
  name text not null,
  native_name text not null
);

create table if not exists public.user_profiles (
  user_id uuid primary key,
  source_language text not null references public.languages(code),
  target_language text not null references public.languages(code),
  current_block_order integer not null default 1,
  streak_days integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.blocks (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  phase text not null,
  block_order integer not null unique
);

create table if not exists public.sentences (
  id uuid primary key default gen_random_uuid(),
  block_id uuid not null references public.blocks(id) on delete cascade,
  level integer not null,
  target_language text not null references public.languages(code),
  text text not null,
  source_gloss text not null,
  version integer not null default 1,
  status text not null default 'published'
);

create table if not exists public.memory_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  sentence_id uuid not null references public.sentences(id) on delete cascade,
  strength numeric not null default 20,
  fluency_score numeric not null default 20,
  stability numeric not null default 0.2,
  ease_factor numeric not null default 2.5,
  review_stage integer not null default 0,
  success_streak integer not null default 0,
  failure_count integer not null default 0,
  next_review_at timestamptz not null default now() + interval '20 minutes',
  created_at timestamptz not null default now(),
  unique (user_id, sentence_id)
);
