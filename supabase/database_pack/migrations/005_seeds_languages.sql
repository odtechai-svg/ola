-- starter languages and pairs
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

