# frozen_string_literal: true

class EventLog < ApplicationRecord
  belongs_to :organization
  belongs_to :workspace
  belongs_to :user, optional: true
end
