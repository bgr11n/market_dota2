Rails.application.routes.draw do
  root to: 'items#index'

  get 'inventory', to: 'inventory#index', as: :inventory
  get 'item_price', to: 'inventory#item_price'
  resources :items, only: [:index, :create]
  get '/items/:market_hash_name', to: 'items#show', as: :item
  post '/items/buy', to: 'items#buy_listing', as: :buy

  get '/account', to: 'users#account'
  post 'users/logout'
  post 'auth/steam/callback', to: 'users#auth_callback'
end
