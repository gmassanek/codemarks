Cms::Application.routes.draw do

  root :to => 'topics#index'

  resources :topics

end
