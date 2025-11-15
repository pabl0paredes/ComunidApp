class Booking < ApplicationRecord
  belongs_to :neighbor
  belongs_to :common_space

  validates :start, :end, presence: true
end
