class CreateUsableHours < ActiveRecord::Migration[7.1]
  def change
    create_table :usable_hours do |t|
      t.datetime :start
      t.datetime :end
      t.integer :weekday
      t.references :common_space, null: false, foreign_key: true

      t.timestamps
    end
  end
end
