Cms::Application.routes.draw do

  root :to => 'topics#index'

  resources :topics
  resources :links

end
