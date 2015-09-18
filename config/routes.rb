require 'sidekiq/web'
Rails.application.routes.draw do
  root to: 'items#index'

  get 'inventory', to: 'inventory#index', as: :inventory
  get 'item_price', to: 'inventory#item_price'
  resources :items, only: [:index, :create]
  get '/items/:market_hash_name', to: 'items#show', as: :item
  resources :listings, only: [:show, :update, :destroy] do
    post '/buy', to: 'listings#buy', on: :collection, as: :buy
  end

  get '/account', to: 'users#account'
  post 'users/logout'
  post 'auth/steam/callback', to: 'users#auth_callback'

  mount Sidekiq::Web => '/sidekiq'
end
