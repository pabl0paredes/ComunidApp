class CommonExpense < ApplicationRecord
  belongs_to :community

  has_many :expense_details, dependent: :destroy
  has_many :expense_details_neighbors, through: :expense_details

  validates :date, presence: true
  validates :total,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }


  def amount_for(user)
    return 0 unless user.neighbor.present?

    expense_details
      .joins(:expense_details_neighbors)
      .where(expense_details_neighbors: { neighbor_id: user.neighbor.id })
      .sum("expense_details_neighbors.amount_due")
  end


  def paid_for(user)
    return 0 unless user.neighbor.present?

    expense_details_neighbors
      .where(neighbor_id: user.neighbor.id, status: "approved")
      .sum(:amount_due)
  end
end
