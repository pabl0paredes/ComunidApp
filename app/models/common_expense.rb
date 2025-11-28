class CommonExpense < ApplicationRecord
  belongs_to :community
  has_many :expense_details, dependent: :destroy



  validates :date, presence: true
  validates :total,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

            
end
