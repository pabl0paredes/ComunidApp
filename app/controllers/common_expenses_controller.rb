class CommonExpensesController < ApplicationController
  skip_after_action :verify_authorized, only: :index
  #skip_after_action :verify_policy_scoped, only: :index

  before_action :set_community, only: [:index, :new, :create]
  before_action :set_common_expense, only: [:show, :edit, :update, :destroy]

  def index
    if current_user == @community.administrator.user
      @common_expenses = CommonExpense
        .where(community: @community)
        .order(date: :desc)
    else
      @common_expenses = CommonExpense
        .joins(expense_details: :expense_details_neighbors)
        .where(expense_details_neighbors: { neighbor_id: current_user.neighbor.id })
        .where(community: @community)
        .order(date: :desc)
        .distinct


      @neighbor_amounts = {}

      ExpenseDetailsNeighbor
        .joins(:expense_detail)
        .where(neighbor: current_user.neighbor)
        .each do |edn|

        ce = edn.expense_detail.common_expense
        @neighbor_amounts[ce.id] ||= 0
        @neighbor_amounts[ce.id] += edn.amount_due
      end


      @total_assigned = @neighbor_amounts.values.sum

      @total_paid = ExpenseDetailsNeighbor
        .where(neighbor: current_user.neighbor, status: "approved")
        .sum(:amount_due)

      @total_pending = @total_assigned - @total_paid
    end
  end


  def show
      @common_expense = CommonExpense.find(params[:id])
      @community = @common_expense.community
      authorize @common_expense

     
      if current_user.neighbor


        @expense_details = @common_expense.expense_details
          .joins(:expense_details_neighbors)
          .where(expense_details_neighbors: { neighbor_id: current_user.neighbor.id })
          .order(created_at: :desc)


        neighbors_edns = ExpenseDetailsNeighbor
          .joins(:expense_detail)
          .where(
            neighbor: current_user.neighbor,
            expense_details: { common_expense_id: @common_expense.id }
          )


        @neighbor_total = neighbors_edns.sum(:amount_due)


        if neighbors_edns.all?(&:approved?)
          @neighbor_status = "approved"
        elsif neighbors_edns.any?(&:rejected?)
          @neighbor_status = "rejected"
        elsif neighbors_edns.any?(&:pending?)
          @neighbor_status = "pending_approval"
        else
          @neighbor_status = "unpaid"
        end


      else
        @expense_details = @common_expense.expense_details.order(created_at: :desc)
      end
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
      redirect_to community_common_expenses_path(@common_expense.community), notice: "Gasto común actualizado correctamente."
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
