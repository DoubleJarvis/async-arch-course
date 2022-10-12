Rails.application.routes.draw do
  devise_for :accounts, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :tasks

  root to: 'tasks#index'
end
