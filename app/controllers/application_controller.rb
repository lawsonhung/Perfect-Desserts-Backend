class ApplicationController < ActionController::API
  # Test users:
  # annie12: ruby
  # kev: buffaloboy


  # Refactoring reused code to keep things DRY
  # Helper methods below

  def token
    request.headers["Authorization"].split(" ")[1]
  end

  # A secret is like the password for the app/developer
  def secret
    # ```'badbreathbuffalo'

    # Hide in React Auth pt2 1:20:00 
    # ```ENV['jwt_secret']
    # Export in ~/.bash_profile
    # export jwt_secret = 'badbreathbuffalo'

    # OR
    
    # $ EDITOR='code --wait' rails credentials:edit
    # Add to the bottom of the file:
    # `jwt_secret: 'badbreathbuffalo'`
    # Save and close the file
    Rails.application.credentials.jwt_secret
  end

  def decoded_token
    JWT.decode(token, secret, true, { algorithm: 'HS256' })
  end

  def user_id
    decoded_token[0]["user_id"]
  end

  def current_user
    User.find(user_id)
  end

  # Encoding a token is the same as creating a token
  # Creates a token
  # Renaming for easier understanding
  # ```def encode_token(user_id)
  def create_token(user_id)
    payload = { user_id: user_id }
    # Creates a token. Encoding something just creates a token
    JWT.encode(payload, secret, 'HS256')
  end

end

# Refactoring reused code to keep things DRY
# From app/controllers/users_controller.rb#profile
# token = request.headers["Authorization"].split(" ")[1]
# decoded_token = JWT.decode(token, 'badbreathbuffalo', true, { algorithm: 'HS256' })
# user_id = decoded_token[0]["user_id"]
# current_user = User.find(user_id)

# From app/controllers/users_controller.rb#create
# payload = { user_id: user.id }
# token = JWT.encode(payload, 'badbreathbuffalo', 'HS256')