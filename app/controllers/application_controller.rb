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

end

# Refactoring reused code to keep things DRY
# token = request.headers["Authorization"].split(" ")[1]
# decoded_token = JWT.decode(token, 'badbreathbuffalo', true, { algorithm: 'HS256' })
# user_id = decoded_token[0]["user_id"]
# current_user = User.find(user_id)