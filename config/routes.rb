Rails.application.routes.draw do
  get 'inventory', to: 'inventory#index', as: :inventory
  get 'item_price', to: 'inventory#item_price'
  resources :items, only: [:index, :create]
  get '/items/:market_hash_name' => 'items#show', as: :item
  post '/items/buy' => 'items#buy_listing', as: :buy

  get 'users/index'
  post 'users/logout'

  put 'app/asd'

  root to: 'items#index'
  post 'auth/steam/callback' => 'users#auth_callback'
end
