class RenameNeighborReferenceToResidentOnBookings < ActiveRecord::Migration[7.1]
  def change
    rename_column :bookings, :neighbor_id, :resident_id
    #rename_index :bookings, "index_bookings_on_neighbor_id", "index_bookings_on_resident_id"
    #remove_foreign_key :bookings, :neighbors
    #add_foreign_key :bookings, :residents, column: :resident_id
  end
end
