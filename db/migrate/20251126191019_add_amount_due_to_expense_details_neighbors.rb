class AddAmountDueToExpenseDetailsNeighbors < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_details_neighbors, :amount_due, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
