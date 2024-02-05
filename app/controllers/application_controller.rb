# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  include ExceptionHandler
  include ScriptVault::Tracker
  before_action :authenticate_user!
  around_action :handle_with_exception
  # after_action :event_logger

  private

  # Override Devise's method to handle authentication
  def authenticate_user!
    return if user_signed_in?

    # If not authenticated, return a 401 unauthorized response
    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def current_workspace
    @current_workspace ||= current_user.workspaces.first
  end

  def current_organization
    @current_organization ||= current_workspace.organization
  end

  protected

  def format_errors(model)
    model.errors.messages.each_with_object({}) do |(attribute, messages), formatted_errors|
      formatted_errors[attribute.to_s] = messages.first
    end
  end

  def render_error(message:, status:, details: nil)
    error_response = {
      errors: [
        {
          status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
          title: "Error",
          detail: message
        }
      ]
    }
    error_response[:errors][0][:source] = details if details
    render json: error_response, status:
  end

  def event_logger
    metadata = {}
    metadata[:connector_name] = @connector.connector_name if @connector.present?
    _track_event("#{params[:controller]}##{params[:action]}", {}.merge(metadata))
  end
end
