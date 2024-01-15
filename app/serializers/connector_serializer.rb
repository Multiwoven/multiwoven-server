class ConnectorSerializer < ActiveModel::Serializer
  attributes :id, :workspace_id, :connector_type, :connector_definition_id, :configuration, :name, :description, :created_at, :updated_at, :connector_name
end