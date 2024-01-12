# frozen_string_literal: true

# == Schema Information
#
# Table name: models
#
#  id           :bigint           not null, primary key
#  name         :string
#  workspace_id :integer
#  connector_id :integer
#  query        :text
#  query_type   :integer
#  primary_key  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Model < ApplicationRecord
  validates :workspace_id, presence: true
  validates :connector_id, presence: true
  validates :name, presence: true
  validates :query, presence: true
  enum :query_type, %i[raw_sql]

  belongs_to :workspace
  belongs_to :connector

  has_many :syncs, dependent: :nullify
end
