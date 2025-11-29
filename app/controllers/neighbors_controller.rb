class NeighborsController < ApplicationController
  before_action :set_neighbor, only: [:show, :edit, :update, :destroy, :auth_waiting, :already_neighbor]
  def index
    @community = Community.find(params[:community_id])
    @neighbors_accepted = Neighbor.where(community: @community, is_accepted: true)
    @neighbors_waiting = Neighbor.where(community: @community, is_accepted: false)
    authorize :neighbor, :index?
  end

  def show
  end

  def new
    @neighbor = Neighbor.new
    @communities = Community.all
    authorize @neighbor

    if current_user.neighbor
      @neighbor = current_user.neighbor
      redirect_to already_neighbor_neighbor_path(current_user.neighbor)
    end
  end

  def create
    @neighbor = Neighbor.new(neighbor_params)
    authorize @neighbor
    @neighbor.user = current_user

    users_count = Neighbor.where(community_id: @neighbor.community.id).size + 1

    @neighbor.common_expense_fraction = 1.0 / users_count

    # Cargar las comunidades para la vista (necesario después de enviar el formulario)
    @communities = Community.all

    if @neighbor.save!
      redirect_to auth_waiting_neighbor_path(@neighbor)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @neighbor
  end

  def update
    authorize @neighbor
    @neighbor.is_accepted = true
    @neighbor.update(neighbor_params)

    redirect_to community_neighbors_path(@neighbor.community)
  end

  def destroy
    authorize @neighbor
    @neighbor.destroy

    redirect_to neighbors_path, status: :see_other
  end

  def auth_waiting
    @community = @neighbor.community
    @administrator = @community.administrator
    authorize @neighbor
    if @neighbor.is_accepted
      redirect_to @community
    end
  end

  def already_neighbor
    authorize @neighbor
  end

  private

  def neighbor_params
    params.require(:neighbor).permit(:community_id, :unit, :common_expense_fraction, :is_accepted)
  end

  def set_neighbor
    @neighbor = Neighbor.find(params[:id])
  end
end
