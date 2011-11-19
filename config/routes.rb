Cms::Application.routes.draw do

  root :to => 'topics#index'

  resources :topics
  resources :links
  resources :users

  get "sessions/new", :as => :sign_in
  post "sessions/create", :as => :create_session
  delete "sessions/destroy", :as => :sign_out

end
