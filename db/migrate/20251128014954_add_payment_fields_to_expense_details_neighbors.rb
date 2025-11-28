class AddPaymentFieldsToExpenseDetailsNeighbors < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_details_neighbors, :status, :string
    add_column :expense_details_neighbors, :paid_at, :datetime
  end
end
