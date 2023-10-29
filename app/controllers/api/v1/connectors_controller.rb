# frozen_string_literal: true

module Api
  module V1
    class ConnectorsController < ApplicationController
      include Connectors

      before_action :set_connector, only: %i[update]

      def index
        @connectors = current_workspace
                      .connectors.all.page(params[:page] || 1)
      end

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

      def update
        result = UpdateConnector.call(
          connector: @connector,
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

      def set_connector
        @connector = current_workspace.connectors.find(params[:id])
      end

      def connector_params
        params.require(:connector).permit(:workspace_id,
                                          :connector_definition_id,
                                          :connector_type, :name,
                                          configuration: {})
      end
    end
  end
end
