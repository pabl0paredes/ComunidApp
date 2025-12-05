class ExpenseDetailsController < ApplicationController
  before_action :set_expense_detail, only: [:show, :edit, :update, :destroy]
  before_action :set_common_expense, only: [:index, :new, :create]

  def index
    @common_expense = CommonExpense.find(params[:common_expense_id])

    if current_user.id == @common_expense.community.administrator_id
      @expense_details = @common_expense
                          .expense_details
                          .order(updated_at: :desc)
    elsif current_user.resident.present?
      @expense_details = @common_expense
                          .expense_details
                          .joins(:expense_details_residents)
                          .where(expense_details_residents: { resident_id: current_user.resident.id })
                          .order(updated_at: :desc)
                          .distinct
    end

    authorize @expense_details
  end

  def new
    @expense_detail = ExpenseDetail.new
    @expense_detail.common_expense = @common_expense
    @residents = @common_expense.community.residents
    authorize @expense_detail
  end

  def create
    @residents = @common_expense.community.residents

    detail_params = expense_detail_params.dup

    # Si el admin eligió "Asignar a todos", forzamos resident_ids
    if params[:assign_mode] == "all"
      detail_params[:resident_ids] = @residents.pluck(:id)
    end

    @expense_detail = ExpenseDetail.new(detail_params)
    @expense_detail.common_expense = @common_expense

    authorize @expense_detail

    if @expense_detail.save
      @expense_detail.assign_amounts_to_residents
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
    @residents = @expense_detail.common_expense.community.residents
    authorize @expense_detail
  end

  def update
    authorize @expense_detail

    base_params = expense_detail_params.dup

    if params[:assign_mode] == "all"
      base_params[:resident_ids] =
        @expense_detail.common_expense.community.residents.pluck(:id)
    end

    if @expense_detail.update(base_params)
      @expense_detail.assign_amounts_to_residents
      redirect_to @expense_detail.common_expense,
                  notice: "Detalle actualizado correctamente."
    else
      @residents = @expense_detail.common_expense.community.residents
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
          .permit(:detail, :amount, resident_ids: [])
          .tap do |whitelisted|
            whitelisted[:resident_ids]&.reject!(&:blank?)
          end
  end
end
