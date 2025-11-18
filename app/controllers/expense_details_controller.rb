class ExpenseDetailsController < ApplicationController
  before_action :set_expense_detail, only: [:show, :edit, :update, :destroy]
  before_action :set_common_expense, only: [:index, :new, :create]

  # GET /common_expenses/:common_expense_id/expense_details
  def index
    @expense_details = @common_expense.expense_details
  end

  # GET /common_expenses/:common_expense_id/expense_details/new
  def new
    @expense_detail = ExpenseDetail.new
  end

  # POST /common_expenses/:common_expense_id/expense_details
  def create
    @expense_detail = ExpenseDetail.new(expense_detail_params)
    @expense_detail.common_expense = @common_expense

    if @expense_detail.save
      redirect_to common_expense_expense_details_path(@common_expense), notice: "Detalle creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /expense_details/:id
  def show
  end

  # GET /expense_details/:id/edit
  def edit
  end

  # PATCH/PUT /expense_details/:id
  def update
    if @expense_detail.update(expense_detail_params)
      redirect_to expense_detail_path(@expense_detail), notice: "Detalle actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /expense_details/:id
  def destroy
    common_expense = @expense_detail.common_expense
    @expense_detail.destroy
    redirect_to common_expense_expense_details_path(common_expense), notice: "Detalle eliminado correctamente."
  end

  private

  def set_common_expense
    @common_expense = CommonExpense.find(params[:common_expense_id])
  end

  def set_expense_detail
    @expense_detail = ExpenseDetail.find(params[:id])
  end

  def expense_detail_params
    params.require(:expense_detail).permit(:detail, :amount)
  end

end
