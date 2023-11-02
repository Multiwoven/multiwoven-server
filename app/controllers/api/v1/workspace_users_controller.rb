# frozen_string_literal: true

module Api
  module V1
    class WorkspaceUsersController < ApplicationController
      include WorkspaceUsers
      before_action :set_workspace
      before_action :authorize_admin!, except: [:index]

      # POST /api/v1/workspaces/:workspace_id/workspace_users
      def create
        result = Create.call(workspace: @workspace, user_params: workspace_user_params)

        if result.success?
          render json: { message: "User added to workspace." }, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/workspaces/:workspace_id/workspace_users
      def index
        result = List.call(workspace: @workspace)

        render json: result.workspace_users
      end

      # PUT /api/v1/workspaces/:workspace_id/workspace_users/:id
      def update
        result = Update.call(id: params[:id], role: params[:role])

        if result.success?
          render json: { message: "User role updated." }, status: :ok
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/workspaces/:workspace_id/workspace_users/:id
      def destroy
        result = Delete.call(id: params[:id])

        if result.success?
          head :no_content
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_workspace
        @workspace = Workspace.find(params[:workspace_id])
      end

      def authorize_admin!
        workspace_user = WorkspaceUser.find_by(workspace: @workspace, user: current_user)
        return if workspace_user&.role == "admin"

        render json: { error: "Unauthorized" }, status: :unauthorized
      end

      def workspace_user_params
        params.require(:workspace_user).permit(:email, :role)
      end
    end
  end
end
