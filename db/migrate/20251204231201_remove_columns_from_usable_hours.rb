class RemoveColumnsFromUsableHours < ActiveRecord::Migration[7.1]
  def change
    remove_column :usable_hours, :weekday, :integer
    remove_column :usable_hours, :date, :date
  end
end
