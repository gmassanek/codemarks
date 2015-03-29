Codemarks::Application.routes.draw do

  get '/about', to: "pages#about", as: :about

  resources :codemarklet, :only => [:new] do
    collection do
      get :login
      get :chrome_extension
    end
  end

  resources :codemarks do
    collection do
      post :sendgrid
    end
  end

  resources :topics
  resources :comments, :only => [:create, :destroy]
  resources :users do
    collection do
      post :subscribe
      post :unsubscribe
    end
  end

  resources :resources, :only => [:create] do
    member do
      post :click
      resources :comments
    end
  end

  post 'auth/:provider/callback', to: 'sessions#create'
  post 'auth/failure', to: 'sessions#failure'

  put 'auth/:provider/callback', to: 'sessions#create'
  put 'auth/failure', to: 'sessions#failure'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: 'sessions#failure'

  resources :sessions, :only => [:new, :create] do
    collection do
      get :codemarklet
      delete :destroy
    end
  end

  root :to => redirect('/codemarks')
end
