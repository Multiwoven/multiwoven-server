# frozen_string_literal: true

class SyncRun < ApplicationRecord
  validates :sync_id, presence: true
  validates :status, presence: true

  validates :started_at, presence: true
  validates :finished_at, presence: true
  validates :total_rows, presence: true
  validates :successful_rows, presence: true
  validates :failed_rows, presence: true

  enum :status, %i[pending in_progress success failed incomplete]

  belongs_to :sync
  has_many :sync_records, dependent: :nullify
end
