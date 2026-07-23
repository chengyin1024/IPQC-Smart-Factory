-- Supabase 資料表草案（正式多人同步版使用）
create table public.ipqc_records (
  id uuid primary key default gen_random_uuid(),
  inspection_date date not null,
  inspection_time time not null,
  part_no text not null,
  operator_name text,
  inspector_name text,
  machine text,
  printing_a_ok integer default 0,
  printing_a_ng integer default 0,
  printing_b_ok integer default 0,
  printing_b_ng integer default 0,
  packing_ok integer default 0,
  packing_ng integer default 0,
  ng_reason text,
  note text,
  alcohol_result text default 'pending',
  tape_result text default 'pending',
  reliability_tester text,
  reliability_note text,
  created_by uuid,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.qc_reports (
  id uuid primary key default gen_random_uuid(),
  report_date date not null,
  qc_account text not null,
  printed_quantity integer default 0,
  printing_ng integer default 0,
  baking_ng integer default 0,
  material_ng integer default 0,
  created_by text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
