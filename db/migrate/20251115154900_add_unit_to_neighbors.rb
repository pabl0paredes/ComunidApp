class AddUnitToNeighbors < ActiveRecord::Migration[7.1]
  def change
    add_column :neighbors, :unit, :string
  end
end
