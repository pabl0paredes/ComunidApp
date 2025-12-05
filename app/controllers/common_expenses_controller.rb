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
        .joins(expense_details: :expense_details_residents)
        .where(expense_details_residents: { resident_id: current_user.resident.id })
        .where(community: @community)
        .order(date: :desc)
        .distinct


      @resident_amounts = {}

      ExpenseDetailsResident
        .joins(:expense_detail)
        .where(resident: current_user.resident)
        .each do |edn|

        ce = edn.expense_detail.common_expense
        @resident_amounts[ce.id] ||= 0
        @resident_amounts[ce.id] += edn.amount_due
      end


      @total_assigned = @resident_amounts.values.sum

      @total_paid = ExpenseDetailsResident
        .where(resident: current_user.resident, status: "approved")
        .sum(:amount_due)

      @total_pending = @total_assigned - @total_paid
    end
  end


  def show
      @common_expense = CommonExpense.find(params[:id])
      @community = @common_expense.community
      authorize @common_expense


      if current_user.resident


        @expense_details = @common_expense.expense_details
          .joins(:expense_details_residents)
          .where(expense_details_residents: { resident_id: current_user.resident.id })
          .order(created_at: :desc)


        residents_edns = ExpenseDetailsResident
          .joins(:expense_detail)
          .where(
            resident: current_user.resident,
            expense_details: { common_expense_id: @common_expense.id }
          )


        @resident_total = residents_edns.sum(:amount_due)


        if residents_edns.all?(&:approved?)
          @resident_status = "approved"
        elsif residents_edns.any?(&:rejected?)
          @resident_status = "rejected"
        elsif residents_edns.any?(&:pending?)
          @resident_status = "pending_approval"
        else
          @resident_status = "unpaid"
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
