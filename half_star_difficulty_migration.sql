-- 新增一星半印刷難度。請在 Supabase SQL Editor 執行一次。

alter table public.part_numbers
  drop constraint if exists part_numbers_difficulty_level_check;
alter table public.part_numbers
  alter column difficulty_level type numeric(2,1) using difficulty_level::numeric;
alter table public.part_numbers
  add constraint part_numbers_difficulty_level_check
  check (difficulty_level in (1, 1.5, 2, 3));

alter table public.qc_batches
  drop constraint if exists qc_batches_difficulty_level_check;
alter table public.qc_batches
  alter column difficulty_level type numeric(2,1) using difficulty_level::numeric;
alter table public.qc_batches
  alter column difficulty_factor type numeric(5,3) using difficulty_factor::numeric;
alter table public.qc_batches
  add constraint qc_batches_difficulty_level_check
  check (difficulty_level in (1, 1.5, 2, 3));
