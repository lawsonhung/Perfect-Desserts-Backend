class User < ApplicationRecord
  # `has_secure_password` allows us to use all the functionality of bcrypt
  # For example, User can have the attribute of `password`
  has_secure_password
end
