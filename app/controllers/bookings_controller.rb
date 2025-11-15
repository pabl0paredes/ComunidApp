class BookingsController < ApplicationController
  before_action :set_common_space, only: [:index, :new, :create]
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  def index
    @bookings = @common_space.bookings.order(start: :asc)
  end

  def show
  end
  def new
    @booking = Booking.new
  end
  def create
    @booking = Booking.new(booking_params)
    @booking.common_space = @common_space
    @booking.neighbor = current_user.neighbor
    
    if @booking.save
      redirect_to common_space_bookings_path(@common_space), notice: "Reserva creada con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to booking_path(@booking), notice: "Reserva actualizada con éxito."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    redirect_to common_space_bookings_path(@booking.common_space), notice: "Reserva eliminada"
  end

  private

  def set_common_space
    @common_space = CommonSpace.find(params[:common_space_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start, :end)
  end
end
