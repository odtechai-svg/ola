-- OLA curriculum seed: 120 blocks
-- Source: uploaded file OLAF - 120 blocos.txt
-- Target language: en
-- Language pair: pt-BR -> en
-- Note: source glosses default to target text in this seed and should be editorially localized before public release.
begin;
insert into public.language_pairs (source_language_code, target_language_code) values ('pt-BR', 'en') on conflict (source_language_code, target_language_code) do nothing;
do $$
declare
  v_pair_id uuid;
  v_block_id uuid;
  v_sentence_id uuid;
  v_sentence_version_id uuid;
begin
  select id into v_pair_id from public.language_pairs where source_language_code = 'pt-BR' and target_language_code = 'en';
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-001-necessidade-b-sica-verbo-want', 'survival', 1, 'Necessidade Básica (Verbo: Want)', 'Necessidade Básica (Verbo: Want)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 1; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Necessidade Básica (Verbo: Want)', 'Necessidade Básica (Verbo: Want)', 'Core communicative block 1', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I want.', 'Alguém apontando para si e para algo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I want.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I want water.', 'A pessoa com um copo d''água', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I want water.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I want water now.', 'Relógio indicando o momento atual', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I want water now.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-002-a-o-de-movimento-verbo-go', 'survival', 2, 'Ação de Movimento (Verbo: Go)', 'Ação de Movimento (Verbo: Go)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 2; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Ação de Movimento (Verbo: Go)', 'Ação de Movimento (Verbo: Go)', 'Core communicative block 2', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I go.', 'Pessoa caminhando', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I go.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I go home.', 'Pessoa chegando em uma casa', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I go home.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I go home with my friend.', 'Duas pessoas caminhando para a casa', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I go home with my friend.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-003-capacidade-verbo-can-do', 'survival', 3, 'Capacidade (Verbo: Can/Do)', 'Capacidade (Verbo: Can/Do)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 3; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Capacidade (Verbo: Can/Do)', 'Capacidade (Verbo: Can/Do)', 'Core communicative block 3', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I can.', 'Alguém fazendo sinal de "positivo" ou força', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I can.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I can do this.', 'Alguém completando uma tarefa simples', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I can do this.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I can do this today.', 'Calendário com o dia de hoje marcado', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I can do this today.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-004-percep-o-verbo-see', 'survival', 4, 'Percepção (Verbo: See)', 'Percepção (Verbo: See)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 4; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Percepção (Verbo: See)', 'Percepção (Verbo: See)', 'Core communicative block 4', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I see.', 'Olhos abertos ou alguém olhando', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I see.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I see the car.', 'Um carro na rua', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I see the car.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I see the car but it is far.', 'Carro pequeno ao fundo na estrada', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I see the car but it is far.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-005-posse-estado-verbo-have', 'survival', 5, 'Posse/Estado (Verbo: Have)', 'Posse/Estado (Verbo: Have)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 5; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Posse/Estado (Verbo: Have)', 'Posse/Estado (Verbo: Have)', 'Core communicative block 5', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I have.', 'Mãos segurando algo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I have.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I have a book.', 'Alguém com um livro', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I have a book.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I have a book and I read.', 'Pessoa lendo o livro', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I have a book and I read.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-006-comunica-o-verbo-say', 'survival', 6, 'Comunicação (Verbo: Say)', 'Comunicação (Verbo: Say)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 6; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Comunicação (Verbo: Say)', 'Comunicação (Verbo: Say)', 'Core communicative block 6', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You say.', 'Alguém falando/balão de fala', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You say.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You say "hello".', 'Aceno de mão e a palavra escrita', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You say "hello".', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You say "hello" because you are good.', 'Sorriso e sinal de amizade', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You say "hello" because you are good.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-007-cogni-o-verbo-know', 'survival', 7, 'Cognição (Verbo: Know)', 'Cognição (Verbo: Know)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 7; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Cognição (Verbo: Know)', 'Cognição (Verbo: Know)', 'Core communicative block 7', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I know.', 'Lâmpada acesa sobre a cabeça', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I know.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I know your name.', 'Crachá ou alguém se apresentando', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I know your name.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I know your name because we are friends.', 'Duas pessoas abraçadas', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I know your name because we are friends.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-008-localiza-o-verbo-be', 'survival', 8, 'Localização (Verbo: Be)', 'Localização (Verbo: Be)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 8; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Localização (Verbo: Be)', 'Localização (Verbo: Be)', 'Core communicative block 8', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'She is.', 'Uma mulher', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'She is.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'She is here.', 'Ela em um local específico marcado com "X"', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'She is here.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'She is here at work.', 'Ela em um escritório/mesa', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'She is here at work.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-009-pensamento-verbo-think', 'survival', 9, 'Pensamento (Verbo: Think)', 'Pensamento (Verbo: Think)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 9; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Pensamento (Verbo: Think)', 'Pensamento (Verbo: Think)', 'Core communicative block 9', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We think.', 'Grupo de pessoas com a mão no queixo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We think.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We think about food.', 'Balão de pensamento com um prato de comida', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We think about food.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We think about food if we are hungry.', 'Pessoa com a mão na barriga vazia', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We think about food if we are hungry.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-010-inten-o-futuro-verbo-will-make', 'survival', 10, 'Intenção/Futuro (Verbo: Will/Make)', 'Intenção/Futuro (Verbo: Will/Make)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 10; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Intenção/Futuro (Verbo: Will/Make)', 'Intenção/Futuro (Verbo: Will/Make)', 'Core communicative block 10', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'They will.', 'Grupo apontando para o futuro', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'They will.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'They will make it.', 'Grupo construindo algo ou vencendo', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'They will make it.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'They will make it tomorrow.', 'Sol nascendo no horizonte', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'They will make it tomorrow.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-011-o-verbo-de-movimento-reversivo-come', 'survival', 11, 'O Verbo de Movimento Reversivo (Come)', 'O Verbo de Movimento Reversivo (Come)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 11; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'O Verbo de Movimento Reversivo (Come)', 'O Verbo de Movimento Reversivo (Come)', 'Core communicative block 11', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You come.', 'Alguém fazendo sinal de "venha"', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You come.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You come here.', 'Uma seta apontando para o chão onde o falante está', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You come here.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You come here every day.', 'Um calendário com todos os dias marcados', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You come here every day.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-012-a-o-de-pegar-levar-take', 'survival', 12, 'Ação de Pegar/Levar (Take)', 'Ação de Pegar/Levar (Take)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 12; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Ação de Pegar/Levar (Take)', 'Ação de Pegar/Levar (Take)', 'Core communicative block 12', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I take.', 'Uma mão pegando uma chave', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I take.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I take the car.', 'Alguém entrando no carro ou segurando a chave do carro', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I take the car.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I take the car to work.', 'O carro em frente a um prédio de escritórios', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I take the car to work.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-013-tempo-e-exist-ncia-time-is', 'survival', 13, 'Tempo e Existência (Time/Is)', 'Tempo e Existência (Time/Is)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 13; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Tempo e Existência (Time/Is)', 'Tempo e Existência (Time/Is)', 'Core communicative block 13', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is.', 'Um relógio ou um conceito neutro', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is time.', 'O relógio marcando a hora de um compromisso', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is time.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is time to speak.', 'Alguém com um microfone ou em uma reunião', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is time to speak.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-014-o-verbo-de-dar-give', 'survival', 14, 'O Verbo de Dar (Give)', 'O Verbo de Dar (Give)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 14; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'O Verbo de Dar (Give)', 'O Verbo de Dar (Give)', 'Core communicative block 14', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Give me.', 'Uma mão aberta esperando algo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Give me.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Give me the money.', 'Alguém entregando uma nota ou moeda', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Give me the money.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Give me the money for the food.', 'Uma nota de dinheiro ao lado de um prato de comida', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Give me the money for the food.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-015-pensamento-e-d-vida-ask-if', 'survival', 15, 'Pensamento e Dúvida (Ask/If)', 'Pensamento e Dúvida (Ask/If)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 15; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Pensamento e Dúvida (Ask/If)', 'Pensamento e Dúvida (Ask/If)', 'Core communicative block 15', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I ask.', 'Alguém levantando a mão na sala de aula', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I ask.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I ask why.', 'Um ponto de interrogação acima da cabeça', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I ask why.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I ask why if I don''t know.', 'Pessoa dando de ombros, sem entender', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I ask why if I don''t know.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-016-localiza-o-relativa-under-on', 'survival', 16, 'Localização Relativa (Under/On)', 'Localização Relativa (Under/On)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 16; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Localização Relativa (Under/On)', 'Localização Relativa (Under/On)', 'Core communicative block 16', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is here.', 'Um objeto em cima de uma mesa', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is here.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is on the table.', 'Zoom no objeto em cima da mesa', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is on the table.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is not under the table.', 'A mesma mesa, mas mostrando o espaço vazio embaixo dela', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is not under the table.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-017-o-verbo-de-ouvir-listen-about', 'survival', 17, 'O Verbo de Ouvir (Listen/About)', 'O Verbo de Ouvir (Listen/About)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 17; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'O Verbo de Ouvir (Listen/About)', 'O Verbo de Ouvir (Listen/About)', 'Core communicative block 17', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We listen.', 'Grupo de pessoas com a mão no ouvido', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We listen.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We listen to you.', 'O grupo olhando para uma pessoa que fala', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We listen to you.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We listen to you about the problem.', 'O grupo com feição de preocupação ouvindo a explicação', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We listen to you about the problem.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-018-frequ-ncia-e-a-o-often-use', 'survival', 18, 'Frequência e Ação (Often/Use)', 'Frequência e Ação (Often/Use)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 18; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Frequência e Ação (Often/Use)', 'Frequência e Ação (Often/Use)', 'Core communicative block 18', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I use.', 'Alguém usando um celular ou ferramenta', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I use.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I use the phone.', 'Alguém digitando no celular', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I use the phone.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I use the phone often.', 'Vários ícones de relógio ao redor do celular', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I use the phone often.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-019-condi-o-e-sentimento-feel-but', 'survival', 19, 'Condição e Sentimento (Feel/But)', 'Condição e Sentimento (Feel/But)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 19; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Condição e Sentimento (Feel/But)', 'Condição e Sentimento (Feel/But)', 'Core communicative block 19', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I feel.', 'Alguém com a mão no coração', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I feel.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I feel good.', 'Alguém sorrindo e feliz', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I feel good.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I feel good but I am tired.', 'Alguém sorrindo, mas bocejando/com sono', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I feel good but I am tired.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-020-finaliza-o-e-resultado-find-way', 'survival', 20, 'Finalização e Resultado (Find/Way)', 'Finalização e Resultado (Find/Way)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 20; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Finalização e Resultado (Find/Way)', 'Finalização e Resultado (Find/Way)', 'Core communicative block 20', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'They find.', 'Alguém encontrando um tesouro ou uma chave perdida', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'They find.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'They find the way.', 'Alguém olhando um mapa ou bússola', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'They find the way.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'They find the way through the city.', 'Uma linha traçada cruzando o mapa de uma cidade', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'They find the way through the city.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-021-inten-o-e-ajuda-verbo-help-need', 'survival', 21, 'Intenção e Ajuda (Verbo: Help / Need)', 'Intenção e Ajuda (Verbo: Help / Need)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 21; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Intenção e Ajuda (Verbo: Help / Need)', 'Intenção e Ajuda (Verbo: Help / Need)', 'Core communicative block 21', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I help.', 'Alguém estendendo a mão', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I help.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I help my family.', 'Pessoa ajudando um idoso ou criança', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I help my family.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I help my family because they need me.', 'Grupo familiar unido', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I help my family because they need me.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-022-movimento-e-destino-verbo-run-to', 'survival', 22, 'Movimento e Destino (Verbo: Run / To)', 'Movimento e Destino (Verbo: Run / To)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 22; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Movimento e Destino (Verbo: Run / To)', 'Movimento e Destino (Verbo: Run / To)', 'Core communicative block 22', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'He runs.', 'Um homem correndo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'He runs.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'He runs to the school.', 'Homem correndo em direção a um prédio escolar', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'He runs to the school.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'He runs to the school before it closes.', 'Homem olhando o relógio e correndo para a porta', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'He runs to the school before it closes.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-023-descoberta-e-objeto-verbo-look-for-find', 'survival', 23, 'Descoberta e Objeto (Verbo: Look for / Find)', 'Descoberta e Objeto (Verbo: Look for / Find)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 23; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Descoberta e Objeto (Verbo: Look for / Find)', 'Descoberta e Objeto (Verbo: Look for / Find)', 'Core communicative block 23', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I look for.', 'Alguém procurando algo com uma lupa', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I look for.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I look for my keys.', 'Pessoa procurando chaves no sofá', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I look for my keys.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I look for my keys until I find them.', 'Pessoa sorrindo com as chaves na mão', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I look for my keys until I find them.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-024-pensamento-coletivo-verbo-believe-that', 'survival', 24, 'Pensamento Coletivo (Verbo: Believe / That)', 'Pensamento Coletivo (Verbo: Believe / That)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 24; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Pensamento Coletivo (Verbo: Believe / That)', 'Pensamento Coletivo (Verbo: Believe / That)', 'Core communicative block 24', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We believe.', 'Pessoas com expressão de confiança/fé', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We believe.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We believe that idea.', 'Grupo apontando para um quadro com um plano/ideia', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We believe that idea.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We believe that idea is good.', 'Sinal de "joinha" para o quadro', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We believe that idea is good.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-025-escrita-e-mem-ria-verbo-write-about', 'survival', 25, 'Escrita e Memória (Verbo: Write / About)', 'Escrita e Memória (Verbo: Write / About)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 25; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Escrita e Memória (Verbo: Write / About)', 'Escrita e Memória (Verbo: Write / About)', 'Core communicative block 25', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'She writes.', 'Mulher escrevendo em um caderno', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'She writes.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'She writes about her life.', 'Fotos de infância e viagens ao lado do caderno', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'She writes about her life.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'She writes about her life in a book.', 'A mulher segurando um livro pronto', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'She writes about her life in a book.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-026-quantidade-e-posse-verbo-have-many', 'survival', 26, 'Quantidade e Posse (Verbo: Have / Many)', 'Quantidade e Posse (Verbo: Have / Many)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 26; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Quantidade e Posse (Verbo: Have / Many)', 'Quantidade e Posse (Verbo: Have / Many)', 'Core communicative block 26', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'They have.', 'Pessoas segurando caixas', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'They have.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'They have many things.', 'Muitas caixas e objetos ao redor delas', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'They have many things.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'They have many things but no space.', 'Pessoas espremidas entre as caixas', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'They have many things but no space.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-027-tentativa-e-erro-verbo-try-again', 'survival', 27, 'Tentativa e Erro (Verbo: Try / Again)', 'Tentativa e Erro (Verbo: Try / Again)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 27; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Tentativa e Erro (Verbo: Try / Again)', 'Tentativa e Erro (Verbo: Try / Again)', 'Core communicative block 27', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I try.', 'Alguém tentando abrir um pote ou resolver um puzzle', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I try.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I try to do this.', 'Foco na ação sendo executada', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I try to do this.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I try to do this again and again.', 'Sequência de imagens da mesma pessoa repetindo a ação', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I try to do this again and again.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-028-mudan-a-de-estado-verbo-become-get', 'survival', 28, 'Mudança de Estado (Verbo: Become / Get)', 'Mudança de Estado (Verbo: Become / Get)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 28; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Mudança de Estado (Verbo: Become / Get)', 'Mudança de Estado (Verbo: Become / Get)', 'Core communicative block 28', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It gets.', 'O céu mudando de cor', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It gets.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It gets dark.', 'O pôr do sol, ficando noite', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It gets dark.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It gets dark after 6 PM.', 'Relógio marcando 18:00 e o céu escuro', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It gets dark after 6 PM.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-029-comunica-o-direta-verbo-tell-truth', 'survival', 29, 'Comunicação Direta (Verbo: Tell / Truth)', 'Comunicação Direta (Verbo: Tell / Truth)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 29; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Comunicação Direta (Verbo: Tell / Truth)', 'Comunicação Direta (Verbo: Tell / Truth)', 'Core communicative block 29', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Tell me.', 'Pessoa com a mão na orelha esperando ouvir algo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Tell me.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Tell me the truth.', 'Olhar sério e honesto entre duas pessoas', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Tell me the truth.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Tell me the truth always.', 'Símbolo de infinito ou repetição', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Tell me the truth always.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-030-prefer-ncia-verbo-like-better', 'survival', 30, 'Preferência (Verbo: Like / Better)', 'Preferência (Verbo: Like / Better)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 30; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Preferência (Verbo: Like / Better)', 'Preferência (Verbo: Like / Better)', 'Core communicative block 30', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I like.', 'Alguém comendo algo gostoso).

** Nível 2: I like this apple. (Imagem: Pessoa segurando uma maçã vermelha', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I like.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I like this apple better than that one.', 'Pessoa comparando uma maçã bonita com uma estragada', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I like this apple better than that one.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-031-perman-ncia-verbo-stay-place', 'expansion', 31, 'Permanência (Verbo: Stay / Place)', 'Permanência (Verbo: Stay / Place)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 31; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Permanência (Verbo: Stay / Place)', 'Permanência (Verbo: Stay / Place)', 'Core communicative block 31', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We stay.', 'Pessoas sentadas em um banco', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We stay.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We stay in this place.', 'O banco em um parque bonito', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We stay in this place.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We stay in this place during the day.', 'O sol brilhando sobre o parque', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We stay in this place during the day.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-032-trabalho-e-ferramentas-verbo-work-with', 'expansion', 32, 'Trabalho e Ferramentas (Verbo: Work / With)', 'Trabalho e Ferramentas (Verbo: Work / With)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 32; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Trabalho e Ferramentas (Verbo: Work / With)', 'Trabalho e Ferramentas (Verbo: Work / With)', 'Core communicative block 32', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You work.', 'Alguém em frente a um computador', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You work.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You work with a computer.', 'Foco nas mãos e no teclado', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You work with a computer.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You work with a computer every week.', 'Sete ícones de computador (um para cada dia)', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You work with a computer every week.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-033-in-cio-e-fim-verbo-start-finish', 'expansion', 33, 'Início e Fim (Verbo: Start / Finish)', 'Início e Fim (Verbo: Start / Finish)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 33; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Início e Fim (Verbo: Start / Finish)', 'Início e Fim (Verbo: Start / Finish)', 'Core communicative block 33', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I start.', 'Alguém na linha de partida ou abrindo um livro', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I start.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I start the work.', 'Pessoa começando a digitar ou construir algo', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I start the work.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I start the work when I arrive.', 'Pessoa abrindo a porta do escritório e sentando', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I start the work when I arrive.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-034-parte-e-todo-substantivo-part-world', 'expansion', 34, 'Parte e Todo (Substantivo: Part / World)', 'Parte e Todo (Substantivo: Part / World)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 34; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Parte e Todo (Substantivo: Part / World)', 'Parte e Todo (Substantivo: Part / World)', 'Core communicative block 34', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'This is a part.', 'Uma peça de um quebra-cabeça', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'This is a part.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'This is a part of the world.', 'Um mapa de um país', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'This is a part of the world.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'This is a part of the world where I live.', 'Alguém apontando para a sua casa no mapa', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'This is a part of the world where I live.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-035-chamado-e-nome-verbo-call-name', 'expansion', 35, 'Chamado e Nome (Verbo: Call / Name)', 'Chamado e Nome (Verbo: Call / Name)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 35; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Chamado e Nome (Verbo: Call / Name)', 'Chamado e Nome (Verbo: Call / Name)', 'Core communicative block 35', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I call.', 'Alguém gritando ou usando o telefone', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I call.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I call your name.', 'Balão de fala com o nome de alguém', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I call your name.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I call your name through the door.', 'Pessoa chamando outra que está atrás de uma porta fechada', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I call your name through the door.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-036-compreens-o-verbo-understand-why', 'expansion', 36, 'Compreensão (Verbo: Understand / Why)', 'Compreensão (Verbo: Understand / Why)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 36; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Compreensão (Verbo: Understand / Why)', 'Compreensão (Verbo: Understand / Why)', 'Core communicative block 36', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You understand.', 'Expressão de "Ah, entendi!" - o clique', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You understand.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You understand the problem.', 'Alguém olhando para um motor quebrado ou conta difícil', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You understand the problem.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You understand the problem now.', 'Pessoa sorrindo e começando a consertar/resolver', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You understand the problem now.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-037-lembran-a-verbo-remember-face', 'expansion', 37, 'Lembrança (Verbo: Remember / Face)', 'Lembrança (Verbo: Remember / Face)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 37; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Lembrança (Verbo: Remember / Face)', 'Lembrança (Verbo: Remember / Face)', 'Core communicative block 37', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I remember.', 'Pessoa tocando a têmpora, pensando', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I remember.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I remember your face.', 'O rosto de uma pessoa embaçado ficando nítido', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I remember your face.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I remember your face from the school.', 'Foto antiga de formatura/sala de aula', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I remember your face from the school.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-038-espa-o-e-dist-ncia-adjetivo-high-low', 'expansion', 38, 'Espaço e Distância (Adjetivo: High / Low)', 'Espaço e Distância (Adjetivo: High / Low)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 38; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Espaço e Distância (Adjetivo: High / Low)', 'Espaço e Distância (Adjetivo: High / Low)', 'Core communicative block 38', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is high.', 'Um pássaro voando alto', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is high.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'The bird is high.', 'O pássaro acima das nuvens', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'The bird is high.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'The bird is high above the house.', 'O pássaro lá no alto e uma casa pequena lá embaixo', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'The bird is high above the house.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-039-utilidade-verbo-use-way', 'expansion', 39, 'Utilidade (Verbo: Use / Way)', 'Utilidade (Verbo: Use / Way)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 39; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Utilidade (Verbo: Use / Way)', 'Utilidade (Verbo: Use / Way)', 'Core communicative block 39', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I use.', 'Alguém com um martelo ou ferramenta', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I use.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I use it this way.', 'Demonstração do uso correto da ferramenta', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I use it this way.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I use it this way to fix things.', 'O objeto sendo consertado', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I use it this way to fix things.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-040-diferencia-o-adjetivo-same-different', 'expansion', 40, 'Diferenciação (Adjetivo: Same / Different)', 'Diferenciação (Adjetivo: Same / Different)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 40; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Diferenciação (Adjetivo: Same / Different)', 'Diferenciação (Adjetivo: Same / Different)', 'Core communicative block 40', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'They are the same.', 'Duas bolas vermelhas iguais', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'They are the same.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'These things are the same.', 'Dois celulares idênticos', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'These things are the same.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'These things are the same but different colors.', 'Um celular preto e um branco do mesmo modelo', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'These things are the same but different colors.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-041-movimento-e-finalidade-revisitando-go-work', 'expansion', 41, 'Movimento e Finalidade (Revisitando: Go, Work)', 'Movimento e Finalidade (Revisitando: Go, Work)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 41; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Movimento e Finalidade (Revisitando: Go, Work)', 'Movimento e Finalidade (Revisitando: Go, Work)', 'Core communicative block 41', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I leave.', 'Alguém saindo por uma porta', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I leave.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I leave home.', 'Pessoa saindo de casa com uma mochila', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I leave home.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I leave home to go to work.', 'Pessoa caminhando de casa para o escritório', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I leave home to go to work.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-042-percep-o-e-tempo-revisitando-see-time', 'expansion', 42, 'Percepção e Tempo (Revisitando: See, Time)', 'Percepção e Tempo (Revisitando: See, Time)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 42; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Percepção e Tempo (Revisitando: See, Time)', 'Percepção e Tempo (Revisitando: See, Time)', 'Core communicative block 42', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I watch.', 'Alguém observando atentamente, como TV ou um jogo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I watch.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I watch the time.', 'Alguém olhando o relógio constantemente', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I watch the time.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I watch the time while I wait.', 'Pessoa sentada em uma sala de espera olhando o relógio', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I watch the time while I wait.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-043-posse-e-quantidade-revisitando-have-many', 'expansion', 43, 'Posse e Quantidade (Revisitando: Have, Many)', 'Posse e Quantidade (Revisitando: Have, Many)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 43; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Posse e Quantidade (Revisitando: Have, Many)', 'Posse e Quantidade (Revisitando: Have, Many)', 'Core communicative block 43', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'There is.', 'Um dedo apontando para a existência de algo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'There is.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'There is water.', 'Um copo ou garrafa sobre a mesa', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'There is water.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'There is enough water for many people.', 'Um galão grande de água e vários copos vazios ao redor', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'There is enough water for many people.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-044-a-o-e-consequ-ncia-revisitando-do-good', 'expansion', 44, 'Ação e Consequência (Revisitando: Do, Good)', 'Ação e Consequência (Revisitando: Do, Good)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 44; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Ação e Consequência (Revisitando: Do, Good)', 'Ação e Consequência (Revisitando: Do, Good)', 'Core communicative block 44', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You help.', 'Alguém oferecendo apoio', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You help.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You do good things.', 'Alguém plantando uma árvore ou ajudando um amigo', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You do good things.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You do good things because you are a friend.', 'Duas pessoas sorrindo e se abraçando', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You do good things because you are a friend.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-045-espa-o-e-localiza-o-revisitando-place-find', 'expansion', 45, 'Espaço e Localização (Revisitando: Place, Find)', 'Espaço e Localização (Revisitando: Place, Find)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 45; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Espaço e Localização (Revisitando: Place, Find)', 'Espaço e Localização (Revisitando: Place, Find)', 'Core communicative block 45', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is near.', 'Dois objetos bem próximos um do outro', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is near.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'The place is near.', 'Um mapa mostrando o destino a poucos metros', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'The place is near.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I can find the place because it is near.', 'Pessoa vendo o prédio de destino logo à frente', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I can find the place because it is near.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-046-necessidade-e-objeto-revisitando-need-money', 'expansion', 46, 'Necessidade e Objeto (Revisitando: Need, Money)', 'Necessidade e Objeto (Revisitando: Need, Money)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 46; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Necessidade e Objeto (Revisitando: Need, Money)', 'Necessidade e Objeto (Revisitando: Need, Money)', 'Core communicative block 46', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We buy.', 'Alguém entregando um cartão ou dinheiro no caixa', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We buy.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We buy food.', 'Carrinho de supermercado com frutas e pão', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We buy food.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We need money to buy food.', 'Pessoa olhando para a carteira e depois para a comida', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We need money to buy food.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-047-cogni-o-e-d-vida-revisitando-know-ask', 'expansion', 47, 'Cognição e Dúvida (Revisitando: Know, Ask)', 'Cognição e Dúvida (Revisitando: Know, Ask)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 47; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Cognição e Dúvida (Revisitando: Know, Ask)', 'Cognição e Dúvida (Revisitando: Know, Ask)', 'Core communicative block 47', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I don''t know.', 'Pessoa com as mãos abertas e expressão de dúvida', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I don''t know.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I don''t know the way.', 'Pessoa em uma encruzilhada olhando para um mapa confuso', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I don''t know the way.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I ask for help when I don''t know the way.', 'Pessoa parando um policial para pedir informação', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I ask for help when I don''t know the way.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-048-sentimento-e-raz-o-revisitando-feel-why', 'expansion', 48, 'Sentimento e Razão (Revisitando: Feel, Why)', 'Sentimento e Razão (Revisitando: Feel, Why)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 48; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Sentimento e Razão (Revisitando: Feel, Why)', 'Sentimento e Razão (Revisitando: Feel, Why)', 'Core communicative block 48', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You seem.', 'Alguém observando a expressão de outra pessoa', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You seem.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You seem tired.', 'Alguém bocejando com olheiras', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You seem tired.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I understand why you seem tired.', 'A pessoa apontando para uma pilha enorme de trabalho', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I understand why you seem tired.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-049-mudan-a-e-futuro-revisitando-become-will', 'expansion', 49, 'Mudança e Futuro (Revisitando: Become, Will)', 'Mudança e Futuro (Revisitando: Become, Will)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 49; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Mudança e Futuro (Revisitando: Become, Will)', 'Mudança e Futuro (Revisitando: Become, Will)', 'Core communicative block 49', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It changes.', 'Uma lagarta e uma borboleta', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It changes.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'The world changes.', 'Um mapa múndi antigo e um digital moderno', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'The world changes.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'The world will change again.', 'Um robô ou cidade futurista com um ponto de interrogação', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'The world will change again.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-050-comunica-o-e-intensidade-revisitando-say-really', 'expansion', 50, 'Comunicação e Intensidade (Revisitando: Say, Really)', 'Comunicação e Intensidade (Revisitando: Say, Really)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 50; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Comunicação e Intensidade (Revisitando: Say, Really)', 'Comunicação e Intensidade (Revisitando: Say, Really)', 'Core communicative block 50', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I mean.', 'Alguém tentando explicar melhor um ponto', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I mean.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I really mean this.', 'Olhar firme e sincero', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I really mean this.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I say "hello" but I mean "I love you".', 'Alguém dizendo olá com um coração no balão de pensamento', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I say "hello" but I mean "I love you".', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-051-perman-ncia-e-condi-o-revisitando-stay-if', 'expansion', 51, 'Permanência e Condição (Revisitando: Stay, If)', 'Permanência e Condição (Revisitando: Stay, If)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 51; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Permanência e Condição (Revisitando: Stay, If)', 'Permanência e Condição (Revisitando: Stay, If)', 'Core communicative block 51', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I wait.', 'Alguém sentado em um banco de praça', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I wait.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I wait for you.', 'Pessoa olhando para o horizonte esperando alguém chegar', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I wait for you.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I will stay here if you come.', 'Pessoa apontando para o banco e para o relógio', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I will stay here if you come.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-052-parte-e-totalidade-revisitando-part-life', 'expansion', 52, 'Parte e Totalidade (Revisitando: Part, Life)', 'Parte e Totalidade (Revisitando: Part, Life)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 52; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Parte e Totalidade (Revisitando: Part, Life)', 'Parte e Totalidade (Revisitando: Part, Life)', 'Core communicative block 52', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Every part.', 'Todas as peças de um motor espalhadas', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Every part.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Every part of my life.', 'Colagem de fotos: infância, trabalho, família', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Every part of my life.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You are a part of my life.', 'O usuário olhando para uma foto de um amigo/parceiro', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You are a part of my life.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-053-prefer-ncia-e-compara-o-revisitando-like-better', 'expansion', 53, 'Preferência e Comparação (Revisitando: Like, Better)', 'Preferência e Comparação (Revisitando: Like, Better)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 53; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Preferência e Comparação (Revisitando: Like, Better)', 'Preferência e Comparação (Revisitando: Like, Better)', 'Core communicative block 53', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'This is small.', 'Uma semente na mão', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'This is small.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'This thing is small.', 'Um celular muito antigo e pequeno', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'This thing is small.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I like it because small is better.', 'Pessoa guardando o celular pequeno facilmente no bolso', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I like it because small is better.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-054-movimento-e-acompanhamento-revisitando-go-with', 'expansion', 54, 'Movimento e Acompanhamento (Revisitando: Go, With)', 'Movimento e Acompanhamento (Revisitando: Go, With)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 54; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Movimento e Acompanhamento (Revisitando: Go, With)', 'Movimento e Acompanhamento (Revisitando: Go, With)', 'Core communicative block 54', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Walk with me.', 'Uma mão estendida para caminhar junto', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Walk with me.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Walk with me through the city.', 'Duas pessoas andando por uma rua movimentada', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Walk with me through the city.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We go to the park to walk.', 'As duas pessoas entrando em uma área verde', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We go to the park to walk.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-055-inten-o-e-a-o-revisitando-want-make', 'expansion', 55, 'Intenção e Ação (Revisitando: Want, Make)', 'Intenção e Ação (Revisitando: Want, Make)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 55; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Intenção e Ação (Revisitando: Want, Make)', 'Intenção e Ação (Revisitando: Want, Make)', 'Core communicative block 55', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I try to make.', 'Alguém com as mãos na massa, cozinhando', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I try to make.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I want to make food.', 'Ingredientes sobre a mesa: tomate, massa', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I want to make food.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I try to make food for my family.', 'A pessoa servindo a mesa para a família', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I try to make food for my family.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-056-verbo-de-uso-revisitando-use-often', 'expansion', 56, 'Verbo de Uso (Revisitando: Use, Often)', 'Verbo de Uso (Revisitando: Use, Often)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 56; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Verbo de Uso (Revisitando: Use, Often)', 'Verbo de Uso (Revisitando: Use, Often)', 'Core communicative block 56', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Don''t use.', 'Sinal de proibido sobre uma mão mexendo em algo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Don''t use.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Don''t use that phone.', 'Um telefone com a tela quebrada ou perigoso', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Don''t use that phone.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I often use this one instead.', 'Pessoa apontando para um telefone novo e funcionando', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I often use this one instead.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-057-percep-o-auditiva-revisitando-hear-voice', 'expansion', 57, 'Percepção Auditiva (Revisitando: Hear, Voice)', 'Percepção Auditiva (Revisitando: Hear, Voice)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 57; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Percepção Auditiva (Revisitando: Hear, Voice)', 'Percepção Auditiva (Revisitando: Hear, Voice)', 'Core communicative block 57', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I hear.', 'Alguém com a mão atrás da orelha', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I hear.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I hear a voice.', 'Ondas sonoras vindo de uma direção', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I hear a voice.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I hear your voice every day.', 'Alguém ouvindo um áudio no celular com um sorriso', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I hear your voice every day.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-058-espa-o-vertical-revisitando-under-high', 'expansion', 58, 'Espaço Vertical (Revisitando: Under, High)', 'Espaço Vertical (Revisitando: Under, High)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 58; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Espaço Vertical (Revisitando: Under, High)', 'Espaço Vertical (Revisitando: Under, High)', 'Core communicative block 58', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Put it.', 'Uma mão colocando um livro em algum lugar', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Put it.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Put it under the table.', 'O livro sendo guardado em uma prateleira baixa sob a mesa', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Put it under the table.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Don''t put it high up.', 'Alguém tentando alcançar uma prateleira muito alta e não conseguindo', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Don''t put it high up.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-059-finaliza-o-revisitando-finish-now', 'expansion', 59, 'Finalização (Revisitando: Finish, Now)', 'Finalização (Revisitando: Finish, Now)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 59; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Finalização (Revisitando: Finish, Now)', 'Finalização (Revisitando: Finish, Now)', 'Core communicative block 59', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We finish.', 'Corredores cruzando a linha de chegada', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We finish.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We finish the work.', 'Alguém fechando o laptop com satisfação', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We finish the work.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We finish the work now and go home.', 'Pessoa pegando a chave do carro e saindo do escritório', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We finish the work now and go home.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-060-identidade-e-nome-revisitando-call-name', 'expansion', 60, 'Identidade e Nome (Revisitando: Call, Name)', 'Identidade e Nome (Revisitando: Call, Name)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 60; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Identidade e Nome (Revisitando: Call, Name)', 'Identidade e Nome (Revisitando: Call, Name)', 'Core communicative block 60', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'What is...?', 'Um ponto de interrogação flutuante', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'What is...?', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'What is the name?', 'Pessoa apontando para um objeto desconhecido', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'What is the name?', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'How do you call this thing?', 'Pessoa segurando uma ferramenta estranha e perguntando a outra', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'How do you call this thing?', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-061-opini-o-e-qualidade-revisitando-think-good', 'conversation', 61, 'Opinião e Qualidade (Revisitando: Think, Good)', 'Opinião e Qualidade (Revisitando: Think, Good)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 61; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Opinião e Qualidade (Revisitando: Think, Good)', 'Opinião e Qualidade (Revisitando: Think, Good)', 'Core communicative block 61', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I think so.', 'Alguém balançando a cabeça positivamente', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I think so.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I think this is good.', 'Alguém provando uma comida ou vendo um projeto', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I think this is good.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I think this is good for the world.', 'Uma lâmpada LED ou símbolo de reciclagem', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I think this is good for the world.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-062-possibilidade-e-lugar-revisitando-can-place', 'conversation', 62, 'Possibilidade e Lugar (Revisitando: Can, Place)', 'Possibilidade e Lugar (Revisitando: Can, Place)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 62; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Possibilidade e Lugar (Revisitando: Can, Place)', 'Possibilidade e Lugar (Revisitando: Can, Place)', 'Core communicative block 62', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You can stay.', 'Alguém indicando uma cadeira/assento', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You can stay.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You can stay in this place.', 'Um hotel aconchegante ou uma sala', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You can stay in this place.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You can stay here until the time to go.', 'Pessoa descansando e olhando para o relógio', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You can stay here until the time to go.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-063-movimento-coletivo-revisitando-come-with', 'conversation', 63, 'Movimento Coletivo (Revisitando: Come, With)', 'Movimento Coletivo (Revisitando: Come, With)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 63; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Movimento Coletivo (Revisitando: Come, With)', 'Movimento Coletivo (Revisitando: Come, With)', 'Core communicative block 63', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Come with us.', 'Grupo de amigos chamando com a mão', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Come with us.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Come with us to the city.', 'O grupo em frente a um trem ou ônibus', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Come with us to the city.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We go to the city every week.', 'O grupo repetindo a viagem no calendário', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We go to the city every week.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-064-desejo-e-tempo-revisitando-want-now', 'conversation', 64, 'Desejo e Tempo (Revisitando: Want, Now)', 'Desejo e Tempo (Revisitando: Want, Now)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 64; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Desejo e Tempo (Revisitando: Want, Now)', 'Desejo e Tempo (Revisitando: Want, Now)', 'Core communicative block 64', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I want to see.', 'Alguém tentando olhar por cima de um muro ou cortina', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I want to see.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I want to see you now.', 'Alguém fazendo uma chamada de vídeo no celular', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I want to see you now.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I want to see you because I miss my friend.', 'Foto de dois amigos juntos', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I want to see you because I miss my friend.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-065-a-o-e-conhecimento-revisitando-do-know', 'conversation', 65, 'Ação e Conhecimento (Revisitando: Do, Know)', 'Ação e Conhecimento (Revisitando: Do, Know)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 65; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Ação e Conhecimento (Revisitando: Do, Know)', 'Ação e Conhecimento (Revisitando: Do, Know)', 'Core communicative block 65', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I do what I know.', 'Alguém consertando algo que domina', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I do what I know.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I do what I know at work.', 'A pessoa em seu ambiente profissional', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I do what I know at work.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I always do my work this way.', 'A pessoa seguindo um processo padrão', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I always do my work this way.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-066-posse-e-necessidade-revisitando-have-money', 'conversation', 66, 'Posse e Necessidade (Revisitando: Have, Money)', 'Posse e Necessidade (Revisitando: Have, Money)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 66; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Posse e Necessidade (Revisitando: Have, Money)', 'Posse e Necessidade (Revisitando: Have, Money)', 'Core communicative block 66', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I have enough.', 'Uma mão fazendo sinal de "cheio" ou "satisfeito"', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I have enough.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I have enough money.', 'Uma carteira com a quantia exata para uma conta', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I have enough money.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I have enough money to buy a home.', 'Pessoa segurando a chave de uma casa nova', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I have enough money to buy a home.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-067-percep-o-de-mudan-a-revisitando-look-different', 'conversation', 67, 'Percepção de Mudança (Revisitando: Look, Different)', 'Percepção de Mudança (Revisitando: Look, Different)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 67; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Percepção de Mudança (Revisitando: Look, Different)', 'Percepção de Mudança (Revisitando: Look, Different)', 'Core communicative block 67', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You look different.', 'Alguém que cortou o cabelo ou trocou de roupa', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You look different.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'This place looks different now.', 'Uma rua que antes era vazia e agora tem prédios', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'This place looks different now.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Everything looks different after many years.', 'Comparação de foto antiga (preto e branco) e atual', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Everything looks different after many years.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-068-comunica-o-de-problemas-revisitando-tell-problem', 'conversation', 68, 'Comunicação de Problemas (Revisitando: Tell, Problem)', 'Comunicação de Problemas (Revisitando: Tell, Problem)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 68; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Comunicação de Problemas (Revisitando: Tell, Problem)', 'Comunicação de Problemas (Revisitando: Tell, Problem)', 'Core communicative block 68', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Tell me why.', 'Alguém com expressão de interrogação', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Tell me why.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Tell me why there is a problem.', 'Alguém apontando para um computador travado', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Tell me why there is a problem.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I need to know the problem to help you.', 'A pessoa abrindo uma caixa de ferramentas', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I need to know the problem to help you.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-069-esfor-o-e-repeti-o-revisitando-try-again', 'conversation', 69, 'Esforço e Repetição (Revisitando: Try, Again)', 'Esforço e Repetição (Revisitando: Try, Again)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 69; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Esforço e Repetição (Revisitando: Try, Again)', 'Esforço e Repetição (Revisitando: Try, Again)', 'Core communicative block 69', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I will try.', 'Alguém se preparando para uma corrida ou desafio', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I will try.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I will try again tomorrow.', 'Pessoa indo dormir com um bilhete de "tente de novo" no despertador', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I will try again tomorrow.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I never stop until I finish.', 'Pessoa cruzando a linha de chegada', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I never stop until I finish.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-070-sentido-e-dire-o-revisitando-feel-way', 'conversation', 70, 'Sentido e Direção (Revisitando: Feel, Way)', 'Sentido e Direção (Revisitando: Feel, Way)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 70; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Sentido e Direção (Revisitando: Feel, Way)', 'Sentido e Direção (Revisitando: Feel, Way)', 'Core communicative block 70', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I feel the way.', 'Alguém tocando uma parede no escuro ou seguindo uma trilha', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I feel the way.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I feel the way home.', 'Alguém caminhando por uma rua familiar à noite', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I feel the way home.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I know the way because I live here.', 'A pessoa apontando para a própria casa', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I know the way because I live here.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-071-uso-e-frequ-ncia-revisitando-use-often', 'conversation', 71, 'Uso e Frequência (Revisitando: Use, Often)', 'Uso e Frequência (Revisitando: Use, Often)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 71; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Uso e Frequência (Revisitando: Use, Often)', 'Uso e Frequência (Revisitando: Use, Often)', 'Core communicative block 71', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We use it.', 'Pessoas usando um aplicativo ou eletrodoméstico', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We use it.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We use it often at home.', 'Família reunida usando um tablet ou cafeteira', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We use it often at home.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is a good thing for the family.', 'Todos sorrindo ao redor do objeto', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is a good thing for the family.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-072-parte-do-todo-revisitando-part-life', 'conversation', 72, 'Parte do Todo (Revisitando: Part, Life)', 'Parte do Todo (Revisitando: Part, Life)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 72; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Parte do Todo (Revisitando: Part, Life)', 'Parte do Todo (Revisitando: Part, Life)', 'Core communicative block 72', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Only a part.', 'Uma fatia de uma pizza ou uma peça de motor', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Only a part.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Only a part of the story.', 'Alguém lendo apenas a primeira página de um livro', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Only a part of the story.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You only know a part of my life.', 'Um iceberg (uma parte fora da água, a maioria escondida)', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You only know a part of my life.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-073-audi-o-e-compreens-o-revisitando-hear-understand', 'conversation', 73, 'Audição e Compreensão (Revisitando: Hear, Understand)', 'Audição e Compreensão (Revisitando: Hear, Understand)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 73; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Audição e Compreensão (Revisitando: Hear, Understand)', 'Audição e Compreensão (Revisitando: Hear, Understand)', 'Core communicative block 73', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I hear you.', 'Alguém com fones de ouvido ou atento', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I hear you.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I hear you but I don''t understand.', 'Pessoa ouvindo alguém falar uma língua estrangeira', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I hear you but I don''t understand.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Can you speak slow please?', 'Sinal de "devagar" com as mãos', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Can you speak slow please?', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-074-exist-ncia-e-quantidade-revisitando-there-is-many', 'conversation', 74, 'Existência e Quantidade (Revisitando: There is, Many)', 'Existência e Quantidade (Revisitando: There is, Many)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 74; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Existência e Quantidade (Revisitando: There is, Many)', 'Existência e Quantidade (Revisitando: There is, Many)', 'Core communicative block 74', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'There are many.', 'Uma multidão ou muitos objetos', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'There are many.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'There are many people here.', 'Uma praça cheia de gente', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'There are many people here.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'There are many people waiting to go.', 'Fila no aeroporto ou rodoviária', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'There are many people waiting to go.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-075-pensamento-e-futuro-revisitando-think-will', 'conversation', 75, 'Pensamento e Futuro (Revisitando: Think, Will)', 'Pensamento e Futuro (Revisitando: Think, Will)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 75; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Pensamento e Futuro (Revisitando: Think, Will)', 'Pensamento e Futuro (Revisitando: Think, Will)', 'Core communicative block 75', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I think I will.', 'Pessoa com o dedo no queixo decidindo algo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I think I will.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I think I will take the car.', 'Pessoa segurando a chave do carro e olhando para a chuva', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I think I will take the car.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I will take the car if it starts.', 'Pessoa tentando ligar a ignição', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I will take the car if it starts.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-076-localiza-o-e-estado-revisitando-be-under', 'conversation', 76, 'Localização e Estado (Revisitando: Be, Under)', 'Localização e Estado (Revisitando: Be, Under)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 76; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Localização e Estado (Revisitando: Be, Under)', 'Localização e Estado (Revisitando: Be, Under)', 'Core communicative block 76', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is under.', 'Um gato embaixo da cama', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is under.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is under the water.', 'Um mergulhador ou um peixe', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is under the water.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You can see it if you look down.', 'Alguém apontando para dentro de uma piscina ou mar', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You can see it if you look down.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-077-trabalho-e-ferramenta-revisitando-work-call', 'conversation', 77, 'Trabalho e Ferramenta (Revisitando: Work, Call)', 'Trabalho e Ferramenta (Revisitando: Work, Call)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 77; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Trabalho e Ferramenta (Revisitando: Work, Call)', 'Trabalho e Ferramenta (Revisitando: Work, Call)', 'Core communicative block 77', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Don''t call me.', 'Sinal de "silêncio" ou telefone desligado', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Don''t call me.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Don''t call me at work.', 'Pessoa concentrada em frente ao computador', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Don''t call me at work.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I need to finish this today.', 'Pessoa suando e trabalhando rápido contra o relógio', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I need to finish this today.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-078-dar-e-receber-revisitando-give-food', 'conversation', 78, 'Dar e Receber (Revisitando: Give, Food)', 'Dar e Receber (Revisitando: Give, Food)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 78; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Dar e Receber (Revisitando: Give, Food)', 'Dar e Receber (Revisitando: Give, Food)', 'Core communicative block 78', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Give some.', 'Alguém repartindo um pão', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Give some.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Give some food to the child.', 'Adulto entregando uma maçã para uma criança', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Give some food to the child.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'The child is hungry and needs to eat.', 'Criança com a mão na barriguinha', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'The child is hungry and needs to eat.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-079-come-o-e-fim-revisitando-start-time', 'conversation', 79, 'Começo e Fim (Revisitando: Start, Time)', 'Começo e Fim (Revisitando: Start, Time)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 79; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Começo e Fim (Revisitando: Start, Time)', 'Começo e Fim (Revisitando: Start, Time)', 'Core communicative block 79', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'When does it start?', 'Pessoa olhando para o palco de um teatro ou cinema', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'When does it start?', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It starts at the same time.', 'Dois relógios marcando 08:00', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It starts at the same time.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It starts every day at 8 AM.', 'Sol nascendo e o relógio despertando', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It starts every day at 8 AM.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-080-identidade-e-verdade-revisitando-say-truth', 'conversation', 80, 'Identidade e Verdade (Revisitando: Say, Truth)', 'Identidade e Verdade (Revisitando: Say, Truth)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 80; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Identidade e Verdade (Revisitando: Say, Truth)', 'Identidade e Verdade (Revisitando: Say, Truth)', 'Core communicative block 80', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'He says it.', 'Alguém falando em um palanque ou para um amigo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'He says it.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'He says the truth.', 'Alguém com a mão no peito, expressão honesta', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'He says the truth.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I believe him because he is my friend.', 'Aperto de mão amigável', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I believe him because he is my friend.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-081-contraste-e-persist-ncia-revisitando-try-still', 'conversation', 81, 'Contraste e Persistência (Revisitando: Try, Still)', 'Contraste e Persistência (Revisitando: Try, Still)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 81; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Contraste e Persistência (Revisitando: Try, Still)', 'Contraste e Persistência (Revisitando: Try, Still)', 'Core communicative block 81', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I still try.', 'Alguém cansado, mas se levantando', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I still try.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I still try to understand.', 'Pessoa olhando para um livro complexo com a mão na testa', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I still try to understand.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Although it is hard, I still try.', 'Uma montanha alta e a pessoa começando a subir', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Although it is hard, I still try.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-082-frequ-ncia-e-h-bito-revisitando-often-use', 'conversation', 82, 'Frequência e Hábito (Revisitando: Often, Use)', 'Frequência e Hábito (Revisitando: Often, Use)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 82; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Frequência e Hábito (Revisitando: Often, Use)', 'Frequência e Hábito (Revisitando: Often, Use)', 'Core communicative block 82', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I usually use.', 'Pessoa pegando algo que usa todo dia, como óculos', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I usually use.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I usually use my phone to work.', 'Pessoa enviando e-mails pelo celular no café', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I usually use my phone to work.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I often do this when I am home.', 'Pessoa relaxada no sofá com o telefone', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I often do this when I am home.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-083-o-verbo-de-parecer-revisitando-seem-good', 'conversation', 83, 'O Verbo de Parecer (Revisitando: Seem, Good)', 'O Verbo de Parecer (Revisitando: Seem, Good)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 83; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'O Verbo de Parecer (Revisitando: Seem, Good)', 'O Verbo de Parecer (Revisitando: Seem, Good)', 'Core communicative block 83', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It seems.', 'Alguém analisando algo de longe', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It seems.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It seems like a good idea.', 'Alguém olhando para um esboço de um projeto e sorrindo', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It seems like a good idea.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It seems good, but we need more time.', 'A pessoa apontando para um relógio de areia/ampulheta', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It seems good, but we need more time.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-084-a-o-conclu-da-revisitando-finish-already', 'conversation', 84, 'Ação Concluída (Revisitando: Finish, Already)', 'Ação Concluída (Revisitando: Finish, Already)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 84; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Ação Concluída (Revisitando: Finish, Already)', 'Ação Concluída (Revisitando: Finish, Already)', 'Core communicative block 84', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I already finished.', 'Alguém com os braços para cima em sinal de vitória', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I already finished.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I already finished my work.', 'Mesa limpa e computador desligado', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I already finished my work.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I can go home now because I already finished.', 'Pessoa pegando o casaco e saindo', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I can go home now because I already finished.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-085-possibilidade-e-escolha-revisitando-might-which', 'conversation', 85, 'Possibilidade e Escolha (Revisitando: Might, Which)', 'Possibilidade e Escolha (Revisitando: Might, Which)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 85; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Possibilidade e Escolha (Revisitando: Might, Which)', 'Possibilidade e Escolha (Revisitando: Might, Which)', 'Core communicative block 85', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I might go.', 'Pessoa em dúvida entre duas portas', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I might go.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I might go to the place you know.', 'Imagem do parque ou café usado em blocos anteriores', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I might go to the place you know.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I don''t know which way is better.', 'Pessoa olhando para um mapa com dois caminhos coloridos', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I don''t know which way is better.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-086-cuidado-e-aten-o-revisitando-look-careful', 'conversation', 86, 'Cuidado e Atenção (Revisitando: Look, Careful)', 'Cuidado e Atenção (Revisitando: Look, Careful)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 86; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Cuidado e Atenção (Revisitando: Look, Careful)', 'Cuidado e Atenção (Revisitando: Look, Careful)', 'Core communicative block 86', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Be careful.', 'Placa de "piso molhado" ou perigo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Be careful.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Be careful with that thing.', 'Alguém segurando uma caixa de vidro frágil', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Be careful with that thing.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You need to look where you go.', 'Pessoa caminhando e olhando para o chão', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You need to look where you go.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-087-rela-es-humanas-revisitando-friend-tell', 'conversation', 87, 'Relações Humanas (Revisitando: Friend, Tell)', 'Relações Humanas (Revisitando: Friend, Tell)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 87; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Relações Humanas (Revisitando: Friend, Tell)', 'Relações Humanas (Revisitando: Friend, Tell)', 'Core communicative block 87', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I will tell.', 'Alguém cochichando ou falando ao telefone', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I will tell.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I will tell my friend.', 'Duas pessoas conversando em um banco', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I will tell my friend.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I will tell him everything I know.', 'Um balão de fala cheio de pequenos ícones/ideias', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I will tell him everything I know.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-088-descoberta-de-solu-es-revisitando-find-way', 'conversation', 88, 'Descoberta de Soluções (Revisitando: Find, Way)', 'Descoberta de Soluções (Revisitando: Find, Way)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 88; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Descoberta de Soluções (Revisitando: Find, Way)', 'Descoberta de Soluções (Revisitando: Find, Way)', 'Core communicative block 88', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Find a way.', 'Alguém em um labirinto vendo a saída', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Find a way.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Find a way to help them.', 'Pessoa entregando uma ferramenta ou recurso para um grupo', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Find a way to help them.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'There is always a way if you try.', 'Uma luz brilhando no fim de um túnel', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'There is always a way if you try.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-089-pensamento-abstrato-revisitando-think-life', 'conversation', 89, 'Pensamento Abstrato (Revisitando: Think, Life)', 'Pensamento Abstrato (Revisitando: Think, Life)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 89; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Pensamento Abstrato (Revisitando: Think, Life)', 'Pensamento Abstrato (Revisitando: Think, Life)', 'Core communicative block 89', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I think about.', 'Pessoa olhando para as estrelas ou para o mar', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I think about.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I think about my life.', 'Flashbacks de momentos felizes e de trabalho', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I think about my life.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I think about my life every day.', 'Calendário com a silhueta da pessoa pensando em cada dia', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I think about my life every day.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-090-mudan-a-e-crescimento-revisitando-become-big', 'conversation', 90, 'Mudança e Crescimento (Revisitando: Become, Big)', 'Mudança e Crescimento (Revisitando: Become, Big)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 90; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Mudança e Crescimento (Revisitando: Become, Big)', 'Mudança e Crescimento (Revisitando: Become, Big)', 'Core communicative block 90', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It becomes.', 'Uma semente virando broto', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It becomes.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'The problem becomes big.', 'Uma pequena rachadura virando um buraco grande', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'The problem becomes big.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It becomes big because we don''t work on it.', 'Pessoa ignorando o problema enquanto ele cresce', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It becomes big because we don''t work on it.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-091-estados-emocionais-revisitando-feel-happy-sad', 'fluency', 91, 'Estados Emocionais (Revisitando: Feel, Happy/Sad)', 'Estados Emocionais (Revisitando: Feel, Happy/Sad)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 91; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Estados Emocionais (Revisitando: Feel, Happy/Sad)', 'Estados Emocionais (Revisitando: Feel, Happy/Sad)', 'Core communicative block 91', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I feel.', 'Rosto neutro', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I feel.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I feel happy today.', 'Rosto sorridente e sol brilhando', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I feel happy today.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I feel happy when I am with you.', 'Duas pessoas rindo juntas', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I feel happy when I am with you.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-092-espa-o-e-ordem-revisitando-place-next-to', 'fluency', 92, 'Espaço e Ordem (Revisitando: Place, Next to)', 'Espaço e Ordem (Revisitando: Place, Next to)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 92; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Espaço e Ordem (Revisitando: Place, Next to)', 'Espaço e Ordem (Revisitando: Place, Next to)', 'Core communicative block 92', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Put it next to.', 'Uma mão colocando uma cadeira ao lado de outra', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Put it next to.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Put it next to the water.', 'Colocar um copo ao lado de uma jarra', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Put it next to the water.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'The place is near the table.', 'Foto de um restaurante mostrando a proximidade dos objetos', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'The place is near the table.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-093-necessidade-de-mudan-a-revisitando-need-change', 'fluency', 93, 'Necessidade de Mudança (Revisitando: Need, Change)', 'Necessidade de Mudança (Revisitando: Need, Change)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 93; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Necessidade de Mudança (Revisitando: Need, Change)', 'Necessidade de Mudança (Revisitando: Need, Change)', 'Core communicative block 93', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I need to change.', 'Pessoa olhando para um guarda-roupa ou para um hábito antigo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I need to change.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I need to change my way.', 'Pessoa mudando a direção em que está caminhando', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I need to change my way.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I need to change because this is bad.', 'Pessoa olhando para algo quebrado ou uma situação negativa', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I need to change because this is bad.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-094-comunica-o-verbal-revisitando-speak-well', 'fluency', 94, 'Comunicação Verbal (Revisitando: Speak, Well)', 'Comunicação Verbal (Revisitando: Speak, Well)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 94; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Comunicação Verbal (Revisitando: Speak, Well)', 'Comunicação Verbal (Revisitando: Speak, Well)', 'Core communicative block 94', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You speak.', 'Pessoa em um palco ou conversando', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You speak.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You speak well.', 'Público aplaudindo ou pessoa com sinal de "legal"', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You speak well.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I understand you because you speak well.', 'Alguém ouvindo com atenção e balançando a cabeça', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I understand you because you speak well.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-095-parte-e-pertencimento-revisitando-part-group', 'fluency', 95, 'Parte e Pertencimento (Revisitando: Part, Group)', 'Parte e Pertencimento (Revisitando: Part, Group)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 95; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Parte e Pertencimento (Revisitando: Part, Group)', 'Parte e Pertencimento (Revisitando: Part, Group)', 'Core communicative block 95', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I am a part.', 'Uma peça de quebra-cabeça encaixando', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I am a part.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I am a part of this group.', 'Foto de equipe ou grupo de amigos', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I am a part of this group.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'This group is important in my life.', 'Coração em volta da foto do grupo', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'This group is important in my life.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-096-mem-ria-e-esquecimento-revisitando-remember-forget', 'fluency', 96, 'Memória e Esquecimento (Revisitando: Remember, Forget)', 'Memória e Esquecimento (Revisitando: Remember, Forget)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 96; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Memória e Esquecimento (Revisitando: Remember, Forget)', 'Memória e Esquecimento (Revisitando: Remember, Forget)', 'Core communicative block 96', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Don''t forget.', 'Nó no dedo ou alarme no celular', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Don''t forget.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Don''t forget the money.', 'Carteira em cima da mesa com um lembrete', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Don''t forget the money.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I always remember it now.', 'Pessoa saindo de casa e pegando a carteira com confiança', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I always remember it now.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-097-inten-o-e-movimento-revisitando-want-bring', 'fluency', 97, 'Intenção e Movimento (Revisitando: Want, Bring)', 'Intenção e Movimento (Revisitando: Want, Bring)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 97; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Intenção e Movimento (Revisitando: Want, Bring)', 'Intenção e Movimento (Revisitando: Want, Bring)', 'Core communicative block 97', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I want to bring.', 'Alguém com uma sacola ou presente', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I want to bring.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I want to bring my friend here.', 'Pessoa apontando para o lugar onde está e pensando no amigo', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I want to bring my friend here.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'He will like this place.', 'O amigo sorrindo na imaginação da pessoa', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'He will like this place.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-098-percep-o-auditiva-revisitando-hear-listen', 'fluency', 98, 'Percepção Auditiva (Revisitando: Hear, Listen)', 'Percepção Auditiva (Revisitando: Hear, Listen)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 98; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Percepção Auditiva (Revisitando: Hear, Listen)', 'Percepção Auditiva (Revisitando: Hear, Listen)', 'Core communicative block 98', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Listen!', 'Pessoa com o dedo na boca pedindo silêncio', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Listen!', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Listen to the world.', 'Pessoa em meio à natureza ou cidade ouvindo os sons', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Listen to the world.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You can hear many things if you are still.', 'Pessoa imóvel e serena ouvindo passarinho ou vento', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You can hear many things if you are still.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-099-tempo-futuro-e-certeza-revisitando-will-happen', 'fluency', 99, 'Tempo Futuro e Certeza (Revisitando: Will, Happen)', 'Tempo Futuro e Certeza (Revisitando: Will, Happen)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 99; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Tempo Futuro e Certeza (Revisitando: Will, Happen)', 'Tempo Futuro e Certeza (Revisitando: Will, Happen)', 'Core communicative block 99', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It will happen.', 'Uma semente prestes a brotar ou um evento marcado', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It will happen.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It will happen soon.', 'Relógio marcando quase a hora', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It will happen soon.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We know it will happen today.', 'Alguém apontando para a data de hoje no calendário', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We know it will happen today.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-100-conclus-o-do-primeiro-ciclo-revisitando-everything-done', 'fluency', 100, 'Conclusão do Primeiro Ciclo (Revisitando: Everything, Done)', 'Conclusão do Primeiro Ciclo (Revisitando: Everything, Done)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 100; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Conclusão do Primeiro Ciclo (Revisitando: Everything, Done)', 'Conclusão do Primeiro Ciclo (Revisitando: Everything, Done)', 'Core communicative block 100', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Everything is.', 'Braços abertos englobando tudo ao redor', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Everything is.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Everything is done.', 'Lista de tarefas toda marcada com "check"', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Everything is done.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I feel good because everything is done.', 'Pessoa relaxando com os pés para cima', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I feel good because everything is done.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-101-escolha-e-consequ-ncia-which-better', 'fluency', 101, 'Escolha e Consequência (Which / Better)', 'Escolha e Consequência (Which / Better)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 101; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Escolha e Consequência (Which / Better)', 'Escolha e Consequência (Which / Better)', 'Core communicative block 101', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Which one?', 'Pessoa apontando para duas opções', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Which one?', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Which way is better?', 'Bifurcação em uma estrada', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Which way is better?', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I need to know which way is better to go.', 'Pessoa olhando para o GPS no celular', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I need to know which way is better to go.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-102-perspectiva-e-tempo-still-not-yet', 'fluency', 102, 'Perspectiva e Tempo (Still / Not yet)', 'Perspectiva e Tempo (Still / Not yet)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 102; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Perspectiva e Tempo (Still / Not yet)', 'Perspectiva e Tempo (Still / Not yet)', 'Core communicative block 102', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Not yet.', 'Um sinal de "espere" ou relógio batendo', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Not yet.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I am not yet at home.', 'Pessoa ainda no ônibus ou carro', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I am not yet at home.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I am still at work, but I will leave soon.', 'Pessoa fechando o escritório tarde da noite', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I am still at work, but I will leave soon.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-103-possibilidade-e-ajuda-might-give', 'fluency', 103, 'Possibilidade e Ajuda (Might / Give)', 'Possibilidade e Ajuda (Might / Give)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 103; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Possibilidade e Ajuda (Might / Give)', 'Possibilidade e Ajuda (Might / Give)', 'Core communicative block 103', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I might.', 'Alguém com expressão de "talvez"', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I might.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I might give you a call.', 'Pessoa segurando o telefone e pensando', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I might give you a call.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I might give you a call if I have the time.', 'Agenda cheia com um espaço livre no fim do dia', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I might give you a call if I have the time.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-104-diferencia-o-e-valor-different-money', 'fluency', 104, 'Diferenciação e Valor (Different / Money)', 'Diferenciação e Valor (Different / Money)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 104; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Diferenciação e Valor (Different / Money)', 'Diferenciação e Valor (Different / Money)', 'Core communicative block 104', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is different.', 'Dois objetos distintos lado a lado', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is different.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'This thing is different.', 'Comparação entre algo barato e algo de luxo', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'This thing is different.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It costs more money because it is different.', 'Etiqueta de preço alta em um objeto artesanal', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It costs more money because it is different.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-105-inten-o-e-movimento-try-follow', 'fluency', 105, 'Intenção e Movimento (Try / Follow)', 'Intenção e Movimento (Try / Follow)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 105; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Intenção e Movimento (Try / Follow)', 'Intenção e Movimento (Try / Follow)', 'Core communicative block 105', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Follow me.', 'Alguém fazendo sinal para ser seguido', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Follow me.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Follow the way I show you.', 'Guia apontando para uma trilha', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Follow the way I show you.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You will find the place if you follow me.', 'Destino aparecendo ao fim do caminho', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You will find the place if you follow me.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-106-cogni-o-e-verdade-believe-real', 'fluency', 106, 'Cognição e Verdade (Believe / Real)', 'Cognição e Verdade (Believe / Real)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 106; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Cognição e Verdade (Believe / Real)', 'Cognição e Verdade (Believe / Real)', 'Core communicative block 106', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Is it real?', 'Alguém tocando algo para ver se existe', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Is it real?', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I believe it is real.', 'Olhar de admiração diante de algo incrível', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I believe it is real.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I believe it because I can see it.', 'Alguém olhando bem de perto para o objeto', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I believe it because I can see it.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-107-uso-de-ferramentas-use-find', 'fluency', 107, 'Uso de Ferramentas (Use / Find)', 'Uso de Ferramentas (Use / Find)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 107; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Uso de Ferramentas (Use / Find)', 'Uso de Ferramentas (Use / Find)', 'Core communicative block 107', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Use this.', 'Alguém entregando uma chave ou controle remoto', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Use this.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Use this to find the problem.', 'Lanterna iluminando um motor', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Use this to find the problem.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is the only way to help now.', 'Pessoa consertando o problema com sucesso', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is the only way to help now.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-108-rela-o-de-espa-o-between-people', 'fluency', 108, 'Relação de Espaço (Between / People)', 'Relação de Espaço (Between / People)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 108; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Relação de Espaço (Between / People)', 'Relação de Espaço (Between / People)', 'Core communicative block 108', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Between them.', 'Um objeto no meio de dois outros', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Between them.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Between these two people.', 'Uma criança entre os pais', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Between these two people.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'There is a big love between them.', 'Um coração unindo as três pessoas', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'There is a big love between them.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-109-condi-o-e-frequ-ncia-always-if', 'fluency', 109, 'Condição e Frequência (Always / If)', 'Condição e Frequência (Always / If)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 109; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Condição e Frequência (Always / If)', 'Condição e Frequência (Always / If)', 'Core communicative block 109', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Always do it.', 'Escovar os dentes ou algo rotineiro', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Always do it.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Always do it this way.', 'Manual de instruções aberto', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Always do it this way.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It will work if you always do it this way.', 'O resultado final perfeito', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It will work if you always do it this way.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-110-fim-e-in-cio-finish-start', 'fluency', 110, 'Fim e Início (Finish / Start)', 'Fim e Início (Finish / Start)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 110; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Fim e Início (Finish / Start)', 'Fim e Início (Finish / Start)', 'Core communicative block 110', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Finish first.', 'Número "1" em destaque antes do "2"', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Finish first.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Finish this part first.', 'Alguém terminando a base de uma construção', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Finish this part first.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Then you can start the new one.', 'Alguém pegando novos materiais para a próxima etapa', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Then you can start the new one.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-111-o-porqu-das-coisas-reason-why', 'fluency', 111, 'O "Porquê" das Coisas (Reason / Why)', 'O "Porquê" das Coisas (Reason / Why)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 111; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'O "Porquê" das Coisas (Reason / Why)', 'O "Porquê" das Coisas (Reason / Why)', 'Core communicative block 111', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'The reason is.', 'Alguém explicando algo com as mãos', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'The reason is.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'This is the reason why.', 'Um quadro negro com uma seta ligando causa e efeito', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'This is the reason why.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'You are the reason why I am happy.', 'Pessoa sorrindo para um amigo', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'You are the reason why I am happy.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-112-quantidade-abstrata-enough-everything', 'fluency', 112, 'Quantidade Abstrata (Enough / Everything)', 'Quantidade Abstrata (Enough / Everything)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 112; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Quantidade Abstrata (Enough / Everything)', 'Quantidade Abstrata (Enough / Everything)', 'Core communicative block 112', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Is it enough?', 'Alguém olhando para um prato ou tanque de combustível', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Is it enough?', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I have enough for everything.', 'Pessoa com mala pronta e carteira organizada', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I have enough for everything.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I don''t need more than this.', 'Pessoa fechando a mala com tranquilidade', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I don''t need more than this.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-113-o-verbo-de-parecer-look-like-same', 'fluency', 113, 'O Verbo de Parecer (Look like / Same)', 'O Verbo de Parecer (Look like / Same)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 113; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'O Verbo de Parecer (Look like / Same)', 'O Verbo de Parecer (Look like / Same)', 'Core communicative block 113', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It looks like.', 'Alguém comparando duas fotos', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It looks like.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It looks like the same thing.', 'Duas chaves quase idênticas', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It looks like the same thing.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'But they are different if you look close.', 'Lupa mostrando detalhes diferentes', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'But they are different if you look close.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-114-express-o-de-desejo-futuro-would-like-go', 'fluency', 114, 'Expressão de Desejo Futuro (Would like / Go)', 'Expressão de Desejo Futuro (Would like / Go)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 114; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Expressão de Desejo Futuro (Would like / Go)', 'Expressão de Desejo Futuro (Would like / Go)', 'Core communicative block 114', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I would like.', 'Alguém sonhando acordado com uma nuvem sobre a cabeça', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I would like.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I would like to go there.', 'Foto de uma praia ou cidade famosa', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I would like to go there.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Maybe next year we can go.', 'Calendário do ano que vem com um círculo', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Maybe next year we can go.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-115-comunica-o-e-sil-ncio-listen-word', 'fluency', 115, 'Comunicação e Silêncio (Listen / Word)', 'Comunicação e Silêncio (Listen / Word)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 115; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Comunicação e Silêncio (Listen / Word)', 'Comunicação e Silêncio (Listen / Word)', 'Core communicative block 115', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'No words.', 'Pessoa com o dedo nos lábios', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'No words.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I have no words to say.', 'Pessoa emocionada ou surpresa', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I have no words to say.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Just listen to my heart.', 'Mão no peito e expressão sincera', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Just listen to my heart.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-116-mudan-a-e-vida-change-life', 'fluency', 116, 'Mudança e Vida (Change / Life)', 'Mudança e Vida (Change / Life)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 116; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Mudança e Vida (Change / Life)', 'Mudança e Vida (Change / Life)', 'Core communicative block 116', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Change is good.', 'Planta crescendo ou lagarta virando borboleta', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Change is good.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'A big change in my life.', 'Mudança de casa ou novo emprego', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'A big change in my life.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Everything is new and I feel great.', 'Pessoa de braços abertos na frente de uma nova vista', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Everything is new and I feel great.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-117-localiza-o-e-dire-o-through-place', 'fluency', 117, 'Localização e Direção (Through / Place)', 'Localização e Direção (Through / Place)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 117; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Localização e Direção (Through / Place)', 'Localização e Direção (Through / Place)', 'Core communicative block 117', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Go through.', 'Carro entrando em um túnel', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Go through.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Go through the city.', 'Linha cruzando o mapa urbano', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Go through the city.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is the fast way to the park.', 'O parque aparecendo do outro lado da cidade', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is the fast way to the park.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-118-certeza-e-d-vida-sure-know', 'fluency', 118, 'Certeza e Dúvida (Sure / Know)', 'Certeza e Dúvida (Sure / Know)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 118; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Certeza e Dúvida (Sure / Know)', 'Certeza e Dúvida (Sure / Know)', 'Core communicative block 118', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Are you sure?', 'Alguém perguntando com a sobrancelha levantada', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Are you sure?', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I am sure about this.', 'Alguém assinando um documento com firmeza', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I am sure about this.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'I know this is the right thing to do.', 'Sinal de "positivo" e olhar confiante', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'I know this is the right thing to do.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-119-necessidade-coletiva-need-each-other', 'fluency', 119, 'Necessidade Coletiva (Need / Each other)', 'Necessidade Coletiva (Need / Each other)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 119; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'Necessidade Coletiva (Need / Each other)', 'Necessidade Coletiva (Need / Each other)', 'Core communicative block 119', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We need.', 'Duas pessoas tentando carregar algo pesado', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We need.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We need each other.', 'Duas pessoas se dando as mãos para subir um degrau', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We need each other.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'We are strong when we are together.', 'Punhos cerrados juntos em sinal de união', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'We are strong when we are together.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
  insert into public.blocks (language_pair_id, slug, phase, block_order, canonical_title, canonical_theme)
  values (v_pair_id, 'block-120-o-fechamento-do-ciclo-everything-done', 'fluency', 120, 'O Fechamento do Ciclo (Everything / Done)', 'O Fechamento do Ciclo (Everything / Done)')
  on conflict (language_pair_id, block_order) do update set
    slug = excluded.slug,
    phase = excluded.phase,
    canonical_title = excluded.canonical_title,
    canonical_theme = excluded.canonical_theme,
    is_active = true
  returning id into v_block_id;
  if v_block_id is null then select id into v_block_id from public.blocks where language_pair_id = v_pair_id and block_order = 120; end if;
  insert into public.block_versions (block_id, version_no, title, theme, objective, editorial_notes, is_published, published_at)
  values (v_block_id, 1, 'O Fechamento do Ciclo (Everything / Done)', 'O Fechamento do Ciclo (Everything / Done)', 'Core communicative block 120', 'Imported from OLAF 120-block source. Review editorial polish before public launch.', true, now())
  on conflict (block_id, version_no) do update set
    title = excluded.title,
    theme = excluded.theme,
    objective = excluded.objective,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.block_versions.published_at, now());
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 1, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 1 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'It is done.', 'Ponto final em um texto ou carimbo de "concluído"', 1.00, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'It is done.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 2, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 2 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Everything we wanted is done.', 'A casa pronta ou o projeto finalizado', 1.35, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Everything we wanted is done.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  insert into public.sentences (block_id, level, sentence_order, kind)
  values (v_block_id, 3, 1, 'core')
  on conflict (block_id, level, sentence_order) do update set kind = excluded.kind
  returning id into v_sentence_id;
  if v_sentence_id is null then select id into v_sentence_id from public.sentences where block_id = v_block_id and level = 3 and sentence_order = 1; end if;
  insert into public.sentence_versions (sentence_id, version_no, target_language_code, text_value, image_path, difficulty, editorial_notes, is_published, published_at)
  values (v_sentence_id, 1, 'en', 'Now we can start a new story.', 'Pessoa fechando um livro e pegando um novo em branco', 1.70, 'Image path stores contextual hint text in this prototype seed.', true, now())
  on conflict (sentence_id, version_no) do update set
    text_value = excluded.text_value,
    image_path = excluded.image_path,
    difficulty = excluded.difficulty,
    editorial_notes = excluded.editorial_notes,
    is_published = true,
    published_at = coalesce(public.sentence_versions.published_at, now())
  returning id into v_sentence_version_id;
  if v_sentence_version_id is null then select id into v_sentence_version_id from public.sentence_versions where sentence_id = v_sentence_id and version_no = 1; end if;
  insert into public.sentence_translations (sentence_version_id, source_language_code, translated_text, support_notes)
  values (v_sentence_version_id, 'pt-BR', 'Now we can start a new story.', 'Prototype placeholder gloss copied from target sentence; replace with editorial PT-BR translation before release.')
  on conflict (sentence_version_id, source_language_code) do update set
    translated_text = excluded.translated_text,
    support_notes = excluded.support_notes;
  v_block_id := null;
  v_sentence_id := null;
  v_sentence_version_id := null;
end $$;
commit;