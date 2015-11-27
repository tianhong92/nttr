Rails.application.routes.draw do
  # default_url_options host: 'http://localhost:3000'

  resources :users do 
    # Wild tweets can only be created, read and destroyed, not changed.
    resources :tweets, except: [:edit, :update] do
      get 'delete'

      collection do
        get 'tweets'
      end
    end
  end

  resources :user_sessions, only: [:new, :create, :destroy]

  root 'users#index'

  match '/register', to: 'users#new', via: :all
  match '/login', to: 'user_sessions#new', via: :all
  match '/logout', to: 'user_sessions#destroy', via: :all
end
