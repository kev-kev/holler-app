Rails.application.routes.draw do
  root 'static_pages#home'

  get 'password_resets/new'
  get 'password_resets/edit'

  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
      member { get :following, :followers }
  end
  resources :account_activations, only: :edit
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end