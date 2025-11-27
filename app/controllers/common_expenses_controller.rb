class CommonExpensesController < ApplicationController
  skip_after_action :verify_authorized, only: :index
  #skip_after_action :verify_policy_scoped, only: :index

  before_action :set_community, only: [:index, :new, :create]
  before_action :set_common_expense, only: [:show, :edit, :update, :destroy]

  def index
    if current_user == @community.administrator

      @common_expenses = @community.common_expenses.order(date: :desc)
    else

      @common_expenses = CommonExpense
        .joins(expense_details: :expense_details_neighbors)
        .where(expense_details_neighbors: { neighbor_id: current_user.neighbor.id })
        .where(community: @community)
        .order(date: :desc)
        .distinct
    end
  end

  def show
    @expense_details = @common_expense.expense_details.order(created_at: :desc)
    authorize @common_expense
  end

  def new
    @common_expense = CommonExpense.new
    @common_expense.community = @community
    authorize @common_expense
  end

  def create
    @common_expense = CommonExpense.new(common_expense_params)
    @common_expense.community = @community
    authorize @common_expense

    if @common_expense.save
      redirect_to community_common_expenses_path(@community), notice: "Gasto común creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @common_expense
  end

  def update
    authorize @common_expense
    if @common_expense.update(common_expense_params)
      redirect_to common_expense_path(@common_expense), notice: "Gasto común actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @common_expense
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
    params.require(:common_expense).permit(:date)
  end

end
