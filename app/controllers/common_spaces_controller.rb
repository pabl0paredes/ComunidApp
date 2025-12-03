class CommonSpacesController < ApplicationController
    before_action :set_common_space, only: [:show, :edit, :update, :destroy]

  def index
    @community = Community.find(params[:community_id])
    @common_spaces = policy_scope(@community.common_spaces)
    authorize @common_spaces
  end

  def show
    authorize @common_space 
    @bookings = @common_space.bookings.order(start: :desc)
    @usable_hours = @common_space.usable_hours.order(:weekday, :start)
    @usable_weekdays = UsableHour.where(common_space_id: @common_space.id).pluck(:weekday)
  end

  def new
    @community = Community.find(params[:community_id])
    @common_space = CommonSpace.new
    authorize @common_space
  end

  def create
    @community = Community.find(params[:community_id])
    @common_spaces= CommonSpace.new(common_space_params)
    @common_space.community = @community
    authorize @common_space

    if @common_space.save
      redirect_to community_common_spaces_path(@community), notice: "Espacio creado correctamente"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @common_space
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
    @common_space.destroy
    redirect_to community_common_spaces_path(@common_space.comunity), notice: "Espacio eliminado"
  end

  private

  def set_common_space
    @common_space = CommonSpace.find(params[:id])
  end

  def common_space_params
    params.require(:common_space).permit(:name, :description, :price, :is_avaible)
  end
end
