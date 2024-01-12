# frozen_string_literal: true

# == Schema Information
#
# Table name: catalogs
#
#  id           :bigint           not null, primary key
#  workspace_id :integer
#  connector_id :integer
#  catalog      :jsonb
#  catalog_hash :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :catalog do
    association :workspace
    association :connector
    catalog { Faker::Name.name }
    catalog_hash { 1 }
  end
end
