# frozen_string_literal: true

class Connector < ApplicationRecord
  validates :workspace_id, presence: true
  validates :connector_type, presence: true
  validates :configuration, presence: true

  # User defined name for this connector eg: reporting warehouse
  validates :name, presence: true
  # Connector name eg: snowflake
  validates :connector_name, presence: true

  enum :connector_type, %i[source destination]

  belongs_to :workspace

  has_many :models, dependent: :nullify
  has_one :catalog, dependent: :nullify

  # TODO: - Validate configuration using JSON schema
end
