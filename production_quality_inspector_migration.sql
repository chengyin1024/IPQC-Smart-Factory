-- 生產單固定品檢人員：建立生產時選一次，後續 IPQC 自動帶入。
alter table public.production_orders
  add column if not exists quality_inspector_name text;

comment on column public.production_orders.quality_inspector_name is
  '建立生產單時指定的品檢人員，多人以｜分隔；後續 IPQC 巡檢自動沿用';
