-- QC 印刷難度星級：請在 Supabase SQL Editor 執行一次。

alter table public.part_numbers add column if not exists difficulty_level smallint check (difficulty_level between 1 and 3);
alter table public.part_numbers add column if not exists difficulty_set_by text;
alter table public.part_numbers add column if not exists difficulty_set_at timestamptz;

alter table public.qc_batches add column if not exists difficulty_level smallint check (difficulty_level between 1 and 3);
alter table public.qc_batches add column if not exists difficulty_factor numeric(4,2);

-- 既有歷史批次採一星基準；本次更新後的新料號才會進入待評清單。
update public.qc_batches
set difficulty_level = 1, difficulty_factor = 1.00
where difficulty_level is null and status = 'completed';

create index if not exists qc_batches_pending_difficulty_idx
on public.qc_batches (status, difficulty_level, completed_at desc);
