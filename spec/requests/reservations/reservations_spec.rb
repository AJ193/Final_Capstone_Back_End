# spec/requests/reservations_spec.rb

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Reservations API', type: :request do

  describe 'GET /reservations' do
    context 'when the user is authenticated' do
      it 'returns a list of reservations for the authenticated user' do
        user = User.new(
          name: 'John Doe',
          email: 'john.doe@example.com',
          password: 'password123'
        )

        car = Car.create(model: 'Car 1', year: 2023, picture: 'car1.jpg')
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        
        Reservation.create(start_date: '2023-10-30', end_date: '2023-11-05', user: user, car: car)
        Reservation.create(start_date: '2023-11-23', end_date: '2023-11-28', user: user, car: car)

        # Make a GET request to /reservations
        get '/reservations', headers: Devise::JWT::TestHelpers.auth_headers(headers, user)
        # Expect a 200 OK response
        expect(response).to have_http_status(200)

        # Parse the JSON response
        reservations = JSON.parse(response.body)

        # Expect the response to be an array of reservations
        expect(reservations['data']).to be_an_instance_of(Array)

        # Expect the correct number of reservations
        expect(reservations['data'].size).to eq(2) # Assuming two reservations were created for the user
      end
    end

    context 'when the user is not authenticated' do
      it 'returns a 401 Unauthorized response' do
        # Make a GET request to /reservations without authenticating
        get '/reservations'

        # Expect a 401 Unauthorized response
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST #create' do
    context 'when the user is authenticated' do
      it 'creates a new reservation' do
        car = Car.create(model: 'Car 1', year: 2023, picture: 'car1.jpg')
        
        resigst_params = {
            user: {
              name: 'Tester',
              email: 'tester-created@mail.com',
              password: 'password123'
            }
        }

        post '/signup', params: resigst_params

        jwt_token = response.headers['Authorization'].split(' ').last

        reservation_params = {
          reservation: {
            car_id: car.id,
            start_date: '2023-10-30',
            end_date: '2023-11-05'
          }
        }
        
        post '/reservations', headers: { 'Accept' => 'application/json', 'Authorization' => "Bearer #{jwt_token}" }, params: reservation_params

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        # Assuming your API returns a JSON response, you can parse it to check the content
        reservation_response = JSON.parse(response.body)
        expect(reservation_response['status']['code']).to eq(200)
        expect(reservation_response['status']['message']).to eq('Succesfully book car')
        expect(reservation_response['data']['car_id']).to eq(car.id)
        expect(reservation_response['data']['start_date']).to eq('2023-10-30T00:00:00.000Z')
        expect(reservation_response['data']['end_date']).to eq('2023-11-05T00:00:00.000Z')
      end
    end

    context 'when the user is not authenticated' do
      it 'returns a 401 Unauthorized response' do
        car = Car.create(model: 'Car 1', year: 2023, picture: 'car1.jpg')
        
        reservation_params = {
          reservation: {
            car_id: car.id,
            start_date: '2023-10-30',
            end_date: '2023-11-05'
          }
        }

        post '/reservations', params: reservation_params

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /reservations/:id' do
    context 'when the user is authenticated' do
      it 'deletes a reservation' do
        # Create a reservation for the user
        # resigst_params = {
        #     user: {
        #       name: 'Tester',
        #       email: 'tester-created@mail.com',
        #       password: 'password123'
        #     }
        # }
        
        # post '/signup', params: resigst_params
        user = User.new(
          name: 'John Doe',
          email: 'john.doe@example.com',
          password: 'password123'
        )
        car = Car.create(model: 'Car 1', year: 2023, picture: 'car1.jpg')

        reservation = Reservation.create(start_date: '2023-10-30', end_date: '2023-11-05', user: user, car: car)
        # Make a DELETE request to delete the reservation
        delete "/reservations/#{reservation.id}", headers: Devise::JWT::TestHelpers.auth_headers({}, user)

        # Expect a 200 OK response indicating successful deletion
        expect(response).to have_http_status(200)

        # Check that the reservation was deleted from the database
        expect { reservation.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the user is not authenticated' do
      it 'returns a 401 Unauthorized response' do
        # Create a reservation for testing
        user = User.new(
          name: 'John Doe',
          email: 'john.doe@example.com',
          password: 'password123'
        )
        car = Car.create(model: 'Car 1', year: 2023, picture: 'car1.jpg')

        reservation = Reservation.create(start_date: '2023-10-30', end_date: '2023-11-05', user: user, car: car)
        puts reservation.inspect
        # Make a DELETE request to delete the reservation without authenticating
        delete "/reservations/#{reservation.id}"

        # Expect a 401 Unauthorized response
        expect(response).to have_http_status(401)
      end
    end
  end
end
