-- Correct the newly-added half-star level from 1.5 to 0.5 and keep its KPI weight linear.
alter table public.part_numbers
  drop constraint if exists part_numbers_difficulty_level_check;

alter table public.qc_batches
  drop constraint if exists qc_batches_difficulty_level_check;

update public.part_numbers
set difficulty_level = 0.5
where difficulty_level = 1.5;

update public.qc_batches
set difficulty_level = 0.5,
    difficulty_factor = 0.875
where difficulty_level = 1.5;

alter table public.part_numbers
  add constraint part_numbers_difficulty_level_check
  check (difficulty_level in (0.5, 1, 2, 3));

alter table public.qc_batches
  add constraint qc_batches_difficulty_level_check
  check (difficulty_level in (0.5, 1, 2, 3));
