class AddColumnsToUsableHours < ActiveRecord::Migration[7.1]
  def change
    add_column :usable_hours, :date, :date
    add_column :usable_hours, :is_available, :boolean
  end
end
