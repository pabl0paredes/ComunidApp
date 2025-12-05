class CommonExpense < ApplicationRecord
  belongs_to :community

  has_many :expense_details, dependent: :destroy
  has_many :expense_details_residents, through: :expense_details

  validates :date, presence: true
  validates :total,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }


  def amount_for(user)
    return 0 unless user.resident.present?

    expense_details
      .joins(:expense_details_residents)
      .where(expense_details_residents: { resident_id: user.resident.id })
      .sum("expense_details_residents.amount_due")
  end


  def paid_for(user)
    return 0 unless user.resident.present?

    expense_details_residents
      .where(resident_id: user.resident.id, status: "approved")
      .sum(:amount_due)
  end
end
