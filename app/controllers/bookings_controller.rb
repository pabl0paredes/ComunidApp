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
    @usable_hours = UsableHour.where(common_space: @common_space)
    authorize @booking
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.end = @booking.start + 1.hour
    @booking.common_space = @common_space
    @booking.resident = current_user.resident
    authorize @booking

    if @booking.save
      usable_hour = UsableHour.find_by(common_space: @common_space, start: @booking.start)
      usable_hour.update(is_available: false)
      respond_to do |format|
        format.html {redirect_to common_space_bookings_path(@common_space), notice: "Reserva creada con éxito."}
        format.turbo_stream
      end
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

  def available_hours
    authorize Booking
    date = Date.parse(params[:date])
    common_space = CommonSpace.find(params[:common_space_id])

    usable_hours = UsableHour
      .where(common_space: common_space)
      .where("DATE(start) = ?", date)
      .where(is_available: true)
      .order(:start)

    render json: usable_hours.map { |u| u.attributes.slice("id", "start", "end") }
  end

  def available_dates
    authorize Booking
    common_space = CommonSpace.find(params[:common_space_id])

    dates = UsableHour
              .where(common_space: common_space, is_available: true)
              .pluck(:start)
              .map { |d| d.to_date }
              .uniq

    render json: dates
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
