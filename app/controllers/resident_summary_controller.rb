class ResidentSummaryController < ApplicationController
  before_action :set_resident, only: [:index, :show]

  def index
    set_resident
    authorize @resident
  end

  def show
    set_resident
    authorize @resident
  end

  private

  def set_resident
    @resident = Resident.find(params[:id])
  end

end
