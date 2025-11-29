class ExpenseDetail < ApplicationRecord
  belongs_to :common_expense

  has_many :expense_details_neighbors,
           class_name: "ExpenseDetailsNeighbor",
           dependent: :destroy
  
  has_many :neighbors, through: :expense_details_neighbors

  accepts_nested_attributes_for :expense_details_neighbors, allow_destroy: true

  after_save :update_common_expense_total
  after_destroy :update_common_expense_total

  validates :detail, :amount, presence: true
  validates :detail, length: { maximum: 200 }
  validates :amount, numericality: { greater_than: 0 }

  def assign_amounts_to_neighbors
    expense_details_neighbors.each do |edn|
      percentage = edn.neighbor.common_expense_fraction.to_f / 100.0
      edn.amount_due = (amount * percentage).round(2)
      edn.save!
    end
  end

  private

  def update_common_expense_total
    common_expense.update(total: common_expense.expense_details.sum(:amount))
  end
end
