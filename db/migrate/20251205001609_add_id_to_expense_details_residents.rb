class AddIdToExpenseDetailsResidents < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_details_residents, :id, :primary_key
  end
end
