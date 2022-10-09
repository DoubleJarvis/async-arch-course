Rails.application.routes.draw do
  devise_for :accounts

  root to: 'accounts#index'

  resources :accounts, only: [:edit, :update, :destroy]
  get '/accounts/current', to: 'accounts#current'
end
