# spec/factories/users.rb

FactoryBot.define do
    factory :user do
      email { "user@example.com" }
      password { "password" }
      password_confirmation { "password" }
      # Add other fields here as required for your model
    end
  end
  