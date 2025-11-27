class Neighbor < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_many :bookings, dependent: :destroy

  has_many :expense_details_neighbors, dependent: :destroy
  has_many :expense_details, through: :expense_details_neighbors

  validates :unit, presence: true, length: { maximum: 10 }
  validates :unit, uniqueness: { scope: :community_id }

  validates :common_expense_fraction,
          presence: true,
          numericality: { greater_than: 0, less_than_or_equal_to: 100 }
end
