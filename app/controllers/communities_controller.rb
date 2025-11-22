class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy]

  def index
    @communities = Community.where(administrator_id: current_user.administrator.id)
  end

  def show
    unless @community.administrator.user == current_user
      Neighbor.find_by(user: current_user, community: @community)
      if neighbor
        unless neighbor.is_accepted
          redirect_to auth_waiting_neighbor_path
        end
      end
    end
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)

    administrator = Administrator.create(user: current_user)

    @community.administrator = administrator
    if @community.save
      redirect_to communities_path()
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @community.update(community_params)

    redirect_to community_path
  end

  def destroy
    @community.destroy

    redirect_to communities_path, status: :see_other
  end

  private

  def community_params
    params.require(:community).permit(:name, :size, :address, :latitude, :longitude)
  end

  def set_community
    @community = Community.find(params[:id])
  end
end
