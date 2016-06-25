SocialFridgeApi::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'application#index'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'

  # Health endpoints
  scope '/health' do
    get '/', to: 'application#health'
    # resources :sidekiq, controller: :sidekiq_health, only: [] do
    #   collection do
    #     get :queues_size
    #     get :latency
    #     get :processes_size
    #   end
    # end
  end


# API Endpoints
  api_version(module:  'api/v1', path: { value: 'api/v1' }, defaults: { format: :json }) do

    resources :fridges, only: [:index, :create]
    resources :volunteers, only: [:index, :create]
    resources :donators, only: [:index, :create]
    resources :o_auth, contoller: :o_auth, only: [] do 
      collection do
        post :token
      end
    end
  end
end
