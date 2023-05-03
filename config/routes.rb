Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'client/sessions', registrations: 'client/registrations' }
    namespace :client, path: '' do
      root 'home#index'
      resource :home
      resource :profile, only: [:show, :edit]
      resources :invites, only: :index
      resources :user_addresses
    end

  end

  constraints(AdminDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'admin/sessions' }, as: 'admin'
    namespace :admin, path: '' do
      root 'home#index'
      resource :home
    end
  end

  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
  end
end
