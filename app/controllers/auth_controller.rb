class AuthController < ApplicationController

  # Make sure to uncomment 'bcrypt' gem in Gemfile

  # $$$$$$$$$$$$$$$$$$$$$$$$$$$$ Terminal/Command Line notes
  # Opens up the rails console
  # $ rails c
  # Creates a user with username:"kev" and password:"buffaloboy"
  # > User.create(username:"kev", password:"buffaloboy")
  # Test to see if user has been created successfully
  # > User.all
  # > User.first
  # Fine the user with the username:kev
  # > User.find_by(username:"kev")
  # => User Load (2.6ms)  SELECT "users".* FROM "users" WHERE "users"."username" = $1 LIMIT $2  [["username", "kev"], ["LIMIT", 1]]
  #  => #<User id: 1, username: "kev", password_digest: [FILTERED], created_at: "2020-02-26 23:14:51", updated_at: "2020-02-26 23:14:51"> 
  # `_` underscore is just a shortcut for whatever was entered in console before. In this case, _ === User.find_by(username:"kev")
  # Then we set that to a variable name `kev`
  # > kev = _
  # `.authenticate` method is basically an app telling you to "please enter your password here". It is where you enter your raw password to log the user in. It's like telling the user: 
  # What's your username? kev
  # What's your password? buffaloboy
  # Authenticate is essentially the same thing as telling you to enter your password
  # > kev.authenticate("buffaloboy")


  # config/routes.rb `auth#login` will refer/point to this method
  def login

    # Find a user

    # `debugger` activates byebug in Rails APIs
    # ```debugger

    # Check to see what is in params
    # > params
    # We get the following because nothing is in params
    # => <ActionController::Parameters {"controller"=>"auth", "action"=>"login"} permitted: false>
    # `c` in byebug continues onto the next line. Make sure it's lowercase
    #  > c

    ########### Postman start
    # POST request to localhost:3000/login
    # "Body" tab in "raw" "JSON" format
    # JSON only takes things in strings, so you have to put "" around username as well
    # {
    # 	"username": "kev"
    # }
    ########### Postman end
    # Send in Postman again to hit debugger in terminal
    # > params
    # Now we have a "username"=>"kev" because we sent that in the body request in Postman
    # <ActionController::Parameters {"username"=>"kev", "controller"=>"auth", "action"=>"login", "auth"=>{"username"=>"kev"}} permitted: false>
    # params[:username] is a key that returns "kev". Sort of like JSON format, hash map or dictionary
    # :username is a key in params (ActionController::Parameters)
    # params[:username] === "kev"
    # > params[:username]
    # => "kev"
    # User.find_by(username:params[:username]) === User.find_by(username:"kev")
    # > User.find_by(username:params[:username])
    # => #<User id: 1, username: "kev", password_digest: [FILTERED], created_at: "2020-02-26 23:14:51", updated_at: "2020-02-26 23:14:51">

    # Assign the variable `user` = `User.find_by(username: params[:username])`
    user = User.find_by(username: params[:username])

    # If user exists, see if they really are the user via a password. AKA use `.authenticate()` to get them enter their password
    # The parameter to pass in is params[:password]. :password is a key within params. We'll pass this in the body request in Postman (below)
    ########## Postman start
    # {
    # 	"username": "kev",
    #   "password": "buffaloboy"
    # }
    ########## Postman end
    # Send request in Postman and hit debugger
    # > params[:password]
    # => "buffaloboy"
    # > is_authenticated returns the User object if true. Else, if :password is wrong, is_authenticated returns false
    is_authenticated = user.authenticate(params[:password])
      
    # If all is well, send back the user. That is, if `.authenticate()` is passed in the correct password parameter, then return back the user.
    # If `is_authenticated` returns true, meaning `user.authenticate(params[:password])` is true and `:password` is the correct password for the user, `is_authenticated` returns true
    debugger
    if is_authenticated
      # API's are json in, json out
      # `render json` sends json out of the rails app
      # If is_authenticated is true and the user types in the correct password, return the user in json format
      # ```render json: user

      # Now if the user is_authenticated, meaning they typed in the correct password and username, instead of returning the user, we want to return the token insead.
      # JWT.encode syntax: JWT.encode(<payload created/defined by us>, <secret>, <encryption method/algorithm we're using to encode>)
      # Assign that to a variable `token`
      # The secret is a server secret, which allows access to everyone on your app. Basically, a secret is a password for your app. It's like a password for the developer the encrypt stuff and log in to the app, with admin privileges
      # The only user-specific information is the payload. AKA the user_id and anything else specific only to the user
      # ```token = JWT.encode(payload, 'badbreathbuffalo', 'HS256')

      # However, we have not yet defined what payload is in this auth_controller, so doing that now
      # user was defined earlier, approx line 64, which is why user.id works and we can get the id of the user
      payload = { user_id: user.id }

      token = JWT.encode(payload, 'badbreathbuffalo', 'HS256')

      # Instead of returning the user, I want to return a JWT token instead
      # Create an object called token and assign it to token defined above
      render json: { token: token }
      # Send a Post request in Postman and you should get back the token object as a response

    else
      # Else return the message that the user entered the wrong password
      # ```render json: 'You entered the wrong username or password. Or you may not be real and just a bot trying to hack into the system... sorry'

      # A more standard thing to return is an error. Or rather an array of errors. 
      # You can also return statuses. Google the "http code" to learn more about each status error
      # By putting the status outside of the object, you'll get a status 422 Unprocessable Entity in Postment, in the return section of the request
      render json: {errors: ['You entered the wrong username or password. Or you may not be real and just a bot trying to hack into the system... sorry']}, status: 422
    end

    # API's are json in, json out
    # `render json` sends json out of the rails app
    # ```render json: 'hi'

    ############### LocalStorage
    # Browser - Console and Application tabs
    # localStorage stores data locally, meaning just your computer/machine
    # Store id and data in localStorage. Check Console > Application tab
    # In console:
    # Check what's in localStorage
    # > localStorage
    # Clear localStorage
    # > localStorage.clear()
    # Store stuff into localStorage
    # > localStorage.setItem('userId', 1)
    # To get stuff from localStorage
    # > localStorage.getItem('userId')
    # => "1"
    # Anything you store in localStorage automatically turns into a string. AKA everything is json.stringify()'ed
    # You can also do localStorage.userId
    # > localStorage.userId
    # => "1"
    # Or you can reassign localStorage.userId
    # > localStorage.userId = 0
    # => 0
    # You can also add new keys into localStorage
    # > localStorage.thisIsANewKey = "newKey"
    # => "newKey"
    # To remove items from localStorage
    # > localStorage.removeItem("thisIsANewKey")
    # => undefined
    # However, since you can simply reassign the value of localStorage.userId, this is not safe and easy to hack as someone can easily reassign localStorage.userId = 2 or any other Id they want

    ############### JWT
    # To prevent against this, we use Javascript Web Tokens (JWT)
    # Go to https://jwt.io/
    # In the decoded JWT, change the payload(body) to:
    ########## Payload start
    # {
    #   "userId": 1
    # }
    ########## Payload end
    # In the signature, we can enter whatever secret we want. In this case, our secret will just be 'badbreathbuffalo'
    # Scroll down the jwt.io webpage until you find the Ruby signatures. 
    # Look for something that says `$ gem install jwt`
    # If we Google "jwt rails", the first link we get is https://github.com/jwt/ruby-jwt
    # Click on that link and scroll down the ReadMe until you hit the "Using Bundler" section
    # It'll instruct you to add `gem 'jwt'` to your Gemfile, so go ahead and do that
    # Take down your server and run `bundle install` as instructed in the ReadMe
    # This will install the `gem 'jwt'` that you just added to the Gemfile
    # Start the server again with `$ rails s`
    # Add debugger above line 82, `if is_authenticated`
    # Refer back to the docs https://github.com/jwt/ruby-jwt under Algorithms & Usage > None
    # Make a post request in Postman to hit debugger
    # > user
    # => #<User id: 1, username: "kev", password_digest: [FILTERED], created_at: "2020-02-26 23:14:51", updated_at: "2020-02-26 23:14:51">
    # > user.id
    # => 1
    # Create an object/hash `{ user_id: user.id }` and save it to the variable `payload`
    # > payload = { user_id: user.id }
    # => {:user_id=>1}
    # Test to see if payload hash/object was properly created
    # > payload
    # => {:user_id=>1}
    # Call encode as a method on JWT with the payload data
    # Reference https://github.com/jwt/ruby-jwt to see where the following code for console comes from
    # > JWT.encode(payload, nul, 'none')
    # => "eyJhbGciOiJub25lIn0.eyJ1c2VyX2lkIjoxfQ."
    # Copy and paste eyJhbGciOiJub25lIn0.eyJ1c2VyX2lkIjoxfQ. into https://jwt.io/ encoded section and you'll see the decoded payload. You should see:
    ########### Postman Start
    # Header: "alg: none"
    # Payload: "user_id": 1
    # Take out the Verify signature so that there is no secret. You'll get an "Invalid Signature" error because there is no secret entered.
    # Verify Signature: <no-secret>
    ########### Postman End
    # However, since there is no secret, this is not secure because attackers can just decode the encoded section
    ############# JWT.encode syntax: JWT.encode(<payload hash/object that we create>, <secret goes here>, <algorithm that we want to use to encode>)
    # The standard algorithm to use is HMAC (reference https://github.com/jwt/ruby-jwt) so we're going to use that. We're going with the HS256 - HMAC using SHA-256 hash algorithm
    # So back in the Rails console:
    # > JWT.encode(payload, 'badbreathbuffalo', 'HS256')
    # => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE"
    # eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE is called the token, or Javascript Web Token (JWT)
    # Copy and paste eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE into https://jwt.io/
    # In Decoded > Verify Signature, the secret should currently be empty, which is why you still see the "Invalid Signature" error message under encoded
    # Since the secret is empty, "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lYHuRcAN30C20HHWkE28A1XyeORMzrLa6Bt1hfymATE" cannnot be decoded until given the secret
    # Enter 'badbreathbuffalo' into the Decoded section to decode the encoded JWT
    # Go back up to approx line 89: token = JWT.encode(payload, 'badbreathbuffalo', 'HS256')


  end

end
