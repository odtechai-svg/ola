-- functions
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

