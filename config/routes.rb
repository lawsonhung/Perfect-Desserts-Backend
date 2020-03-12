Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # This is where we create custom routes to point to other files/methods in this Rails application

  # Looking for a `post` request to `'/login'` URL to auth_controller with a method `login` in auth_controller
  # `'auth#login'` goes into app/controllers/auth_controller.rb and looks for a method `login`
  # Endpoint is `'/login'`
  post '/login', to: 'auth#login'

  # Creates all restful routes
  # Actually writing `post '/login', to: 'auth#login'`
  # ```resources :users

  # Ability to make a POST request to localhost:3000/signup
  # Redirects POST '/signup' to app/controllers/users_controller.rb and looks for the `create` method
  post '/signup', to: 'users#create'

  # GET request to '/profile' that goes to app/controllers/users_controller.rb with the custom method called 'profile' in users_controller.rb
  get '/profile', to: 'users#profile'

end
