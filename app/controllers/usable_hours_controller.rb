class UsableHoursController < ApplicationController
  before_action :set_common_space

  def create
    authorize @common_space, :manage_hours?

    result = UsableHoursGenerator.call(@common_space, generator_params)

    if result.success?
      redirect_to edit_common_space_path(@common_space), notice: "Horarios generados correctamente"
    else
      flash[:alert] = result.error
      redirect_to edit_common_space_path(@common_space)
    end
  end

  private

  def set_common_space
    @common_space = CommonSpace.find(params[:common_space_id])
  end

  def generator_params
    params.permit(:start_time, :end_time, days_of_week: [])
  end
end
