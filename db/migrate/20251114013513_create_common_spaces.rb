class CreateCommonSpaces < ActiveRecord::Migration[7.1]
  def change
    create_table :common_spaces do |t|
      t.references :community, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.integer :price
      t.boolean :is_available

      t.timestamps
    end
  end
end
