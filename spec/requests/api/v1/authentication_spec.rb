# frozen_string_literal: true

# spec/requests/api/v1/authentication_spec.rb
require "swagger_helper"

RSpec.describe "API::V1::Authentication", type: :request do
  # Define a path for the login operation
  path "/api/v1/login" do
    # HTTP POST operation for the login
    post "Logs in a user" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      # Define parameters and their specifications
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      # Define the response for a successful operation (HTTP 200)
      response "200", "User logged in" do
        # Create a user record for the test
        let(:user) { create(:user, password: "password", password_confirmation: "password") }
        let(:credentials) { { email: user.email, password: "password" } }

        # Run the test and validate the response
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key("token")
        end
      end

      # Define the response for an unsuccessful operation (HTTP 401)
      response "401", "Invalid credentials" do
        let(:credentials) { { email: "invalid@example.com", password: "wrong_password" } }

        run_test!
      end
    end
  end
end
