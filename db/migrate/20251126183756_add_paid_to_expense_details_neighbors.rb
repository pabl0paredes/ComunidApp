class AddPaidToExpenseDetailsNeighbors < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_details_neighbors, :paid, :boolean, default: false, null: false
  end
end
