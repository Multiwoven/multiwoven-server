# frozen_string_literal: true

# spec/factories/workspace_users.rb

FactoryBot.define do
  factory :workspace_user do
    workspace
    user
    role { "admin" }
  end
end
