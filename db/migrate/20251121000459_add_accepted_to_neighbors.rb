class AddAcceptedToNeighbors < ActiveRecord::Migration[7.1]
  def change
    add_column :neighbors, :is_accepted, :boolean, default: false
  end
end
