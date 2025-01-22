Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/auth/login', to: 'auth#login', as: :login
  get '/auth/callback', to: 'auth#callback', as: :callback
end
