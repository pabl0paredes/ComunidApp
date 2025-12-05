class ExpenseDetailsResident < ApplicationRecord
  belongs_to :expense_detail
  belongs_to :resident

  has_one_attached :receipt

  STATUSES = %w[unpaid pending_approval approved rejected]

  validates :status, inclusion: { in: STATUSES }

  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= "unpaid"
  end

  def pending?
    status == "pending_approval"
  end

  def approved?
    status == "approved"
  end

  def rejected?
    status == "rejected"
  end


end
