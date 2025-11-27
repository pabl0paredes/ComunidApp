class AddIdToExpenseDetailsNeighbors < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_details_neighbors, :id, :primary_key
  end
end
