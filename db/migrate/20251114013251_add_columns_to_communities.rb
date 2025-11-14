class AddColumnsToCommunities < ActiveRecord::Migration[7.1]
  def change
    add_column :communities, :address, :string
    add_column :communities, :latitude, :float
    add_column :communities, :longitude, :float
  end
end
