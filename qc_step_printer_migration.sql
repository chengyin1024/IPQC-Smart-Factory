-- QC 各道印刷手：讓多道印刷的完成數量與 NG 正確歸屬到實際參與人員。
-- 請在 Supabase SQL Editor 執行一次；只新增欄位，不會修改既有資料。

alter table public.qc_batch_steps
  add column if not exists printer_name text;
