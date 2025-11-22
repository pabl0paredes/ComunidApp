class CommonSpacesController < ApplicationController
    before_action :set_common_space, only: [:show, :edit, :update, :destroy]

  def index
    @community = Community.find(params[:community_id])
    @common_spaces = @community.common_spaces
  end

  def show
    @bookings = @common_space.bookings.order(start: :asc)
    @usable_hours = @common_space.usable_hours.order(:weekday, :start)
  end

  def new
    @community = Community.find(params[:community_id])
    @common_space = CommonSpace.new
  end

  def create
    @community = Community.find(params[:community_id])
    @common_spaces= CommonSpace.new(common_space_params)
    @common_space.community = @community

    if @common_space.save
      redirect_to community_common_spaces_path(@community), notice: "Espacio creado correctamente"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @common_space.update(common_space_params)
      redirect_to common_space_path(@common_space), notice: "Espacio actualizado"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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
