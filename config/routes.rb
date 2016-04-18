Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  namespace :admin do
    resources :api_clients do
      resource :api_secret, only: :update, module: :api_clients
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
end
