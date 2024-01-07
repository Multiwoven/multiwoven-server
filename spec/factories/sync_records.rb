# frozen_string_literal: true

FactoryBot.define do
  factory :sync_record do
    sync_id { 1 }
    sync_run_id { 1 }
    record { "" }
    fingerprint { "MyString" }
  end
end
