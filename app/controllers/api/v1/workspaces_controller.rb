# app/controllers/api/v1/workspaces_controller.rb
module Api
  module V1
    class WorkspacesController < ApplicationController
    include Workspaces

      def index
        result = ListAll.call(user: current_user)
        @workspaces = result.workspaces
      end

      def create
        result = Create.call(user: current_user, workspace_params: workspace_params)
        if result.success?
          @workspace = result.workspace
          render :show, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      def update
        result = Update.call(id: params[:id], user: current_user, workspace_params: workspace_params)
        if result.success?
          @workspace = result.workspace
          render :show, status: :ok
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        Delete.call(id: params[:id], user: current_user)
        head :no_content
      end

      private

      def workspace_params
        params.require(:workspace).permit(:name)
      end
    end
  end
end
