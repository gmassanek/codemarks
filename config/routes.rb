Codemarks::Application.routes.draw do

  get '/welcome', to: "users#welcome", as: :welcome
  get '/about', to: "pages#about", as: :about

  resources :codemarks, :only => [:new, :create, :destroy]
  get '/public', to: "codemarks#public", :as => :public_codemarks

  post 'listener/sendgrid', :to => "listener#sendgrid", as: "sendgrid_listener"
  get 'listener/prepare_bookmarklet', :to => "listener#prepare_bookmarklet", as: "prepare_bookmarklet"
  get 'listener/bookmarklet', :to => "listener#bookmarklet", as: "bookmarklet"
  post '/listener/github'

  match 'auth/:provider/callback', to: 'sessions#create'
  get 'pages/autocomplete_topic_title', :as => :topic_title_autocomplete

  root :to => 'pages#landing'

  resources :topics
  get 'topics/:id/:user_id', :to => 'topics#show', :as => 'topic_user'

  get '/links/topic_checkbox', :to => "links#topic_checkbox"
  resources :links
  post 'links/click', :as => :click_link

  get "sessions/new", :as => :sign_in
  post "sessions/create", :as => :create_session
  post "sessions/filter", :as => :filter_session
  delete "sessions/destroy", :as => :sign_out

  get '/pages/test_bookmarklet?:l&:url', :controller => :pages, :action => :test_bookmarklet, :as => :test_bookarklet

  resources :users, :only => [:show, :update]
  get '/:id', :to => 'users#show', :as => "short_user"
  get '/:id/account', to: "users#account", as: :account
  get '/:id/account/edit', to: "users#edit", as: :edit_account

end
