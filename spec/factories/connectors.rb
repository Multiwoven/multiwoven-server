# frozen_string_literal: true

FactoryBot.define do
  factory :connector do
    association :workspace
    connector_type { 1 }
    configuration { { test: "test" } }
    name { Faker::Name.name }
  end
end
