class CommonExpensesController < ApplicationController
  before_action :set_community, only: [:index, :new, :create]
  before_action :set_common_expense, only: [:show, :edit, :update, :destroy]

  # GET /communities/:community_id/common_expenses
  def index
    @common_expenses = @community.common_expenses.order(date: :desc)
  end
  # GET /communities/:community_id/common_expenses/new
  def new
    @common_expense = CommonExpense.new
  end
  # POST /communities/:community_id/common_expenses
  def create
    @common_expense = CommonExpense.new(common_expense_params)
    @common_expense.community = @community

    if @common_expense.save
      redirect_to community_common_expenses_path(@community), notice: "Gasto común creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end
  #GET /common_expenses/:id
  def show
    @expense_details = @common_expense.expense_details
  end
  # GET /common_expenses/:id/edit
  def edit
  end
  # PATCH/PUT /common_expenses/:id
  def update
    if @common_expense.update(common_expense_params)
      redirect_to common_expense_path(@common_expense), notice: "Gasto común actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  # DELETE /common_expenses/:id
  def destroy
    community = @common_expense.community
    @common_expense.destroy
    redirect_to community_common_expenses_path(community), notice: "Gasto común eliminado correctamente."
  end
  private

  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_common_expense
    @common_expense = CommonExpense.find(params[:id])
    @community = @common_expense.community
  end

  def common_expense_params
    params.require(:common_expense).permit(:date, :total)
  end
end
