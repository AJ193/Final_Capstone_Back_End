require 'swagger_helper'

RSpec.describe 'cars', type: :request do
  path '/cars/models' do
    get('car_models car') do
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/cars' do
    get('list cars') do
      tags 'Cars'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 status: {
                   type: :object,
                   properties: {
                     code: { type: :integer },
                     message: { type: :string }
                   }
                 },
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       model: { type: :string },
                       year: { type: :integer },
                       picture: { type: :string },
                       created_at: { type: :string, format: 'date-time' },
                       updated_at: { type: :string, format: 'date-time' },
                       city: { type: :string },
                       price_per_day: { type: :integer }
                     },
                     required: %w[id model year picture created_at updated_at city price_per_day]
                   }
                 }
               }

        example 'List of cars' => {

          status: { code: 200, message: 'Fetch all cars successfully.' },
          data:[
            {
              "id": 5,
              "model": "Honda Accord",
              "year": 2022,
              "picture": "http://localhost:5000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--e6399d7d60e6424e7d5271228564cb6eb84f851f/download.jpeg",
              "created_at": "2023-10-30T13:07:11.719Z",
              "updated_at": "2023-10-30T13:07:11.746Z",
              "city": "San Fransisco",
              "price_per_day": 30
            },
            {
              "id": 6,
              "model": "Toyota Supra",
              "year": 2022,
              "picture": "http://localhost:5000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--cfc6de97918a8e371a25e80398fb500e84240ee9/download.jpeg",
              "created_at": "2023-10-30T13:08:07.643Z",
              "updated_at": "2023-10-30T13:08:07.666Z",
              "city": "Jakarta",
              "price_per_day": 30
            },
            {
              "id": 7,
              "model": "Lamborghini Aventador",
              "year": 2022,
              "picture": "http://localhost:5000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--276860267bc2ed930b13f8e18ce6ca86c321f879/download.jpeg",
              "created_at": "2023-10-30T13:09:30.098Z",
              "updated_at": "2023-10-30T13:09:30.109Z",
              "city": "Tokyo",
              "price_per_day": 30
            },  
          ]
        }
        run_test!
      end
    end

    post('create car') do
      tags 'Cars'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :model, in: :formData, type: :string, required: true
      parameter name: :year, in: :formData, type: :integer, required: true
      parameter name: :price_per_day, in: :formData, type: :integer, required: true
      parameter name: :city, in: :formData, type: :string, required: true
      parameter name: :image, in: :formData, type: :file, required: true

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 status: {
                   type: :object,
                   properties: {
                     code: { type: :integer },
                     message: { type: :string }
                   }
                 },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     model: { type: :string },
                     year: { type: :integer },
                     picture: { type: :string },
                     created_at: { type: :string, format: 'date-time' },
                     updated_at: { type: :string, format: 'date-time' },
                     city: { type: :string },
                     price_per_day: { type: :integer }
                   }
                 }
               }

        example 'Creating a car' => {
          status: { code: 200, message: 'Car created successfully' },
          data: {
            id: 1,
            model: 'Toyota Supra',
            year: 2020,
            picture: 'https://example.com/car_image.jpg',
            created_at: '2023-11-02T12:00:00Z',
            updated_at: '2023-11-02T12:00:00Z',
            city: 'San Francisco',
            price_per_day: 20
          }
        }

        run_test!
      end
  end

  path '/cars/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show car') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete car') do
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
