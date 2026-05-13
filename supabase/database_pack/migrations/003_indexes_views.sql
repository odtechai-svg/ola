-- indexes and views
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

