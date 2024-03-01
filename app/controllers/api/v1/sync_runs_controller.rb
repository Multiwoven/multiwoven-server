# frozen_string_literal: true

module Api
  module V1
    class SyncRunsController < ApplicationController
      skip_before_action :validate_contract
      def index
        sync_runs = current_workspace.syncs.find(params[:sync_id]).sync_runs
        sync_runs = sync_runs.where(status: params[:status]) if params[:status].present?
        sync_runs = sync_runs.page(params[:page] || 1)
        render json: sync_runs, status: :ok
      end
    end
  end
end
