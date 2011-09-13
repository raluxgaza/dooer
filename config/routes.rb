Dooer::Application.routes.draw do

  resources :users
  #resources :tasks
  resources :projects

  resources :projects do
    member do
      resources :tasks
    end
  end

  resources :sessions, :only => [:new, :create, :destroy]
  
  match '/signup', :to => "users#new"
  match '/signin', :to => "sessions#new"
  match '/signout', :to => "sessions#destroy"

  root :to => 'pages#home'
end
