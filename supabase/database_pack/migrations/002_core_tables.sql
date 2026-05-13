-- core tables
-- ------------------------------------------------------------
-- profile / enrollment
-- ------------------------------------------------------------
create table if not exists public.user_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  source_language_code text,
  target_language_code text,
  timezone text default 'UTC',
  onboarding_completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists trg_user_profiles_updated_at on public.user_profiles;
create trigger trg_user_profiles_updated_at
before update on public.user_profiles
for each row execute function ola.set_updated_at();

create table if not exists public.languages (
  code text primary key,
  english_name text not null,
  native_name text not null,
  locale text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.language_pairs (
  id uuid primary key default gen_random_uuid(),
  source_language_code text not null references public.languages(code),
  target_language_code text not null references public.languages(code),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (source_language_code, target_language_code),
  check (source_language_code <> target_language_code)
);

create table if not exists public.user_enrollments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  language_pair_id uuid not null references public.language_pairs(id) on delete restrict,
  current_block_order int not null default 1,
  current_block_id uuid,
  is_active boolean not null default true,
  started_at timestamptz not null default now(),
  last_session_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, language_pair_id)
);

drop trigger if exists trg_user_enrollments_updated_at on public.user_enrollments;
create trigger trg_user_enrollments_updated_at
before update on public.user_enrollments
for each row execute function ola.set_updated_at();

-- ------------------------------------------------------------
-- curriculum model
-- ------------------------------------------------------------
create table if not exists public.blocks (
  id uuid primary key default gen_random_uuid(),
  language_pair_id uuid not null references public.language_pairs(id) on delete cascade,
  slug text not null,
  phase ola.block_phase not null,
  block_order int not null,
  canonical_title text not null,
  canonical_theme text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (language_pair_id, block_order),
  unique (language_pair_id, slug)
);

drop trigger if exists trg_blocks_updated_at on public.blocks;
create trigger trg_blocks_updated_at
before update on public.blocks
for each row execute function ola.set_updated_at();

create table if not exists public.block_versions (
  id uuid primary key default gen_random_uuid(),
  block_id uuid not null references public.blocks(id) on delete cascade,
  version_no int not null,
  title text not null,
  theme text,
  objective text,
  editorial_notes text,
  is_published boolean not null default false,
  published_at timestamptz,
  created_at timestamptz not null default now(),
  unique (block_id, version_no)
);

create unique index if not exists ux_block_versions_published
  on public.block_versions(block_id)
  where is_published;

create table if not exists public.sentences (
  id uuid primary key default gen_random_uuid(),
  block_id uuid not null references public.blocks(id) on delete cascade,
  level int not null check (level between 1 and 3),
  sentence_order int not null default 1,
  kind text not null default 'core',
  created_at timestamptz not null default now(),
  unique (block_id, level, sentence_order)
);

create table if not exists public.sentence_versions (
  id uuid primary key default gen_random_uuid(),
  sentence_id uuid not null references public.sentences(id) on delete cascade,
  version_no int not null,
  target_language_code text not null references public.languages(code),
  text_value text not null,
  transliteration text,
  audio_path text,
  image_path text,
  difficulty numeric(5,2) not null default 1.0,
  editorial_notes text,
  is_published boolean not null default false,
  published_at timestamptz,
  created_at timestamptz not null default now(),
  unique (sentence_id, version_no)
);

create unique index if not exists ux_sentence_versions_published
  on public.sentence_versions(sentence_id)
  where is_published;

create table if not exists public.sentence_translations (
  id uuid primary key default gen_random_uuid(),
  sentence_version_id uuid not null references public.sentence_versions(id) on delete cascade,
  source_language_code text not null references public.languages(code),
  translated_text text not null,
  support_notes text,
  created_at timestamptz not null default now(),
  unique (sentence_version_id, source_language_code)
);

-- ------------------------------------------------------------
-- learning state
-- ------------------------------------------------------------
create table if not exists public.memory_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  sentence_id uuid not null references public.sentences(id) on delete cascade,
  language_pair_id uuid not null references public.language_pairs(id) on delete restrict,
  strength numeric(5,2) not null default 20 check (strength between 0 and 100),
  fluency_score numeric(5,2) not null default 0 check (fluency_score between 0 and 100),
  stability numeric(10,4) not null default 1 check (stability > 0),
  ease_factor numeric(6,3) not null default 2.5 check (ease_factor >= 1.3),
  review_stage int not null default 0 check (review_stage between 0 and 5),
  success_streak int not null default 0,
  failure_count int not null default 0,
  times_seen int not null default 0,
  last_review_at timestamptz,
  next_review_at timestamptz,
  mastered_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, sentence_id)
);

drop trigger if exists trg_memory_items_updated_at on public.memory_items;
create trigger trg_memory_items_updated_at
before update on public.memory_items
for each row execute function ola.set_updated_at();

create table if not exists public.speech_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  sentence_id uuid not null references public.sentences(id) on delete cascade,
  memory_item_id uuid references public.memory_items(id) on delete set null,
  provider text not null default 'webspeech',
  transcript text,
  normalized_transcript text,
  speech_score numeric(5,4),
  whisper_score numeric(5,4),
  final_speech_score numeric(5,4),
  latency_ms int,
  audio_path text,
  raw_payload jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  language_pair_id uuid not null references public.language_pairs(id) on delete restrict,
  session_kind ola.session_kind not null default 'lesson',
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  duration_seconds int,
  total_items int not null default 0,
  review_items int not null default 0,
  speech_items int not null default 0,
  new_items int not null default 0,
  avg_performance_score numeric(5,4),
  created_at timestamptz not null default now()
);

create table if not exists public.session_events (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.sessions(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  sentence_id uuid references public.sentences(id) on delete set null,
  memory_item_id uuid references public.memory_items(id) on delete set null,
  queue_item_kind ola.queue_item_kind,
  exercise_kind ola.exercise_kind,
  actor ola.event_actor not null default 'system',
  prompt_text text,
  expected_text text,
  user_text text,
  recall_score numeric(5,4),
  speech_score numeric(5,4),
  speed_score numeric(5,4),
  final_score numeric(5,4),
  metadata jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.analytics_events (
  id bigserial primary key,
  user_id uuid references auth.users(id) on delete set null,
  session_id uuid references public.sessions(id) on delete set null,
  event_name text not null,
  event_properties jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

