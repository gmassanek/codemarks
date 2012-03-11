Codemarks::Application.routes.draw do

  get '/dashboard', to: "users#dashboard", as: :dashboard
  get '/welcome', to: "users#welcome", as: :welcome
  get '/profile', to: "users#profile", as: :profile
  get '/profile/edit', to: "users#edit", as: :edit_profile
  get '/about', to: "pages#about", as: :about

  resources :codemarks, :only => [:create, :destroy]
  get '/codemarks/build_linkmark', to: "codemarks#build_linkmark", as: :build_linkmark
  get '/public', to: "codemarks#public", :as => :public_codemarks

  post 'listener/sendgrid', :to => "listener#sendgrid", as: "sendgrid_listener"
  get 'listener/prepare_bookmarklet', :to => "listener#prepare_bookmarklet", as: "prepare_bookmarklet"
  get 'listener/bookmarklet', :to => "listener#bookmarklet", as: "bookmarklet"

  match 'auth/:provider/callback', to: 'sessions#create'
  get 'pages/autocomplete_topic_title', :as => :topic_title_autocomplete

  root :to => 'pages#landing'

  resources :topics

  get '/links/topic_checkbox', :to => "links#topic_checkbox"
  resources :links
  post 'links/click', :as => :click_link

  resources :users
  get "sessions/new", :as => :sign_in
  post "sessions/create", :as => :create_session
  post "sessions/filter", :as => :filter_session
  delete "sessions/destroy", :as => :sign_out


  get '/pages/test_bookmarklet?:l&:url', :controller => :pages, :action => :test_bookmarklet, :as => :test_bookarklet

  post '/listener/github'
end
