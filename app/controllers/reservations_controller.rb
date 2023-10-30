# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :authenticate_user!

  # GET /reservations
  def index
    @reservations = current_user.reservations.all

    render json: { status: { code: 200, message: 'Fetch all reservations successfully.' }, data: @reservations },
           status: :ok
  end

  # POST /reservations

  def create
    @reservation = current_user.reservations.build(reservation_params)
    if @reservation.save
      render json: { status: { code: 200, message: 'Succesfully book car' }, data: @reservation }, status: :created
    else
      render json: { status: 400, message: "Couldn't book car" }, status: :bad_request
    end
  end

  # DELETE /reservations/1

  def destroy
    @reservation = Reservation.find(params[:id])
    if @reservation.destroy
      render json: { status: { code: 200, message: 'Delete reservation successfully.' } }, status: :ok
    else
      render json: { status: 400, message: "Couldn't delete reservation" }, status: :bad_request
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:car_id, :start_date, :end_date)
  end
end
