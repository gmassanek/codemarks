Codemarks::Application.routes.draw do

  get '/about', to: "pages#about", as: :about

  resources :codemarklet, :only => [:new] do
    collection do
      get :login
      get :chrome_extension
    end
  end

  resources :codemarks
  resources :topics
  resources :users do
    collection do
      post :subscribe
      post :unsubscribe
    end
  end

  resources :comments, :only => [:create, :destroy]
  get 'topics/:id/:user_id', :to => 'topics#show', :as => 'topic_user'

  resources :links, :only => [] do
    member do
      post :click
    end
  end

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: 'sessions#failure'
  resources :sessions, :only => [:new, :create] do
    collection do
      get :codemarklet
      delete :destroy
    end
  end

  root :to => redirect('/codemarks')
end
