class CommonSpacesController < ApplicationController
  before_action :set_common_space, only: [:show, :edit, :update, :destroy]
  before_action :set_community, only: [:index, :new, :create]
  skip_after_action :verify_authorized, only: :index

  def index
    @common_spaces = policy_scope(@community.common_spaces)

  end

  def show
    authorize @common_space
    @booking = Booking.new
    if policy(@common_space).update?
      @bookings = @common_space.bookings.includes(resident: :user)
    else
      @bookings = @common_space.bookings
                              .where(resident: current_user.resident)
                              .includes(resident: :user)
    end
    @usable_hours = @common_space.usable_hours.sort_by { |h| [h.start.wday, h.start] }

    if current_user.resident.present?
      @usable_weekdays = @usable_hours.map { |h| h.start.wday }.uniq
    else
      @usable_weekdays = []
    end
  end

  def new
    @common_space = CommonSpace.new(community: @community)
    authorize @common_space
  end

  def create
    @common_space = CommonSpace.new(common_space_params)
    @common_space.community = @community

    authorize @common_space

    if @common_space.save
      redirect_to edit_common_space_path(@common_space), notice: "Espacio creado correctamente"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @common_space
    @usable_hour = UsableHour.new
  end

  def update
    authorize @common_space
    if @common_space.update(common_space_params)
      redirect_to common_space_path(@common_space), notice: "Espacio actualizado"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @common_space
    community = @common_space.community
    @common_space.destroy
    redirect_to community_common_spaces_path(community), notice: "Espacio eliminado"
  end

  private

  def set_common_space
    @common_space = CommonSpace.find(params[:id])
  end

  def set_community
    @community = Community.find(params[:community_id])
  end

  def common_space_params
    params.require(:common_space).permit(:name, :description, :price, :is_available)
  end
end
