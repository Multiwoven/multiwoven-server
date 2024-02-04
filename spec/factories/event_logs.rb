# frozen_string_literal: true

FactoryBot.define do
  factory :event_log do
    event_name { "MyString" }
    properties { "" }
    organization { nil }
    workspace { nil }
  end
end
