class CreateJoinTableExpenseDetailsResidents < ActiveRecord::Migration[7.1]

  def change
    create_join_table :expense_details, :residents do |t|
      t.index [:expense_detail_id, :resident_id], name: "index_expense_details_residents_on_detail_and_resident"
      t.index [:resident_id, :expense_detail_id], name: "index_expense_details_residents_on_resident_and_detail"
    end
  end

end
