class UsersController < ApplicationController

  # A custom method called profile
  # In config/routes.rb, `get '/profile', to: 'users#profile'` would point to this method
  # '/profile' is the same thing as 'localhost:3000/profile'
  def profile
    debugger

    # When working with Rails APIs, everything that comes in and out is in json format
    # Test to see if this worked by going to Postman, making a GET request to 'localhost:3000/profile'
    # No "body" payload being sent
    # Send in Postman, and you should get back 'yo, im the profile' as a response.
    # We now have a custom route '/profile' that returns 'yo, im the profile'
    render json: 'yo, im the profile'
    # Tokens will be sent to this route. The server will then look at the user_id inside the token and look for the user and make sure that it is the actual user (entered password correctly and correct username)
    # Once the server has verified and checked that the username and password match what is on file, the server will send the user back as a token. Then store the token in localStorage
    # Tokens only come from either log in or sign up. Then we store the token in localStorage

    ################# Postman notes
      # GET requests cannot use body in Postman
      # Body is only used in POST/PUT/PATCH
      # All requests take "headers". You can send info on every type of request using headers
      # Tokens are sent through "headers"
      # In Postman, go to "Authorization" tab in headers section
      # Choose type of "Bearer Token"
      # Copy/paste token into token field: "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE"
      # This is how we send tokens later on.
      # For now, don't send it yet
      # Turn off headers by staying in "Authorization" tab and select Type: "No auth"
      # Change URL request to localhost:3000/login 
      # Change to POST request
      # Go to "Body" tab and select "raw" request
      # Send a request and you should get back the token: "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE"

      # Copy the token "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE"
      # Change to a GET request to localhost:3000/profile
      # "Body" tab of request section change to "none"
      # Go to "Authentication" tab and change Type to "Bearer Token"
      # Paste the token into the token field "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE"
      # Send in Postman to hit debugger in approx line 7
    ################# Postman notes end

      # Send in Postman to hit debugger in approx line 7
      # > request.headers
      # => You get back a bunch of stuff. Used to check all the keys in headers in Rails
      # If you know the key, you can get the value. e.g. "Content-Type"
      # > request.headers["Content-Type"]
      # => "application/json"
      # To get the Bearer Token:
      # > request.headers["Authorization"]
      # => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE"
      # Notice that there is the word "Bearer" in there. So get just the token by itself, we have to split the entire string "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE". Then, we have to choose the second item in the split array to get the token by itself.
      # > request.headers["Authorization"].split(" ")
      # => ["Bearer", "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE"]
      # Now we want the second item in the array
      # > request.headers["Authorization"].split(" ")[1]
      # => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE"
      # Now we want to save that token to a variable so that we can use it. For convenience, we'll name the variable token
      # > token = request.headers["Authorization"].split(" ")[1]
      # => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE"

      ############### So now we're able to get the token into the server side. Now that have the ENCODED token, we want to DECODE it so that we can use it as a human
      # So going back to the documentation: https://github.com/jwt/ruby-jwt, we can figure out how to DECODE HMAC
      ############## JWT.decode syntax: JWT.decode(<token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE">, <secret = 'badbreathbuffalo'>, <true (unsure what this does and why it has to be true)>, <algorithm we're using to decode = { algorithm: 'HS256' }. It has to be the SAME algorithm that we used to encode as well>)
      # > JWT.decode(token, 'badbreathbuffalo', true, { algorithm: 'HS256' })
      # => [{"user_id"=>1}, {"alg"=>"HS256"}]


  end

end
