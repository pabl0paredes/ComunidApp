class CreateCommonExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :common_expenses do |t|
      t.references :community, null: false, foreign_key: true
      t.datetime :date
      t.integer :total

      t.timestamps
    end
  end
end
