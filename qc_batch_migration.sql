-- V4.3：QC 多道印刷與交接
-- 請在 Supabase 的 SQL Editor 執行一次。

create table if not exists public.qc_batches (
  id uuid primary key default gen_random_uuid(),
  batch_no text not null unique,
  part_number text not null,
  printer_name text,
  status text not null default 'in_progress' check (status in ('in_progress', 'completed')),
  total_quantity integer,
  started_by text not null,
  started_at timestamptz not null default now(),
  completed_by text,
  completed_date date,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.qc_batch_steps (
  id uuid primary key default gen_random_uuid(),
  batch_id uuid not null references public.qc_batches(id) on delete cascade,
  step_number integer not null check (step_number > 0),
  machine_name text not null,
  qc_account text not null,
  printing_ng integer not null default 0 check (printing_ng >= 0),
  baking_ng integer not null default 0 check (baking_ng >= 0),
  material_ng integer not null default 0 check (material_ng >= 0),
  completed_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  unique (batch_id, step_number)
);

alter table public.qc_batches add column if not exists completed_date date;

create index if not exists qc_batches_status_started_at_idx on public.qc_batches (status, started_at desc);
create index if not exists qc_batches_part_completed_date_idx on public.qc_batches (part_number, completed_date desc);
create index if not exists qc_batch_steps_batch_id_idx on public.qc_batch_steps (batch_id, step_number);

grant select, insert, update, delete on public.qc_batches to anon, authenticated;
grant select, insert, update, delete on public.qc_batch_steps to anon, authenticated;
