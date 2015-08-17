Rails.application.routes.draw do
  get 'app/index'
  get 'app/logout'
  root 'app#index'
  post 'auth/steam/callback' => 'app#auth_callback'
end
