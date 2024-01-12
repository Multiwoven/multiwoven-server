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
class Catalog < ApplicationRecord
  belongs_to :workspace
  belongs_to :connector

  validates :workspace_id, presence: true
  validates :connector_id, presence: true
  validates :catalog, presence: true
  validates :catalog_hash, presence: true
end
