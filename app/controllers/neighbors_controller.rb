class NeighborsController < ApplicationController
  before_action :set_neighbor, only: [:show, :edit, :update, :destroy, :auth_waiting]
  def index
    @community = Community.find(params[:community_id])
    @neighbors_accepted = Neighbor.where(community: @community, is_accepted: true)
    @neighbors_waiting = Neighbor.where(community: @community, is_accepted: false)
  end

  def show
  end

  def new
    @neighbor = Neighbor.new
    @communities = Community.all
  end

  def create
    @neighbor = Neighbor.new(neighbor_params)
    @neighbor.user = current_user
    @neighbor.common_expense_fraction = 0

    if @neighbor.save
      redirect_to auth_waiting_neighbor_path(@neighbor)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @neighbor.is_accepted = true
    @neighbor.update(neighbor_params)

    redirect_to community_neighbors_path(@neighbor.community)
  end

  def destroy
  end

  def auth_waiting
    community = @neighbor.community
    @administrator = community.administrator
  end

  private

  def neighbor_params
    params.require(:neighbor).permit(:community_id, :unit, :common_expense_fraction, :is_accepted)
  end

  def set_neighbor
    @neighbor = Neighbor.find(params[:id])
  end
end
