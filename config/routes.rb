Codemarks::Application.routes.draw do

  get '/welcome', to: "users#welcome", as: :welcome
  get '/about', to: "pages#about", as: :about
  get '/codemarklet_test', to: "pages#codemarklet_test"
  get 'pages/autocomplete_topic_title', :as => :topic_title_autocomplete
  get '/pages/test_bookmarklet?:l&:url', :controller => :pages, :action => :test_bookmarklet, :as => :test_bookarklet

  resources :codemarklet, :only => [:new, :create] do
    collection { get :login }
    collection { get :chrome_extension }
  end
  resources :codemarks, :only => [:new, :create, :destroy] do
    collection do
      get 'search'
    end
  end
  get '/public', to: "codemarks#public", :as => :public_codemarks

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: 'sessions#failure'

  resources :comments, :only => [:create, :destroy]
  resources :topics
  get 'topics/:id/:user_id', :to => 'topics#show', :as => 'topic_user'

  get '/codemarks/topic_checkbox'
  resources :links do
    member { post :click }
  end

  get "sessions/codemarklet_sign_in", :as => :codemarklet_sign_in
  post "sessions/create", :as => :create_session
  post "sessions/filter", :as => :filter_session
  delete "sessions/destroy", :as => :sign_out

  resources :users, :only => [:show, :update]
  get '/:id', :to => 'users#show', :as => "short_user"
  get '/:id/account', to: "users#account", as: :account
  get '/:id/account/edit', to: "users#edit", as: :edit_account

  root :to => 'pages#landing'
end
