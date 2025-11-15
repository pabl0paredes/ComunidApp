class Neighbor < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_many :bookings, dependent: :destroy

  validates :unit, presence: true, length: { maximum: 10 }
  validates :unit, uniqueness: { scope: :community_id }
end
