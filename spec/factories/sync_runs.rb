FactoryBot.define do
  factory :sync_run do
    sync_id { 1 }
    status { 1 }
    started_at { "2024-01-08 01:47:34" }
    finished_at { "2024-01-08 01:47:34" }
    total_rows { 1 }
    successful_rows { 1 }
    failed_rows { 1 }
    error { "MyText" }
  end
end
