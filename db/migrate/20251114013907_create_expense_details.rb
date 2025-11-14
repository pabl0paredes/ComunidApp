class CreateExpenseDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :expense_details do |t|
      t.references :common_expense, null: false, foreign_key: true
      t.string :detail
      t.integer :amount

      t.timestamps
    end
  end
end
