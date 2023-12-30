require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  # Helper method to parse JSON response
  def json_response
    JSON.parse(response.body)
  end

  describe 'POST #signup' do
    context 'with valid parameters' do
      it 'creates a new user and returns a success message' do
        post :signup, params: { email: 'test@example.com', password: 'password123', password_confirmation: 'password123' }

        expect(response).to have_http_status(:created)
        expect(json_response['message']).to eq('Signup successful!')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user and returns an error' do
        post :signup, params: { email: 'test', password: 'pass', password_confirmation: 'wrong' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).not_to be_nil
      end
    end
  end
end
