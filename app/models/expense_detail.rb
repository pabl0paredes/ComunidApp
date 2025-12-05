class ExpenseDetail < ApplicationRecord
  belongs_to :common_expense

  has_many :expense_details_residents,
           class_name: "ExpenseDetailsResident",
           dependent: :destroy

  has_many :residents, through: :expense_details_residents

  accepts_nested_attributes_for :expense_details_residents, allow_destroy: true

  after_save :update_common_expense_total
  after_destroy :update_common_expense_total

  validates :detail, :amount, presence: true
  validates :detail, length: { maximum: 200 }
  validates :amount, numericality: { greater_than: 0 }

   def assign_amounts_to_residents

    total_percentage = expense_details_residents.sum do |edn|
      edn.resident.common_expense_fraction.to_f
    end

    return if total_percentage.zero?

    expense_details_residents.each do |edn|
      resident_percentage = edn.resident.common_expense_fraction.to_f

      proportion = resident_percentage / total_percentage
      edn.amount_due = (amount * proportion).round(2)

      edn.save!
    end
  end


  private

  def update_common_expense_total
    common_expense.update(total: common_expense.expense_details.sum(:amount))
  end
end
