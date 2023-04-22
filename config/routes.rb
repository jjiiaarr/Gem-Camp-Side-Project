Rails.application.routes.draw do
  devise_for :users

  root 'home#index'

  namespace :admin do
    resources :users
  end
end
