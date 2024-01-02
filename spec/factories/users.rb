# frozen_string_literal: true

# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }
    trait :verified do
      confirmed_at { Time.current }
    end
  end
end
