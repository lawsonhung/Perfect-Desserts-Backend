Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Looking for a `post` request to `'/login'` URL to auth_controller with a method `login` in auth_controller
  # `'auth#login'` goes into app/controllers/auth_controller.rb and looks for a method `login`
  # Endpoint is `'/login'`
  post '/login', to: 'auth#login'

  # Creates all restful routes
  # Actually writing `post '/login', to: 'auth#login'`
  # ```resources :users

end
