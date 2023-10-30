require 'rails_helper'

RSpec.describe 'Cars API', type: :request do
  # Before each test, create some sample cars in the database.
  before do
    @car = Car.create(model: 'Car 1', year: 2023, city: 'car1.jpg', price_per_day: 2)
    Car.create(model: 'Car 2', year: 2024, city: 'car2.jpg', price_per_day: 2)
    @car_delete = Car.create(model: 'Car to Delete', year: 2023, city: 'delete_me.jpg', price_per_day: 2)
  end

  describe 'GET /cars' do
    it 'returns a list of cars' do
      get '/cars'

      # Expect a 200 OK response
      expect(response).to have_http_status(200)

      # Parse the JSON response
      cars = JSON.parse(response.body)

      # Expect the response to be an array of cars
      expect(cars['data']).to be_an_instance_of(Array)
      expect(cars['data'].size).to eq(3) # Assuming you have 2 cars in the database
    end
  end

  describe 'GET /cars/:id' do
    it 'returns the details of a specific car' do
      get "/cars/#{@car.id}"

      # Expect a 200 OK response
      expect(response).to have_http_status(200)

      # Parse the JSON response
      car = JSON.parse(response.body)

      # Expect the response to be a car object
      expect(car['data']).to be_an_instance_of(Hash)

      # Verify specific attributes of the car
      expect(car['data']['model']).to eq(@car.model)
      expect(car['data']['year']).to eq(@car.year)
      expect(car['data']['city']).to eq(@car.city)
    end

    it 'returns a 404 Not Found response for an invalid car id' do
      get '/cars/999' # Assuming 999 is not a valid car id

      # Expect a 404 Not Found response
      expect(response).to have_http_status(404)
    end
  end

  describe 'POST /cars' do
    context 'with valid parameters' do
      it 'creates a new car' do
        car_params = {
          model: 'New Car',
          year: 2023,
          city: 'new_car.jpg',
          price_per_day: 2
        }

        post '/cars', params: car_params

        # Expect a 201 Created response
        expect(response).to have_http_status(201)

        # Parse the JSON response
        car = JSON.parse(response.body)

        # Expect the response to be a car object
        expect(car['data']).to be_an_instance_of(Hash)

        # Verify specific attributes of the created car
        expect(car['data']['model']).to eq('New Car')
        expect(car['data']['year']).to eq(2023)
        expect(car['data']['city']).to eq('new_car.jpg')
      end
    end

    context 'with invalid parameters' do
      it 'returns a 422 Unprocessable Entity response' do
        invalid_params = {
          car: {
            year: 2023,
            city: 'invalid_car.jpg'
          }
        }

        post '/cars', params: invalid_params

        # Expect a 422 Unprocessable Entity response
        expect(response).to have_http_status(422)

        # Parse the JSON response to check for error details
        errors = JSON.parse(response.body)

        # Verify that the response includes specific validation error messages
        expect(errors).to include('model' => ["can't be blank"])
      end
    end
  end

  describe 'DELETE /cars/:id' do
    it 'deletes a car' do
      delete "/cars/#{@car_delete.id}"

      # Expect a 200 OK response
      expect(response).to have_http_status(200)

      # Verify the response message
      response_data = JSON.parse(response.body)
      expect(response_data['status']['message']).to eq('Delete successfully.')
    end

    it 'returns a 404 Not Found response for an invalid car id' do
      delete '/cars/999' # Assuming 999 is not a valid car id

      # Expect a 404 Not Found response
      expect(response).to have_http_status(404)
    end
  end
end
