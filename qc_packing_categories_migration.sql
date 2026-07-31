-- V4.5：包裝成品 NG 分為印刷與烤漆兩類
-- 請在 Supabase 的 SQL Editor 執行一次。

alter table public.qc_batches
  add column if not exists packing_printing_ng integer not null default 0 check (packing_printing_ng >= 0),
  add column if not exists packing_baking_ng integer not null default 0 check (packing_baking_ng >= 0);
