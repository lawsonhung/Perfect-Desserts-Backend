class ApplicationController < ActionController::API
  # Refactoring reused code to keep things DRY
  # Helper methods below

  def token
    request.headers["Authorization"].split(" ")[1]
  end

  def decoded_token
    JWT.decode(token, 'badbreathbuffalo', true, { algorithm: 'HS256' })
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
    # Creates a token
    JWT.encode(payload, 'badbreathbuffalo', 'HS256')
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