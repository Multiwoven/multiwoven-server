# frozen_string_literal: true

module Api
  module V1
    class ConnectorsController < ApplicationController
      include Connectors
      def create
        result = CreateConnector.call(
          workspace: current_workspace,
          connector_params:
        )

        if result.success?
          @connector = result.connector
        else
          render json: { errors: result.errors },
                 status: :unprocessable_entity
        end
      end

      private

      def connector_params
        params.require(:connector).permit(:workspace_id,
                                          :connector_definition_id,
                                          :connector_type, :name,
                                          configuration: {})
      end
    end
  end
end
