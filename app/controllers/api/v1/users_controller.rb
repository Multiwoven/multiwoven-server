# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_after_action :event_logger
      def me
        render json: current_user, status: :ok
      end
    end
  end
end
