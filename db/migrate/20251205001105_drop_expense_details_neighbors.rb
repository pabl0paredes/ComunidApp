class DropExpenseDetailsNeighbors < ActiveRecord::Migration[7.1]
  def change
    drop_table :expense_details_neighbors
  end
end
