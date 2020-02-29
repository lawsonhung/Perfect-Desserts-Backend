class UsersController < ApplicationController

  # A custom method called profile
  # In config/routes.rb, `get '/profile', to: 'users#profile'` would point to this method
  # '/profile' is the same thing as 'localhost:3000/profile'
  def profile
    # When working with Rails APIs, everything that comes in and out is in json format
    # Test to see if this worked by going to Postman, making a GET request to 'localhost:3000/profile'
    # No "body" payload being sent
    # Send in Postman, and you should get back 'yo, im the profile' as a response.
    # We now have a custom route '/profile' that returns 'yo, im the profile'
    render json: 'yo, im the profile'
  end

end
