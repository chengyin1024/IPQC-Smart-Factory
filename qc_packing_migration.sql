-- V4.4：包裝成品 NG 登記（3F3 專用）
-- 請在 Supabase 的 SQL Editor 執行一次。

alter table public.qc_batches
  add column if not exists packing_ng integer not null default 0 check (packing_ng >= 0);

alter table public.qc_batches
  drop constraint if exists qc_batches_status_check;

alter table public.qc_batches
  add constraint qc_batches_status_check
  check (status in ('in_progress', 'awaiting_packing', 'completed'));
