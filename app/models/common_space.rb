class CommonSpace < ApplicationRecord
  belongs_to :community
  has_many :bookings, dependent: :destroy
  has_many :usable_hours, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :community_id }
  validates :name, length: { maximum: 50 }

  validates :is_available, presence: true
end
