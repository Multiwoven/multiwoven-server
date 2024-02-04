# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Tracker
  def _track_event(event_name, properties = {})
    EventLog.create!(
      event_name:,
      properties: properties.merge({ time: Time.zone.now.utc.to_i }),
      organization: current_organization,
      workspace: current_workspace,
      user: current_user
    )
  rescue StandardError => e
    Rails.logger.error "Failed to track event: #{e.message}"
  end
end
