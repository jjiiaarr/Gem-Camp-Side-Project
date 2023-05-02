Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'client/sessions', registrations: 'client/registrations' }
    namespace :client, path: '' do
      root 'home#index'
      resource :home
      resource :profile, only: [:show, :edit]
      resources :invites, only: :index
      resources :user_address
    end

  end

  constraints(AdminDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'admin/sessions' }, as: 'admin'
    namespace :admin, path: '' do
      root 'home#index'
      resource :home
    end
  end
end
