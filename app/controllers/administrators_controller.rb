class AdministratorsController < ApplicationController
  before_action :set_administrator, only: :show
  def show
    @community = Community.find(params[:community_id])
  end

  def new
  end

  def create
  end

  def destroy
  end

  private

  def set_administrator
    @administrator = Administrator.find(params[:id])
  end
end
