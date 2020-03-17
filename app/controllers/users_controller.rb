class UsersController < ApplicationController

  # A custom method called profile
  # In config/routes.rb, `get '/profile', to: 'users#profile'` would point to this method
  # '/profile' is the same thing as 'localhost:3000/profile'
  def profile
    # debugger

    ################ Note1
    # Let's assign the token to a variable, named `token`
    # As a reminder:
    # > request.headers["Authorization"].split(" ")[1]
    # => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE"
    token = request.headers["Authorization"].split(" ")[1]

    # Now we neet to decode the token
    # We'll assign that to a variable `decoded_token`
    # > JWT.decode(token, 'badbreathbuffalo', true, { algorithm: 'HS256' })
    # => [{"user_id"=>1}, {"alg"="HS256"}]
    decoded_token = JWT.decode(token, 'badbreathbuffalo', true, { algorithm: 'HS256' })

    # Now we want to get the user ID
    # We want to get the first item in the array of the decoded token, with the key "user_id"
    # We'll set that to the variable `user_id`
    # > decoded_token[0]["user_id"]
    # => 1
    user_id = decoded_token[0]["user_id"]

    # Now we want to find the current user
    # We'll set the user object to a variable `current_user`
    # > User.find(user_id)
    # => User Load (19.8ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
    # => ↳ (byebug):1:in `profile'
    # => #<User id: 1, username: "kev", password_digest: [FILTERED], created_at: "2020-02-26 23:14:51", updated_at: "2020-02-26 23:14:51">
    current_user = User.find(user_id)

    # Now all we have to do is just render the current_user in json format
    # This is what is returned when we hit SEND in Postman
    render json: current_user

    ################# Now to test in Postman
    # Make a GET request to 'localhost:3000/profile'
    # 'Authorization' tab with type "Bearer Token"
    # Token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE
    # SEND
    # => {
    #     "id": 1,
    #     "username": "kev",
    #     "password_digest": "$2a$12$GM3bZpw88/0fzK1CVsOSAODe8wkk5TAevyJryveNjDAsLfs3i6hZu",
    #     "created_at": "2020-02-26T23:14:51.245Z",
    #     "updated_at": "2020-02-26T23:14:51.245Z"
    # }

    ############# Postman end


    ######################### Note1 end

    # When working with Rails APIs, everything that comes in and out is in json format
    # Test to see if this worked by going to Postman, making a GET request to 'localhost:3000/profile'
    # No "body" payload being sent
    # Send in Postman, and you should get back 'yo, im the profile' as a response.
    # We now have a custom route '/profile' that returns 'yo, im the profile'
    # ```render json: 'yo, im the profile'
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
      # If you give the wrong secret (server password) but right token(client/user password), you'll get an error
      # The error just means that you signed off the wrong signature/secret so that it couldn't be verified server side
      # > JWT.decode(token, 'badbreathbuffalowwwwww', true, { algorithm: 'HS256' })
      # => *** JWT::VerificationError Exception: Signature verification raised
      # => nil 
      # If all is well and you properly decoded the JWT, you'll get the payload[0] and the header[1]
      # The payload[0] = {"user_id"=>1}
      # The header[1] = {"alg"=>"HS256"}
      # JWT.decode(token, 'badbreathbuffalo', true, { algorithm: 'HS256' })
      # => [{"user_id"=>1}, {"alg"=>"HS256"}]
      # Set the decoded token to a variable. For convenience, we'll name it `decoded_token`
      # > decoded_token = JWT.decode(token, 'badbreathbuffalo', true, { algorithm: 'HS256' })
      # => [{"user_id"=>1}, {"alg"="HS256"}]
      # As stated, the payload = decoded_token[0]
      # Let's test it for debugging purposes
      # > decoded_token[0]
      # => {"user_id"=>1}
      # To get the user_id, we just navigate it like a hash or Javascript object
      # > decoded_token[0]["user_id"]
      # => 1
      # Now that we have our user ID, we can find it in our Rails app using User.find
      # We can make it slightly more readable by assigning it to a variable first. Let's name it `user_id` for convenience.
      # > user_id = decoded_token[0]["user_id"]
      # => 1
      # > user_id
      # => 1
      # Now lets find the user in our Rails app using User.find since we have our user_id
      # > User.find(user_id)
      # =>   User Load (19.8ms)  SELECT "users".* FROM "users" WHERE "users"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
      # => ↳ (byebug):1:in `profile'
      # => #<User id: 1, username: "kev", password_digest: [FILTERED], created_at: "2020-02-26 23:14:51", updated_at: "2020-02-26 23:14:51">
      # Now let's convert all these console entries into the UsersController so we can use Rails to automate it
      ################### Note1 Skip/Jump up to `def profile` approx line 9



  end

  # In config/routes.rb, `post '/signup', to: 'users#create'` points/redirects to this method
  def create
    ############### Postman notes start
    # Make a POST request to 'localhost:3000/signup'
    # In the "Body" tab "RAW":
    # {
      # "username": "kev",
      # "password": "buffaloboy"
    # }
    # And SEND to hit debugger
    ############### Postman notes end
    # Essentially we're trying to sign up a new user/create a new user with the "username": "kev" and "password": "buffaloboy"
    ############ ```debugger
    # Let's see what we sent over in the post request
    # > params
    # => <ActionController::Parameters {"username"=>"kev", "password"=>"buffaloboy", "controller"=>"users", "action"=>"create", "user"=>{"username"=>"kev"}} permitted: false>
    # > c
    # Exit out of debugger
    
    # Let's try to make a new user
    ################# Postman notes start
    # Make a POST request to 'localhost:3000/signup'
    # In the "Body" tab "raw":
    # {
      # "username": "annie",
      # "password": "ruby"
    # }
    # And SEND to hit debugger
    ################# Postman notes end
    # > params
    # => <ActionController::Parameters {"username"=>"annie", "password"=>"ruby", "controller"=>"users", "action"=>"create", "user"=>{"username"=>"annie"}} permitted: false>

    ############ Note3 Start
    # Create a user using `user_params`
    user = User.create(user_params)

    # Check to see if `user` is valid
    # User will be valid if created successfully, AKA "username" and "password" are not blank
    if user.valid?
      # If `user` is valid and created successfully, then `render json` below
      render json: "user is valid and created successfully"
    else 

    end
    ############ Note3 End
  end

  # Strong params/private
  private

  # Strong params provides an interface for protecting attributes from end-user reassignment. Parameters marked as required flow through a predefined raise/rescute flow so that a `400 Bad Request` error is thrown back.
  def user_params
    ################# Note2 start
    # So that we don't have to look for a nested part of params called `:user`, remove the `.require(:user)`
    # ```params.require(:user).permit(:username, :password)
    # In params, only permit the two keys `:username` and `:password`
    params.permit(:username, :password)
    ################ Note2 end
  end
  # > c
  # To get out of debugger and resend in Postman
  ############# Postman Start
  # Make a POST request to 'localhost:3000/signup'
  # In the "Body" tab "raw":
  # {
    # "username": "annie",
    # "password": "ruby"
  # }
  # And SEND to hit debugger
  ############# Postman End
  # > user_params
  # => <ActionController::Parameters {"username"=>"annie"} permitted: true>
  # We get the "username" but no "password"
  # > params
  # => <ActionController::Parameters {"username"=>"annie", "password"=>"ruby", "controller"=>"users", "action"=>"create", "user"=><ActionController::Parameters {"username"=>"annie"} permitted: false>} permitted: false>
  # `user_params` returns the nested `user` ActionController::Parameters
  # `user_params` calls `permit`, which looks for a nested part of the params called `:user`, which is what `params.require(:user)` is doing. It's essentially looking for params[:user] which is why it returns => "user"=><ActionController::Parameters {"username"=>"annie"} permitted: false>} 
  ############# Note2

  # Now we only permit `:username` and `:password` without having the nested `:user` params
  # > c
  # To continue out of debugger
  # POSTMAN hit SEND to hit debugger again
  # > user_params
  # => Unpermitted parameter: :user
  # <ActionController::Parameters {"username"=>"annie", "password"=>"ruby"} permitted: true>
  # This returns just the parameters with ":username" and ":password" keys and their values
  # <ActionController::Parameters {"username"=>"annie", "password"=>"ruby"} permitted: true>

  # Now we can create a user using these `user_params`
  # > User.create(user_params)
  # => Unpermitted parameter: :user
  #  (5.1ms)  BEGIN
  #  ↳ (byebug):1:in `create'
  #  User Create (18.3ms)  INSERT INTO "users" ("username", "password_digest", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["username", "annie"], ["password_digest", "$2a$12$eBhpV8KB34Pg7UmN7QJBmuocXw6C2uegsF39xmXVKb6MwOTUFtIx2"], ["created_at", "2020-03-16 20:18:02.277438"], ["updated_at", "2020-03-16 20:18:02.277438"]]
  #  ↳ (byebug):1:in `create'
  #   (0.9ms)  COMMIT
  #  ↳ (byebug):1:in `create'
  #  <User id: 2, username: "annie", password_digest: [FILTERED], created_at: "2020-03-16 20:18:02", updated_at: "2020-03-16 20:18:02">
  # User was created successfully
  # > c
  # To Continue out of console

  # Create another user "annie2"
  ############## Postman Start
  # Make a POST request to 'localhost:3000/signup'
  # In the "Body" tab "raw":
  # {
    # "username": "annie2",
    # "password": "ruby"
  # }
  # SEND to hit debugger
  ############## Postman End
  # Create a new user using `user_params` and save it to  variable
  # > user = User.create(user_params)
  # => Unpermitted parameter: :user
  #    (6.0ms)  BEGIN
  #    ↳ (byebug):1:in `create'
  #    User Create (8.0ms)  INSERT INTO "users" ("username", "password_digest", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["username", "annie2"], ["password_digest", "$2a$12$4IkbSORnNNIu9nf4PXItjeH.Pl76XD7xTVuisOQHvuDzUc.PURpEC"], ["created_at", "2020-03-17 18:49:42.613332"], ["updated_at", "2020-03-17 18:49:42.613332"]]
  #    ↳ (byebug):1:in `create'
  #     (1.4ms)  COMMIT
  #    ↳ (byebug):1:in `create'
  #  #<User id: 3, username: "annie2", password_digest: [FILTERED], created_at: "2020-03-17 18:49:42", updated_at: "2020-03-17 18:49:42">
  # Check to see if `user` was saved
  # > user
  # => #<User id: 3, username: "annie2", password_digest: [FILTERED], created_at: "2020-03-17 18:49:42", updated_at: "2020-03-17 18:49:42">
  # Check to see if user is valid
  # > user.valid?
  # => true
  # > c
  # Continue out of debugger

  # Example of when user is not valid/invalid
  ############## Postman start
  # POST request to 'localhost:3000/signup'
  # In "Body" tab "raw" option:
  # {
  # }
  # SEND to hit debugger
  ############## Postman end
  # > user_params
  # => Unpermitted parameter: :user
  # <ActionController::Parameters {} permitted: true>
  # Nothing in user_params because nothing was sent in Postman Body
  # Let's try and create a user anyway using these empty params
  # > user = User.create(user_params)
  # => Unpermitted parameter: :user
  # <User id: nil, username: nil, password_digest: nil, created_at: nil, updated_at: nil>
  # `user` was never actually created, so `user` is not valid
  # > User.last
  #   User Load (7.0ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT $1  [["LIMIT", 1]]
  # ↳ (byebug):1:in `create'
  # #<User id: 3, username: "annie2", password_digest: [FILTERED], created_at: "2020-03-17 18:49:42", updated_at: "2020-03-17 18:49:42">
  # `user.valid?` will return false because `user` is invalid and was never actually created
  # > user.valid?
  # => false
  # To see the errors:
  # > user.errors
  # => #<ActiveModel::Errors:0x00007fa2a59abbf0 @base=#<User id: nil, username: nil, password_digest: nil, created_at: nil, updated_at: nil>, @messages={:password=>["can't be blank"]}, @details={:password=>[{:error=>:blank}]}>
  # > user.errors.full_messages
  # => ["Password can't be blank"]

  # Let's create a user now instead of using the console
  ############## Note3

end
