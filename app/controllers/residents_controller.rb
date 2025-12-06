class ResidentsController < ApplicationController
  before_action :set_resident, only: [:show, :edit, :update, :destroy, :auth_waiting, :already_resident]
  def index
    @community = Community.find(params[:community_id])
    @residents_accepted = Resident.where(community: @community, is_accepted: true)
    @residents_waiting = Resident.where(community: @community, is_accepted: false)
    authorize :resident, :index?
  end

  def show
  end

  def new
    @resident = Resident.new
    @communities = Community.all
    authorize @resident

    if current_user.resident
      @resident = current_user.resident
      redirect_to already_resident_resident_path(current_user.resident)
    end
  end

  def create
    @resident = Resident.new(resident_params)
    authorize @resident
    @resident.user = current_user
    
    users_count = Resident.where(community_id: @resident.community.id).size + 1

    @resident.common_expense_fraction = 1.0 / users_count

    # Cargar las comunidades para la vista (necesario después de enviar el formulario)
    @communities = Community.all

    if @resident.save!
      redirect_to auth_waiting_resident_path(@resident)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @resident
  end

  def update
    authorize @resident
    @resident.is_accepted = true
    @resident.update(resident_params)

    redirect_to community_residents_path(@resident.community)
  end

  def destroy
    authorize @resident
    @resident.destroy

    redirect_to residents_path, status: :see_other
  end

  def auth_waiting
    @community = @resident.community
    @administrator = @community.administrator
    authorize @resident
    if @resident.is_accepted
      redirect_to @community
    end
  end

  def already_resident
    authorize @resident
  end

  private

  def resident_params
    params.require(:resident).permit(:community_id, :unit, :common_expense_fraction, :is_accepted)
  end

  def set_resident
    @resident = Resident.find(params[:id])
  end
end
