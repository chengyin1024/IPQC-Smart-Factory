-- IPQC 巡檢：印刷 A、印刷 B 各自的備註／處理方式
-- 請在 Supabase 的 SQL Editor 執行一次。

alter table public.inspections
  add column if not exists printing_a_notes text,
  add column if not exists printing_b_notes text;
