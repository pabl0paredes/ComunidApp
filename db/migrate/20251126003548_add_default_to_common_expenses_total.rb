class AddDefaultToCommonExpensesTotal < ActiveRecord::Migration[7.1]
  def change
    change_column_default :common_expenses, :total, 0
  end
end
