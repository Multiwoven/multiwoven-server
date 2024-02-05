# frozen_string_literal: true

module Api
  module V1
    class ModelsController < ApplicationController
      include Models
      attr_reader :connector, :model

      before_action :set_connector, only: %i[create]
      before_action :set_model, only: %i[show update destroy]

      def index
        @models = current_workspace
                  .models.all.page(params[:page] || 1)
        _track_event(TRACKER["events"]["models"]["viewed_all"], { count: @models.count })
        render json: @models, status: :ok
      end

      def show
        _track_event(TRACKER["events"]["models"]["viewed"], { model_id: @model.id })
        render json: @model, status: :ok
      end

      def create
        result = CreateModel.call(
          connector:,
          model_params:
        )
        if result.success?
          @model = result.model
          _track_event(TRACKER["events"]["models"]["created"], { model_id: @model.id })
          render json: @model, status: :created
        else
          render_error(
            message: "Model creation failed",
            status: :unprocessable_entity,
            details: format_errors(result.model)
          )
        end
      end

      def update
        result = UpdateModel.call(
          model:,
          model_params:
        )

        if result.success?
          @model = result.model
          _track_event(TRACKER["events"]["models"]["updated"], { model_id: @model.id })
          render json: @model, status: :ok
        else
          render_error(
            message: "Model update failed",
            status: :unprocessable_entity,
            details: format_errors(result.model)
          )
        end
      end

      def destroy
        _track_event(TRACKER["events"]["models"]["deleted"], { model_id: @model.id })
        model.destroy!
        head :no_content
      end

      private

      def set_connector
        @connector = current_workspace.connectors.find(model_params[:connector_id])
      end

      def set_model
        @model = current_workspace.models.find(params[:id])
      end

      def model_params
        params.require(:model).permit(:connector_id,
                                      :name,
                                      :description,
                                      :query,
                                      :query_type,
                                      :primary_key).merge(workspace_id: current_workspace.id)
      end
    end
  end
end
