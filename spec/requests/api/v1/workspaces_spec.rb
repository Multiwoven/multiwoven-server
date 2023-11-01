# spec/requests/api/v1/workspaces_spec.rb

require 'swagger_helper'

RSpec.describe "API::V1::Workspaces", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }

  path '/api/v1/workspaces' do

    get 'Lists all workspaces' do
      tags 'Workspaces'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearerAuth: [] }] # This line indicates that this endpoint is secured using the 'bearerAuth' security scheme
       
      response '200', 'Workspaces retrieved' do
        let(:'Authorization') { headers['Authorization'] }

        before { create_list(:workspace, 5) }

        run_test!
      end
    end
  end
end
