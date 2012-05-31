Codemarks::Application.routes.draw do

  get '/welcome', to: "users#welcome", as: :welcome
  get '/about', to: "pages#about", as: :about
  get '/codemarklet_test', to: "pages#codemarklet_test"
  get 'pages/autocomplete_topic_title', :as => :topic_title_autocomplete
  get '/pages/test_bookmarklet?:l&:url', :to => 'pages#test_bookmarklet', :as => :test_bookarklet

  resources :codemarklet, :only => [:new, :create] do
    collection do
      get :login
      get :chrome_extension
    end
  end

  resources :codemarks, :only => [:index, :new, :create, :destroy] do
    collection do
      get 'search/:query', :action => :search
      get :topic_checkbox
    end
  end
  get '/public', to: "codemarks#index", :as => :public_codemarks

  resources :comments, :only => [:create, :destroy]
  resources :topics
  get 'topics/:id/:user_id', :to => 'topics#show', :as => 'topic_user'

  resources :links, :only => [] do
    member do
      post :click
    end
  end

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: 'sessions#failure'
  resources :sessions, :only => [:create] do
    collection do
      get :codemarklet
      delete :destroy
    end
  end

  resources :users, :only => [:show, :update]
  get '/:id', :to => 'users#show', :as => "short_user"
  get '/:id/account', to: "users#account", as: :account
  get '/:id/account/edit', to: "users#edit", as: :edit_account

  root :to => 'pages#landing'
end
