# frozen_string_literal: true

module Api
  module V1
    class ConnectorDefinitionsController < ApplicationController
      before_action :set_connectors, only: %i[show index]
      before_action :set_connector_client, only: %i[check_connection]

      def index
        render json: @connectors
      end

      def show
        @connector = @connectors.find do |hash|
          hash[:name].downcase == connector_definitions_params[:id].downcase
        end
        render json: @connector || []
      end

      def check_connection
        connection_spec = connector_definitions_params[:connection_spec]
        connection_spec = connection_spec.to_unsafe_h if connection_spec.respond_to?(:to_unsafe_h)
        connection_status = @connector_client
                            .check_connection(
                              connection_spec
                            )

        render json: connection_status
      end

      private

      def set_connectors
        @connectors = Multiwoven::Integrations::Service
                      .connectors
                      .with_indifferent_access
        @connectors = @connectors[connector_definitions_params[:type]] if connector_definitions_params[:type]
      end

      def set_connector_client
        @connector_client = Multiwoven::Integrations::Service
                            .connector_class(
                              connector_definitions_params[:type].camelize,
                              connector_definitions_params[:connector_name].camelize
                            ).new
      end

      def connector_definitions_params
				params.permit(:type,
											:connector_name,
											:id,
											connection_spec: {})
      end
    end
  end
end
