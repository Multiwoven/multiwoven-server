# frozen_string_literal: true

module Connectors
  class CreateConnector
    include Interactor

    def call
      connector = context.workspace
                         .connectors
                         .create(context.connector_params)

      if connector.persisted?
        context.connector = connector
      else
        context.fail!(connector:)
      end
    end
  end
end
