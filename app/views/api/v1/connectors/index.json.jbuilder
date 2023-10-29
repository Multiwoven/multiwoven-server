# frozen_string_literal: true

json.array! @connectors do |connector|
  json.partial! "api/v1/models/connector", formats: [:json], connector:
end
