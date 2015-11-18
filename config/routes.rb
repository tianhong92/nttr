Rails.application.routes.draw do
  resources :users do 
    # Wild tweets can only be created, read and destroyed, not changed.
    # resources :tweets, only: [:new, :create, :destory, :show, :index, :delete] do 
    resources :tweets do
      get 'delete'
    end
  end

  resources :user_sessions, only: [:new, :create, :destory]

  root 'users#index'

  match '/register', to: 'users#new', via: :all
  match '/login', to: 'user_sessions#new', via: :all
  match '/logout', to: 'user_sessions#destroy', via: :all
end
