Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  namespace :admin do
    resources :api_clients do
      resource :app_secret, only: :update, module: :api_clients
    end
  end

  namespace :api do
    namespace :v1 do
      resources :projects, only: [:index, :create, :update, :destroy]
    end
  end

  devise_scope :user do
    authenticated :user do
      root 'admin/api_clients#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
