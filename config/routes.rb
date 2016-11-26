SocialFridgeApi::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'application#index'

  require 'sidekiq/web'
  require 'sidetiq/web'
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
    resources :volunteers do
      collection do
        post :fb_connect
        get :me
      end
    end
    resources :donators, only: [:index, :create, :update] do
      collection do
        get :me
      end
    end
    resources :donations, only: [:create] do
      member do
        post :activate
        post :finish
        post :cancel
        post :reopen
        post :ongoing
      end

      collection do
        get :active
        get :open
        get :finished
      end
    end
    resources :o_auth, only: [] do
      collection do
        post :token
        post :save_token
        post :delete_token
      end
    end
  end
end
