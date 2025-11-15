class ExpenseDetail < ApplicationRecord
  belongs_to :common_expense

  validates :detail, :amount, presence: true
  validates :detail, length: { maximum: 200 }
  validates :amount, numericality: { greater_than: 0 }
end
