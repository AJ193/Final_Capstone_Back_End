# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    include RackSessionsFix
    respond_to :json

    private

    def respond_with(current_user, _opts = {})
      # Generate a JWT token
      jwt_token = generate_jwt_token(current_user)

      render json: {
        status: {
          code: 200,
          message: 'Logged in successfully.',
          data: {
            user: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
            jwt: jwt_token
          }
        }
      }, status: :ok
    end

    def respond_to_on_destroy
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
                                 Rails.application.credentials.devise_jwt_secret_key!).first
        current_user = User.find(jwt_payload['sub'])
      end

      if current_user
        render json: {
          status: 200,
          message: 'Logged out successfully.'
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    end

    def generate_jwt_token(user)
      # Your JWT token generation logic here
      # You'll need to use the 'jwt' gem or any other JWT library
      # For example, using the 'jwt' gem:

      payload = {
        sub: user.id,
        exp: Time.now.to_i + 3600 # Set the expiration time as desired
      }

      JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key, 'HS256')
    end
  end
end
