# spec/requests/users/registrations_spec.rb

require 'rails_helper'

RSpec.describe 'User Registrations API', type: :request do
  describe 'POST /signup' do
    it 'creates a new user' do
      user_params = {
        email: 'newuser@example.com',
        password: 'password123',
        name: 'test'
      }

      post '/signup', params: { user: user_params }

      expect(response).to have_http_status(200)
      expect(response.body).to include('Signed up successfully')

      token = response.headers['Authorization']
      expect(token).to start_with('Bearer')
    end

    it 'returns an error if user creation fails' do
      # Handle cases where user creation fails, e.g., invalid parameters
      user_params = {
        email: '', # Invalid email
        password: 'short' # Invalid password
        # Add other user attributes as needed
      }

      post '/signup', params: { user: user_params }

      expect(response).to have_http_status(422) # 422 indicates unprocessable entity
      expect(response.body).to include("User couldn't be created successfully")
      # Adjust the error message expectation based on your implementation
    end
  end

  describe 'POST /login' do
    let!(:user) { User.create(email: 'testuser@example.com', password: 'password123', name: 'test') }

    it 'logs in a user with valid credentials' do
      login_params = {
        user: {
          email: 'testuser@example.com',
          password: 'password123'
        }
      }

      post '/login', params: login_params

      expect(response).to have_http_status(200)
      expect(response.body).to include('Logged in successfully')

      # Optionally, you can check for the presence of an authentication token here
      # If you're using 'devise-jwt', for example, you may expect a token in the response.
      # Parse the response body or headers to extract the token if needed.

      # Example for checking an authentication token in response headers (if applicable)
      token = response.headers['Authorization']
      expect(token).to start_with('Bearer')

      # Example for checking an authentication token in response body (if applicable)
      # token = JSON.parse(response.body)['authentication_token']
      # expect(token).not_to be_nil
    end

    it 'returns an error for invalid login credentials' do
      invalid_params = {
        user: {
          email: 'testuser@example.com',
          password: 'incorrectpassword'
        }
      }

      post '/login', params: invalid_params

      expect(response).to have_http_status(401) # 401 indicates unauthorized
      expect(response.body).to include('Invalid Email or password')
    end
  end

  describe 'DELETE /logout' do
    let!(:user) { User.create(email: 'testuser@example.com', password: 'password123', name: 'test') }

    it 'logs out a user with a valid token' do
      # Log in the user to get a valid token
      login_params = {
        user: {
          email: 'testuser@example.com',
          password: 'password123'
        }
      }
      post '/login', params: login_params
      token = response.headers['Authorization']

      # Log out the user using the obtained token
      delete '/logout', headers: { 'Authorization' => token }

      expect(response).to have_http_status(200)
      expect(response.body).to include('Logged out successfully')
    end
  end
end
