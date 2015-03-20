Rails.application.routes.draw do

  resources :users
  namespace :api do
    resources :posts, only: [:index, :show]
  end
  api_for '/apidoc'

  root 'home#index'
end
