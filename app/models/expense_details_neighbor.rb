class ExpenseDetailsNeighbor < ApplicationRecord
  belongs_to :expense_detail
  belongs_to :neighbor

end
