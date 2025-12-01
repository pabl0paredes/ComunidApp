class ExpenseDetailsController < ApplicationController
  before_action :set_expense_detail, only: [:show, :edit, :update, :destroy]
  before_action :set_common_expense, only: [:index, :new, :create]

  def index
    @common_expense = CommonExpense.find(params[:common_expense_id])

    if current_user.id == @common_expense.community.administrator_id
      @expense_details = @common_expense
                          .expense_details
                          .order(updated_at: :desc)
    elsif current_user.neighbor.present?
      @expense_details = @common_expense
                          .expense_details
                          .joins(:expense_details_neighbors)
                          .where(expense_details_neighbors: { neighbor_id: current_user.neighbor.id })
                          .order(updated_at: :desc)
                          .distinct
    end

    authorize @expense_details
  end

  def new
    @expense_detail = ExpenseDetail.new
    @expense_detail.common_expense = @common_expense
    @neighbors = @common_expense.community.neighbors
    authorize @expense_detail
  end

  def create
    @neighbors = @common_expense.community.neighbors

    detail_params = expense_detail_params.dup

    # Si el admin eligió "Asignar a todos", forzamos neighbor_ids
    if params[:assign_mode] == "all"
      detail_params[:neighbor_ids] = @neighbors.pluck(:id)
    end

    @expense_detail = ExpenseDetail.new(detail_params)
    @expense_detail.common_expense = @common_expense

    authorize @expense_detail

    if @expense_detail.save
      @expense_detail.assign_amounts_to_neighbors
      redirect_to common_expense_expense_details_path(@common_expense),
                  notice: "Detalle creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize @expense_detail
  end

  def edit
    @neighbors = @expense_detail.common_expense.community.neighbors
    authorize @expense_detail
  end

  def update
    authorize @expense_detail

    base_params = expense_detail_params.dup

    if params[:assign_mode] == "all"
      base_params[:neighbor_ids] =
        @expense_detail.common_expense.community.neighbors.pluck(:id)
    end

    if @expense_detail.update(base_params)
      @expense_detail.assign_amounts_to_neighbors
      redirect_to @expense_detail.common_expense,
                  notice: "Detalle actualizado correctamente."
    else
      @neighbors = @expense_detail.common_expense.community.neighbors
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @expense_detail
    common_expense = @expense_detail.common_expense
    @expense_detail.destroy
    redirect_to common_expense_expense_details_path(common_expense),
                notice: "Detalle eliminado correctamente."
  end

  private

  def set_common_expense
    @common_expense = CommonExpense.find(params[:common_expense_id])
  end

  def set_expense_detail
    @expense_detail = ExpenseDetail.find(params[:id])
  end

  def expense_detail_params
    params.require(:expense_detail)
          .permit(:detail, :amount, neighbor_ids: [])
          .tap do |whitelisted|
            whitelisted[:neighbor_ids]&.reject!(&:blank?)
          end
  end
end
