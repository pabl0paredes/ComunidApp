class BookingsController < ApplicationController
  before_action :set_common_space, only: [:index, :new, :create]
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  def index
    @bookings = policy_scope(@common_space.bookings.order(start: :asc))
    authorize Booking
  end

  def show
    authorize @booking
  end
  def new
    @booking = Booking.new
    authorize @booking
  end
  def create
    @booking = Booking.new(booking_params)
    @booking.common_space = @common_space
    @booking.neighbor = current_user.neighbor
    authorize @booking
    
    if @booking.save
      redirect_to common_space_bookings_path(@common_space), notice: "Reserva creada con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @booking
  end

  def update
    if @booking.update(booking_params)
      redirect_to booking_path(@booking), notice: "Reserva actualizada con éxito."
    else
      render :edit, status: :unprocessable_entity
    end
    authorize @booking
  end

  def destroy
    authorize @booking
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
