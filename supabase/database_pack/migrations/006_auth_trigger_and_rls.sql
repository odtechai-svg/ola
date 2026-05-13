-- auth trigger, rls, grants
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

