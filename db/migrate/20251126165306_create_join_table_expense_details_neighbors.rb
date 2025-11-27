class CreateJoinTableExpenseDetailsNeighbors < ActiveRecord::Migration[7.1]
  def change
    create_join_table :expense_details, :neighbors do |t|
      t.index [:expense_detail_id, :neighbor_id], name: "index_expense_details_neighbors_on_detail_and_neighbor"
      t.index [:neighbor_id, :expense_detail_id], name: "index_expense_details_neighbors_on_neighbor_and_detail"
  end
end
end
