# frozen_string_literal: true

class SyncRecord < ApplicationRecord
  validates :sync_id, presence: true
  validates :sync_run_id, presence: true
  validates :record, presence: true
  validates :fingerprint, presence: true

  belongs_to :sync
  belongs_to :sync_run
end
