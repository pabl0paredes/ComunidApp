class AddEmbeddingToCommunities < ActiveRecord::Migration[7.1]
  def change
    add_column :communities, :embedding, :vector, limit: 1536
  end
end
