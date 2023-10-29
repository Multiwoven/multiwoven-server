# frozen_string_literal: true

module Api
  module V1
    class ModelsController < ApplicationController
      include Models

      before_action :set_connector
      attr_reader :connector, :model

      def create
        result = CreateModel.call(
          connector:,
          model_params:
        )

        if result.success?
          @model = result.model
        else
          render json: { errors: result.errors },
                 status: :unprocessable_entity
        end
      end

      private

      def set_connector
        @connector = current_workspace.connectors.find(model_params[:connector_id])
      end

      def model_params
        params.require(:model).permit(:connector_id,
                                      :name,
                                      :query,
                                      :query_type).merge(workspace_id: current_workspace.id)
      end
    end
  end
end
