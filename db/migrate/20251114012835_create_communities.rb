class CreateCommunities < ActiveRecord::Migration[7.1]
  def change
    create_table :communities do |t|
      t.references :administrator, null: false, foreign_key: true
      t.string :name
      t.integer :size

      t.timestamps
    end
  end
end
