class AddEmbeddingToCommonExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :common_expenses, :embedding, :vector, limit: 1536
  end
end
