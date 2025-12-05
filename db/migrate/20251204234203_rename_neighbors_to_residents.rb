class RenameNeighborsToResidents < ActiveRecord::Migration[7.1]
  def change
    rename_table :neighbors, :residents
  end
end
