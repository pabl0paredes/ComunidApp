class DropCommonExpensesNeighbors < ActiveRecord::Migration[7.1]
  def change
    drop_table :common_expenses_neighbors
  end
end
