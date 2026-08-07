-- V4.6：包裝 NG 與 QC 批次分流
-- 請在 Supabase SQL Editor 執行一次

create table if not exists public.packing_reports (
  id bigint generated always as identity primary key,
  report_date date not null default current_date,
  part_number text not null check (length(trim(part_number)) > 0),
  printing_ng integer not null default 0 check (printing_ng >= 0),
  baking_ng integer not null default 0 check (baking_ng >= 0),
  material_ng integer not null default 0 check (material_ng >= 0),
  created_by text not null default '3F3',
  created_at timestamptz not null default now()
);

-- 可重複執行：若曾安裝舊版包裝表，自動補上三種 NG 欄位。
alter table public.packing_reports
  add column if not exists printing_ng integer not null default 0 check (printing_ng >= 0),
  add column if not exists baking_ng integer not null default 0 check (baking_ng >= 0),
  add column if not exists material_ng integer not null default 0 check (material_ng >= 0);

create index if not exists packing_reports_date_created_idx
  on public.packing_reports (report_date, created_at desc);

alter table public.packing_reports enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'packing_reports'
      and policyname = 'packing_reports_public_access'
  ) then
    create policy packing_reports_public_access
      on public.packing_reports for all
      to anon, authenticated
      using (true)
      with check (true);
  end if;
end $$;

-- 舊版本已送包裝、但尚未結案的 QC 批次，改為 QC 已完成。
update public.qc_batches
set status = 'completed',
    completed_by = coalesce(completed_by, 'QC舊資料轉換'),
    completed_date = coalesce(completed_date, (updated_at at time zone 'Asia/Taipei')::date),
    completed_at = coalesce(completed_at, updated_at, now()),
    updated_at = now()
where status = 'awaiting_packing';
