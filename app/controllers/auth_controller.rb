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
    if is_authenticated
      # API's are json in, json out
      # `render json` sends json out of the rails app
      # If is_authenticated is true and the user types in the correct password, return the user in json format
      render json: user
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

    # Browser
    # localStorage stores data locally, meaning just your computer/machine
    # Store id and data in localStorage. Check Console > Application tab
    # In console:
    # Check what's in localStorage
    # > localStorage
    # Clear localStorage
    # > localStorage.clear()
    # Store stuff into localStorage
    # > localStorage.setItem('userId', 1)
  end

end
