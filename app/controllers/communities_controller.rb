class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy]

  def index
    @communities = Community.where(administrator_id: current_user.administrator.id)
  end

  def show
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.administrator_id = current_user.administrator.id
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
