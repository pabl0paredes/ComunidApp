class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy]

  def index
    # @communities = Community.where(administrator_id: current_user.administrator.id)
    @communities = policy_scope(Community)
    authorize @communities

    # authorize :community, :index?
  end

  def show
    authorize @community
    unless @community.administrator.user == current_user
      neighbor = Neighbor.find_by(user: current_user, community: @community)
      if neighbor
        unless neighbor.is_accepted
          redirect_to auth_waiting_neighbor_path(neighbor)
        end
      end
    end
  end

  def new
    @community = Community.new
    authorize @community
  end

  def create
    @community = Community.new(community_params)
    authorize @community

    administrator = Administrator.create(user: current_user)

    @community.administrator = administrator
    if @community.save
      redirect_to communities_path()
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @community
  end

  def update
    authorize @community
    @community.update(community_params)

    redirect_to community_path
  end

  def destroy
    authorize @community
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
