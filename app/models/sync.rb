# frozen_string_literal: true

class Sync < ApplicationRecord
  validates :workspace_id, presence: true
  validates :source_id, presence: true
  validates :destination_id, presence: true
  validates :model_id, presence: true
  validates :configuration, presence: true
  validates :schedule_type, presence: true
  validates :sync_interval, presence: true
  validates :sync_interval_unit, presence: true

  validates :status, presence: true

  enum :schedule_type, %i[manual automated]
  enum :status, %i[healthy failed aborted in_progress disabled]
  enum :sync_mode, %i[full_refresh incremental]

  enum :sync_interval_unit, %i[hours days weeks]

  belongs_to :workspace
  belongs_to :source, class_name: "Connector"
  belongs_to :destination, class_name: "Connector"
  belongs_to :model
  has_many :sync_runs, dependent: :nullify
end
