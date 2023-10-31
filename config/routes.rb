Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users
  # Health Check
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication Routes
      post 'signup', to: 'auth#signup'
      post 'verify_code', to: 'auth#verify_code'
      post 'login', to: 'auth#login'
      delete 'logout', to: 'auth#logout'
      post 'forgot_password', to: 'auth#forgot_password'
      post 'reset_password', to: 'auth#reset_password'

      # Workspace Routes
      resources :workspaces
      resources :connectors
      resources :models
      resources :syncs
    end
  end

  # Uncomment below if you have a root path
  root "rails/health#show"
end