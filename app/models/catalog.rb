# frozen_string_literal: true

class Catalog < ApplicationRecord
  belongs_to :workspace
  belongs_to :connector

  validates :workspace_id, presence: true
  validates :connector_id, presence: true
  validates :catalog, presence: true
  validates :catalog_hash, presence: true

  def find_stream_by_name(name)
    catalog["streams"].find { |stream| stream["name"] == name }
  end
end
