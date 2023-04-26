Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'client/sessions' }
    namespace :client, path: '' do
      root 'home#index'
      resource :home
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
