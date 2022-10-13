Rails.application.routes.draw do
  devise_for :accounts, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :tasks, only: %i[create index] do
    post :finish, on: :member

    get :reassign, on: :collection
  end

  root to: 'tasks#index'
end
