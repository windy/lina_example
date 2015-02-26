Rails.application.routes.draw do
  api_for '/apidoc'

  root 'home#index'
end
