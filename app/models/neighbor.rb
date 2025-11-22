class Neighbor < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_many :bookings, dependent: :destroy

  has_and_belongs_to_many :common_expenses
  
  validates :unit, presence: true, length: { maximum: 10 }
  validates :unit, uniqueness: { scope: :community_id }
end
