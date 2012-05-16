Codemarks::Application.routes.draw do

  get '/welcome', to: "users#welcome", as: :welcome
  get '/about', to: "pages#about", as: :about
  get '/codemarklet_test', to: "pages#codemarklet_test"

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

  post 'listener/sendgrid', :to => "listener#sendgrid", as: "sendgrid_listener"
  get 'listener/prepare_bookmarklet', :to => "listener#prepare_bookmarklet", as: "prepare_bookmarklet"
  get 'listener/bookmarklet', :to => "listener#bookmarklet", as: "bookmarklet"
  post '/listener/github'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: 'sessions#failure'
  get 'pages/autocomplete_topic_title', :as => :topic_title_autocomplete

  root :to => 'pages#landing'

  resources :comments, :only => [:create, :destroy]
  resources :topics
  get 'topics/:id/:user_id', :to => 'topics#show', :as => 'topic_user'

  get '/links/topic_checkbox', :to => "links#topic_checkbox"
  resources :links do
    member { post :click }
  end

  get "sessions/codemarklet_sign_in", :as => :codemarklet_sign_in
  post "sessions/create", :as => :create_session
  post "sessions/filter", :as => :filter_session
  delete "sessions/destroy", :as => :sign_out

  get '/pages/test_bookmarklet?:l&:url', :controller => :pages, :action => :test_bookmarklet, :as => :test_bookarklet

  resources :users, :only => [:show, :update]
  get '/:id', :to => 'users#show', :as => "short_user"
  get '/:id/account', to: "users#account", as: :account
  get '/:id/account/edit', to: "users#edit", as: :edit_account

end
