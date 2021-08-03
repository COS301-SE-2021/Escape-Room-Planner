require 'jwt'

class JsonWebToken
  # Encode a token given a certain payload ID password etc.
  # The token will expire after 24 hours
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  # used when a user tries to access functionality (Just checks that the user is registered and is logged in)
  def self.decode(token)
    body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    HashWithIndifferentAccess.new body
  end
end
