class CarsController < ApplicationController
  before_action :set_car, only: %i[show destroy]

  # GET /cars
  def index
    @cars = Car.all

    render json: { status: { code: 200, message: 'Fetch all cars successfully.' }, data: @cars }, status: :ok
  end

  # GET /cars/1
  def show
    render json: { status: { code: 200, message: 'Fetch car detail successfully.' }, data: @car }, status: :ok
  end

  # POST /cars
  def create
    @car = Car.new(car_params)

    if @car.save
      render json: { status: { code: 200, message: 'Succesfully added car' }, data: @car }, status: :created
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cars/1
  def destroy
    if @car.destroy
      render json: { status: { code: 200, message: 'Delete successfully.' } }, status: :ok
    else
      render json: { status: 400, message: "Couldn't delete car" }, status: :bad_request
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_car
    @car = Car.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def car_params
    params.require(:car).permit(:model, :year, :picture)
  end
end
