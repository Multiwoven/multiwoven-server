# frozen_string_literal: true

module Api
  module V1
    class SyncRecordsController < ApplicationController
      skip_before_action :validate_contract
      def index
        sync_records = current_workspace.syncs.find(params[:sync_id]).sync_runs.find(params[:sync_run_id]).sync_records
        sync_records = sync_records.where(status: params[:status]) if params[:status].present?

        sync_records = sync_records.page(params[:page] || 1)
        render json: sync_records, status: :ok
      end
    end
  end
end
