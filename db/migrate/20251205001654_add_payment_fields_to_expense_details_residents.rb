class AddPaymentFieldsToExpenseDetailsResidents < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_details_residents, :status, :string
    add_column :expense_details_residents, :paid_at, :datetime
  end
end
