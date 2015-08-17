Rails.application.routes.draw do
  get 'users/index'
  post 'users/logout'

  get 'app/index'
  get 'app/load_inventory'
  root 'app#index'

  post 'auth/steam/callback' => 'users#auth_callback'
end
