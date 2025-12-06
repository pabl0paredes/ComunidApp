class AddEmbeddingToExpenseDetails < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_details, :embedding, :vector , limit: 1536
  end
end
