class NeighborsController < ApplicationController
  before_action :set_neighbor, only: [:show, :edit, :update, :destroy, :auth_waiting]
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
  end

  def create
    @neighbor = Neighbor.new(neighbor_params)
    authorize @neighbor
    @neighbor.user = current_user
    @neighbor.common_expense_fraction = 0

    if @neighbor.save
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
  end

  def auth_waiting
    @community = @neighbor.community
    @administrator = @community.administrator
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
