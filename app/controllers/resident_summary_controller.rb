class ResidentSummaryController < ApplicationController

  def index
    @resident = current_user.resident
    authorize @resident
  end

  def show
    @resident = current_user.resident
    authorize @resident
  end


end
