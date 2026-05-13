-- extracted from master
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