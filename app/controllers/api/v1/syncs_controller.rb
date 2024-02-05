# frozen_string_literal: true

module Api
  module V1
    class SyncsController < ApplicationController
      include Syncs
      before_action :set_sync, only: %i[show update destroy]

      attr_reader :sync

      def index
        @syncs = current_workspace
                 .syncs.all.page(params[:page] || 1)
        _track_event(TRACKER["events"]["syncs"]["viewed_all"], { count: @syncs.count })
        render json: @syncs, status: :ok
      end

      def show
        _track_event(TRACKER["events"]["syncs"]["viewed"], { sync_id: @sync.id })
        render json: @sync, status: :ok
      end

      def create
        result = CreateSync.call(
          workspace: current_workspace,
          sync_params:
        )

        if result.success?
          @sync = result.sync
          _track_event(TRACKER["events"]["syncs"]["created"], { sync_id: @sync.id })
          render json: @sync, status: :created
        else
          render_error(
            message: "Sync creation failed",
            status: :unprocessable_entity,
            details: format_errors(result.sync)
          )
        end
      end

      def update
        result = UpdateSync.call(
          sync:,
          sync_params:
        )

        if result.success?
          @sync = result.sync
          _track_event(TRACKER["events"]["syncs"]["updated"], { sync_id: @sync.id })
          render json: @sync, status: :ok
        else
          render_error(
            message: "Sync update failed",
            status: :unprocessable_entity,
            details: format_errors(result.sync)
          )
        end
      end

      def destroy
        _track_event(TRACKER["events"]["syncs"]["deleted"], { sync_id: @sync.id })
        sync.destroy!
        head :no_content
      end

      # TODO: Sync trigger API
      # def trigger; end

      private

      def set_sync
        @sync = current_workspace.syncs.find(params[:id])
      end

      def sync_params
        params.require(:sync).permit(:source_id,
                                     :destination_id,
                                     :model_id,
                                     :schedule_type,
                                     :status,
                                     :sync_interval,
                                     :sync_mode,
                                     :sync_interval_unit,
                                     :stream_name,
                                     configuration: {})
              .merge(workspace_id: current_workspace.id)
      end
    end
  end
end
