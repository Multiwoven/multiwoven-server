Rails.application.routes.draw do
  devise_for :users
  # Health Check
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  
  namespace :v1 do
    # Authentication Routes
    post 'signup', to: 'auth#signup'
    post 'verify_code', to: 'auth#verify_code'
    post 'login', to: 'auth#login'
    delete 'logout', to: 'auth#logout'
    post 'forgot_password', to: 'auth#forgot_password'
    post 'reset_password', to: 'auth#reset_password'

    # Workspace Routes
    resources :workspaces do
      resources :workspace_users, only: [:create, :index, :update, :destroy]
    end
    resources :connectors
    resources :models
    resources :syncs
  end
  

  # Uncomment below if you have a root path
  root "rails/health#show"
end