class AddEmbeddingToResidents < ActiveRecord::Migration[7.1]
  def change
    add_column :residents, :embedding, :vector, limit: 1536
  end
end
