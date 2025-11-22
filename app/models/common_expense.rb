class CommonExpense < ApplicationRecord
  belongs_to :community
  has_many :expense_details, dependent: :destroy

  has_and_belongs_to_many :neighbors
  
  validates :date, presence: true
  validates :total, presence: true, numericality: { greater_than: 0 }
end
