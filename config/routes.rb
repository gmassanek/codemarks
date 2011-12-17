Cms::Application.routes.draw do

  get '/dashboard', to: "users#dashboard", as: :dashboard
  get '/profile', to: "users#profile", as: :profile
  get '/codemarks/build_link', to: "codemarks#build_link", as: :build_link
  post '/codemarks', to: "codemarks#create", as: :codemarks

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

end
