class CreateNeighbors < ActiveRecord::Migration[7.1]
  def change
    create_table :neighbors do |t|
      t.references :user, null: false, foreign_key: true
      t.references :community, null: false, foreign_key: true
      t.float :common_expense_fraction

      t.timestamps
    end
  end
end
