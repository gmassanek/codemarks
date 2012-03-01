Codemarks::Application.routes.draw do

  get '/public', to: "codemarks#public", :as => :public_codemarks
  get '/dashboard', to: "users#dashboard", as: :dashboard
  get '/welcome', to: "users#welcome", as: :welcome
  get '/profile', to: "users#profile", as: :profile
  get '/profile/edit', to: "users#edit", as: :edit_profile
  get '/about', to: "pages#about", as: :about
  resources :codemarks, :only => [:edit]
  get '/codemarks/build_linkmark', to: "codemarks#build_linkmark", as: :build_linkmark
  get '/widget', to: "pages#widget", as: :widget
  post '/codemarks', to: "codemarks#create", as: :codemarks

  post 'listener/sendgrid', :to => "listener#sendgrid", as: "sendgrid_listener"
  get 'listener/prepare_bookmarklet', :to => "listener#prepare_bookmarklet", as: "prepare_bookmarklet"

  match 'auth/:provider/callback', to: 'sessions#create'
  get '/about', :to => 'pages#about', :as => :about_path
  get 'pages/autocomplete_topic_title', :as => :topic_title_autocomplete
  get '/links/topic_checkbox', :to => "links#topic_checkbox"

  root :to => 'pages#landing'

  resources :topics
  resources :links
  resources :users
  resources :reminders, :only => [:create]

  post 'links/click', :as => :click_link

  get "sessions/new", :as => :sign_in
  post "sessions/create", :as => :create_session
  post "sessions/filter", :as => :filter_session
  delete "sessions/destroy", :as => :sign_out


  get '/pages/test_bookmarklet?:l&:url', :controller => :pages, :action => :test_bookmarklet, :as => :test_bookarklet
end
