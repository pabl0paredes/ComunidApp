class CreateJoinTableCommonExpensesNeighbors < ActiveRecord::Migration[7.1]
  def change
    create_join_table :common_expenses, :neighbors do |t|
      t.index [:common_expense_id, :neighbor_id], name: "index_common_expenses_neighbors"
      t.index [:neighbor_id, :common_expense_id], name: "index_neighbors_common_expenses"
    end
  end
end
