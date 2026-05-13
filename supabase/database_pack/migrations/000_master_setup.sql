-- OLA - Supabase master database setup
-- Safe to run in Supabase SQL Editor on a fresh project.

begin;

create extension if not exists pgcrypto;
create extension if not exists pg_trgm;
create extension if not exists btree_gist;

-- ------------------------------------------------------------
-- helper schema
-- ------------------------------------------------------------
create schema if not exists ola;

-- ------------------------------------------------------------
-- enums
-- ------------------------------------------------------------
do $$ begin
  create type ola.block_phase as enum ('survival', 'expansion', 'conversation', 'fluency');
exception when duplicate_object then null; end $$;

do $$ begin
  create type ola.session_kind as enum ('lesson', 'review', 'micro_review', 'quick_train', 'placement');
exception when duplicate_object then null; end $$;

do $$ begin
  create type ola.queue_item_kind as enum ('review_due', 'review_normal', 'speech_train', 'new_content');
exception when duplicate_object then null; end $$;

do $$ begin
  create type ola.exercise_kind as enum ('listen_repeat', 'recall', 'build_sentence', 'shadowing');
exception when duplicate_object then null; end $$;

do $$ begin
  create type ola.event_actor as enum ('user', 'system');
exception when duplicate_object then null; end $$;

-- ------------------------------------------------------------
-- generic updated_at trigger
-- ------------------------------------------------------------
create or replace function ola.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

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

-- ------------------------------------------------------------
-- indexes
-- ------------------------------------------------------------
create index if not exists idx_user_enrollments_user_active on public.user_enrollments(user_id, is_active);
create index if not exists idx_blocks_language_pair_order on public.blocks(language_pair_id, block_order);
create index if not exists idx_sentences_block_level on public.sentences(block_id, level);
create index if not exists idx_memory_items_user_next_review on public.memory_items(user_id, next_review_at);
create index if not exists idx_memory_items_user_fluency on public.memory_items(user_id, fluency_score);
create index if not exists idx_memory_items_user_strength on public.memory_items(user_id, strength);
create index if not exists idx_speech_logs_user_created on public.speech_logs(user_id, created_at desc);
create index if not exists idx_sessions_user_started on public.sessions(user_id, started_at desc);
create index if not exists idx_session_events_session_created on public.session_events(session_id, created_at);
create index if not exists idx_analytics_events_name_created on public.analytics_events(event_name, created_at);
create index if not exists idx_sentence_versions_text_trgm on public.sentence_versions using gin (text_value gin_trgm_ops);

-- ------------------------------------------------------------
-- helper views
-- ------------------------------------------------------------
create or replace view public.published_block_versions as
select bv.*
from public.block_versions bv
where bv.is_published = true;

create or replace view public.published_sentence_versions as
select sv.*
from public.sentence_versions sv
where sv.is_published = true;

create or replace view public.user_block_progress as
select
  mi.user_id,
  s.block_id,
  count(*) as sentence_count,
  avg(mi.strength) as avg_strength,
  avg(mi.fluency_score) as avg_fluency,
  count(*) filter (where mi.strength >= 70 and mi.fluency_score >= 60) as mastered_sentence_count,
  (count(*) filter (where mi.strength >= 70 and mi.fluency_score >= 60))::numeric / nullif(count(*),0)::numeric as mastery_ratio,
  min(mi.next_review_at) as next_due_at,
  max(mi.updated_at) as last_activity_at
from public.memory_items mi
join public.sentences s on s.id = mi.sentence_id
group by mi.user_id, s.block_id;

-- ------------------------------------------------------------
-- core scoring and scheduling functions
-- ------------------------------------------------------------
create or replace function ola.ola_compute_performance_score(
  p_recall numeric,
  p_speech numeric,
  p_speed numeric
)
returns numeric
language sql
immutable
as $$
  select greatest(0, least(1, (coalesce(p_recall,0) * 0.4) + (coalesce(p_speech,0) * 0.4) + (coalesce(p_speed,0) * 0.2)));
$$;

create or replace function ola.ola_calculate_next_review(
  p_strength numeric,
  p_fluency_score numeric,
  p_stability numeric,
  p_ease_factor numeric,
  p_now timestamptz default now()
)
returns timestamptz
language plpgsql
immutable
as $$
declare
  v_base numeric;
  v_fluency_penalty numeric;
  v_adjusted_days numeric;
  v_minutes numeric;
begin
  v_base := greatest(0.0138889, coalesce(p_stability,1) * coalesce(p_ease_factor,2.5)); -- 20 min in days floor
  v_fluency_penalty := 1 - (greatest(0, least(100, coalesce(p_fluency_score,0))) / 100.0);
  v_adjusted_days := v_base * (1 - v_fluency_penalty * 0.5);
  v_minutes := greatest(20, least(90*24*60, v_adjusted_days * 24 * 60));
  return p_now + make_interval(mins => ceil(v_minutes)::int);
end;
$$;

create or replace function ola.ola_next_stage(
  p_strength numeric,
  p_fluency numeric,
  p_current_stage int,
  p_performance_score numeric
)
returns int
language plpgsql
immutable
as $$
begin
  if coalesce(p_performance_score,0) < 0.4 then
    return greatest(0, coalesce(p_current_stage,0) - 1);
  elsif coalesce(p_strength,0) > 80 and coalesce(p_fluency,0) > 70 then
    return least(5, coalesce(p_current_stage,0) + 1);
  elsif coalesce(p_strength,0) > 60 and coalesce(p_fluency,0) > 50 then
    return greatest(coalesce(p_current_stage,0), 3);
  elsif coalesce(p_strength,0) > 30 then
    return greatest(coalesce(p_current_stage,0), 1);
  else
    return coalesce(p_current_stage,0);
  end if;
end;
$$;

create or replace function ola.ola_upsert_memory_item(
  p_user_id uuid,
  p_sentence_id uuid,
  p_language_pair_id uuid,
  p_recall numeric,
  p_speech numeric,
  p_speed numeric,
  p_reviewed_at timestamptz default now()
)
returns public.memory_items
language plpgsql
security definer
set search_path = public, auth, extensions, ola
as $$
declare
  v_item public.memory_items;
  v_perf numeric;
  v_new_strength numeric;
  v_new_fluency numeric;
  v_new_ease numeric;
  v_new_stability numeric;
  v_new_stage int;
  v_next_review timestamptz;
begin
  v_perf := ola.ola_compute_performance_score(p_recall, p_speech, p_speed);

  insert into public.memory_items (
    user_id, sentence_id, language_pair_id, strength, fluency_score, stability, ease_factor,
    review_stage, success_streak, failure_count, times_seen, last_review_at, next_review_at
  )
  values (
    p_user_id, p_sentence_id, p_language_pair_id, 20, 0, 1, 2.5,
    0, 0, 0, 0, null, p_reviewed_at + interval '20 minutes'
  )
  on conflict (user_id, sentence_id) do nothing;

  select * into v_item
  from public.memory_items
  where user_id = p_user_id and sentence_id = p_sentence_id
  for update;

  v_new_ease := greatest(1.3, v_item.ease_factor + (0.1 - (1 - v_perf) * 0.2));
  v_new_strength := least(100, greatest(0, v_item.strength + (v_perf * 20) - case when v_perf < 0.4 then 10 else 0 end));
  v_new_fluency := least(100, greatest(0, v_item.fluency_score + (v_perf * 25) - case when coalesce(p_speech,0) < 0.4 then 8 else 0 end));
  v_new_stability := case
    when v_perf < 0.4 then greatest(0.25, v_item.stability * 0.5)
    else greatest(0.25, v_item.stability * (1 + v_perf))
  end;
  v_new_stage := ola.ola_next_stage(v_new_strength, v_new_fluency, v_item.review_stage, v_perf);
  v_next_review := ola.ola_calculate_next_review(v_new_strength, v_new_fluency, v_new_stability, v_new_ease, p_reviewed_at);

  update public.memory_items
  set strength = v_new_strength,
      fluency_score = v_new_fluency,
      stability = v_new_stability,
      ease_factor = v_new_ease,
      review_stage = v_new_stage,
      success_streak = case when v_perf >= 0.6 then v_item.success_streak + 1 else 0 end,
      failure_count = case when v_perf < 0.4 then v_item.failure_count + 1 else 0 end,
      times_seen = v_item.times_seen + 1,
      last_review_at = p_reviewed_at,
      next_review_at = v_next_review,
      mastered_at = case when v_new_stage = 5 then coalesce(v_item.mastered_at, p_reviewed_at) else v_item.mastered_at end,
      updated_at = now()
  where id = v_item.id
  returning * into v_item;

  return v_item;
end;
$$;

-- ------------------------------------------------------------
-- queue building / progression
-- ------------------------------------------------------------
create or replace function ola.ola_can_unlock_block(
  p_user_id uuid,
  p_block_id uuid
)
returns boolean
language sql
stable
as $$
  with stats as (
    select
      count(*)::numeric as total_count,
      count(*) filter (where mi.strength >= 70 and mi.fluency_score >= 60)::numeric as mastered_count
    from public.sentences s
    left join public.memory_items mi
      on mi.sentence_id = s.id
     and mi.user_id = p_user_id
    where s.block_id = p_block_id
  )
  select case
    when total_count = 0 then false
    else (mastered_count / total_count) >= 0.8
  end
  from stats;
$$;

create or replace function ola.ola_build_session_queue(
  p_user_id uuid,
  p_language_pair_id uuid,
  p_limit_due int default 5,
  p_limit_speech int default 3,
  p_limit_new int default 2
)
returns table (
  queue_position int,
  queue_item_kind ola.queue_item_kind,
  sentence_id uuid,
  memory_item_id uuid,
  block_id uuid,
  suggested_exercise ola.exercise_kind
)
language sql
stable
as $$
  with due_items as (
    select
      mi.sentence_id,
      mi.id as memory_item_id,
      s.block_id,
      'review_due'::ola.queue_item_kind as queue_item_kind,
      case
        when mi.fluency_score < 50 then 'shadowing'::ola.exercise_kind
        when mi.strength < 50 then 'recall'::ola.exercise_kind
        else 'build_sentence'::ola.exercise_kind
      end as suggested_exercise,
      row_number() over (order by mi.next_review_at asc nulls first, mi.fluency_score asc, mi.strength asc) as seq
    from public.memory_items mi
    join public.sentences s on s.id = mi.sentence_id
    where mi.user_id = p_user_id
      and mi.language_pair_id = p_language_pair_id
      and coalesce(mi.next_review_at, now()) <= now()
    limit p_limit_due
  ),
  speech_items as (
    select
      mi.sentence_id,
      mi.id as memory_item_id,
      s.block_id,
      'speech_train'::ola.queue_item_kind as queue_item_kind,
      'shadowing'::ola.exercise_kind as suggested_exercise,
      row_number() over (order by mi.fluency_score asc, mi.next_review_at asc nulls first) as seq
    from public.memory_items mi
    join public.sentences s on s.id = mi.sentence_id
    where mi.user_id = p_user_id
      and mi.language_pair_id = p_language_pair_id
      and mi.fluency_score < 60
      and (mi.next_review_at is null or mi.next_review_at > now())
    limit p_limit_speech
  ),
  active_enrollment as (
    select ue.*
    from public.user_enrollments ue
    where ue.user_id = p_user_id
      and ue.language_pair_id = p_language_pair_id
      and ue.is_active = true
    order by ue.updated_at desc
    limit 1
  ),
  next_block as (
    select b.id as block_id
    from public.blocks b
    join active_enrollment ae on ae.language_pair_id = b.language_pair_id
    where b.language_pair_id = p_language_pair_id
      and b.is_active = true
      and b.block_order >= ae.current_block_order
    order by b.block_order asc
    limit 1
  ),
  new_items as (
    select
      s.id as sentence_id,
      null::uuid as memory_item_id,
      s.block_id,
      'new_content'::ola.queue_item_kind as queue_item_kind,
      'listen_repeat'::ola.exercise_kind as suggested_exercise,
      row_number() over (order by s.level asc, s.sentence_order asc) as seq
    from public.sentences s
    join next_block nb on nb.block_id = s.block_id
    where not exists (
      select 1
      from public.memory_items mi
      where mi.user_id = p_user_id
        and mi.sentence_id = s.id
    )
    limit p_limit_new
  ),
  combined as (
    select seq as ord, queue_item_kind, sentence_id, memory_item_id, block_id, suggested_exercise from due_items
    union all
    select p_limit_due + seq, queue_item_kind, sentence_id, memory_item_id, block_id, suggested_exercise from speech_items
    union all
    select p_limit_due + p_limit_speech + seq, queue_item_kind, sentence_id, memory_item_id, block_id, suggested_exercise from new_items
  )
  select row_number() over (order by ord), queue_item_kind, sentence_id, memory_item_id, block_id, suggested_exercise
  from combined
  order by ord;
$$;

-- ------------------------------------------------------------
-- seed core languages / starter pairs
-- ------------------------------------------------------------
insert into public.languages (code, english_name, native_name, locale, is_active)
values
  ('en', 'English', 'English', 'en-US', true),
  ('pt-BR', 'Portuguese (Brazil)', 'Português (Brasil)', 'pt-BR', true),
  ('es', 'Spanish', 'Español', 'es-ES', true)
on conflict (code) do update
set english_name = excluded.english_name,
    native_name = excluded.native_name,
    locale = excluded.locale,
    is_active = excluded.is_active;

insert into public.language_pairs (source_language_code, target_language_code, is_active)
values
  ('pt-BR', 'en', true),
  ('en', 'pt-BR', true),
  ('en', 'es', true),
  ('pt-BR', 'es', true)
on conflict (source_language_code, target_language_code) do update
set is_active = excluded.is_active;

-- ------------------------------------------------------------
-- auto profile creation on signup
-- ------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, auth, extensions, ola
as $$
begin
  insert into public.user_profiles (id, display_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'display_name', split_part(new.email, '@', 1))
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ------------------------------------------------------------
-- RLS
-- ------------------------------------------------------------
alter table public.user_profiles enable row level security;
alter table public.user_enrollments enable row level security;
alter table public.memory_items enable row level security;
alter table public.speech_logs enable row level security;
alter table public.sessions enable row level security;
alter table public.session_events enable row level security;
alter table public.analytics_events enable row level security;

-- public read-only curriculum tables
alter table public.languages enable row level security;
alter table public.language_pairs enable row level security;
alter table public.blocks enable row level security;
alter table public.block_versions enable row level security;
alter table public.sentences enable row level security;
alter table public.sentence_versions enable row level security;
alter table public.sentence_translations enable row level security;

-- profiles
create policy if not exists "user_profiles_select_own" on public.user_profiles
for select using (auth.uid() = id);
create policy if not exists "user_profiles_update_own" on public.user_profiles
for update using (auth.uid() = id);
create policy if not exists "user_profiles_insert_own" on public.user_profiles
for insert with check (auth.uid() = id);

-- enrollments
create policy if not exists "user_enrollments_select_own" on public.user_enrollments
for select using (auth.uid() = user_id);
create policy if not exists "user_enrollments_insert_own" on public.user_enrollments
for insert with check (auth.uid() = user_id);
create policy if not exists "user_enrollments_update_own" on public.user_enrollments
for update using (auth.uid() = user_id);

-- memory
create policy if not exists "memory_items_select_own" on public.memory_items
for select using (auth.uid() = user_id);
create policy if not exists "memory_items_insert_own" on public.memory_items
for insert with check (auth.uid() = user_id);
create policy if not exists "memory_items_update_own" on public.memory_items
for update using (auth.uid() = user_id);

-- speech logs
create policy if not exists "speech_logs_select_own" on public.speech_logs
for select using (auth.uid() = user_id);
create policy if not exists "speech_logs_insert_own" on public.speech_logs
for insert with check (auth.uid() = user_id);

-- sessions
create policy if not exists "sessions_select_own" on public.sessions
for select using (auth.uid() = user_id);
create policy if not exists "sessions_insert_own" on public.sessions
for insert with check (auth.uid() = user_id);
create policy if not exists "sessions_update_own" on public.sessions
for update using (auth.uid() = user_id);

-- session events
create policy if not exists "session_events_select_own" on public.session_events
for select using (auth.uid() = user_id);
create policy if not exists "session_events_insert_own" on public.session_events
for insert with check (auth.uid() = user_id);

-- analytics
create policy if not exists "analytics_events_select_own" on public.analytics_events
for select using (auth.uid() = user_id);
create policy if not exists "analytics_events_insert_own" on public.analytics_events
for insert with check (auth.uid() = user_id or user_id is null);

-- curriculum readable by authenticated users
create policy if not exists "languages_read_all" on public.languages
for select using (true);
create policy if not exists "language_pairs_read_all" on public.language_pairs
for select using (true);
create policy if not exists "blocks_read_all" on public.blocks
for select using (true);
create policy if not exists "block_versions_read_published" on public.block_versions
for select using (is_published = true);
create policy if not exists "sentences_read_all" on public.sentences
for select using (true);
create policy if not exists "sentence_versions_read_published" on public.sentence_versions
for select using (is_published = true);
create policy if not exists "sentence_translations_read_all" on public.sentence_translations
for select using (true);

-- ------------------------------------------------------------
-- grants for rpc use
-- ------------------------------------------------------------
grant usage on schema ola to anon, authenticated, service_role;
grant execute on function ola.ola_compute_performance_score(numeric, numeric, numeric) to anon, authenticated, service_role;
grant execute on function ola.ola_calculate_next_review(numeric, numeric, numeric, numeric, timestamptz) to anon, authenticated, service_role;
grant execute on function ola.ola_next_stage(numeric, numeric, int, numeric) to anon, authenticated, service_role;
grant execute on function ola.ola_upsert_memory_item(uuid, uuid, uuid, numeric, numeric, numeric, timestamptz) to authenticated, service_role;
grant execute on function ola.ola_can_unlock_block(uuid, uuid) to authenticated, service_role;
grant execute on function ola.ola_build_session_queue(uuid, uuid, int, int, int) to authenticated, service_role;

commit;
