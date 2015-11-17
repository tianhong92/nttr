Rails.application.routes.draw do
  resources :users
  resources :user_sessions, only: [:new, :create, :destory]

  root 'users#index'

  match '/register', to: 'users#new', via: :all
  match '/login', to: 'user_sessions#new', via: :all
  match '/logout', to: 'user_sessions#destroy', via: :all
end
