class AddEmbeddingToCommonSpaces < ActiveRecord::Migration[7.1]
  def change
    add_column :common_spaces, :embedding, :vector , limit: 1536
  end
end
